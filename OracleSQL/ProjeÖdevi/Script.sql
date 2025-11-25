CREATE TABLE "customers" (
  "customer_id" number GENERATED AS IDENTITY PRIMARY KEY,
  "first_name" varchar(50) NOT NULL,
  "last_name" varchar(50) NOT NULL,
  "birth_date" date NOT NULL,
  "id_number" char(11) UNIQUE NOT NULL,
  "email" varchar(100) UNIQUE,
  "phone" varchar(20),
  "is_active" bool DEFAULT true NOT NULL,
  "updated_at" timestamp,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "account_types" (
  "account_type_id" number GENERATED AS IDENTITY PRIMARY KEY,
  "name" varchar(50) UNIQUE NOT NULL,
  "description" varchar(255),
  "min_balance" decimal(18,2) DEFAULT 0 NOT NULL,
  "interest_rate" decimal(5,2) DEFAULT 0 NOT NULL,
  "is_active" bool DEFAULT true NOT NULL,
  "updated_at" timestamp,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "accounts" (
  "account_id" number GENERATED AS IDENTITY PRIMARY KEY,
  "customer_id" number NOT NULL,
  "account_type_id" number NOT NULL,
  "iban" char(26) UNIQUE NOT NULL,
  "balance" decimal(18,2) DEFAULT 0 NOT NULL,
  "currency" char(3) DEFAULT 'TRY' NOT NULL,
  "is_active" bool DEFAULT true NOT NULL,
  "updated_at" timestamp,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "transactions" (
  "transaction_id" number GENERATED AS IDENTITY PRIMARY KEY,
  "account_id" number NOT NULL,
  "transaction_date" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "amount" decimal(18,2) NOT NULL,
  "transaction_type" nvarchar2(255) NOT NULL CHECK ("transaction_type" IN ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER_IN', 'TRANSFER_OUT', 'CARD_PAYMENT', 'ONLINE_CARD_PAYMENT', 'REFUND')) NOT NULL,
  "description" varchar(255),
  "after_balance" decimal(18,2) NOT NULL
);

CREATE TABLE "cards" (
  "card_id" number GENERATED AS IDENTITY PRIMARY KEY,
  "account_id" number NOT NULL,
  "card_number" char(16) UNIQUE NOT NULL,
  "card_type" nvarchar2(255) NOT NULL CHECK ("card_type" IN ('DEBIT', 'CREDIT', 'VIRTUAL')) NOT NULL,
  "expiration_date" date NOT NULL,
  "is_active" bool DEFAULT true NOT NULL,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "account_settings" (
  "account_id" number PRIMARY KEY,
  "daily_withdrawal_limit" decimal(18,2) DEFAULT 5000 NOT NULL,
  "daily_transfer_limit" decimal(18,2) DEFAULT 10000 NOT NULL,
  "overdraft_allowed" boolean DEFAULT false NOT NULL
);

CREATE TABLE "companies" (
  "company_id" number GENERATED AS IDENTITY PRIMARY KEY,
  "company_name" varchar(150) NOT NULL,
  "tax_number" varchar(20) NOT NULL,
  "is_active" bool DEFAULT true NOT NULL,
  "updated_at" timestamp,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "automatic_payments" (
  "automatic_payment_id" number GENERATED AS IDENTITY PRIMARY KEY,
  "account_id" number NOT NULL,
  "company_id" number NOT NULL,
  "amount" decimal(18,2) NOT NULL,
  "frequency" varchar(20) NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date,
  "status" varchar(20) NOT NULL
);

ALTER TABLE "accounts" ADD FOREIGN KEY ("customer_id") REFERENCES "customers" ("customer_id");

ALTER TABLE "accounts" ADD FOREIGN KEY ("account_type_id") REFERENCES "account_types" ("account_type_id");

ALTER TABLE "transactions" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id");

ALTER TABLE "cards" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id");

ALTER TABLE "account_settings" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id");

ALTER TABLE "automatic_payments" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id");

ALTER TABLE "automatic_payments" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("company_id");

-- Indexler
CREATE INDEX idx_customers_last_name ON customers(last_name);
CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);
CREATE INDEX idx_accounts_account_type_id ON accounts(account_type_id);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_cards_account_id ON cards(account_id);
CREATE INDEX idx_cards_expiration_date ON cards(expiration_date);
CREATE INDEX idx_account_settings_account_id ON account_settings(account_id);
CREATE INDEX idx_companies_tax_number ON companies(tax_number);
CREATE INDEX idx_automatic_payments_account_id ON automatic_payments(account_id);
CREATE INDEX idx_automatic_payments_company_id ON automatic_payments(company_id);
CREATE INDEX idx_automatic_payments_start_date ON automatic_payments(start_date);
CREATE INDEX idx_automatic_payments_end_date ON automatic_payments(end_date);
