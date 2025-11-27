/*
    Record tipleri:
    Table-based 
    Cursor-based => selecten dönen kaydı tutar
    Programmer-defined => hangi kolnları tutacağını ben tanımlarım

    Cursor her zaman kapanması gerektiği için exception alırsa ve close komutu çalışmazsa best practice exception kısmında cursor açık mı kontrolü yapılır ve kapatılır 

    Cursor parametreleri
    notfound => getirecek satır kalmadı
    found => getirecek satır var
    rowcount => işlenen satır sayısı
    isopen => cursor açık mı kapalı mı olduğunu gösterir

    Trigger özel bir prosedürdür. Yapılan işlem tetikler. Normal prosedürden farkı başka bir işlem (insert, update, delete) tetikler. Normalleri biz kendimiz tetikleriz.
    Çok fazla trigger kullanmak system db'yi performans açısından olumsuz etkiler. Mümkün mertebe alternatif çözümü varsa uygula yoksa mecbur kullancan.
    Odit işlemlerini triger ile yapılmaz. Odit özelliklerini kullan

                                                Insert       Update       Delete
    :NEW (mssql'de inserted tablosu vardır)=>       +           +           -     => Yeni gelen değeri tutar
    :OLD (mssql'de deleted tablosu vardır)=>       -            +           +     => Eski değeri tutar



    ÖDEV: Geçen hafta yazılan dinamik pivot örneğini incele
    ÖDEV: ETL nedir, hangi araçlar kullanılır araştır sadece

*/