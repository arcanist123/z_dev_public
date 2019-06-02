*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_page_iterator DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_product_count TYPE int4
        iv_page_size     TYPE int4 DEFAULT 1000
      .
    METHODS get_next
      RETURNING
        VALUE(r_result) TYPE abap_bool.
    METHODS get_current_page
      RETURNING
        VALUE(r_result) TYPE int4.
  PROTECTED SECTION.
  PRIVATE SECTION.


    DATA gv_product_count TYPE int4.
    DATA gv_page_size TYPE int4.
    DATA gv_current_page TYPE int4.
    DATA gv_max_pages TYPE int4.

    METHODS get_max_pages
      RETURNING VALUE(rv_max_pages) TYPE int4.

ENDCLASS.

CLASS lcl_page_iterator IMPLEMENTATION.

  METHOD constructor.

    me->gv_product_count = iv_product_count.
    me->gv_page_size = iv_page_size.
    me->gv_max_pages = me->get_max_pages( ).
  ENDMETHOD.

  METHOD get_next.
    DATA lx_next_exist LIKE r_result.

    IF me->gv_current_page < me->gv_max_pages.
      me->gv_current_page = me->gv_current_page + 1.
      lx_next_exist = abap_true.
    ENDIF.

    r_result = lx_next_exist.
  ENDMETHOD.

  METHOD get_max_pages.
    DATA(lv_whole_pages) = me->gv_product_count div me->gv_page_size.
    DATA(lv_partial_pages) = me->gv_product_count mod me->gv_page_size.
    IF lv_partial_pages > 0.
      lv_whole_pages = lv_whole_pages + 1.
    ENDIF.


    rv_max_pages = lv_whole_pages.
  ENDMETHOD.


  METHOD get_current_page.
    r_result = me->gv_current_page.

  ENDMETHOD.

ENDCLASS.
