CLASS z_test_fpm_004_search_dep DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class CL_FPM_TEST_SEARCH_DEP
*"* do not include other source files here!!!

    INTERFACES if_fpm_guibb .
    INTERFACES if_fpm_guibb_search .
    INTERFACES if_fpm_guibb_ovs .
    INTERFACES if_fpm_guibb_ovs_search .


    TYPES:
      BEGIN OF s_attr,
        product_group TYPE /bi0/oitsc0ocpg,
        product_line  TYPE /bi0/oitsc0ocpl,
        product       TYPE /bi0/oitsc0ocpp,
      END OF s_attr.

    TYPES:
      t_attr TYPE STANDARD TABLE OF s_attr WITH DEFAULT KEY .
  PROTECTED SECTION.
*"* protected components of class CL_FPM_TEST_SEARCH_DEP
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class CL_FPM_TEST_SEARCH_DEP
*"* do not include other source files here!!!


    TYPES:
      BEGIN OF ts_input_product_group,
        product_group TYPE /bi0/oitsc0ocpg,
      END OF ts_input_product_group ,

      BEGIN OF ts_input_product_line,
        product_line TYPE /bi0/oitsc0ocpl,
      END OF ts_input_product_line ,

      BEGIN OF ts_input_product,
        product TYPE /bi0/oitsc0ocpp,
      END OF ts_input_product,

      BEGIN OF ts_list_product_group,
        product_group TYPE /bi0/oitsc0ocpg,
        description   TYPE text60,
      END OF ts_list_product_group,

      BEGIN OF ts_list_product_line,
        product_line TYPE /bi0/oitsc0ocpl,
        description  TYPE text60,
      END OF ts_list_product_line,

      BEGIN OF ts_list_product,
        product_line TYPE /bi0/oitsc0ocpp,
        description  TYPE text60,
      END OF ts_list_product.



    DATA mt_criteria TYPE fpmgb_t_search_criteria .
ENDCLASS.



CLASS z_test_fpm_004_search_dep IMPLEMENTATION.


  METHOD if_fpm_guibb_ovs_search~set_current_search_criteria.

    mt_criteria = it_fpm_search_criteria.

  ENDMETHOD.


  METHOD if_fpm_guibb_ovs~handle_phase_0.


    DATA: l_text         TYPE wdr_name_value,
          l_label_texts  TYPE wdr_name_value_list,
          l_column_texts TYPE wdr_name_value_list,
          l_window_title TYPE string,
          l_group_header TYPE string,
          l_table_header TYPE string.

    CASE iv_field_name.
      WHEN 'PRODUCT_GROUP'.
        l_text-name = 'PRODUCT_GROUP'.  "must match a field in list structure
        l_text-value = 'Product group'.
        INSERT l_text INTO TABLE l_label_texts.
        INSERT l_text INTO TABLE l_column_texts.

        l_window_title = 'Product group'.
        l_group_header = 'Product group'.
        l_table_header = 'Product group'.
        io_ovs_callback->set_configuration(
                  label_texts  = l_label_texts
                  column_texts = l_column_texts
                  group_header = l_group_header
                  window_title = l_window_title
                  table_header = l_table_header
                  col_count    = 1
                  row_count    = 5 ).

      WHEN 'PRODUCT_LINE'.
        l_text-name = 'PRODUCT_LINE'.  "must match a field in list structure
        l_text-value = 'Product line'.
        INSERT l_text INTO TABLE l_label_texts.
        INSERT l_text INTO TABLE l_column_texts.
        l_window_title = 'Product line'.
        l_group_header = 'Product line'.
        l_table_header = 'Product line'.
        io_ovs_callback->set_configuration(
                  label_texts  = l_label_texts
                  column_texts = l_column_texts
                  group_header = l_group_header
                  window_title = l_window_title
                  table_header = l_table_header
                  col_count    = 1
                  row_count    = 5 ).

      WHEN 'PRODUCT'.
        l_text-name = 'PRODUCT'.  "must match a field in list structure
        l_text-value = 'Product'.
        INSERT l_text INTO TABLE l_label_texts.
        INSERT l_text INTO TABLE l_column_texts.
        l_window_title = 'Product'.
        l_group_header = 'Product'.
        l_table_header = 'Product'.
        io_ovs_callback->set_configuration(
                  label_texts  = l_label_texts
                  column_texts = l_column_texts
                  group_header = l_group_header
                  window_title = l_window_title
                  table_header = l_table_header
                  col_count    = 1
                  row_count    = 5 ).


    ENDCASE.

  ENDMETHOD.


  METHOD if_fpm_guibb_ovs~handle_phase_1.

    "set search structure and defaults
*   In this phase you can set the structure and default values
*   of the search structure. If this phase is omitted, the search
*   fields will not be displayed, but the selection table is
*   displayed directly.
*   Read values of the original context (not necessary, but you
*   may set these as the defaults). A reference to the context
*   element is available in the callback object.

    RETURN.

