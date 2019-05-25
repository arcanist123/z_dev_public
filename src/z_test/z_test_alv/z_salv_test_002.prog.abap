*&---------------------------------------------------------------------*
*& Report  ZCS2_COURSE_RPT_OO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_salv_test_002.


CLASS lcl_kbed_alv_control DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    DATA go_container_top   TYPE REF TO cl_gui_splitter_container.
    DATA: go_container_left TYPE REF TO cl_gui_container.
    DATA go_table TYPE REF TO cl_salv_table.
    DATA gt_table_sflight TYPE STANDARD TABLE OF sflight WITH DEFAULT KEY.
    DATA gt_table_scarr TYPE STANDARD TABLE OF scarr WITH DEFAULT KEY.
    METHODS pai
      IMPORTING
        iv_ok_code TYPE syucomm.
    METHODS pbo.
    METHODS free_controls.
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.

CLASS lcl_kbed_alv_control IMPLEMENTATION.


  METHOD pai.
    CASE iv_ok_code.
      WHEN 'DSPPREQ '.
        CALL METHOD go_container_top->get_container
          EXPORTING
            row       = 1    " Row
            column    = 1    " Column
          RECEIVING
            container = go_container_left.    " Container
        SELECT * FROM sflight INTO TABLE gt_table_sflight.

        IF go_table IS NOT BOUND.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container  = go_container_left
              list_display = abap_false
            IMPORTING
              r_salv_table = go_table
            CHANGING
              t_table      = gt_table_sflight.
        ENDIF.
        SELECT * FROM sflight INTO TABLE gt_table_sflight.
        CALL METHOD go_table->set_data
          CHANGING
            t_table = gt_table_sflight.    " Table to Be Displayed
        CALL METHOD go_table->display.

      WHEN 'DSPREG'.
        IF go_table IS NOT BOUND.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              r_container  = go_container_left
              list_display = abap_false
            IMPORTING
              r_salv_table = go_table
            CHANGING
              t_table      = gt_table_scarr.
        ENDIF.
        SELECT * FROM scarr INTO TABLE gt_table_scarr.
        CALL METHOD go_table->set_data
          CHANGING
            t_table = gt_table_scarr.    " Table to Be Displayed


        CALL METHOD go_table->display.
    ENDCASE.

  ENDMETHOD.


  METHOD pbo.
    IF go_container_top IS NOT BOUND.
      CREATE OBJECT go_container_top
        EXPORTING
          link_dynnr        = '0100' " Screen Number
          link_repid        = sy-repid " Report Name
          parent            = cl_gui_container=>default_screen " Parent Container
          rows              = 1 " Number of Rows to be displayed
          columns           = 2 " Number of Columns to be Displayed
        EXCEPTIONS
          cntl_error        = 1
          cntl_system_error = 2
          OTHERS            = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD free_controls.

  ENDMETHOD.

ENDCLASS.


DATA lr_controller TYPE REF TO lcl_kbed_alv_control.
DATA ok_code TYPE syucomm.

START-OF-SELECTION.

  CREATE OBJECT lr_controller.
  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*&      Module  status_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'MAIN'.
  SET TITLEBAR '100'.

ENDMODULE.                 " status_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  lr_controller->pai( EXPORTING iv_ok_code = ok_code ).
  CLEAR ok_code.

ENDMODULE.                 " user_command_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  pbo_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.

  lr_controller->pbo( ).

ENDMODULE.                 " pbo_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  exit_dynp_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_dynp_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
      CLEAR ok_code.
      lr_controller->free_controls( ).
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.                 " exit_dynp_0100  INPUT
