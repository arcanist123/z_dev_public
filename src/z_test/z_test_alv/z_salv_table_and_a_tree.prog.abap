*&---------------------------------------------------------------------*
*& Report z_salv_test_003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_salv_table_and_a_tree.
CLASS lcl_report DEFINITION DEFERRED  .
CLASS lcl_table DEFINITION DEFERRED.
CLASS lcl_tree DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    DATA lo_alv_tree TYPE REF TO cl_salv_tree.
    METHODS _on_tree_double_click
          FOR EVENT double_click  OF if_salv_events_tree
      IMPORTING
          !node_key
          !columnname .
    METHODS constructor
      IMPORTING
        io_container  TYPE REF TO cl_gui_container
        io_controller TYPE REF TO lcl_report.
    METHODS show_tree.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF t_key,
        event_name TYPE zcl_fi_otc_ui_controller=>typ_tree_event_name,
        key        TYPE salv_de_node_key,
      END OF t_key.
    TYPES tt_keys TYPE STANDARD TABLE OF t_key WITH DEFAULT KEY.
    TYPES:

      BEGIN OF ts_hier,
        node   TYPE string,
        parent TYPE string,
        key    TYPE salv_de_node_key,
      END OF ts_hier .
    TYPES:
      tt_hier TYPE STANDARD TABLE OF ts_hier WITH DEFAULT KEY .

    DATA _go_controller TYPE REF TO lcl_report.
    DATA _go_container TYPE REF TO cl_gui_container .
    DATA _go_events TYPE REF TO cl_salv_events_tree .
    DATA _go_tree          TYPE REF TO cl_salv_tree.
    DATA _gt_event_keys TYPE tt_keys.
    DATA _gt_hier TYPE tt_hier . " Tree hierarchy
ENDCLASS.

CLASS lcl_tree IMPLEMENTATION.

  METHOD constructor.

    me->_go_container = io_container.
    me->_go_controller = io_controller.

  ENDMETHOD.

  METHOD _on_tree_double_click.

    FIELD-SYMBOLS: <ls_event_key> TYPE lcl_tree=>t_key.

    "get the action
    READ TABLE me->_gt_event_keys ASSIGNING <ls_event_key> WITH KEY key = node_key.

    "send the action to the main controller
    IF <ls_event_key> IS ASSIGNED.
      CALL METHOD me->_go_controller->('PROCESS_TREE_EVENT')
