/*Subquery
-----------
Dinamik ve statik filtreleme yapılabilir

SELECT...................................
FROM.....................................
WHERE kolonadi = (SELECT kolonadi
                    From tablo
                );
                
subquery'de dışardaki sorgunun filtrelenen kolonu ile içerdeki sorgunun select'inden dönen kolon aynı veritipinde olmalıdır. (string ise strin gibi)

subquery'lerde parantez içindeki sorgudan birden fazla satır sonuç geliyorsa dışardaki sorunun filtreleme kısmında = yerine IN operatörü kullanılmalıdır.

*/
-- Fiyatı en pahalı olan ürünle aynı renge sahip olan bütün ürünleri getir.
select *
from product
where color = (
    select color 
    from product
    order by listprice desc
    fetch next 1 rows only
);

-- En son verilen siparişle aynı tarihte verilen bütün siparişler
select *
from salesorderheader
where orderdate = (
    select orderdate
    from salesorderheader
    order by orderdate desc
    fetch next 1 rows only
);

-- Fiyatı ortalama fiyatın üzerinde olan ürünler gelsin
select * 
from product
where listprice > (
    select avg(listprice)
    from product
);

-- Fiyatı en pahalı olan ürünle aynı renge sahip olan bütün ürünleri MAX kullanarak getir.
select * 
from product
where color in (
    select  color 
    from product 
    where listprice = (
        select max(listprice)
        from product
));

/* Set Operators
----------------
1- union all
2- union
3- intersect
4- minus (mssql'de except)

- 2 sorgunun sonuçlarını birleştirir => union all (hepsini birleştirir, tekrar eden satırları da getirir) ve union (arka planda distinct çalıştırır ve tekrar eden satırları filtreler)
Tekrar etmediğinden eminsek union all daha performanslı çünkü distinct maaliyeti yok
- 2 sorgunun sonuçlarını satır satır karşılaştırıp ortak satırları bulur => intersect
- 2 sorgunun sonuçlarını satır satır karşılaştırıp farklı satırları bulur => minus (a fark b) sorgu sırası burda önemli b fark a isteniyorsa b ilk yazılmalı

iki olmazsa olmaz kural.
-- yazılan select içinde çekilen kolon sayıları eşit olmalı
-- alt alta sırayla denk gelen kolonların veri tipleri aynı olmalı

-- kolon adı üsttekinde firstname, alttakinde name ise sonuç kümesinde üsttekini kullanır.
*/

-- Farklı bir telefon kaydını var bunu bul. Üstteki sorgu 10.785, alttaki 10.784 kayıt var. Fazla olanı üstte yazmak lazım
select *
from personphone
where phonenumber like '%-%-%'
minus
select *
from personphone
where phonenumber like '___-___-____';

-- Ortak kayıtları bul
select *
from personphone
where phonenumber like '%-%-%'
intersect
select *
from personphone
where phonenumber like '___-___-____';

-- 2 sorgunun birleşimi
select *
from personphone
where phonenumber like '%-%-%'
union all
select *
from personphone
where phonenumber like '___-___-____';

-- 2 sorgunun birleşimi ama tekrarlı kayıtları çıkar
select *
from personphone
where phonenumber like '%-%-%'
union
select *
from personphone
where phonenumber like '___-___-____';

/* Veri tipleri
---------------

Sayısal Veri Tipleri
--------------------
number(p,s) => tam sayı ve ondalıklı sayılar içinde kullanılır. p=sayı kaç haneli, s=ondalıklı kısmı kaç haneli.
number(3) => -999...+999

Tarihsel Veri Tipleri
---------------------
date
timestamp (daha hassas, saniyenin binde biri gibi)

Metinsel Veri Tipleri
---------------------
char => uzunluğu sabittir. eksik karakter girersek boşlukla tamamlar
varchar2 => değişken uzunluklu. kaç karakter girersen onu tutar
clob => charachter large object. uzun metinleri tutar.

*/

/* Data Type Conversion
-----------------------
cast(kolonadi as veritipi) kolonu yazılan veritipine çevirir
to_char() 
to_date() metinsel girdiyi verilen formata uygun tarihe çevirir
to_number() metinsel veriyi number'a çevirir
numtoyminterval()
numtodsinterval()
*/

