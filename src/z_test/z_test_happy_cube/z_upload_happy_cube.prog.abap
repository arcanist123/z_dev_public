*&---------------------------------------------------------------------*
*& Report z_upload_happy_cube
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_upload_happy_cube.
*PARAMETERS p_side1 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\6.txt'.
*PARAMETERS p_side2 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\5.txt'.
*PARAMETERS p_side3 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\4.txt'.
*PARAMETERS p_side4 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\3.txt'.
*PARAMETERS p_side5 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\2.txt'.
*PARAMETERS p_side6 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\1.txt'.
PARAMETERS p_side1 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\blue1.txt'.
PARAMETERS p_side2 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\blue2.txt'.
PARAMETERS p_side3 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\blue3.txt'.
PARAMETERS p_side4 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\blue4.txt'.
PARAMETERS p_side5 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\blue5.txt'.
PARAMETERS p_side6 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\blue6.txt'.
*PARAMETERS p_side1 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\lilac1.txt'.
*PARAMETERS p_side2 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\lilac2.txt'.
*PARAMETERS p_side3 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\lilac3.txt'.
*PARAMETERS p_side4 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\lilac4.txt'.
*PARAMETERS p_side5 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\lilac5.txt'.
*PARAMETERS p_side6 TYPE string OBLIGATORY DEFAULT 'D:\work\abap\happy_cube\lilac6.txt'.

START-OF-SELECTION.

  DATA(lo_hc_ui) = NEW zcl_hc_controller( ).
  CALL METHOD lo_hc_ui->main
    EXPORTING
      iv_side_1_path = p_side1
      iv_side_2_path = p_side2
      iv_side_3_path = p_side3
      iv_side_4_path = p_side4
      iv_side_5_path = p_side5
      iv_side_6_path = p_side6.
