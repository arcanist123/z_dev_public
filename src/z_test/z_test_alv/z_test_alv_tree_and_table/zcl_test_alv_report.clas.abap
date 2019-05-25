"! <p class="shorttext synchronized" lang="en">test</p>
CLASS zcl_test_alv_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    TYPES:
      typ_tree_event_name TYPE c LENGTH 10 .
    DATA lo_tree TYPE REF TO zcl_test_alv_tree.
    DATA lo_table TYPE REF TO zcl_test_alv_table.
    DATA go_container_top   TYPE REF TO cl_gui_splitter_container.
    METHODS: display.
    METHODS constructor
      IMPORTING
        iv_repid TYPE syrepid
        iv_dynnr TYPE sydynnr.
    METHODS      process_tree_event
      IMPORTING
        iv_event TYPE typ_tree_event_name.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA go_tree_container TYPE REF TO cl_gui_container.
    DATA go_table_container TYPE REF TO cl_gui_container.
    DATA _gv_repid TYPE syrepid.
    DATA _gv_dynnr TYPE sydynnr.

ENDCLASS.



CLASS zcl_test_alv_report IMPLEMENTATION.


  METHOD constructor.
    me->_gv_repid = iv_repid.
    me->_gv_dynnr = iv_dynnr.
  ENDMETHOD.


  METHOD display.
    CREATE OBJECT go_container_top
      EXPORTING
        link_dynnr        = me->_gv_dynnr " Screen Number
        link_repid        = me->_gv_repid " Report Name
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

    CALL METHOD go_container_top->get_container
      EXPORTING
        row       = 1 " Row
        column    = 1 " Column
      RECEIVING
        container = go_tree_container.    " Container

    CREATE OBJECT lo_tree
      EXPORTING
        io_container  = go_tree_container
        io_controller = me.
    CALL METHOD lo_tree->show_tree.


    CALL METHOD go_container_top->get_container
      EXPORTING
        row       = 1 " Row
        column    = 2 " Column
      RECEIVING
        container = go_table_container. " Container

    CREATE OBJECT lo_table
      EXPORTING
        io_container  = go_table_container
        io_controller = me.

    DATA: lt_sflight TYPE STANDARD TABLE OF sflight.
    SELECT * FROM sflight INTO TABLE lt_sflight.
    CALL METHOD lo_table->display
      CHANGING
        it_data = lt_sflight.
  ENDMETHOD.


  METHOD process_tree_event.
    DATA: lt_sflight TYPE STANDARD TABLE OF sflight,
          lt_scarr   TYPE STANDARD TABLE OF scarr.
    CASE iv_event.
      WHEN 'SFLIGHT'.
        SELECT * FROM sflight INTO TABLE lt_sflight.
        CALL METHOD lo_table->display
          CHANGING
            it_data = lt_sflight.
      WHEN 'SCARR'.
        SELECT * FROM scarr INTO TABLE @lt_scarr.
        CALL METHOD lo_table->display
          CHANGING
            it_data = lt_scarr.
    ENDCASE.




  ENDMETHOD.
ENDCLASS.
