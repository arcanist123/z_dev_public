CLASS zcl_bwhier_hierarchy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC

  GLOBAL FRIENDS zcl_bwhier_node .

  PUBLIC SECTION.

    INTERFACES zif_bwhier_hierarchy .

    METHODS constructor .
    METHODS validate_new_node
      IMPORTING
        is_node_value TYPE zif_bwhier_node=>ts_node_value.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ts_hieararchy_line,
        node_name   TYPE string,
        node_iobjnm TYPE string,
        link        TYPE abap_bool,
        node        TYPE REF TO zcl_bwhier_node,
      END OF ts_hieararchy_line.

    TYPES tt_hierarchy TYPE STANDARD TABLE OF ts_hieararchy_line
        WITH EMPTY KEY
        WITH UNIQUE SORTED KEY node_key COMPONENTS node
        WITH NON-UNIQUE SORTED KEY value_key COMPONENTS node_name node_iobjnm.
    DATA gt_hierarchy TYPE tt_hierarchy.
    DATA go_root_node TYPE REF TO zif_bwhier_node.
    METHODS delete_node_by_ref
      IMPORTING
        io_node TYPE REF TO zcl_bwhier_node.

    METHODS get_link_nodes
      IMPORTING
        is_node_value   TYPE zcl_bwhier_node=>ts_nove_value
      RETURNING
        VALUE(r_result) TYPE zif_bwhier_node=>tt_nodes.

ENDCLASS.



CLASS zcl_bwhier_hierarchy IMPLEMENTATION.


  METHOD constructor.
    "set empty node as a root node
    me->go_root_node = NEW zcl_bwhier_node( is_node_value   = VALUE zif_bwhier_node=>ts_node_value( )
                                            io_hierarchy    = me ).
  ENDMETHOD.


  METHOD zif_bwhier_hierarchy~get_base_node.
*    READ TABLE gt_hierarchy REFERENCE INTO DATA(ls_hierarchy_node) WITH KEY node_name = iv_node_name node_iobjnm = iv_node_iobjnm link = abap_false.
*    IF ls_hierarchy_node IS BOUND.
*      ro_node = ls_hierarchy_node->node.
*    ELSE.
*      RAISE EXCEPTION TYPE zcx_exception.
*    ENDIF.
  ENDMETHOD.


  METHOD zif_bwhier_hierarchy~get_main_root_node.

    ro_root_node = me->go_root_node.

  ENDMETHOD.
  METHOD delete_node_by_ref.
    DELETE TABLE me->gt_hierarchy WITH TABLE KEY node_key COMPONENTS node = io_node.
  ENDMETHOD.




  METHOD get_link_nodes.
    LOOP AT me->gt_hierarchy REFERENCE INTO DATA(ls_hierarhcy_line) USING KEY value_key
        WHERE node_name = is_node_value-node_name AND node_iobjnm = is_node_value-node_iobjnm.
      APPEND ls_hierarhcy_line->node TO r_result.
    ENDLOOP.
  ENDMETHOD.


  METHOD validate_new_node.
*    "this is a shit implementation. Should be rewritten with class based enumarations
*    DATA(lx_base_node_exists) = me->go_hierarhy->zif_bwhier_hierarchy~check_base_node_exists( is_node_value ).
*    DATA(lv_pattern) = xsdbool( is_node_value-link = abap_true )
*        && xsdbool( me->go_hierarhy->zif_bwhier_hierarchy~check_base_node_exists( is_node_value ) = abap_true ) .
*    CASE lv_pattern.
*      WHEN `XX` OR "link node for existing base node
*        '  '. "base node for not existing base node
*      WHEN 'X ' OR"link node for not existing base node
*        ' X'. "base node for existing base node
*        RAISE EXCEPTION TYPE zcx_exception.
*    ENDCASE.
  ENDMETHOD.

ENDCLASS.
