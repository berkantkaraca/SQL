
select * 
from product;


select name, color, listprice
from product;

-- Buraya yazilan seyler birer yorumdur
-- ahgsfd ashgdfashgd ascdascd

/* hsadfadf ashdfasgd ahsgdahsgd ahsgdahsdhgad
ajsdjasdajfdasd
asdasdasdasdasdasd
*/

-- Sadece fiyati 0 olan urunler gelsin
select name, color, listprice
from product
where listprice = 0;

-- fiyati 0 dan farkli olan urunler
select name, color, listprice
from product
where listprice <> 0;

-- 2. yontem
select name, color, listprice
from product
where listprice != 0;

-- Fiyati 1000-2000 arasida olan urunler gelsin
select name, color, listprice
from product
where listprice between 1000 and 2000;

-- 2. yontem
select name, color, listprice
from product
where listprice >= 1000 AND listprice <= 2000;

-- Rengi Siyah ya da Kirmizi olup ve ayni zamanda fiyati da 1000 den buyuk olan urunler
select name, color, listprice
from product
where (color = 'Black' OR color = 'Red') AND listprice > 1000;

-- Siyah ya da Kirmizi ya da Mavi ya da Sari olan urunler
select name, color, listprice
from product
where color IN ('Black', 'Red', 'Blue', 'Yellow');


select name, color, listprice
from product
where LOWER(color) IN ('black', 'red', 'blue', 'yellow');

-- Siyah ya da Kirmizi ya da Mavi ya da Sari olmayan urunler
select name, color, listprice
from product
where color NOT IN ('Black', 'Red', 'Blue', 'Yellow') OR color is null;

-- Rengi NULL olan urunler gelsin
select name, color, listprice
from product
where color is NULL;

-- Rengi NULL olmayan urunler
select name, color, listprice
from product
where color is not NULL;


/* LIKE
-------------------
%   --> 0 veya daha fazla karakteri temsil eder
_   --> Sadece tek 1 adet karakteri temsil eder

*/

-- Soyadi K ile baslayan kisiler gelsin
select *
from person
where lastname like 'K%';

-- Soyadi K ile biten kisiler gelsin
select *
from person
where lastname like '%k';

-- Soyadinin icinde K gecen kisiler
select *
from person
where UPPER(lastname) like '%K%';

-- Soyadinin sondan 3. harfi K olan kisiler
select *
from person
where UPPER(lastname) like '%K__';

-- 615-555-0153 formatinda olan telefonlar gelsin
select *
from personphone
where phonenumber like '%-%-%';

-- 2. yontem
select *
from personphone
where phonenumber like '___-___-____';


-- Sadece 2007 yilinda verilen siparisler gelsin
select *
from salesorderheader
where EXTRACT(year from orderdate) = 2007;

-- 2. yontem
select *
from salesorderheader
where orderdate between '01-JAN-07' and '31-DEC-07';

-- 3. yontem
select *
from salesorderheader
where orderdate between TO_DATE('01.01.2007', 'DD.MM.YYYY') 
                    and TO_DATE('01.01.2008', 'DD.MM.YYYY');

-- 4. yontem
select *
from salesorderheader
where orderdate >= TO_DATE('01.01.2007', 'DD.MM.YYYY')
    and orderdate < TO_DATE('01.01.2008', 'DD.MM.YYYY');

-- 5. yontem
select *
from salesorderheader
where orderdate like '%07';

-- 6. yontem
select *
from salesorderheader
where TO_CHAR(orderdate, 'YYYY') = '2007';

-- Kac farkli renk mevcut
select distinct color
from product;

select unique color
from product;


select distinct color, sized
from product;

-- Fiyati 0-1000 --> Ucuz
-- Fiyati 1000-2000 --> Orta
-- Fiyati 2000 den buyukse --> Pahali olarak gelsin
select name, color, listprice, 
    case when listprice between 0 and 1000 then 'Ucuz'
         when listprice between 1000 and 2000 then 'Orta'
         when listprice > 2000 then 'Pahal�'
         else 'Di�er'
    end as Segment
