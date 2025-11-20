/* Table Expression (Sanal Tablo)
---------------------
1- Derived Table (Subquery)
2- Common Table (CTE - With Clause)

Aynı sorguda işlem yapamadığında sanal tablo oluşturup sorguda kullanılır
*/

-- Fiyatı 0-1000 => ucuz
-- Fiyatı 1000-2000 => orta
-- Fiyatı >2000 => pahalı olarak gelsin
-- Kaç adet ucuz, kaç adet orta, kaç adet pahalı ürün var
-- 1- Derived Table (Subquery) çözümü
select Segment, count(*)
from (
    select name, color, listprice, 
        case when listprice between 0 and 1000 then 'Ucuz'
            when listprice between 1000 and 2000 then 'Orta'
            when listprice > 2000 then 'Pahalı'
            else 'Diğer' 
        end as Segment
    from product
) tbl --tbl: burdan dönen sanal tablonun adı. Oracle'da yazılması zorunlu değil ama MSSQL'de zorunlu.
group by Segment;

-- Fiyatı 0-1000 => ucuz
-- Fiyatı 1000-2000 => orta
-- Fiyatı >2000 => pahalı olarak gelsin
-- Kaç adet ucuz, kaç adet orta, kaç adet pahalı ürün var
-- 2- Common Table (CTE - With Clause) çözümü
with tbldeneme as (
    select name, color, listprice, 
        case when listprice between 0 and 1000 then 'Ucuz'
            when listprice between 1000 and 2000 then 'Orta'
            when listprice > 2000 then 'Pahalı'
            else 'Diğer' 
        end as Segment
    from product
)
select Segment, count(*)
from tbldeneme
group by Segment;

-- subquery aynı sorguda birden fazla kullanılacaksa 2. yöntemi kullanmak performans açısından daha iyi. 


-- Oracle Analitik Fonksiyonlar
-------------------------------
-- Her rengin en pahalı fiyatı gelsin
select color, max(listprice)
from product
group by color;

-- Sıra numarası üretme: 3 fonksiyonu  var.
-- over() => kendisinden önce yazılan analitik fonksiyonun nasıl bir verinin içinde çalışacağını söyler ve her analitik fonksiyondan sonra yazılmalıdır
-- rank() over(order by listprice desc)=> parametre almaz. listprice'a göre sıralayığ sıra numarası üretir. Sıraladığı değer aynıysa aynı sırayı verir. Yani aynı fiyatlar aynı sıra numarasına sahiptir ve aynı fiyat oldukça saymaya devam eder. Sıra numarası değişmez ama bir sonraki fiyata geçerken kaldığı id'den devam eder. İlk 5 aynı fiyata 1 yazdı, farklı fiyata geçince gap bırakır ve 6 sıranosu verir.
-- dense_rank() over(order by listprice desc) as SıraNo => rankten farkı gap bırakmaz. İlk 5 aynı fiyata 1 yazdı, farklı fiyata geçince gap bırakırmaz ve 2 sıranosu verir.
-- row_number() over(order by listprice desc) => fiyatın aynı olması önemli değil artan sırada sıra verir
select name, color, listprice, 
    rank() over(order by listprice desc) as rank,
    dense_rank() over(order by listprice desc) as dense_rank,
    row_number() over(order by listprice desc) as rownumber
from product;

-- Her rengin en pahalı ilk 3 farklı fiyata sahip ürünleri gelsin
-- over kullanarak gruplama işleminde partition by yazılır. group by yazılmaz.
select *
from  (
    select name, color, listprice, 
        rank() over(partition by color order by listprice desc) as rank,
        dense_rank() over(partition by color order by listprice desc) as dense_rank,
        row_number() over(partition by color order by listprice desc) as row_number
    from product
)
where dense_rank <= 3;

-- Her müşterinin vermiş olduğu sadece son 3 adet siparişi gelsin
select * 
from (
    select customerid, orderdate,
        row_number() over(partition by customerid order by orderdate desc) as row_number
    from salesorderheader
)
where row_number <= 3;

-- Fiyatı en pahalı olan 3. %10'luk ürün dilimi gelsin
-- ntile(sayi): tabloyu sayi kadar eşit parçalara böler
-- 504 satır için 500'ü parçalar, kalan 4ü en baştan sırayla parçalara ekler. 
select * 
from (
    select name, color, listprice,
        ntile(10) over(order by listprice desc) as ParcaNo
    from product
)
where ParcaNo = 3;

-- Aylık cirolarımız toplam genel cironun yüzde kaçını oluşturur
create view VWAylikCiro as
select extract(year from orderdate) as Yıl, extract(month from orderdate) as Ay, sum(subtotal)as Ciro
from salesorderheader
group by extract(year from orderdate), extract(month from orderdate)
order by Yıl asc, AY asc;

-- ratio_to_report(hesaplanacak_kolon) => oran hesaplar
-- aylık cironun genel toplam ciroya oranı
select yil, ay, ciro,
    round(ratio_to_report(ciro) over()* 100, 2)  as AylikOran
from VWAylikCiro; 

-- Aylık cironun kendi yılındaki ciroya oranı hesapla
select yil, ay, ciro,
    round(ratio_to_report(ciro) over()* 100, 2)  as AylikOran,
    round(ratio_to_report(ciro) over(partition by yil)* 100, 2)  as AylikOranYılBazlı
from VWAylikCiro
order by Yıl asc, AY asc;

