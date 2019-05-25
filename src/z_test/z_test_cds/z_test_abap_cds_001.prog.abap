*&---------------------------------------------------------------------*
*& Report zjp_cds_inv_items_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zjp_cds_inv_items_test.

CLASS lcl_main DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_main.

    METHODS run.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD create.
    CREATE OBJECT r_result.
  ENDMETHOD.

  METHOD run.

    cl_salv_gui_table_ida=>create_for_cds_view(`Z_Invoice_Items`)->fullscreen( )->display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  lcl_main=>create( )->run( ).
