CLASS zcl_test_alv_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA lo_alv_table TYPE REF TO cl_salv_table.
    DATA lrt_data TYPE REF TO data.
    METHODS constructor
      IMPORTING
        io_container  TYPE  REF TO cl_gui_container
        io_controller TYPE REF TO  zcl_test_alv_report.
    METHODS display
      CHANGING
        it_data TYPE STANDARD TABLE.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA _go_controller TYPE REF TO zcl_test_alv_report.
    DATA _go_container TYPE REF TO cl_gui_container .
ENDCLASS.



CLASS ZCL_TEST_ALV_TABLE IMPLEMENTATION.


  METHOD constructor.
    me->_go_container = io_container.
    me->_go_controller = io_controller.
  ENDMETHOD.


  METHOD display.
    "set the table
    CLEAR lrt_data.
    CREATE DATA lrt_data LIKE it_data.
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.
    ASSIGN lrt_data->* TO <lt_data>.

    <lt_data> = it_data.

    IF lo_alv_table IS BOUND.
      CALL METHOD me->lo_alv_table->set_data
        CHANGING
          t_table = <lt_data>. " Table to Be Displayed

      CALL METHOD me->lo_alv_table->refresh
        EXPORTING
          refresh_mode = if_salv_c_refresh=>full.    " ALV: Data Element for Constants
    ELSE.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          r_container  = me->_go_container    " Abstract Container for GUI Controls
        IMPORTING
          r_salv_table = me->lo_alv_table " Basis Class Simple ALV Tables
        CHANGING
          t_table      = <lt_data>.
      CALL METHOD lo_alv_table->display.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
