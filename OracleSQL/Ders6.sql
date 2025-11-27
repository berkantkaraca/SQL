-- Soyadının ilk 3 ahrfi Kim ile başlayan kişiler gelsin (index kullanır)
select * 
from person
where lower(lastname) like 'kim%';

-- Soyadının ilk 3 ahrfi Kim ile başlayan kişiler gelsin (index kullanmaz çünkü baş harf bilinmiyor)
select * 
from person
where lower(lastname) like '%kim%';

-- Soyadının ilk 3 ahrfi Kim ile başlayan kişiler gelsin (index kullanmaz)
select * 
from person
where substr(lastname, 1, 3) = 'Kim';


/*
    PL/SQL prosedürel bir dildir. Yazılan sırayla çalışır.
    Network trafiğini azaltır 
    Güvenliği sağlar

    Anonim blok: veritabanına kaydedilmeyen bloklardır. Tek kullanımlıktır.
    Named blok: tekrar tekrar kullanılcağı için veritabanına kaydedilir

    Declaration section: tanımlamalar yapılır
    Executable section: Zorunlu sectiondur. Komutlar burda yazılr
    Exception section: Runtime da çıkan hataları yakalar

    pl/sql de noktalı virgül zorunlu
    oracle atama operatörü => :=

    Query Execution Phases
    ----------------------
    1- Syntax Check (Parsing)
    2- Name Resolution (Binding)
    3- Compile 
    4- Execution Plan => Kodu Çalıştırma Planlarını Hazırlar
    5- Execute

    İsimlendirilmiş nesnelerde bu planlar her zaman yapılmaz. Cache mekanizmasıyla kaydedilir.

    SQL PLUS => script çalışmak için kullanılır. Extra kaynak tükenmeyeceği için burdan yap. (arayüzü vs yok bildiğin cmd)
*/

-- En yüksek tutarda sipariş veren müşteriyi bulup kullanıcıdan alınan indirim oranına göre müşterinin toplam sipariş tutarı üzerinden indirim kuponu tutarını hesaplar.
SET SERVEROUTPUT ON;
declare
    v_customer_id   customer.customerid%type;
    v_first_name    person.firstname%type;
    v_last_name     person.lastname%type;
    v_total_amount  number;
    v_discount_rate number := &sv_discount_rate; 
    v_discount  number;
    c_max_discount  constant number := 20;
begin
    -- En yüksek tutarda sipariş veren müşteriyi bulma
    select c.customerid, p.firstname, p.lastname, sum(soh.totaldue)
    into v_customer_id, v_first_name, v_last_name, v_total_amount
    from customer c
    join person p on c.personid = p.businessentityid
    join salesorderheader soh on c.customerid = soh.customerid
    group by c.customerid, p.firstname, p.lastname
    order by sum(soh.totaldue) desc
    fetch first 1 rows only;

    dbms_output.put_line('En Çok Sipariş Veren Müşteri:');
    dbms_output.put_line('ID: ' || v_customer_id);
    dbms_output.put_line('Adı: ' || v_first_name);
    dbms_output.put_line('Soyadı: ' || v_last_name);
    dbms_output.put_line('Toplam Sipariş Tutarı: ' || v_total_amount);

    -- İndirim oranı kontrolü ve indirim tutarını hesaplama. 0-20 aralığında olmalı.
    if v_discount_rate > c_max_discount then
        dbms_output.put_line('İndirim oranı maksimum ' || c_max_discount || ' olabilir. Girilen indirim oranı: ' || v_discount_rate);
        v_discount_rate := c_max_discount;
        dbms_output.put_line('Uygulanan indirim oranı: ' || v_discount_rate);
    elsif v_discount_rate < 0 then
        dbms_output.put_line('İndirim oranı 0''dan küçük olamaz. Girilen indirim oranı: ' || v_discount_rate);
        v_discount_rate := 0;
        dbms_output.put_line('Uygulanan indirim oranı: ' || v_discount_rate);
    else
        dbms_output.put_line('Uygulanan indirim oranı: ' || v_discount_rate);
    end if;

    v_discount := (v_total_amount * v_discount_rate) / 100;
    dbms_output.put_line('İndirim Miktarı: ' || v_discount);

exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Hiç sipariş bulunamadı.');
end;