from product;

-- urun renkleri turkce olarak gosterilsin
select name, color, listprice, 
    case when color = 'Black' then 'Siyah'
         when color = 'Red' then 'K�rm�z�'
         when color = 'Blue' then 'Mavi'
         else 'Di�er'
    end as Renk
from product;

-- Urunler fiyata gore kucukten buyuge dogru sirali gelsin
select name, color, listprice
from product
order by listprice asc;

-- buyukten kucuge dogru siralama
select name, color, listprice
from product
order by listprice desc;

-- coklu siralama
-- urunler once fiyata gore asc, 
-- fiyati ayni olan urunler de kendi icinde isme gore a-z sirali getirelim
select name, color, listprice
from product
order by listprice asc, name asc;

-- Urunler renge gore z-a sirali gelsin. NULL en sonda gelsin
select name, color, listprice
from product
order by color desc
NULLS LAST;
-- NULLS FIRST;

-- Fiyati en pahali olan ilk 10 urun gelsin
select *
from
    (
    select name, color, listprice , ROWID, ROWNUM
    from product
    order by listprice desc
    )
where ROWNUM <= 10;

-- 2. yontem
select name, color, listprice 
from product
order by listprice desc
offset 0 rows fetch next 10 rows only;


/* SORGU KOMUTLARININ YAZILMA VE CALISTIRILMA SIRASI
-----------------------------------------------------
                 Calistirilma Sirasi
SELECT ..................(5)
FROM ....................(1)
WHERE ...................(2)
GROUP BY ................(3)
HAVING ..................(4)
ORDER BY ................(6)

*/

-- Urun Ad�, Renk, Liste Fiyat�
select name as "Urun Ad�", color as Renk, listprice as "Liste Fiyat�"
from product
where color = 'Black'
order by "Liste Fiyat�" desc;


/* AGGREGATE FUNCTIONS
-----------------------
SUM()   --> toplam
MIN()   --> minimum, en kucuk deger
MAX()   --> maksimum, en buyuk deger
COUNT() --> satir sayisi, adet
AVG()   --> ortalama

*/

-- Her bir renkten kac adet urun var
select color, COUNT(*) as Adet
from product
group by color;

select color
from product
where color like 'B%'
group by color;

-- Her bir sehirde kac adet adres var. Cikan sonuclari siralayip en cok hangi sehirde adres var.
select city, count(*) as Adet
from address
group by city
order by Adet desc;

-- Her rengin en pahali fiyat�, en ucuz fiyati, ortalama fiyat� gelsin
select color, MAX(listprice) as Enpahali, MIN(listprice) as Enucuz, AVG(listprice) as Ortalama
from product
group by color;

-- Her bir yilda toplam ne kadar ciro elde edildi
select EXTRACT(year from orderdate) as Yil, TO_CHAR(SUM(subtotal), '$999,999,999') as Ciro
from salesorderheader
group by EXTRACT(year from orderdate)
order by Yil asc;

-- Her bir yilin her bir ayinda toplam ne kadar ciro elde edildi
select EXTRACT(year from orderdate) as Yil, 
        EXTRACT(month from orderdate) as Ay,
        TO_CHAR(SUM(subtotal), '$999,999,999') as Ciro
from salesorderheader
group by EXTRACT(year from orderdate), EXTRACT(month from orderdate)
order by Yil asc, Ay asc;

-- Sadece 5 milyon dolar ve uzerinde ciro elde edilen aylar gelsin
select EXTRACT(year from orderdate) as Yil, 
        EXTRACT(month from orderdate) as Ay,
        TO_CHAR(SUM(subtotal), '$999,999,999') as Ciro
from salesorderheader
group by EXTRACT(year from orderdate), EXTRACT(month from orderdate)
having SUM(subtotal) >= 5000000
order by Yil asc, Ay asc;

-- En az 100 adet adresi olan sehirler gelsin
select city, count(*) as Adet
from address
group by city
having count(*) >= 100
order by Adet desc;