***  CASE iv_field_name.
***    WHEN 'COUNTRY'.
***      DATA: l_search_input  TYPE t_stru_input_country.
***      io_ovs_callback->context_element->get_static_attributes(
***          IMPORTING static_attributes = l_search_input ).
****     pass the values to the OVS component
***      io_ovs_callback->set_input_structure(
***          input = l_search_input ).
***
***    WHEN 'CITY'.
***      DATA: l_search_input  TYPE t_stru_input_city.
***      io_ovs_callback->context_element->get_static_attributes(
***          IMPORTING static_attributes = l_search_input ).
****     pass the values to the OVS component
***      io_ovs_callback->set_input_structure(
***          input = l_search_input ).
***  ENDCASE.

  ENDMETHOD.


  METHOD if_fpm_guibb_ovs~handle_phase_2.

    CASE iv_field_name.
      WHEN 'PRODUCT_GROUP'.
        SELECT * FROM /bi0/mtsc0ocpg INTO TABLE @DATA(lt_product_groups).
        io_ovs_callback->set_output_table( output = lt_product_groups ).


      WHEN 'PRODUCT_LINE'.
        SELECT * FROM /bi0/mtsc0ocpg INTO TABLE @DATA(lt_product_lines).
        io_ovs_callback->set_output_table( output = lt_product_lines ).

      WHEN 'PRODUCT'.

      WHEN 'COUNTRY'.



      WHEN 'CITY'.


    ENDCASE.

  ENDMETHOD.


  METHOD if_fpm_guibb_ovs~handle_phase_3.


    CASE iv_field_name.
      WHEN 'COUNTRY'.


        FIELD-SYMBOLS: <selection>    TYPE ts_list_product_group.
*   apply result

        IF io_ovs_callback->selection IS NOT BOUND.
******** TODO exception handling
        ENDIF.

        ASSIGN io_ovs_callback->selection->* TO <selection>.

        IF <selection> IS ASSIGNED.
          io_ovs_callback->context_element->set_attribute(
                                 name  = iv_wd_context_attr_name
                                 value = <selection>-product_group ).

          CREATE OBJECT eo_fpm_event
            EXPORTING
              iv_event_id = 'DUMMY'.

        ENDIF.

      WHEN 'CITY'.


        FIELD-SYMBOLS: <selection_city>    TYPE ts_list_product_line.
*   apply result

        IF io_ovs_callback->selection IS NOT BOUND.
******** TODO exception handling
        ENDIF.

        ASSIGN io_ovs_callback->selection->* TO <selection_city>.

        IF <selection_city> IS ASSIGNED.
          io_ovs_callback->context_element->set_attribute(
                                 name  = iv_wd_context_attr_name
                                 value = <selection_city>-product_line ).

          CREATE OBJECT eo_fpm_event
            EXPORTING
              iv_event_id = 'DUMMY'.

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD if_fpm_guibb_search~check_config.
  ENDMETHOD.


  METHOD if_fpm_guibb_search~flush.
  ENDMETHOD.


  METHOD if_fpm_guibb_search~get_data.
  ENDMETHOD.


  METHOD if_fpm_guibb_search~get_default_config.
  ENDMETHOD.


  METHOD if_fpm_guibb_search~get_definition.

    DATA: ls_attr        TYPE s_attr,
          ls_field_descr TYPE fpmgb_s_searchfield_descr,
          lt_exclude_ops TYPE fpmgb_t_search_operator,
          ls_exclude_ops LIKE LINE OF lt_exclude_ops.

    ls_exclude_ops-operator_id = '02'.
    APPEND ls_exclude_ops TO lt_exclude_ops.
    ls_exclude_ops-operator_id = '03'.
    APPEND ls_exclude_ops TO lt_exclude_ops.
    ls_exclude_ops-operator_id = '04'.
    APPEND ls_exclude_ops TO lt_exclude_ops.
    ls_exclude_ops-operator_id = '05'.
    APPEND ls_exclude_ops TO lt_exclude_ops.
    ls_exclude_ops-operator_id = '06'.
    APPEND ls_exclude_ops TO lt_exclude_ops.
    ls_exclude_ops-operator_id = '07'.
    APPEND ls_exclude_ops TO lt_exclude_ops.
    ls_exclude_ops-operator_id = '08'.
    APPEND ls_exclude_ops TO lt_exclude_ops.
    ls_exclude_ops-operator_id = '09'.
    APPEND ls_exclude_ops TO lt_exclude_ops.


* field catalog
    eo_field_catalog_attr ?= cl_abap_structdescr=>describe_by_data( ls_attr ).
* ovs search attribute
    ls_field_descr-name      = 'PRODUCT'.
    ls_field_descr-ovs_name = 'Z_TEST_FPM_004_SEARCH_DEP'.
    ls_field_descr-exclude_operators = lt_exclude_ops.
    APPEND ls_field_descr TO et_field_description_attr.


  ENDMETHOD.


  METHOD if_fpm_guibb_search~process_event.
  ENDMETHOD.


  METHOD if_fpm_guibb~get_parameter_list.
  ENDMETHOD.


  METHOD if_fpm_guibb~initialize.
  ENDMETHOD.
ENDCLASS.
