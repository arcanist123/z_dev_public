CLASS zcl_test_alv_tree DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

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
        io_controller TYPE REF TO zcl_test_alv_report.
    METHODS show_tree.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF t_key,
        event_name TYPE zcl_test_alv_report=>typ_tree_event_name,
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

    DATA _go_controller TYPE REF TO zcl_test_alv_report.
    DATA _go_container TYPE REF TO cl_gui_container .
    DATA _go_events TYPE REF TO cl_salv_events_tree .
    DATA _go_tree          TYPE REF TO cl_salv_tree.
    DATA _gt_event_keys TYPE tt_keys.
    DATA _gt_hier TYPE tt_hier . " Tree hierarchy
ENDCLASS.



CLASS ZCL_TEST_ALV_TREE IMPLEMENTATION.


  METHOD constructor.

    me->_go_container = io_container.
    me->_go_controller = io_controller.

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


  METHOD _on_tree_double_click.

    FIELD-SYMBOLS: <ls_event_key> TYPE zcl_test_alv_tree=>t_key.

    "get the action
    READ TABLE me->_gt_event_keys ASSIGNING <ls_event_key> WITH KEY key = node_key.

    "send the action to the main controller
    IF <ls_event_key> IS ASSIGNED.
*      CALL METHOD me->_go_controller->('PROCESS_TREE_EVENT')
      CALL METHOD me->_go_controller->process_tree_event
        EXPORTING
          iv_event = <ls_event_key>-event_name.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
