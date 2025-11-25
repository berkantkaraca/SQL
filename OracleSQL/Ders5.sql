-- Pivot: satırları sütunlara çevirir
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


create view VWPIVOTDATA as
select *
from (
    select extract(year from orderdate) as Yıl, extract(month from orderdate) as Ay, sum(subtotal)as Ciro
    from salesorderheader
    group by extract(year from orderdate), extract(month from orderdate)
    order by Yıl asc, AY asc
)
pivot (
    sum(Ciro)
    for Ay in (1 as Ocak, 2 as Şubat, 3 as Mart, 4 as Nisan, 5 as Mayıs, 6 as Haziran,
               7 as Temmuz, 8 as Ağustos, 9 as Eylül, 10 as Ekim, 11 as Kasım, 12 as Aralık)
)
order by Yıl asc;

-- Unpivot: sütunları satırlara çevirir
select * 
from VWPIVOTDATA
unpivot (
    Ciro for Ay in (Ocak, Şubat, Mart, Nisan, Mayıs, Haziran,
                    Temmuz, Ağustos, Eylül, Ekim, Kasım, Aralık)
);

/* Index
--------



Tablolarda filtreleme yapılan kolonlarda index oluşturulması sorgu performansını artırır
Join sorgularında on kısmında kullanılan kolonlarda index oluşturulması sorgu performansını artırır
Gruplama yapılan kolonlarda index oluşturulması sorgu performansını artırır
where kısmında birden fazla kolon varsa ikisinde de index oluşturulması sorgu performansını artırır çünkü seçicilik oranı artar (composite index)

Seçicilik : Sorgudan gelmesi gelen satır sayısının tablodaki toplam satır sayısına oranı
Seçicilik oranı yüksekse index kullanma oranı artar, azaldıkça indexi kullanma oranı azalır
900 sayfalık kitapta 2 sayfa aranması => 2/900 seçicilik oranı yüksek
900 sayfalık kitapta 800 sayfa aranması => 800/900 seçicilik oranı düşük

Null değerler indexlenmez. Tasarımda null geçilmemesi gereken kolonlara not null kısıtı eklenmelidir.
PK ve Unique kısıtları otomatik olarak index oluşturur.
FK kısıtları index oluşturmaz. Performans için index oluşturulması tavsiye edilir.

Indexler zamanla fragmente (bozuluur) olur. Bu yüzden periyodik olarak rebuild edilmesi gerekir. Kullanılmayan indexler silinmelidir.

DML işlemleri indexleri fragmente eder. 1M kullanıcın var, yeni kayıt ekledin. adı selçuk olsun. tabloya işlemi yapar daha sonra indexi günceller. Bu durum insert, update, delete işlemlerinde olur.

*/


/*Explain Plan
--------------
Explain plan, bir SQL sorgusunun nasıl çalıştırılacağını gösteren bir araçtır. Sorgunun yürütülme planını analiz ederek performans sorunlarını tespit etmeye yardımcı olur.
Operation: Sorgunun hangi işlemleri gerçekleştirdiğini gösterir.
Options: İşlemin nasıl gerçekleştirileceğine dair ek bilgileri içerir.
Object Name: İşlemin hangi tablo veya indeks üzerinde gerçekleştirildiğini gösterir.
Cardinality: İşlemin sonucunda beklenen satır sayısını gösterir.
Cost: Sorgunun yürütülme maliyetini gösterir.

Cost yüksekse sorgu daha çok ramor ve cpu kullanır. Cost düşükse sorgu daha az ramor ve cpu kullanır.

*/
-- Index kullandı cost 2
select salesorderid, orderdate, subtotal
from salesorderheader
WHERE salesorderid = 44000;

-- Index kullanmadı cost 171
select salesorderid, orderdate, subtotal
from salesorderheader
WHERE salesorderid between 44000 and 50000;

-- Index oluşturmadan önce cost 5
select name, color, listprice
from product
where color = 'White';

create index color_ix
on product(color);

-- Index oluşturduktan sonra cost 2
select name, color, listprice
from product
where color = 'White';

-- 504 üründen 1 tane ürün geliyor ama index kullanmadı 
select name, color, listprice
from product
where listprice = 34.99 and color = 'Red';


-- null değerler indexlenmez bu yüzden index kullanmadı
select * 
from product
where color is NULL;

-- lower fonksiyonu kullanıldığı için index kullanmadı
-- best practice: filtrelemede fonksiyon kullanmadan yapabiliyorsan sorgunu fonksiyonsuz yaz
-- cost 5
select *
from product
where lower(color) = 'white';

-- Function-based index: filtrelemede fonksiyon kullanılması gerekiyorsa function-based index oluşturulabilir
create index color_fb_ix
on product(lower(color));

-- index oluşturulduktan sonra cost 2
select *
from product
where lower(color) = 'white';

select salesorderid, customerid, to_char(orderdate,'DD.MM.YYYY')
from salesorderheader
where to_char(orderdate,'DD.MM.YYYY') = '22-FEB-2007';

create index ix_orderdate
on salesorderheader(to_char(orderdate,'DD.MM.YYYY'));













