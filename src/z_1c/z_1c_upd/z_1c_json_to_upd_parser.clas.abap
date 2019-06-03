CLASS z_1c_json_to_upd_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES
      :
      BEGIN OF t_material,
        material_attribute_name TYPE string,
        material_article        TYPE string,
        material_id             TYPE string,
        material_line_number    TYPE i,
        material_name           TYPE string,
        material_ozon_id        TYPE string,
        material_price          TYPE p LENGTH 16 DECIMALS 3,
        material_quantity       TYPE p LENGTH 16 DECIMALS 3,
        material_sum            TYPE p LENGTH 16 DECIMALS 3,
        material_code           TYPE string,
      END OF t_material.
    TYPES tt_materials TYPE STANDARD TABLE OF t_material WITH EMPTY KEY.
    TYPES:
      BEGIN OF t_document,
        date               TYPE string,
        invoice_code       TYPE string,
        materials          TYPE tt_materials,
        seller_first_name  TYPE string,
        seller_middle_name TYPE string,
        seller_last_name   TYPE string,
        seller_org_name    TYPE string,
        seller_inn         TYPE string,
      END OF t_document.

    CLASS-METHODS create
      IMPORTING
        iv_document_base64 TYPE string
      RETURNING
        VALUE(r_result)    TYPE REF TO z_1c_json_to_upd_parser.

    METHODS parse
      RETURNING VALUE(rv_upd_base64) TYPE string.
    METHODS constructor
      IMPORTING
        iv_document_base64 TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA document_base64 TYPE string.
    METHODS get_document_from_base64
      IMPORTING
        iv_document_base64 TYPE string
      RETURNING
        VALUE(r_result)    TYPE t_document.
    METHODS get_document_json_from_base64
      IMPORTING
        iv_document_base64 TYPE string
      RETURNING
        VALUE(r_result)    TYPE string.
    METHODS get_document_from_json
      IMPORTING
        iv_document_json TYPE string
      RETURNING
        VALUE(r_result)  TYPE t_document.
    METHODS get_upd
      IMPORTING
        is_document     TYPE z_1c_json_to_upd_parser=>t_document
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS encode_upd_base64
      IMPORTING
        i_lv_upd        TYPE string
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS update_ozon_id
      IMPORTING
        is_document     TYPE z_1c_json_to_upd_parser=>t_document
      RETURNING
        VALUE(r_result) TYPE z_1c_json_to_upd_parser=>t_document.
ENDCLASS.



CLASS z_1c_json_to_upd_parser IMPLEMENTATION.


  METHOD constructor.
    me->document_base64 = iv_document_base64.

  ENDMETHOD.


  METHOD create.

    r_result = NEW #( iv_document_base64 ).

  ENDMETHOD.


  METHOD encode_upd_base64.
*convert string to xstring
    DATA lv_xstring TYPE xstring.
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = i_lv_upd
      IMPORTING
        buffer = lv_xstring
      EXCEPTIONS
        failed = 1
        OTHERS = 2.

*Find the number of bites of xstring

    DATA(lv_len)  = xstrlen( lv_xstring ).
    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_xstring
      IMPORTING
        output = r_result.

  ENDMETHOD.


  METHOD get_document_from_base64.

    DATA(lv_document_json) = me->get_document_json_from_base64( iv_document_base64 ).

    r_result = me->get_document_from_json( lv_document_json ).


  ENDMETHOD.


  METHOD get_document_from_json.
    /ui2/cl_json=>deserialize(  EXPORTING   json = iv_document_json
                                CHANGING    data = r_result ).

  ENDMETHOD.


  METHOD get_document_json_from_base64.

    "Convert Base64 string to XString.
    DATA: lv_xstring TYPE xstring,       "Xstring
          lv_len     TYPE i,                  "Length
          lt_content TYPE soli_tab,      "Content
          lv_string  TYPE string,        "Text
          lv_base64  TYPE string.        "Base64
    CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
      EXPORTING
        input  = iv_document_base64
      IMPORTING
        output = lv_xstring
      EXCEPTIONS
        failed = 1
        OTHERS = 2.


*Convert Text to Binary
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_xstring
      IMPORTING
        output_length = lv_len
      TABLES
        binary_tab    = lt_content[].

*Convert Binary to String
    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = lv_len
      IMPORTING
        text_buffer  = r_result
      TABLES
        binary_tab   = lt_content[]
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
  ENDMETHOD.


  METHOD get_upd.
    CALL TRANSFORMATION z_1c_upd
        SOURCE document =  is_document
        RESULT XML DATA(lv_xstring).

*Convert Text to Binary
    DATA lv_len     TYPE i.
    DATA lt_content TYPE soli_tab.
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_xstring
      IMPORTING
        output_length = lv_len
      TABLES
        binary_tab    = lt_content[].

*Convert Binary to String
    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = lv_len
      IMPORTING
        text_buffer  = r_result
      TABLES
        binary_tab   = lt_content[]
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
  ENDMETHOD.


  METHOD parse.
    TRY.

        DATA(ls_document) = me->get_document_from_base64( me->document_base64 ).
        ls_document = me->update_ozon_id( ls_document ).
        DATA(lv_upd) = me->get_upd( ls_document ).
        rv_upd_base64 = me->encode_upd_base64( lv_upd ).

      CATCH zcx_1c_exception INTO DATA(lo_cx).


    ENDTRY.

  ENDMETHOD.


  METHOD update_ozon_id.
    DATA(ls_document) = is_document.

    DATA(lt_products) = NEW z1coz_products( )->get_products( ).
    DATA(lo_ozon_id_parser) = NEW lcl_ozon_id_parser( lt_products ).
    LOOP AT ls_document-materials REFERENCE INTO DATA(ls_material).
      ls_material->* = lo_ozon_id_parser->update_ozon_id( ls_material ).
    ENDLOOP.

    r_result = ls_document.
  ENDMETHOD.
ENDCLASS.