-- Adı ve soyadı kolonları birleştirilip tek bir kolonda gösterilsin
select firstname, lastname, concat(firstname, lastname), firstname || ' ' || lastname
from person;

-- kişilerin sicil no ve soyadı kolonlarını tek bir kolonda göster
select businessentityid || ' ' || lastname, cast(businessentityid as varchar2(50)) || ' ' || lastname
from person;

-- 
select * 
from person
where to_char(namestyle) = 'a';

--DD ayın günü, DDD yılın kaçıncı günü, DY günün adını kısaltılmış olarak verir, DAY gün adını tam yazar,  day kullanımında en uzun gün 9 harfli olduğundan eksik olanlara boşluk ekler fmDAY bu boşlukları kaldırır
select orderdate, to_char(orderdate, 'DDD')
from salesorderheader;

-- Sadece cuma günü verilen siparişler gelsin
select orderdate, to_char(orderdate, 'fmDAY')
from salesorderheader
where to_char(orderdate, 'fmDAY') = 'FRIDAY';

-- mssql'de identity bulunduğu kolona aittir, oracle sequence ayrı bir nesnedir. bir squence birden fazla tabloada numaralandırma yapabilir
-- CREATE SEQUENCE MUSTERI_SEQ INCREMENT BY 1 START WITH 1;

-- Sequence değerleri: nextval, currval
select MUSTERI_SEQ.NEXTVAL from dual; -- bir sonraki değeri üretir
select MUSTERI_SEQ.CURRVAL from dual; -- şuanki değeri döner

insert into musteri (musteriid, adsoyad, kayittarihi) values (MUSTERI_SEQ.NEXTVAL, 'Berkant', sysdate);
insert into musteri (musteriid, adsoyad, kayittarihi) values (MUSTERI_SEQ.NEXTVAL, 'Fevzi', sysdate);
insert into musteri (musteriid, adsoyad, kayittarihi) values (MUSTERI_SEQ.NEXTVAL, 'Muhammed', sysdate);
insert into musteri (musteriid, adsoyad, kayittarihi) values (MUSTERI_SEQ.NEXTVAL, 'Mert', sysdate);
insert into musteri (musteriid, adsoyad, kayittarihi) values (MUSTERI_SEQ.NEXTVAL, 'Mustafa', sysdate);
insert into musteri (musteriid, adsoyad, kayittarihi) values (MUSTERI_SEQ.NEXTVAL, 'Yusuf', sysdate);
insert into musteri (musteriid, adsoyad, kayittarihi) values (MUSTERI_SEQ.NEXTVAL, 'Bahadır', sysdate);

select * from musteri;

-- mssql auto commit yöntemiyle çalışır, oracle da commit veya rollback komutlarını bekler 
-- COMMIT: yapılan işlemi veritabanına yansıtır
-- ROLLBACK: yapılan işlemi veritabanına yansıtmaz

UPDATE MUSTERI SET ADRES = 'Ümraniye' WHERE musteriid = 7;

delete from musteri where musteriid = 9;

create table SIPARIS(
    SIPARISID NUMBER(22,0) PRIMARY KEY,
    SIPARISTARIHI TIMESTAMP NOT NULL,
    TUTAR NUMBER(22,2) NOT NULL,
    MUSTERIID NUMBER(22, 0),
    CONSTRAINT FK_MUSTERI_SIPARIS FOREIGN KEY (MUSTERIID) REFERENCES MUSTERI (MUSTERIID)
);

select * from siparis;

insert into siparis 
values(SIPARIS_SEQ.NEXTVAL, sysdate, 333.33, 4);

delete from musteri where musteriid = 5;

-- View: belirli aralıklarla atılan sorguların tablosunu kaydeder
-- Veriningüvenliği sağlamak içinde kullanılır. (Datanın bir kısmını erişime açar)
-- View'lar select sorgularını kaydeder

create view VWHAFTALIKRAPOR
as 
select p.name Urun, p.color, p.listprice, pm.name as ModelAdı
from product p full join productmodel pm
on p.productmodelid = pm.productmodelid;

select * from VWHAFTALIKRAPOR;

-- Standart view'lar data tutmaz, sorguyu tutar. Oracle'da materilize view datayıyıda tutar, select performansı gerekiyosa kullanılır.




















