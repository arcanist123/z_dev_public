REPORT ztdi_tree.

TYPES:
* Types for structure and table of tree data
  BEGIN OF ts_data,
    node     TYPE string,
    descript TYPE string,
  END OF ts_data,
  tt_data TYPE TABLE OF ts_data,

* Types for structure and table of tree hierarchy
  BEGIN OF ts_hier,
    node   TYPE string,
    parent TYPE string,
    key    TYPE salv_de_node_key,
  END OF ts_hier,
  tt_hier TYPE TABLE OF ts_hier.

DATA:
  gt_data TYPE tt_data, " Tree data
  gt_hier TYPE tt_hier. " Tree hierarchy

START-OF-SELECTION.

* Read the tree data and hierarchy
  PERFORM scan_hier USING 'CL_SALV_MODEL' '' CHANGING gt_data gt_hier.

* Other sample with sales documents
* PERFORM read_sales CHANGING gt_data gt_hier.

* Display tree
  PERFORM display_alv_tree.

*&---------------------------------------------------------------------*
*&      Form  scan_hier
*&---------------------------------------------------------------------*
FORM scan_hier USING    pi_node   TYPE seoclsname
                        pi_parent TYPE seoclsname
               CHANGING pt_data   TYPE tt_data
                        pt_hier   TYPE tt_hier.

  DATA:
    ls_data  TYPE ts_data,
    ls_hier  TYPE ts_hier,
    lv_child TYPE seoclsname.

* Read and save data
  ls_data-node = pi_node.
  SELECT SINGLE descript
    INTO ls_data-descript
    FROM seoclasstx
    WHERE clsname = pi_node
      AND langu   = sy-langu.
  APPEND ls_data TO pt_data.

* Save relation
  ls_hier-node   = pi_node.
  ls_hier-parent = pi_parent.
  ls_hier-key    = pi_node.
  APPEND ls_hier TO pt_hier.

* Find children
  SELECT clsname
    INTO lv_child
    FROM seometarel
    WHERE refclsname = pi_node.

    PERFORM scan_hier USING lv_child pi_node CHANGING pt_data pt_hier.
  ENDSELECT.
ENDFORM.                    "scan_hier


*&---------------------------------------------------------------------*
*&      Form  display_alv_tree
*&---------------------------------------------------------------------*
FORM display_alv_tree.

  DATA:
    lt_empty         TYPE tt_data,
    ls_data          TYPE ts_data,
    ls_hier          TYPE ts_hier,
    lv_key           TYPE salv_de_node_key,
    lo_tree          TYPE REF TO cl_salv_tree,
    lo_nodes         TYPE REF TO cl_salv_nodes,
    lo_node          TYPE REF TO cl_salv_node,
    lo_columns       TYPE REF TO cl_salv_columns,
    lo_column        TYPE REF TO cl_salv_column,
    lo_tree_settings TYPE REF TO cl_salv_tree_settings,
    lv_text          TYPE lvc_value.

  FIELD-SYMBOLS:
    <fs_hier> TYPE ts_hier.

  TRY.
*     1. Create instance with an empty table
      CALL METHOD cl_salv_tree=>factory
        IMPORTING
          r_salv_tree = lo_tree
        CHANGING
          t_table     = lt_empty.

*     2. Add the nodes to the tree and set their relations
      lo_nodes = lo_tree->get_nodes( ).

      LOOP AT gt_hier ASSIGNING <fs_hier>.

        IF <fs_hier>-parent = ''.
*         Add the node as root
          lo_node = lo_nodes->add_node(
            related_node = ''
            relationship = if_salv_c_node_relation=>parent ).
        ELSE.
*         Read the ALV key of parent node and add as a child
          READ TABLE gt_hier INTO ls_hier
            WITH KEY node = <fs_hier>-parent.
          lo_node = lo_nodes->add_node(
            related_node = ls_hier-key
            relationship = if_salv_c_node_relation=>first_child ).
        ENDIF.

*       Save the ALV internal key
        <fs_hier>-key = lo_node->get_key( ).

*       Add the data of the tree
        READ TABLE gt_data INTO ls_data
          WITH KEY node = <fs_hier>-node.
        lo_node->set_data_row( ls_data ).
        lv_text = ls_data-node.
        lo_node->set_text( lv_text ).
      ENDLOOP.

*     Do some final format tasks
      lo_columns = lo_tree->get_columns( ).
      lo_columns->set_optimize( abap_true ).
      lo_column = lo_columns->get_column( 'NODE' ).
      lo_column->set_visible( abap_false ).
      lo_tree_settings = lo_tree->get_tree_settings( ).
      lo_tree_settings->set_hierarchy_header( 'Node' ).
      lo_nodes->expand_all( ).

*     Display Table
      lo_tree->display( ).

    CATCH cx_salv_error. " for cl_salv_tree=>factory
  ENDTRY.
ENDFORM.                    "display_alv_tree
