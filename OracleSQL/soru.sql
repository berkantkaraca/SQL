SET SERVEROUTPUT ON;

DECLARE
    TYPE t_numbers IS TABLE OF NUMBER;
    v_numbers t_numbers := t_numbers();

    v_index NUMBER;
    v_test_value NUMBER;
BEGIN
    FOR i IN 1..5 LOOP
        v_numbers.EXTEND;
        v_numbers(i) := i * 10;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('KOLEKSİYON FONKSİYONLARI AÇIKLAMALARI: ');
    DBMS_OUTPUT.PUT_LINE('COUNT: Koleksiyondaki mevcut eleman sayısını döndürür');
    DBMS_OUTPUT.PUT_LINE('FIRST: Koleksiyondaki ilk elemanın index numarasını döndürür');
    DBMS_OUTPUT.PUT_LINE('LAST: Koleksiyondaki son elemanın index numarasını döndürür');
    DBMS_OUTPUT.PUT_LINE('NEXT(n): n index''inden sonraki geçerli index''i döndürür');
    DBMS_OUTPUT.PUT_LINE('PRIOR(n): n index''inden önceki geçerli index''i döndürür');
    DBMS_OUTPUT.PUT_LINE('EXISTS(n): n index''inde eleman var mı kontrol eder (TRUE/FALSE)');
    DBMS_OUTPUT.PUT_LINE('EXTEND: Koleksiyonun sonuna yeni eleman ekler (boş yer açar)');
    DBMS_OUTPUT.PUT_LINE('TRIM: Koleksiyonun sonundan eleman siler');
    DBMS_OUTPUT.PUT_LINE('DELETE(n): Belirtilen index''teki elemanı siler');
    DBMS_OUTPUT.PUT_LINE('DELETE: Tüm elemanları siler (bellek ayrılmış kalır)');
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('Güncel Koleksiyon İçeriği:');
    FOR i IN v_numbers.FIRST..v_numbers.LAST 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Index ' || i || ': ' || v_numbers(i));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('İLK DURUM: ');
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_numbers.COUNT);
    DBMS_OUTPUT.PUT_LINE('FIRST: ' || v_numbers.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST: ' || v_numbers.LAST);
    DBMS_OUTPUT.PUT_LINE('NEXT(2): ' || v_numbers.NEXT(2));
    DBMS_OUTPUT.PUT_LINE('PRIOR(3): ' || v_numbers.PRIOR(3));
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('DELETE(2) SONRASI: ');
    v_numbers.DELETE(2);
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_numbers.COUNT);
    DBMS_OUTPUT.PUT_LINE('EXISTS(2): ' ||
                         CASE 
                           WHEN v_numbers.EXISTS(2) THEN 'TRUE'
                           ELSE 'FALSE'
                         END);
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('TRIM SONRASI: ');
    v_numbers.TRIM;

    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_numbers.COUNT);
    DBMS_OUTPUT.PUT_LINE('FIRST: ' || v_numbers.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST: ' || v_numbers.LAST);
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('TRIM sonrası FIRST hala çalışıyor mu? ');
    IF v_numbers.FIRST IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('FIRST çalışıyor: ' || v_numbers.FIRST);
        DBMS_OUTPUT.PUT_LINE('İlk elemanın değeri: ' || v_numbers(v_numbers.FIRST));
    END IF;
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('EXISTS ile index kontrolleri: ');
    DBMS_OUTPUT.PUT_LINE('EXISTS(2) [Delete ile silindi]: ' ||
                         CASE WHEN v_numbers.EXISTS(2) THEN 'TRUE' ELSE 'FALSE' END);
    
    DBMS_OUTPUT.PUT_LINE('EXISTS(4) [TRIM ile kaldırıldı]: ' ||
                         CASE WHEN v_numbers.EXISTS(4) THEN 'TRUE' ELSE 'FALSE' END);

    DBMS_OUTPUT.PUT_LINE('EXISTS(3): ' ||
                         CASE WHEN v_numbers.EXISTS(3) THEN 'TRUE' ELSE 'FALSE' END);
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('NEXT ile silinmiş index''leri atlama:');
    v_index := v_numbers.FIRST;
    WHILE v_index IS NOT NULL 
    LOOP
        DBMS_OUTPUT.PUT_LINE('  Index: ' || v_index || ' => Değer: ' || v_numbers(v_index));
        v_index := v_numbers.NEXT(v_index);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('PRIOR ile geriye gezinme:');
    v_index := v_numbers.LAST;
    WHILE v_index IS NOT NULL 
    LOOP
        DBMS_OUTPUT.PUT_LINE('  Index: ' || v_index || ' => Değer: ' || v_numbers(v_index));
        v_index := v_numbers.PRIOR(v_index);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('Yeni eleman ekleme sonrası:');
    v_numbers.EXTEND;
    v_numbers(v_numbers.LAST) := 50;
    
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_numbers.COUNT);
    DBMS_OUTPUT.PUT_LINE('LAST: ' || v_numbers.LAST);
    DBMS_OUTPUT.PUT_LINE('LAST değeri: ' || v_numbers(v_numbers.LAST));
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('DELETE ALL sonrası:');
    v_numbers.DELETE;
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || v_numbers.COUNT);
    IF v_numbers.FIRST IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('FIRST: NULL (koleksiyon boş)');
    END IF;
END;
/

