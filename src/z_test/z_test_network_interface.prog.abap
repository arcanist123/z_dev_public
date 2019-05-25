*&---------------------------------------------------------------------*
*& Report z_test_network_interface
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_test_network_interface.

*DATA lr_controller TYPE REF TO zcl_
*DATA ok_code TYPE syucomm.
*
*START-OF-SELECTION.
*  CREATE OBJECT lr_controller.
*  CALL SCREEN 100.
*
*MODULE status_0100 OUTPUT.
*  SET PF-STATUS 'MAIN'.
*  SET TITLEBAR '100'.
*ENDMODULE.
*
*MODULE user_command_0100 INPUT.
*  lr_controller->pai( EXPORTING iv_ok_code = ok_code ).
*  CLEAR ok_code.
*ENDMODULE. "user_command_0100 input
*
*MODULE pbo_0100 OUTPUT.
*  lr_controller->pbo( ).
*ENDMODULE. " pbo_0100 output
*
*MODULE exit_dynp_0100 INPUT.
*  CASE ok_code.
*    WHEN 'BACK' OR 'CANC' OR 'EXIT'.
*      CLEAR ok_code.
*      lr_controller->free_controls( ).
*      LEAVE TO SCREEN 0.
*  ENDCASE.
*ENDMODULE. "exit_dynp_0100 INPUT