/* JOINS
----------------
1- INNER JOIN
2- OUTER JOIN
    - LEFT JOIN
    - RIGHT JOIN
    - FULL JOIN
3- CROSS JOIN

*/

-- Siparis tarihi, tutari, bolgeadi gelsin
select * from salesorderheader where ROWNUM <= 50;
select * from salesterritory;

-- ANSI 92 Syntax
select soh.orderdate, soh.subtotal, st.name
from salesorderheader soh inner join salesterritory st
on soh.territoryid = st.territoryid;

-- ANSI 89 Syntax
select soh.orderdate, soh.subtotal, st.name
from salesorderheader soh , salesterritory st
where soh.territoryid = st.territoryid;

-- Urunadi, Renk, Fiyat, Modeladi
select * from product;
select * from productmodel;


select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p inner join productmodel pm
on p.productmodelid = pm.productmodelid;


select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p , productmodel pm
where p.productmodelid = pm.productmodelid;

-- Kategoriadi, Altkategoriadi, Urunadi, Renk, Fiyat, Modeladi gelsin
select * from productcategory;
select * from productsubcategory;
select * from product;
select * from productmodel;

select pc.name as Kategoriadi, psc.name as Altkategoriadi, p.name as Urunadi, 
        p.color, p.listprice, pm.name as Modeladi
from productcategory pc inner join productsubcategory psc
on pc.productcategoryid = psc.productcategoryid
inner join product p
on psc.productsubcategoryid = p.productsubcategoryid
inner join productmodel pm
on pm.productmodelid = p.productmodelid;

-- ANSI 89 Syntax
select pc.name as Kategoriadi, psc.name as Altkategoriadi, p.name as Urunadi, 
        p.color, p.listprice, pm.name as Modeladi
from productcategory pc, productsubcategory psc, product p, productmodel pm
where pc.productcategoryid = psc.productcategoryid 
    AND psc.productsubcategoryid = p.productsubcategoryid
    AND pm.productmodelid = p.productmodelid;
    
 

 
 
select * from product;      -- 504 rows
select * from productmodel; -- 128 rows

-- INNER JOIN  -- 295 rows  -- (sadece modeli olan urunler)
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p inner join productmodel pm
on p.productmodelid = pm.productmodelid;
 
-- INNER JOIN  -- 295 rows  -- (sadece modeli olan urunler) ANSI 89 Syntax
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p , productmodel pm
where p.productmodelid = pm.productmodelid;

 
-- LEFT JOIN  -- 504 rows  -- (modeli olsun ya da olmasin BUTUN URUNLER)
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p left join productmodel pm
on p.productmodelid = pm.productmodelid;
  
-- LEFT JOIN  -- 504 rows  -- (modeli olsun ya da olmasin BUTUN URUNLER) ANSI 89 Syntax
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p , productmodel pm
where p.productmodelid = pm.productmodelid(+);
    
-- RIGHT JOIN  -- 304 rows  -- (urunu olsun ya da olmasin BUTUN MODELLER)
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p right join productmodel pm
on p.productmodelid = pm.productmodelid;    
    

-- RIGHT JOIN  -- 304 rows  -- (urunu olsun ya da olmasin BUTUN MODELLER) ANSI 89 Syntax
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p , productmodel pm
where p.productmodelid(+) = pm.productmodelid;

-- FULL JOIN  -- 513 rows  -- (hem BUTUN URUNLER -left join- hem de BUTUN MODELLER -right join-)
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p full join productmodel pm
on p.productmodelid = pm.productmodelid;    
    
-- FULL JOIN  -- 513 rows  -- (hem BUTUN URUNLER -left join- hem de BUTUN MODELLER -right join-) ANSI 89 Syntax
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p , productmodel pm
where p.productmodelid(+) = pm.productmodelid    
UNION  
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p , productmodel pm
where p.productmodelid = pm.productmodelid(+);   

-- CROSS JOIN  -- 64512 rows  -- (kartezyen carpim)
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p cross join productmodel pm; 

-- CROSS JOIN  -- 64512 rows  -- (kartezyen carpim) ANSI 89 Syntax
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p , productmodel pm; 

