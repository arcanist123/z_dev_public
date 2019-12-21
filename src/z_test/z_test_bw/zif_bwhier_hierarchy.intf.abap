INTERFACE zif_bwhier_hierarchy
  PUBLIC .
  METHODS get_base_node
    IMPORTING
      is_node_value  TYPE zif_bwhier_node=>ts_node_value
    RETURNING
      VALUE(ro_node) TYPE REF TO zif_bwhier_node
    RAISING
      zcx_exception.

  METHODS get_main_root_node
    RETURNING
      VALUE(ro_root_node) TYPE REF TO zif_bwhier_node.
  METHODS check_base_node_exists
    IMPORTING
      is_node_value    TYPE zif_bwhier_node=>ts_node_value
    RETURNING
      VALUE(rx_exists) TYPE abap_bool.
ENDINTERFACE.
