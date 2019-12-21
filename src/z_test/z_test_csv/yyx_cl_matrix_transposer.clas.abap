CLASS yyx_cl_matrix_transposer DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES tt_matrix TYPE STANDARD TABLE OF string_table WITH EMPTY KEY.
    TYPES:
      BEGIN OF ts_transpose_rule,
        flat_colume_number  TYPE int4,
        pivot_index_type    TYPE c LENGTH 1,
        pivot_column_number TYPE int4,
      END OF ts_transpose_rule.

    TYPES tt_transpose_rules TYPE STANDARD TABLE OF ts_transpose_rule WITH EMPTY KEY.

    CONSTANTS:
      BEGIN OF gc_pivot_index_type,
        row    TYPE c LENGTH 20 VALUE 'HEADER_ELEM',
        column TYPE c LENGTH 20 VALUE 'ROW_ELEM',
        value  TYPE c LENGTH 20 VALUE 'PIVOT_VALUE',
      END OF gc_pivot_index_type.
    CLASS-METHODS create_with_string_table
      IMPORTING
        it_table        TYPE tt_matrix
      RETURNING
        VALUE(r_result) TYPE REF TO yyx_cl_matrix_transposer.
    CLASS-METHODS create_with_table
      IMPORTING
        it_table        TYPE ANY TABLE
      RETURNING
        VALUE(r_result) TYPE REF TO yyx_cl_matrix_transposer.

    METHODS transpose_to_pivot
      IMPORTING
        it_transpose_rules TYPE tt_transpose_rules
      RETURNING
        VALUE(rt_pivot)    TYPE tt_matrix.
    METHODS transpose_to_flat_table
      IMPORTING
        it_transpose_rules   TYPE tt_transpose_rules
      RETURNING
        VALUE(rt_flat_table) TYPE tt_matrix.

    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA gt_data TYPE REF TO data.
    METHODS get_pivot_header
      IMPORTING
        i_it_transpose_rules TYPE yyx_cl_matrix_transposer=>tt_transpose_rules
      RETURNING
        VALUE(r_result)      TYPE string.
    METHODS get_pivot_rows
      IMPORTING
        i_it_transpose_rules TYPE yyx_cl_matrix_transposer=>tt_transpose_rules
      RETURNING
        VALUE(r_result)      TYPE string.
    METHODS get_column_rows_count
      IMPORTING
        i_it_transpose_rules TYPE yyx_cl_matrix_transposer=>tt_transpose_rules
      RETURNING
        VALUE(r_result)      TYPE int4.
    METHODS project_data
      IMPORTING
        i_it_transpose_rules TYPE yyx_cl_matrix_transposer=>tt_transpose_rules
      RETURNING
        VALUE(r_result)      TYPE REF TO data.
    METHODS get_existing_components
      IMPORTING
        it_data              TYPE REF TO data
      RETURNING
        VALUE(rt_components) TYPE cl_abap_structdescr=>component_table.
    METHODS get_necessary_components
      IMPORTING
        it_components      TYPE abap_component_tab
        it_transpose_rules TYPE yyx_cl_matrix_transposer=>tt_transpose_rules
      RETURNING
        VALUE(r_result)    TYPE abap_component_tab.
    METHODS create_projection_receiver
      IMPORTING
        it_necessary_components TYPE abap_component_tab
      RETURNING
        VALUE(r_result)         TYPE REF TO data.
    METHODS move_data_to_projection
      IMPORTING
        it_projection   TYPE REF TO data
        it_source_data  TYPE REF TO data
      RETURNING
        VALUE(r_result) TYPE REF TO data.
    METHODS get_sorting_key
      IMPORTING
        i_it_transpose_rules  TYPE yyx_cl_matrix_transposer=>tt_transpose_rules
      RETURNING
        VALUE(rv_sorting_key) TYPE abap_sortorder_tab.

ENDCLASS.



