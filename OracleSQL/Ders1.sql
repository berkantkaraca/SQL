select * 
from product;

select name, color,listprice 
from product;

-- Fiyatı 0 olan ürünler
select name, color,listprice 
from product
where listprice = 0;

-- Fiyatı 0'dan farklı olan ürünler
select name, color,listprice 
from product
where listprice != 0; -- <> buda eşit değildir anlamındadır

-- Fiyatı 1000 - 2000 arasında olan ürünler
select name, color,listprice 
from product
where listprice between 1000 and 2000; -- başlangıç ve bitiş değerleri dahildir

select name, color,listprice 
from product
where (listprice > 1000) and (listprice < 2000); -- 2 koşul and veya or ile birleştirilir. Bu yöntemde sınırları =>, =< operatörleriyle dahil ederdim.

-- Rengi siyah veya kırmızı olup ve aynı zamanda fiyatı 1000'den büyük olan ürünler
select name, color,listprice 
from product
where (color = 'Black' or color = 'Red') and (listprice > 1000);

-- Rengi siyah, kırmızı, mavi veya sarı olan ürünler gelsin
-- IN: bir kolon içinde birden fazla değeri  filtrelem
select name, color,listprice 
from product
where (color = 'Black' or color = 'Red' or color = 'Yellow' or color = 'Blue');

select name, color,listprice 
from product
where color in ('Black', 'Red', 'Yellow', 'Blue');

select name, color,listprice 
from product
where lower(color) in ('black', 'red', 'yellow', 'blue'); -- lower: color kolonundan gelen değerleri küçük harf yapar ve karşılaştırır. In içindekileri de küçük yazman lazım. Upperda tam tersi

-- Rengi siyah, kırmızı, mavi veya sarı olmayan ürünler gelsin
select name, color,listprice 
from product
where lower(color) not in ('black', 'red', 'yellow', 'blue') or color is null; --in ve not in kullanınca null olanlar gelmez

-- Rengi null olan ürünler gelsin
select name, color,listprice 
from product
where color is null;

-- Rengi null olmayan ürünler gelsin
select name, color,listprice 
from product
where color is not null;

/* Like
-----------------------
Metinsel veriler içinde arama yapılmak için kullanılır
% => 0 veya daha fazla karakter 
_ => sadece tek 1 adet karakteri temsil eder
*/

-- Soyadı k harfi ile başlayan kişiler
select *
from person  
where lastname like 'K%';

-- Soyadı k harfi ile biten kişiler
select *
from person  
where lastname like '%k';

-- Soyadında k harfi bulunan kişiler
select *
from person  
where upper(lastname) like '%K%';

-- Soyadının sondan 3. harfi k olanlar
select *
from person  
where upper(lastname) like '%K__';

-- sadece 771-555-0180 formatında olan telefonlar
select *
from personphone
where phonenumber like '___-___-____';

-- Sadece 2007 yılındaki siparişler gelsin
select * 
from salesorderheader
where EXTRACT(YEAR FROM orderdate) = 2007; --fonksiyon kullanmak sorguyu yavaşlatır. 4. yöntemdeki gibi filtreleme yaparken yalın halde filtreleme önerilir

select * 
from salesorderheader
where orderdate between '01-JAN-07' and '31-DEC-07';

select * 
from salesorderheader
where orderdate between TO_DATE('01.01.2007', 'DD.MM.YYYY') and TO_DATE('31.12.2007', 'DD.MM.YYYY'); -- TO_DATE: istediğin formatta tarih, formatın kalıbını yaz
-- başlangıç- bitiş dahil olacak mı? 
-- saat bilgisi nolcak? saat bilgisi 00:00 yazılır. son gün çekilemez. Bunun için bir gün sonrası çekilebilir veya todate fonk düzenle: TO_DATE('31.12.2007 23:59:59', 'DD.MM.YYYY HH24:MI:SS')

select * 
from salesorderheader
where orderdate >= TO_DATE('01.01.2007', 'DD.MM.YYYY') and orderdate < TO_DATE('31.12.2007', 'DD.MM.YYYY'); -- BU SORUNUN TAVSİYE EDİLEN YÖNTEM

select * 
from salesorderheader
where orderdate like '%07'; -- Lıke tarihsel verilerde önerilmez

select * 
from salesorderheader
where TO_CHAR(orderdate, 'YYYY') = '2007'; -- yıl kısmını char'a çevirir
--------------------------------------------------------------------------------

-- Kaç farklı renk mevcut
select distinct color
from product;

select unique color
from product; --oracle'da geçerli

select distinct color, sized
from product; -- bu şekilde 2'li olarak tekiller. composit key mantığı

-- Fiyatı 0-1000 => ucuz
-- Fiyatı 1000-2000 => orta
-- Fiyatı >2000 => pahalı olarak gelsin
select name, color, listprice, 
    case when listprice between 0 and 1000 then 'Ucuz'
         when listprice between 1000 and 2000 then 'Orta'
         when listprice > 2000 then 'Pahalı'
         else 'Diğer' 
    end as Segment
from product;

-- Ürün renkleri türkçe olarak gösterilsin
select name, color, listprice, 
    case when color = 'Black' then 'siyah'
         when color = 'Red' then 'kırmızı'
         when color = 'Blue' then 'Mavi'
         else 'Diğer' 
    end as Renk
from product;

-- Ürünler fiyarlarına göre küçükten büyüğe doğru sıralı gelsin
select name, color, listprice
from product
order by listprice asc;

-- Ürünler fiyarlarına göre büyüten küçüğe doğru sıralı gelsin
select name, color, listprice
from product
order by listprice desc;

--Ürünler önce fiyata göre asc, fiyatı aynı olan ürünlerde kendi içlerinde isme göre a-z sırala
select name, color, listprice
from product
order by listprice asc, name asc;

-- Ürünler renge göre a-z sırala
select name, color, listprice
from product
order by color asc;

-- Ürünler renge göre z-a sırala
select name, color, listprice
from product
order by color desc;

-- Ürünler renge göre z-a sırala, null değerler en sonda 
select name, color, listprice
from product
order by color desc nulls last; -- nulls first ile de başta gelir

-- Fiyatı en pahalı olan ilk 10 ürün gelsin
-- önce sıralama sonra sorgulamak lazım

/*
select name, color, listprice, rowid, rownum --sanal kolonlardır. rowid: bu satır diskin hangi adresinde tutuluyosa onu gösterir, rownum: kaydediliş sırası"
    from product
    order by listprice desc;
*/

select name, color, listprice 
from 
    (
    select name, color, listprice--, rowid, rownum --sanal kolonlardır. rowid: bu satır diskin hangi adresinde tutuluyosa onu gösterir, rownum: kaydediliş sırası"
    from product
    order by listprice desc
    )
where rownum <= 10;


select name, color, listprice
from product
order by listprice desc
FETCH FIRST 10 ROWS ONLY; 
-- offset 0 rows fetch next 10 rows only;
-- offsrt: veri sıralandıktan sonra atlanacak satır sayısı. hiç yazmazsan hiç atlama yapmaz
-- fetch: getirilecek satır sayısı

