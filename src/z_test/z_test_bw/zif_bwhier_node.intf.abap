INTERFACE zif_bwhier_node
  PUBLIC .

  TYPES:
    BEGIN OF ts_node_value,
      node_name   TYPE string,
      node_iobjnm TYPE string,
      link        TYPE abap_bool,
    END OF ts_node_value.


  TYPES tt_nodes TYPE STANDARD TABLE OF REF TO zif_bwhier_node WITH EMPTY KEY.
  METHODS get_children
    RETURNING
      VALUE(rt_children) TYPE tt_nodes.
  METHODS get_parent
    RETURNING
      VALUE(ro_parent) TYPE REF TO zif_bwhier_node.
  METHODS insert_node_value_first
    IMPORTING
      is_node_value  TYPE ts_node_value
    RETURNING
      VALUE(ro_node) TYPE REF TO zif_bwhier_node
    RAISING
      zcx_exception.

  METHODS insert_existing_node_first
    IMPORTING
      io_node TYPE REF TO zif_bwhier_node.
  METHODS get_my_link_nodes
    RETURNING
      VALUE(rt_nodes) TYPE tt_nodes.
  METHODS delete
    RAISING
      zcx_exception.
  METHODS get_node_value
    RETURNING VALUE(rs_node_value) TYPE ts_node_value.

ENDINTERFACE.