/* SUBQUERY
-----------------------------
SELECT .......
FROM ......
WHERE kolonadi IN (SELECT kolonadi
                    FROM .....
                 );


*/


-- Fiyati en pahali olan urunle ayni renge sahip olan butun urunler gelsin
select color
from product
order by listprice desc
fetch next 1 rows only;

select *
from product
where color = (select color
                from product
                order by listprice desc
                fetch next 1 rows only);


-- En son verilen siparisle ayni tarihte verilen butun siparisler gelsin
select max(orderdate)
from salesorderheader;


select *
from salesorderheader
where orderdate = (select max(orderdate)
                    from salesorderheader);
                    

-- Fiyati ortalama fiyatin uzerinde olan uruler gelsin
select AVG(listprice)
from product;

select *
from product 
where listprice > (select AVG(listprice)
                    from product);

-- Fiyati en pahali olan urunle ayni renge sahip olan butun urunler gelsin MAX kullanarak
select *
from product
where color IN
    (
    select color
    from product
    where listprice =
        (
        select max(listprice)
        from product
        )
    );

-- Hic siparis vermemis olan musteriler gelsin
-- SOME, ANY, ALL

/* SET OPERATORS
-----------------------
1- UNION ALL
2- UNION
3- INTERSECT
4- MINUS (EXCEPT)

*/

select *
from personphone
where phonenumber like '%-%-%'
MINUS
select *
from personphone
where phonenumber like '___-___-____';


select *
from personphone
where phonenumber like '%-%-%'
INTERSECT
select *
from personphone
where phonenumber like '___-___-____';


select *
from personphone
where phonenumber like '%-%-%'
UNION ALL
select *
from personphone
where phonenumber like '___-___-____';


select *
from personphone
where phonenumber like '%-%-%'
UNION 
select *
from personphone
where phonenumber like '___-___-____';

/* DATA TYPE CONVERSION
--------------------------
CAST(kolonadi as veritipi)
TO_CHAR()
TO_DATE()
TO_NUMBER()
NUMTOYMINTERVAL()
NUMTODSINTERVAL()

*/

-- Adi ve Soyadi kolonlari birlestirilip tek bir kolonda gosterilsin
select firstname, lastname, CONCAT(firstname, lastname), firstname || ' ' || lastname
from person;


-- Sicil NO ile Soyadi kolonlarini birlestirip tek bir kolonda gosterelim
select businessentityid, lastname, CAST(businessentityid as varchar2(50)) || lastname
from person;


select *
from person
where TO_CHAR(namestyle) = 'A';


select orderdate, TO_CHAR(orderdate, 'fmDAY')
from salesorderheader;

-- Sadece Cuma gunu verilen siparisler gelsin
select orderdate, TO_CHAR(orderdate, 'fmDAY')
from salesorderheader
where TO_CHAR(orderdate, 'fmDAY') = 'FRIDAY';

-- sequence degerleri
select MUSTERI_SEQ.NEXTVAL from dual;
select MUSTERI_SEQ.CURRVAL from dual;

select * from dual;

insert into MUSTERI(MUSTERIID, ADSOYAD, KAYITTARIHI)
values (MUSTERI_SEQ.NEXTVAL, 'Abdullah Alt�ntas', SYSDATE);

select * from MUSTERI;

-- COMMIT
-- ROLLBACK

INSERT INTO musteri (
    musteriid,
    adsoyad,
    kayittarihi,
    adres
) VALUES (
    MUSTERI_SEQ.NEXTVAL,
    'Bar�� Alt�ntas',
    SYSDATE,
    'Tuzla'
);

select * from MUSTERI;

update MUSTERI
set Adres = 'Halkal�'
where MUSTERIID = 3;

delete from MUSTERI
where MUSTERIID = 4;


create table SIPARIS
(
SIPARISID NUMBER(22,0) PRIMARY KEY,
SIPARISTARIHI TIMESTAMP NOT NULL,
TUTAR NUMBER(22,2) NOT NULL,
MUSTERIID NUMBER,
CONSTRAINT FK_MUSTERI_SIPARIS FOREIGN KEY (MUSTERIID) REFERENCES MUSTERI(MUSTERIID) 
);

