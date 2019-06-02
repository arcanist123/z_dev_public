*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_ozon_id_parser DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        it_products TYPE  z1coz_products=>tt_products .
    METHODS update_ozon_id
      IMPORTING
        is_material     TYPE REF TO z_1c_json_to_upd_parser=>t_material
      RETURNING
        VALUE(r_result) TYPE z_1c_json_to_upd_parser=>t_material.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES tt_products TYPE SORTED TABLE OF z1coz_products=>ts_product WITH NON-UNIQUE KEY product_id.
    DATA gt_products TYPE tt_products.
    DATA go_messages TYPE REF TO zblog_service_provider.
ENDCLASS.

CLASS lcl_ozon_id_parser IMPLEMENTATION.

  METHOD constructor.
    me->gt_products = VALUE z1coz_products=>tt_products(
        FOR <wa> IN it_products (
            ozon_id = <wa>-ozon_id
            product_id = to_upper( <wa>-product_id )
        ) ).

    me->go_messages = zblog_service_provider=>get_default_service( ).
  ENDMETHOD.


  METHOD update_ozon_id.
    r_result = is_material->*.
    DATA(lv_material_product_id) = |{ is_material->material_article }_{ to_upper( is_material->material_attribute_name ) }|.
    IF line_exists( me->gt_products[ product_id = lv_material_product_id ] ).
      r_result-material_ozon_id = me->gt_products[ product_id = lv_material_product_id ]-ozon_id.
    ELSE.
      MESSAGE e001(z1c) WITH lv_material_product_id INTO DATA(lv_dummy).
      me->go_messages->add_sy( ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
