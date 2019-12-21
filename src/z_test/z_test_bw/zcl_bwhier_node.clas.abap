CLASS zcl_bwhier_node DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_bwhier_node.

    TYPES:
      BEGIN OF ts_nove_value,
        node_name   TYPE string,
        node_iobjnm TYPE string,
        link        TYPE abap_bool,
      END OF ts_nove_value.
    METHODS constructor
      IMPORTING
        io_hierarchy  TYPE REF TO zcl_bwhier_hierarchy
        io_parent     TYPE REF TO zcl_bwhier_node OPTIONAL
        io_next       TYPE REF TO zcl_bwhier_node OPTIONAL
        io_previous   TYPE REF TO zcl_bwhier_node OPTIONAL
        is_node_value TYPE ts_nove_value    .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES tt_nodes TYPE STANDARD TABLE OF REF TO zcl_bwhier_node WITH EMPTY KEY.

    DATA go_hierarhy TYPE REF TO zcl_bwhier_hierarchy.
    DATA go_parent TYPE REF TO zcl_bwhier_node.
    DATA go_next TYPE REF TO zcl_bwhier_node.
    DATA go_previous TYPE REF TO zcl_bwhier_node.

    DATA gs_node_value TYPE ts_nove_value.

    DATA gt_children TYPE tt_nodes.
    METHODS remove_child_from_child_list
      IMPORTING
        io_child TYPE REF TO zcl_bwhier_node
      RAISING
        zcx_exception.
    METHODS set_next
      IMPORTING
        io_next TYPE REF TO zcl_bwhier_node.
    METHODS set_previous
      IMPORTING
        io_previous TYPE REF TO zcl_bwhier_node.
ENDCLASS.



CLASS zcl_bwhier_node IMPLEMENTATION.

  METHOD constructor.
    me->go_parent = io_parent.
    me->gs_node_value = is_node_value.
  ENDMETHOD.
  METHOD zif_bwhier_node~delete.
    IF me->go_parent = me->go_hierarhy->go_root_node.
      RAISE EXCEPTION TYPE zcx_exception.
    ENDIF.

    "recursive
    LOOP AT me->gt_children INTO DATA(ls_child).
      ls_child->zif_bwhier_node~delete( ).
    ENDLOOP.

    me->go_parent->remove_child_from_child_list( me ).



    me->go_hierarhy->delete_node_by_ref( me ).
  ENDMETHOD.

  METHOD zif_bwhier_node~get_children.
    rt_children = me->gt_children.
  ENDMETHOD.

  METHOD zif_bwhier_node~get_my_link_nodes.

    rt_nodes = me->go_hierarhy->get_link_nodes( gs_node_value ).
  ENDMETHOD.

  METHOD zif_bwhier_node~get_parent.
    ro_parent = me->go_parent.

  ENDMETHOD.

  METHOD zif_bwhier_node~insert_existing_node_first.

*  data(lo_)



  ENDMETHOD.

  METHOD remove_child_from_child_list.
    READ TABLE me->gt_children INTO DATA(lo_child_to_delete) WITH KEY table_line = io_child.
    IF sy-subrc = 0.
      DELETE me->gt_children INDEX sy-tabix.

      IF lo_child_to_delete->go_previous IS BOUND.
        lo_child_to_delete->go_previous->set_next( lo_child_to_delete->go_next ).
      ENDIF.
      IF lo_child_to_delete->go_next IS BOUND.
        lo_child_to_delete->go_next->set_previous( lo_child_to_delete->go_previous ).
      ENDIF.

    ELSE.
      RAISE EXCEPTION TYPE zcx_exception.
    ENDIF.

  ENDMETHOD.


  METHOD set_next.
    me->go_next = io_next.
  ENDMETHOD.


  METHOD set_previous.
    me->go_previous = io_previous.
  ENDMETHOD.

  METHOD zif_bwhier_node~insert_node_value_first.

    go_hierarhy->validate_new_node( is_node_value ).
    IF me->gt_children IS INITIAL.
      ro_node = NEW zcl_bwhier_node(    io_hierarchy    = me->go_hierarhy
                                        io_parent       = me
                                        is_node_value   = is_node_value ).
    ELSE.
      READ TABLE me->gt_children INTO DATA(lo_first_child) INDEX 1.
      DATA(lo_new_first_node) = NEW zcl_bwhier_node(    io_hierarchy    = me->go_hierarhy
                                                        io_next         = lo_first_child
                                                        io_parent       = me
                                                        is_node_value   = is_node_value ).
      lo_first_child->go_previous = lo_new_first_node.

    ENDIF.

    ro_node = lo_new_first_node.


  ENDMETHOD.

  METHOD zif_bwhier_node~get_node_value.
    rs_node_value = me->gs_node_value.
  ENDMETHOD.

ENDCLASS.
