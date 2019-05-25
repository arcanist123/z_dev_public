CLASS z_1c_excel_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*    CONSTANTS:
*      BEGIN OF gc_command,
*        json_to_excel TYPE string VALUE 'json_to_excel',
*        excel_to_json TYPE string VALUE 'excel_to_json',
*      END OF gc_command.

    TYPES:
      BEGIN OF ENUM command STRUCTURE gc_command,
        json_to_excel,
        excel_to_json ,
        json_to_upd,
      END OF ENUM command STRUCTURE gc_command.


    TYPES:
      BEGIN OF t_material,
        group               TYPE string,
        name                TYPE string,
        photo               TYPE string,
        attribute           TYPE string,
        picture             TYPE string,
        price               TYPE string,
        discount            TYPE string,
        price_with_discount TYPE string,
        quantity            TYPE string,
        your_order          TYPE string,
        order_sum           TYPE string,
      END OF t_material.
    TYPES tt_materials TYPE STANDARD TABLE OF t_material
        WITH EMPTY KEY
        WITH NON-UNIQUE SORTED KEY main_key COMPONENTS group name attribute.
    TYPES:
      BEGIN OF t_organisation,
        organisation_name TYPE string,
      END OF t_organisation.
    TYPES:
      BEGIN OF t_document,
        organisation TYPE t_organisation,
        materials    TYPE tt_materials,
      END OF t_document.

    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO z_1c_excel_processor.
    METHODS process_command
      IMPORTING
        iv_command               TYPE string
        iv_data                  TYPE string
      RETURNING
        VALUE(rv_command_result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_command_from_string
      IMPORTING
        iv_command      TYPE string
      RETURNING
        VALUE(r_result) TYPE command.
ENDCLASS.



CLASS z_1c_excel_processor IMPLEMENTATION.

  METHOD create.

    CREATE OBJECT r_result.

  ENDMETHOD.


  METHOD process_command.
    DATA(lv_command) = me->get_command_from_string( iv_command ).

    rv_command_result = COND string(
        WHEN lv_command = gc_command-excel_to_json
            THEN z_1c_json_to_upd_parser=>create( iv_data )->parse( )
        WHEN lv_command = gc_command-json_to_upd
            THEN z_1c_json_to_upd_parser=>create( iv_data )->parse( ) ).


  ENDMETHOD.


  METHOD get_command_from_string.
    "try to get the component of the enumeration
    ASSIGN COMPONENT iv_command OF STRUCTURE gc_command TO FIELD-SYMBOL(<lv_command>).
    IF <lv_command> IS ASSIGNED .
      r_result = <lv_command>.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