select * from SIPARIS;

insert into SIPARIS
values (SIPARIS_SEQ.NEXTVAL, SYSDATE, 333.33, 5);

delete from MUSTERI
where MUSTERIID = 5;

select * from SIPARIS;


create view VWHAFTALIKRAPOR
as
select p.name as Urunadi, p.color, p.listprice, pm.name as Modeladi
from product p full join productmodel pm
on p.productmodelid = pm.productmodelid;   


-- view kullanma
select *
from vwhaftalikrapor;


/* TABLE EXPRESSIONS
-----------------------------
1- Derived Table (Subquery)
2- Common Table Expression (CTE - With Clause)

*/
-- Kac adet Ucuz, kac adet Orta, kac adet Pahali urun var
-- Derived Table (Subquery)
select Segment, COUNT(*) 
from
    (
    select name, color, listprice, 
        case when listprice between 0 and 1000 then 'Ucuz'
             when listprice between 1000 and 2000 then 'Orta'
             when listprice > 2000 then 'Pahal�'
             else 'Di�er'
        end as Segment
    from product
    ) tbl
group by Segment;

-- Common Table Expression (CTE - With Clause)
-- Kac adet Ucuz, kac adet Orta, kac adet Pahali urun var
with tbldeneme
as
    (
    select name, color, listprice, 
            case when listprice between 0 and 1000 then 'Ucuz'
                 when listprice between 1000 and 2000 then 'Orta'
                 when listprice > 2000 then 'Pahal�'
                 else 'Di�er'
            end as Segment
    from product
    )
select Segment, COUNT(*)
from tbldeneme
group by Segment;



-- Her rengin en pahali fiyati gelsin
select color, max(listprice)
from product
group by color;

-- Her rengin en pahali ilk 3 farkli fiyata sahip urunleri gelsin

-- sira numarasi uretme
select name, color, listprice, 
    RANK() OVER(order by listprice desc) as Sirano,
    DENSE_RANK() OVER(order by listprice desc) as Sirano2,
    ROW_NUMBER() OVER(order by listprice desc) as Sirano3
from product;



-- Her rengin en pahali ilk 3 farkli fiyata sahip urunleri gelsin
select *
from
    (
    select name, color, listprice, 
        RANK() OVER(partition by color order by listprice desc) as Sirano,
        DENSE_RANK() OVER(partition by color order by listprice desc) as Sirano2,
        ROW_NUMBER() OVER(partition by color order by listprice desc) as Sirano3
    from product
    )
where Sirano2 <= 3;


-- Her musterinin vermis oldugu sadece son 3 adet siparisi gelsin
select *
from
    (
    select customerid, orderdate, subtotal, 
        ROW_NUMBER() OVER(partition by customerid order by orderdate desc) as Sirano
    from salesorderheader
    )
where Sirano <= 3;


-- Fiyati en pahali olan 3. yuzde 10 luk urun dilimi gelsin
select *
from
    (
    select name, color, listprice,
        NTILE(10) OVER(order by listprice desc) as Parcano
    from product
    )
where Parcano = 3;

-- Aylik cirolar�m�z toplam genel cironun yuzde kacini olusturuyor
create view vwAylikCiro
as
    select EXTRACT(year from orderdate) as Yil, 
            EXTRACT(month from orderdate) as Ay,
            SUM(subtotal) as Ciro
    from salesorderheader
    group by EXTRACT(year from orderdate), EXTRACT(month from orderdate)
    order by Yil asc, Ay asc;



select Yil, Ay, Ciro,
    ROUND(RATIO_TO_REPORT(Ciro) OVER() * 100, 2)  as AylikOran,
    ROUND(RATIO_TO_REPORT(Ciro) OVER(partition by Yil) * 100, 2)  as AylikOranYilBazli
from vwaylikciro
order by Yil asc, Ay asc;