CLASS yyx_cl_matrix_transposer IMPLEMENTATION.

  METHOD create_with_string_table.

    CREATE OBJECT r_result.

  ENDMETHOD.

  METHOD create_with_table.

    CREATE OBJECT r_result.

  ENDMETHOD.

  METHOD constructor.


  ENDMETHOD.
  METHOD transpose_to_pivot.

    "based on the provided mapping construct the projection of the table
    DATA(lt_data_projection) = me->project_data( it_transpose_rules ).
    FIELD-SYMBOLS <lt_projection> TYPE STANDARD TABLE.
    ASSIGN lt_data_projection->* TO <lt_projection>.

    SORT <lt_projection> BY me->get_sorting_key( it_transpose_rules ).
    LOOP AT <lt_projection> ASSIGNING FIELD-SYMBOL(<ls_projection>).
    ENDLOOP.



  ENDMETHOD.

  METHOD transpose_to_flat_table.
    ASSERT 1 = 2. "not implemented

  ENDMETHOD.


  METHOD get_pivot_header.
    "get the count of header rows
*    DATA(lv_colum_rows_count) = me->get_column_rows_count( i_it_transpose_rules ).

    DATA lt_data TYPE STANDARD TABLE OF sflight WITH EMPTY KEY.
    SORT lt_data AS TEXT ASCENDING BY carrid.

  ENDMETHOD.


  METHOD get_pivot_rows.

  ENDMETHOD.


  METHOD get_column_rows_count.

  ENDMETHOD.


  METHOD project_data.

    DATA(lt_components) = get_existing_components( me->gt_data ).
    DATA(lt_necessary_components) = get_necessary_components(   it_components = lt_components
                                                                it_transpose_rules = i_it_transpose_rules ).
    r_result = me->create_projection_receiver( lt_necessary_components ).
    r_result = me->move_data_to_projection( it_projection = r_result
                                            it_source_data = me->gt_data ).


  ENDMETHOD.

  METHOD get_existing_components.


    cl_abap_tabledescr=>describe_by_data_ref(   EXPORTING   p_data_ref  = it_data   " Reference to described data object
                                                RECEIVING   p_descr_ref = DATA(lo_data_descr)
                                                EXCEPTIONS  reference_is_initial = 1
                                                            OTHERS               = 2 ).
    ASSERT sy-subrc = 0.

    DATA(lo_table_descr) = CAST cl_abap_tabledescr( lo_data_descr ).
    DATA(lo_struct_descr) = CAST cl_abap_structdescr( lo_table_descr->get_table_line_type( ) ).
    rt_components = lo_struct_descr->get_components( ).

  ENDMETHOD.




  METHOD get_necessary_components.
    "first put the rows into the structure
    DATA(lt_transpose_rules) = it_transpose_rules.
    SORT lt_transpose_rules BY pivot_column_number ASCENDING.
    LOOP AT lt_transpose_rules REFERENCE INTO DATA(ls_transpose_rule_row) WHERE pivot_index_type = gc_pivot_index_type-row.
      APPEND it_components[ ls_transpose_rule_row->flat_colume_number ] TO r_result.
    ENDLOOP.

    "then put the columns
    LOOP AT lt_transpose_rules REFERENCE INTO DATA(ls_transpose_rule_col) WHERE pivot_index_type = gc_pivot_index_type-column.
      APPEND it_components[ ls_transpose_rule_col->flat_colume_number ] TO r_result.
    ENDLOOP.

    "then put the value
    DATA(ls_transpose_rule_val) = lt_transpose_rules[ pivot_index_type = gc_pivot_index_type-value ].
    APPEND it_components[ ls_transpose_rule_val-flat_colume_number ] TO r_result.

  ENDMETHOD.


  METHOD create_projection_receiver.

    DATA(lo_line_handle) = cl_abap_structdescr=>get( it_necessary_components ).
    DATA(lo_table_handler) = cl_abap_tabledescr=>create(    p_line_type = lo_line_handle
                                                            p_key_kind  = cl_abap_tabledescr=>keydefkind_empty ).
    CREATE DATA r_result TYPE HANDLE lo_table_handler.
  ENDMETHOD.


  METHOD move_data_to_projection.
    "prepare source handler
    FIELD-SYMBOLS <lt_source_data> TYPE ANY TABLE.
    ASSIGN it_source_data->* TO <lt_source_data>.

    "prepare projection handler
    FIELD-SYMBOLS <lt_projection> TYPE STANDARD TABLE.
    CREATE DATA r_result LIKE it_projection.
    ASSIGN r_result->* TO <lt_projection>.

    "move data to projection
    MOVE-CORRESPONDING <lt_source_data> TO <lt_projection>.

  ENDMETHOD.


  METHOD get_sorting_key.

  ENDMETHOD.

ENDCLASS.
