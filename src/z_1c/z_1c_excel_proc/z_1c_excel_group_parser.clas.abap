CLASS z_1c_excel_group_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        it_group        TYPE z_1c_excel_processor=>tt_materials
      RETURNING
        VALUE(r_result) TYPE REF TO z_1c_excel_group_parser.
    METHODS constructor
      IMPORTING
        it_group TYPE z_1c_excel_processor=>tt_materials.
    METHODS parse
      RETURNING VALUE(ro_excel) TYPE REF TO zcl_excel.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA gt_group TYPE z_1c_excel_processor=>tt_materials .
ENDCLASS.



CLASS z_1c_excel_group_parser IMPLEMENTATION.

  METHOD constructor.

    me->gt_group = it_group.

  ENDMETHOD.

  METHOD create.

    r_result = NEW #( it_group ).

  ENDMETHOD.
  METHOD parse.
*    DATA(lo_excel) = NEW zcl_excel( ).
*    DATA(lo_worksheet) = lo_excel->add_new_worksheet( ).
*    lo_worksheet->se

  ENDMETHOD.

ENDCLASS.
