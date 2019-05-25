*&---------------------------------------------------------------------*
*& Report z_test_loop_performance
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_loop_performance.

START-OF-SELECTION.
  DATA(lo_test) = NEW z_test_loop_performance( ).
  CALL METHOD lo_test->main
    EXPORTING
      p_rows = 20000.
  WRITE: 'success'.
