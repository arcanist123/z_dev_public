*&---------------------------------------------------------------------*
*& Report z_test_bw_hier_save
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_bw_hier_save.

CLASS lcl_main DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS main.
  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD main.

*call FUNCTION 'RRHI_HIERARCHY_ACTIVATE'


  ENDMETHOD.

ENDCLASS.



START-OF-SELECTION.

  NEW lcl_main(  )->main(  ).
