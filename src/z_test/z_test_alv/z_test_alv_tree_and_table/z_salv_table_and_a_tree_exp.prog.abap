*&---------------------------------------------------------------------*
*& Report z_salv_table_and_a_tree_exp
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_salv_table_and_a_tree_exp.

DATA lo_report TYPE REF TO  zcl_test_alv_report.

START-OF-SELECTION.
  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  CREATE OBJECT lo_report
    EXPORTING
      iv_repid = sy-repid
      iv_dynnr = sy-dynnr.
  CALL METHOD lo_report->display.
ENDMODULE.
