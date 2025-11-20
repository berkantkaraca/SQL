--------------------------------------------------------
--  Ref Constraints for Table CUSTOMER
--------------------------------------------------------

  ALTER TABLE "BILGEADAM"."CUSTOMER" ADD CONSTRAINT "Customer_FK1" FOREIGN KEY ("PERSONID")
	  REFERENCES "BILGEADAM"."PERSON" ("BUSINESSENTITYID") ENABLE;
  ALTER TABLE "BILGEADAM"."CUSTOMER" ADD CONSTRAINT "Customer_FK2" FOREIGN KEY ("TERRITORYID")
	  REFERENCES "BILGEADAM"."SALESTERRITORY" ("TERRITORYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table EMAILADDRESS
--------------------------------------------------------

  ALTER TABLE "BILGEADAM"."EMAILADDRESS" ADD CONSTRAINT "EmailAddress_FK1" FOREIGN KEY ("BUSINESSENTITYID")
	  REFERENCES "BILGEADAM"."PERSON" ("BUSINESSENTITYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PERSONPHONE
--------------------------------------------------------

  ALTER TABLE "BILGEADAM"."PERSONPHONE" ADD CONSTRAINT "PersonPhone_FK1" FOREIGN KEY ("BUSINESSENTITYID")
	  REFERENCES "BILGEADAM"."PERSON" ("BUSINESSENTITYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRODUCT
--------------------------------------------------------

  ALTER TABLE "BILGEADAM"."PRODUCT" ADD CONSTRAINT "Product_FK1" FOREIGN KEY ("PRODUCTSUBCATEGORYID")
	  REFERENCES "BILGEADAM"."PRODUCTSUBCATEGORY" ("PRODUCTSUBCATEGORYID") ENABLE;
  ALTER TABLE "BILGEADAM"."PRODUCT" ADD CONSTRAINT "Product_FK2" FOREIGN KEY ("PRODUCTMODELID")
	  REFERENCES "BILGEADAM"."PRODUCTMODEL" ("PRODUCTMODELID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRODUCTSUBCATEGORY
--------------------------------------------------------

  ALTER TABLE "BILGEADAM"."PRODUCTSUBCATEGORY" ADD CONSTRAINT "ProductSubcategory_FK1" FOREIGN KEY ("PRODUCTCATEGORYID")
	  REFERENCES "BILGEADAM"."PRODUCTCATEGORY" ("PRODUCTCATEGORYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SALESORDERHEADER
--------------------------------------------------------

  ALTER TABLE "BILGEADAM"."SALESORDERHEADER" ADD CONSTRAINT "SalesOrderHeader_FK1" FOREIGN KEY ("CUSTOMERID")
	  REFERENCES "BILGEADAM"."CUSTOMER" ("CUSTOMERID") ENABLE;
  ALTER TABLE "BILGEADAM"."SALESORDERHEADER" ADD CONSTRAINT "SalesOrderHeader_FK2" FOREIGN KEY ("TERRITORYID")
	  REFERENCES "BILGEADAM"."SALESTERRITORY" ("TERRITORYID") ENABLE;
  ALTER TABLE "BILGEADAM"."SALESORDERHEADER" ADD CONSTRAINT "SalesOrderHeader_FK3" FOREIGN KEY ("SALESPERSONID")
	  REFERENCES "BILGEADAM"."SALESPERSON" ("BUSINESSENTITYID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SALESPERSON
--------------------------------------------------------

  ALTER TABLE "BILGEADAM"."SALESPERSON" ADD CONSTRAINT "SalesPerson_FK1" FOREIGN KEY ("TERRITORYID")
	  REFERENCES "BILGEADAM"."SALESTERRITORY" ("TERRITORYID") ENABLE;
  ALTER TABLE "BILGEADAM"."SALESPERSON" ADD CONSTRAINT "SalesPerson_FK2" FOREIGN KEY ("BUSINESSENTITYID")
	  REFERENCES "BILGEADAM"."PERSON" ("BUSINESSENTITYID") ENABLE;
--------------------------------------------------------
