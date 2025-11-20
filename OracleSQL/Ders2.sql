-- and ve or aynı anda kullanılınca işlem önceliği and'dedir

/* Sorgu komutlarının yazılma ve çalıştırılma sırası
----------------------------------------------------
Yazma Sırası                    Çalıştırılma sırası
SELECT...................................(5)
FROM.....................................(1)
WHERE....................................(2)
GROUP BY.................................(3)
HAVING...................................(4)
ORDER BY.................................(6)
*/

-- Ürün Adı, Renk, Liste Fiyatı
select name as "Ürün  Adı", color as "Renk", listprice as "Liste Fiyati"
from product
where color = 'Black' -- "Renk" = 'Black' yazamam çünkü çalışma sırası select'e gelmediği için erişemem
order by "Liste Fiyati"; -- orderby selecten ssonra çalıştığı için aliaslara erişebilir

/* Aggregate Functions
----------------------
SUM()   => toplam
MIN()   => en küçüğünü döner
MAX()   => en büyüğünü döner
COUNT() => adet, Null değerleri saymaz
AVG()   => aritmetik ortalama
*/

-- Her bir renkten kaç adet ürün var sayın
-- group by sorgularında select kısmına sadece grupladığın kolon ve aggregate fonksiyonlar yazılır
select color, count(*) as Adet
from product
group by color;

-- her bir şehirde kaç adet adres var. Çıkan sonuçları sıralayıp en çok hangi şehirde adres var bulalım
select city, count(*) as Adet
from address
group by city
order by Adet desc;

-- Her rengin en pahalı fiyatı, en ucuz fiyatı ve ortalamsı gelsin
select color, min(listprice) as min, max(listprice) as max, avg(listprice) as avg
from product
group by color;

-- Her bir yılda toplam ne kadar ciro elde edildi
select extract(year from orderdate) as Yıl, to_char(sum(subtotal), '$999,999,999.000') as Ciro
from salesorderheader
group by extract(year from orderdate)
order by Yıl asc;

-- Her bir yılın her bir ayında toplam ne kadar ciro elde edildi (aylık ciro raporu)
select extract(year from orderdate) as Yıl, extract(month from orderdate) as Ay, to_char(sum(subtotal), '$999,999,999.000') as Ciro
from salesorderheader
group by extract(year from orderdate), extract(month from orderdate)
order by Yıl asc, AY asc;

-- Sadece 5 milyon dolar ve üzerinde ciro elde edilen aylar gelsin
select extract(year from orderdate) as Yıl, extract(month from orderdate) as Ay, to_char(sum(subtotal), '$999,999,999.000') as Ciro
from salesorderheader
group by extract(year from orderdate), extract(month from orderdate)
having sum(subtotal) >= 5000000
order by Yıl asc, AY asc;

-- En az 100 adet adresi olan şehirler hangileri
select city, count(*) as Adet
from address
group by city
having count(*) >= 100
order by Adet desc;

/* Joinler
----------
1- INNER JOIN
2- OUTHER JOIN
    - LEFT JOIN
    - RIGHT JOIN
    - FULL JOIN => satır sayısı = left + right - inner
3- CROSS JOIN => ürün x renk, ürün x beden
*/

-- Sipariş tarihi, tutar, bölge adı gelsin
select * from salesorderheader where rownum <= 10;
select * from salesterritory where rownum <= 10;

-- ANSI 92
select soh.orderdate, soh.subtotal, st.name
from salesorderheader soh join salesterritory st 
on soh.territoryid = st.territoryid;

-- ANSI 89
select soh.orderdate, soh.subtotal, st.name
from salesorderheader soh, salesterritory st 
where soh.territoryid = st.territoryid;

-- Ürün Adı, Rengi, Fiyatı, Model Adı
-- ANSI 92
select p.name, p.color, p.listprice, pm.name
from product p inner join productmodel pm
on p.productmodelid = pm.productmodelid;

-- ANSI 89
select p.name, p.color, p.listprice, pm.name
from product p, productmodel pm
where p.productmodelid = pm.productmodelid;

-- Kategori Adı, alt kategori, ürün adıi, rengi , fiyatı, model adı
select pc.name as kategori, psc.name altkategori, p.name as ürünadı, p.color, p.listprice, pm.name as modeladı
from product p 
inner join productmodel pm on p.productmodelid = pm.productmodelid
inner join productsubcategory psc on p.productsubcategoryid = psc.productsubcategoryid
inner join productcategory pc on psc.productcategoryid = pc.productcategoryid;

--
select * from product;      -- 504 rows
select * from productmodel; -- 128 rows

-- Inner Join ANSI 92 sytax, 295 rows, Sadece modeli olan ürünler
select p.name, p.color, p.listprice, pm.name
from product p inner join productmodel pm
on p.productmodelid = pm.productmodelid;

-- Inner Join ANSI 89 sytax, 295 rows, Sadece modeli olan ürünler
select p.name, p.color, p.listprice, pm.name
from product p, productmodel pm
where p.productmodelid = pm.productmodelid;

-- Left Join ANSI 92 sytax, 504 rows, Modeli olan veya olmayan ürünler
select p.name, p.color, p.listprice, pm.name
from product p left join productmodel pm
on p.productmodelid = pm.productmodelid;

-- Left Join ANSI 89 sytax, 504 rows, Modeli olan veya olmayan ürünler
select p.name, p.color, p.listprice, pm.name
from product p, productmodel pm
where p.productmodelid = pm.productmodelid(+); -- null gelecek tarafa (+) koyulur

-- Right Join ANSI 92 sytax, 304 rows, Ürünü olan veya olmayan modaller
select p.name, p.color, p.listprice, pm.name
from product p right join productmodel pm
on p.productmodelid = pm.productmodelid;

-- Right Join ANSI 89 sytax, 304 rows, Ürünü olan veya olmayan modaller
select p.name, p.color, p.listprice, pm.name
from product p, productmodel pm
where p.productmodelid(+) = pm.productmodelid; -- null gelecek tarafa (+) koyulur

-- Full Join ANSI 92 sytax, 513 rows, hem bütün ürünler hem de bütün modeller (left + right)
select p.name, p.color, p.listprice, pm.name
from product p full join productmodel pm
on p.productmodelid = pm.productmodelid;

-- Full Join ANSI 89 sytax, 513 rows, hem bütün ürünler hem de bütün modeller (left + right)
select p.name, p.color, p.listprice, pm.name
from product p, productmodel pm
where p.productmodelid(+) = pm.productmodelid

union -- iki tabloyu toplar

select p.name, p.color, p.listprice, pm.name
from product p, productmodel pm
where p.productmodelid = pm.productmodelid(+);


-- Cross Join ANSI 92 sytax, 64,512 rows, kartezyen çarpım
select p.name, p.color, p.listprice, pm.name
from product p cross join productmodel pm;

-- Cross Join ANSI 89 sytax, 64,512 rows, Ürünü olan veya olmayan modaller
select p.name, p.color, p.listprice, pm.name
from product p, productmodel pm;