-- Kümülatif toplam ve hareketli ortalama hesabı
-- Kümülatif toplam: üzerinde işlem yapılan satıra kadar toplaya toplaya gider
-- Hareketli ortalama: üzerinde işlem yapılan satıra kadar ortalmasını alarak gider
-- sum yanına over ekleyerek analitik fonksiyona dönüştürdük. bunu tüm aggregate fonksiyonlara uygulayabilirsin
select yil, ay, ciro,
    sum(ciro) over(order by yil asc, ay asc) as GenelKümülatifToplami, -- hangi sırada tolayacak ve hangi satırı toplayacak (yıla ve aya göre sıralayıp)
    sum(ciro) over(partition by yil order by yil asc, ay asc) as YıllıkKümülatifToplam, 
    round(avg(ciro) over(partition by yil order by yil asc, ay asc)  ) as GenelHareketliOrtalma
from VWAylikCiro;

/* Sliding Window
------------------

*/
select yil, ay, ciro,
    sum(ciro) over(order by yil asc, ay asc rows between unbounded preceding and current row) as GenelKümülatifToplami, -- unbounded preceding: en baştan toplamaya başla (veri setindeki ilk satırdan başlar), current row: bulunduğu satıra kadar topla. bunu yazmazsan default olarak bu çalışır
    sum(ciro) over(order by yil asc, ay asc rows between 12 preceding and current row) as Son12AyınKümülatifToplami, -- 12 satır öncesinden başlar
    sum(ciro) over(partition by yil order by yil asc, ay asc rows between 12 preceding and current row) as YıllıkKümülatifToplam, 
    round(avg(ciro) over(partition by yil order by yil asc, ay asc rows between 3 preceding and 3 following) ) as UcAyÖncesi_UcAySonrasıHareketliOrtalma -- 3 ay öncesi ve 3 ay sonrasındaki değerleri kullanır
from VWAylikCiro;

-- Bu ay elde edilen ciroyu geçen ay elde edilen ciro ile karşılaştırıp aradaki farkı bulun
-- Sütunlar arası 4 işlem yapılamaz ama satır içindeki kolonlar arası yapılır
-- Leg(öncekiSatırdanÇekilecekKolon): önceki satırı yanına getirir
-- Lead(sonrakiSatırdanÇekilecekKolon): sonraki satırı yanına getirir
select yil, ay, ciro,
    lag(ciro) over(order by yil asc, ay asc) as BirOncekiAydakiCiro,
    ciro - lag(ciro) over(order by yil asc, ay asc) as Fark,
    lead(ciro) over(order by yil asc, ay asc) as BirSonrakiAydakiCiro
from VWAylikCiro;

-- 2025 temmuz ile 2024 
-- leg'in ikinci parametresi default olarak 1. bunu değiştirirsek o kadar ay geriye gider. lead bunun tam tersi.
-- leg'in üçüncü parametresi eğer o değer null ddönerse ne yazılacağını belirler
select yil, ay, ciro,
    lag(ciro, 12, 0) over(order by yil asc, ay asc) as BirOncekiYılınAynıAydakiCiro,
    ciro - lag(ciro, 12, 0) over(order by yil asc, ay asc) as Fark,
    lead(ciro, 12, 0) over(order by yil asc, ay asc) as BirSonrakiYılınAynıAydakiCiro
from VWAylikCiro;

/* Group by Extensions
----------------------
1- Cube
2- Rollup
3- Grouping Sets
*/
/*
- Cube(a,b): ara toplam ve genel toplamın hepisni hesaplar.
- a ve b gruplar, ayı grublar, b'yi gruplar, a-b hesaba katmadan gruplar(bu genel toplamı verir).
- 2sini aynı anda gruplar, sadece ayları gruplar, sadece yılları gruplar, hiç birini dahil etmeden genel toplamı bulur
- ay kısmında null yazıyosa yıllık ara toplamı verir
- yıll kısmında null yazıyorsa aylık ara toplamı verir
- hem yıl hem ay null ise genel toplamı verir

- Cube(a,b) => a,b
                a
                b
                GT
- Cube(a,b,c) => a,b,c
                a,b
                a,c
                b,c
                a
                b
                c
                GT
*/
select extract(year from orderdate) as Yıl, extract(month from orderdate) as Ay, sum(subtotal)as Ciro
from salesorderheader
group by cube(extract(year from orderdate), extract(month from orderdate))
order by Yıl asc, AY asc;

/*
- önce parantez içindekileri beraber gruplar
- sonra son taraftan atıp geri kalanları gruplar
- yıl ve ayı grupladı ve ayı çıkardı, yıla göre grupladı ve yılı çıkardı ve hiç bir şey kalmamış halide gruplar genel toplam hesaplanır

- rollup(a, b) => a,b
                    a
                    GT 

- rollup(a, b,c) => a,b,c
                    a,b
                    a
                    GT
*/
select extract(year from orderdate) as Yıl, extract(month from orderdate) as Ay, sum(subtotal)as Ciro
from salesorderheader
group by rollup(extract(year from orderdate), extract(month from orderdate))
order by Yıl asc, AY asc;


/*
custom gruplama yazmak isteniyorsa grouping sets kullanılır
sadece yıllar ve sadece aylar isteniyorsa vb
grouping sets( (extract(year from orderdate)), (extract(month from orderdate)), () ) => ilk önce 1. parantezdeki kolonu gruplar sonra devam eder... Boş bıraktığında genel toplamı verir


*/
select extract(year from orderdate) as Yıl, extract(month from orderdate) as Ay, sum(subtotal)as Ciro
from salesorderheader
group by grouping sets( (extract(year from orderdate)), (extract(month from orderdate)), () )
order by Yıl asc, AY asc;




















