CLASS z_1c_json_to_excel_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        iv_data         TYPE string
      RETURNING
        VALUE(r_result) TYPE REF TO z_1c_json_to_excel_parser.
    METHODS constructor
      IMPORTING
        iv_base64_data TYPE string.
    METHODS parse
      .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA gv_base64_data TYPE string.


    METHODS get_excel_data
      IMPORTING
        i_lv_json_string TYPE string
      RETURNING
        VALUE(r_result)  TYPE z_1c_excel_processor=>t_document.
    METHODS get_excel
      RETURNING
        VALUE(r_result) TYPE REF TO  zcl_excel.
    METHODS parse_headers
      IMPORTING
        is_organisation TYPE z_1c_excel_processor=>t_organisation
        io_excel        TYPE REF TO zcl_excel
      RETURNING
        VALUE(r_result) TYPE REF TO zcl_excel.
    METHODS parse_materials
      IMPORTING
        it_materials    TYPE z_1c_excel_processor=>tt_materials
        io_excel        TYPE REF TO zcl_excel
      RETURNING
        VALUE(r_result) TYPE REF TO zcl_excel.

ENDCLASS.



CLASS z_1c_json_to_excel_parser IMPLEMENTATION.


  METHOD constructor.

    me->gv_base64_data = iv_base64_data.



  ENDMETHOD.


  METHOD create.

    r_result = NEW #( iv_data ).

  ENDMETHOD.




  METHOD get_excel_data.



  ENDMETHOD.


  METHOD parse.

    "get json
    DATA(lv_json_string) = cl_http_utility=>if_http_utility~decode_base64( me->gv_base64_data ).

    "get the data in typed form
    DATA(ls_excel_data) = me->get_excel_data( lv_json_string ).

    DATA(lo_excel) = me->get_excel( ).

    lo_excel = me->parse_headers(   is_organisation = ls_excel_data-organisation
                                    io_excel        = lo_excel ).

    lo_excel = me->parse_materials( it_materials    = ls_excel_data-materials
                                    io_excel        = lo_excel ).




  ENDMETHOD.



  METHOD get_excel.
    "later we might prepare a template here
    r_result = NEW #( ).

  ENDMETHOD.


  METHOD parse_headers.

  ENDMETHOD.


  METHOD parse_materials.
    LOOP AT it_materials REFERENCE INTO DATA(ls_material) GROUP BY ( key1 = ls_material->group ).
      DATA(lt_group) = FILTER z_1c_excel_processor=>tt_materials( it_materials USING KEY main_key WHERE group = ls_material->group ).
      DATA(lo_excel_group) = z_1c_excel_group_parser=>create( lt_group )->parse( ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
