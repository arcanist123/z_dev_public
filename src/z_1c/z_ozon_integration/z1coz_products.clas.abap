CLASS z1coz_products DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_product,
        product_id TYPE string,
        ozon_id    TYPE string,
      END OF ts_product.
    TYPES tt_products TYPE STANDARD TABLE OF ts_product WITH EMPTY KEY.
    METHODS constructor.

    METHODS get_products
      RETURNING
        VALUE(rt_products) TYPE tt_products.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS gc_page_size TYPE int4 VALUE 1000.
    DATA go_ozon_http_service TYPE REF TO z1coz_service.
    DATA gv_method TYPE string VALUE `/v1/product/list`.
    METHODS get_request_for_product_count
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS get_products_by_packages
      IMPORTING
        iv_product_count TYPE i
      RETURNING
        VALUE(r_result)  TYPE tt_products.
    METHODS get_request_for_product_page
      IMPORTING
        iv_current_page TYPE i
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS get_products_by_page
      IMPORTING
        iv_page         TYPE i
      RETURNING
        VALUE(r_result) TYPE z1coz_products=>tt_products .
ENDCLASS.



CLASS z1coz_products IMPLEMENTATION.


  METHOD constructor.
    me->go_ozon_http_service = z1coz_service=>create_by_current_config( ).

  ENDMETHOD.


  METHOD get_products.

    DATA(lv_product_count_request) = me->get_request_for_product_count( ).
    DATA(ls_product_count) = me->go_ozon_http_service->request_data(    iv_method       = gv_method
                                                                        iv_request_body = lv_product_count_request ).
    rt_products = me->get_products_by_packages( ls_product_count-total ).

  ENDMETHOD.


  METHOD get_products_by_packages.
    DATA lt_products LIKE r_result.
    DATA(lo_page_iterator) = NEW lcl_page_iterator( iv_product_count    = iv_product_count
                                                    iv_page_size        = me->gc_page_size ).
    WHILE lo_page_iterator->get_next( ) = abap_true.
      APPEND LINES OF me->get_products_by_page( lo_page_iterator->get_current_page( ) ) TO lt_products.
    ENDWHILE.

    r_result = lt_products.
  ENDMETHOD.


  METHOD get_request_for_product_count.
    r_result = `{ "page": 1, "page_size": 1 }` ##NO_TEXT.
  ENDMETHOD.

  METHOD get_request_for_product_page.
    r_result = |\{ "page": { iv_current_page }, "page_size": { me->gc_page_size } \}|.
  ENDMETHOD.


  METHOD get_products_by_page.

    DATA(lv_request_body) = me->get_request_for_product_page( iv_page ).
    DATA(ls_products) = me->go_ozon_http_service->request_data( iv_method       = me->gv_method
                                                                iv_request_body = lv_request_body ).
    r_result = ls_products-items.

  ENDMETHOD.

ENDCLASS.
