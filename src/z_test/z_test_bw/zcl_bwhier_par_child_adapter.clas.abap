CLASS zcl_bwhier_par_child_adapter DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_parent_child_hier,
        parent_node_iobjnm TYPE string,
        parent_node_name   TYPE string,
        node_name          TYPE string,
        node_iobjnm        TYPE string,
      END OF ts_parent_child_hier.
    TYPES tt_parent_child_hier TYPE STANDARD TABLE OF ts_parent_child_hier
        WITH EMPTY KEY
        WITH NON-UNIQUE SORTED KEY parent COMPONENTS parent_node_iobjnm parent_node_name.
    METHODS get_hier_from_parent_child
      IMPORTING
        it_hier_parent_child TYPE tt_parent_child_hier
      RETURNING
        VALUE(ro_hierarhy)   TYPE REF TO zif_bwhier_hierarchy      .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS add_children_to_node
      IMPORTING
        io_root_node         TYPE REF TO zif_bwhier_node
        it_hier_parent_child TYPE zcl_bwhier_par_child_adapter=>tt_parent_child_hier.

ENDCLASS.



CLASS zcl_bwhier_par_child_adapter IMPLEMENTATION.
  METHOD get_hier_from_parent_child.

    DATA(lo_hier) = NEW zcl_bwhier_hierarchy( ).
    DATA(lo_root_node) = lo_hier->zif_bwhier_hierarchy~get_main_root_node( ).

    me->add_children_to_node(   io_root_node        = lo_root_node
                                it_hier_parent_child = it_hier_parent_child ).

    ro_hierarhy = lo_hier.
  ENDMETHOD.


  METHOD add_children_to_node.
    DATA(ls_node_value) = io_root_node->get_node_value( ).

    DATA(lt_root_nodes) = FILTER tt_parent_child_hier( it_hier_parent_child USING KEY parent
        WHERE parent_node_iobjnm = ls_node_value-node_iobjnm AND parent_node_name = ls_node_value-node_name ).
    LOOP AT lt_root_nodes REFERENCE INTO DATA(ls_child_node).
      DATA(lo_child_node) = io_root_node->insert_node_value_first( VALUE #( node_iobjnm = ls_child_node->node_iobjnm node_name = ls_child_node->node_name ) ).

      me->add_children_to_node( io_root_node            = lo_child_node
                                it_hier_parent_child    = it_hier_parent_child ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