-- Kumulatif Toplam ve Hareketli Ortalama Hesabi
select Yil, Ay, Ciro, 
    SUM(Ciro) OVER(order by Yil asc, Ay asc) as GenelKumulatifToplam,
    SUM(Ciro) OVER(partition by Yil order by Yil asc, Ay asc) as YillikKumulatifToplam,
    AVG(Ciro) OVER(order by Yil asc, Ay asc) as GenelHareketliOrtalama
from vwAylikCiro;

-- sliding window
select Yil, Ay, Ciro, 
    SUM(Ciro) OVER(order by Yil asc, Ay asc 
            ROWS BETWEEN 12 PRECEDING AND CURRENT ROW) as Son12AyinKumulatifToplam,
    SUM(Ciro) OVER(partition by Yil order by Yil asc, Ay asc) as YillikKumulatifToplam,
    AVG(Ciro) OVER(order by Yil asc, Ay asc
            ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) as UcAyOncesiIleUcAySonrasiOrtalama
from vwAylikCiro;

-- Bu ay elde edilen ciroyu gecen ay elde edilen ciroyla karsilastirip aradaki farki bulun
select Yil, Ay, Ciro,
    LAG(Ciro) OVER(order by Yil asc, Ay asc) as BirOncekiAydakiCiro,
    Ciro - LAG(Ciro) OVER(order by Yil asc, Ay asc) as Fark,
    LEAD(Ciro) OVER(order by Yil asc, Ay asc) as BirSonrakiAydakiCiro
from vwaylikciro;



select Yil, Ay, Ciro,
    LAG(Ciro, 12, 0) OVER(order by Yil asc, Ay asc) as BirOncekiYilinAyniAydakiCiro,
    Ciro - LAG(Ciro, 12, 0) OVER(order by Yil asc, Ay asc) as Fark,
    LEAD(Ciro, 12, 0) OVER(order by Yil asc, Ay asc) as BirSonrakiYilinAyniAydakiCiro
from vwaylikciro;


/* GROUP BY EXTENSIONS
-------------------------------
1- CUBE
2- ROLLUP
3- GROUPING SETS

*/
-- CUBE
select EXTRACT(year from orderdate) as Yil, 
            EXTRACT(month from orderdate) as Ay,
            SUM(subtotal) as Ciro
from salesorderheader
group by CUBE ( EXTRACT(year from orderdate), EXTRACT(month from orderdate) )
order by Yil asc, Ay asc;

-- ROLLUP
select EXTRACT(year from orderdate) as Yil, 
            EXTRACT(month from orderdate) as Ay,
            SUM(subtotal) as Ciro
from salesorderheader
group by ROLLUP ( EXTRACT(year from orderdate), EXTRACT(month from orderdate) )
order by Yil asc, Ay asc;

-- GROUPING SETS
select EXTRACT(year from orderdate) as Yil, 
            EXTRACT(month from orderdate) as Ay,
            SUM(subtotal) as Ciro
from salesorderheader
group by GROUPING SETS (  (EXTRACT(year from orderdate)), (EXTRACT(month from orderdate)), ()  )
order by Yil asc, Ay asc;



-- PIVOT ve UNPIVOT
create view VWPIVOTDATA
as
select *
from
    (
    select EXTRACT(year from orderdate) as Yil, 
                EXTRACT(month from orderdate) as Ay,
                SUM(subtotal) as Ciro
    from salesorderheader
    group by EXTRACT(year from orderdate), EXTRACT(month from orderdate)
    order by Yil asc, Ay asc
    )
PIVOT (SUM(Ciro) for Ay IN (1 as OCA,2 as SUB,3 as MAR,4 as NIS,5 as MAY,6 as HAZ,7 as TEM
                            ,8 as AGU,9 as EYL,10 as EKI,11 as KAS,12 as ARA))
order by Yil asc;

-- UNPIVOT
select *
from vwpivotdata
UNPIVOT (Ciro for Ay IN (OCA,SUB,MAR,NIS,MAY,HAZ,TEM,AGU,EYL,EKI,KAS,ARA));





