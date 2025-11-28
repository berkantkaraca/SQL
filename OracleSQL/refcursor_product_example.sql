SET SERVEROUTPUT ON;
DECLARE
    TYPE t_product_cursor IS REF CURSOR;
    v_product_cursor t_product_cursor;
    
    v_product_id PRODUCT.PRODUCTID%TYPE;
    v_product_name PRODUCT.NAME%TYPE;
    v_category_name PRODUCTCATEGORY.NAME%TYPE;
    v_subcategory_name PRODUCTSUBCATEGORY.NAME%TYPE;
    v_list_price PRODUCT.LISTPRICE%TYPE;
    v_standard_cost PRODUCT.STANDARDCOST%TYPE;
    v_stock PRODUCT.SAFETYSTOCKLEVEL%TYPE;
    v_color PRODUCT.COLOR%TYPE;
    v_counter NUMBER := 0;
    v_total_value NUMBER := 0;
    v_stock_status VARCHAR2(20);
    
    -- Örnek kategoriler (Bikes, Clothing, Accessories, Components)
    v_category_filter VARCHAR2(50) := '&p_category';
    
BEGIN
    DBMS_OUTPUT.PUT_LINE( v_category_filter ||' Kategorisi Ürünleri: ' );
    DBMS_OUTPUT.PUT_LINE('');
    
    OPEN v_product_cursor 
    FOR
        SELECT  p.PRODUCTID, p.NAME, pc.NAME AS CATEGORY_NAME, psc.NAME AS SUBCATEGORY_NAME, p.LISTPRICE, p.STANDARDCOST, p.SAFETYSTOCKLEVEL, p.COLOR
        FROM PRODUCT p
        INNER JOIN PRODUCTSUBCATEGORY psc ON p.PRODUCTSUBCATEGORYID = psc.PRODUCTSUBCATEGORYID
        INNER JOIN PRODUCTCATEGORY pc ON psc.PRODUCTCATEGORYID = pc.PRODUCTCATEGORYID
        WHERE pc.NAME = v_category_filter
        ORDER BY p.LISTPRICE DESC;
    LOOP
        FETCH v_product_cursor 
        INTO v_product_id, v_product_name, v_category_name, v_subcategory_name, v_list_price, v_standard_cost, v_stock, v_color;
        
        EXIT WHEN v_product_cursor%NOTFOUND;
        v_counter := v_counter + 1;

        -- Toplam ürün değeri hesaplama
        v_total_value := v_total_value + (v_list_price * v_stock);
        
        -- Ürün bilgilerini yazdırma
        DBMS_OUTPUT.PUT_LINE('--- ÜRÜN #' || v_counter || ' ---');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_product_id);
        DBMS_OUTPUT.PUT_LINE('Ürün Adı: ' || v_product_name);
        DBMS_OUTPUT.PUT_LINE('Alt Kategori: ' || v_subcategory_name);
        DBMS_OUTPUT.PUT_LINE('Renk: ' || NVL(v_color, 'Belirtilmemiş'));
        DBMS_OUTPUT.PUT_LINE('Liste Fiyatı: ' || TO_CHAR(v_list_price, '$999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Maliyet: ' || TO_CHAR(v_standard_cost, '$999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Stok Sayısı: ' || v_stock);
        DBMS_OUTPUT.PUT_LINE('');

        IF v_counter >= 5 THEN
            DBMS_OUTPUT.PUT_LINE('... (İlk 5 ürün gösterildi)');
            EXIT;
        END IF;
    END LOOP;
    
    CLOSE v_product_cursor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('HATA: ' || SQLERRM);
        IF v_product_cursor%ISOPEN THEN
            CLOSE v_product_cursor;
        END IF;
END;
/