*      CALL METHOD me->_go_controller->PROCESS_TREE_EVENT "wtf.... why do I have to set the name dinamically omg
        EXPORTING
          iv_event = <ls_event_key>-event_name.

    ENDIF.

  ENDMETHOD.

  METHOD show_tree.
    DATA ls_event_key LIKE LINE OF _gt_event_keys.
    DATA: lo_nodes            TYPE REF TO cl_salv_nodes,
          lo_parent_node      TYPE REF TO cl_salv_node,
          lv_parent_key       TYPE salv_de_node_key,
          lo_sflight          TYPE REF TO cl_salv_node,
          lo_scarr            TYPE REF TO cl_salv_node,
          lo_posted_data_node TYPE REF TO cl_salv_node.
    CLEAR _gt_hier.
    CLEAR me->_gt_event_keys.
    "create a tree
    CALL METHOD cl_salv_tree=>factory
      EXPORTING
        r_container = me->_go_container    " Abstract Container for GUI Controls
        hide_header = abap_true    " Do Not Show Header
      IMPORTING
        r_salv_tree = _go_tree    " ALV: Tree Model
      CHANGING
        t_table     = _gt_hier.

    "get nodes
    CALL METHOD _go_tree->get_nodes
      RECEIVING
        value = lo_nodes. " ALV: All Nodes of a Tree

    "add parent
    CALL METHOD lo_nodes->add_node
      EXPORTING
        related_node = '' " Key to Related Node
        relationship = if_salv_c_node_relation=>parent    " Node Relation in Tree
        text         = 'Data'(002)
      RECEIVING
        node         = lo_parent_node.    " Node Key

    "get parent key
    CALL METHOD lo_parent_node->get_key
      RECEIVING
        value = lv_parent_key. " Node Key

    "add sflight
    CALL METHOD lo_nodes->add_node
      EXPORTING
        related_node = lv_parent_key    " Key to Related Node
        relationship = if_salv_c_node_relation=>last_child    " Node Relation in Tree
        text         = 'SFLIGHT'    " ALV Control: Cell Content
      RECEIVING
        node         = lo_sflight.    " Node Key


    ls_event_key-event_name = 'SFLIGHT'.
    CALL METHOD lo_sflight->get_key
      RECEIVING
        value = ls_event_key-key.    " Node Key
    APPEND ls_event_key TO me->_gt_event_keys.


    CALL METHOD lo_nodes->add_node
      EXPORTING
        related_node = lv_parent_key    " Key to Related Node
        relationship = if_salv_c_node_relation=>last_child    " Node Relation in Tree
        text         = 'SCARR'    " ALV Control: Cell Content
      RECEIVING
        node         = lo_scarr.    " Node Key

    ls_event_key-event_name = 'SCARR'.
    CALL METHOD lo_scarr->get_key
      RECEIVING
        value = ls_event_key-key.    " Node Key
    APPEND ls_event_key TO me->_gt_event_keys.

    DATA:
      ls_hier          TYPE ts_hier,
      lv_key           TYPE salv_de_node_key,
      lo_node          TYPE REF TO cl_salv_node,
      lo_columns       TYPE REF TO cl_salv_columns,
      lo_column        TYPE REF TO cl_salv_column,
      lo_tree_settings TYPE REF TO cl_salv_tree_settings,
      lv_text          TYPE lvc_value,
      lo_events        TYPE REF TO cl_salv_events_tree.

    FIELD-SYMBOLS:
      <fs_hier> TYPE ts_hier.

    lo_columns = _go_tree->get_columns( ).
    lo_columns->set_optimize( abap_true ).
    lo_column = lo_columns->get_column( 'NODE' ).
    lo_column->set_visible( abap_false ).
    lo_tree_settings = _go_tree->get_tree_settings( ).
    lo_tree_settings->set_hierarchy_header( 'Node' ).
    lo_nodes->expand_all( ).

    "get the events
    CALL METHOD _go_tree->get_event
      RECEIVING
        value = _go_events. " ALV: Events of CL_SALV_TABLE

    SET HANDLER me->_on_tree_double_click FOR _go_events.

    _go_tree->display( ).
  ENDMETHOD.

ENDCLASS.



CLASS lcl_table DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    DATA lo_alv_table TYPE REF TO cl_salv_table.
    DATA lrt_data TYPE REF TO data.
    METHODS constructor
      IMPORTING
        io_container  TYPE  REF TO cl_gui_container
        io_controller TYPE REF TO  lcl_report.
    METHODS display
      CHANGING
        it_data TYPE STANDARD TABLE.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA _go_controller TYPE REF TO lcl_report.
    DATA _go_container TYPE REF TO cl_gui_container .
ENDCLASS.

CLASS lcl_table IMPLEMENTATION.

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

CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    DATA lo_tree TYPE REF TO lcl_tree.
    DATA lo_table TYPE REF TO lcl_table.
    DATA go_container_top   TYPE REF TO cl_gui_splitter_container.
    METHODS: display,
      process_tree_event
        IMPORTING
          iv_event TYPE zcl_fi_otc_ui_controller=>typ_tree_event_name.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA go_tree_container TYPE REF TO cl_gui_container.
    DATA go_table_container TYPE REF TO cl_gui_container.

ENDCLASS.

CLASS lcl_report IMPLEMENTATION.


  METHOD display.
    CREATE OBJECT go_container_top
      EXPORTING
        link_dynnr        = sy-dynnr " Screen Number
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

DATA lo_report TYPE REF TO  lcl_report.

START-OF-SELECTION.
  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  CREATE OBJECT lo_report.
  CALL METHOD lo_report->display.
ENDMODULE.
