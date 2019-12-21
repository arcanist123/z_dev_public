*&---------------------------------------------------------------------*
*& Report z_test_sapscript_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_sapscript_001.

FORM get_strichcode TABLES in_tab STRUCTURE itcsy
out_tab STRUCTURE itcsy.
  DATA lv_test TYPE string.
  lv_test = '233'.
  READ TABLE out_tab WITH KEY 'BARCODE'.
  CHECK sy-subrc = 0.


  SELECT SINGLE * FROM sflight INTO @DATA(ls_sflight).
  ls_sflight-fldate = sy-datum.
  MODIFY sflight FROM ls_sflight.
  COMMIT WORK AND WAIT.


  out_tab-value = 'asdasdasdasd'.          "Flag: last page


ENDFORM.


START-OF-SELECTION.
  MESSAGE e000(z_test) WITH 'something'.
