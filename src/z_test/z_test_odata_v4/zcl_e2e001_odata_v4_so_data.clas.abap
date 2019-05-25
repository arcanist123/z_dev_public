class zcl_e2e001_odata_v4_so_data definition
  public
  inheriting from /iwbep/cl_v4_abs_data_provider
  final
  create public .

  public section.
    interfaces zif_e2e001_odata_v4_so_types.


    methods /iwbep/if_v4_dp_basic~read_entity redefinition .
    methods /iwbep/if_v4_dp_basic~read_entity_list redefinition.
    methods /iwbep/if_v4_dp_basic~read_ref_target_key_data_list redefinition .
    methods /iwbep/if_v4_dp_basic~create_entity redefinition.
    methods /iwbep/if_v4_dp_basic~update_entity redefinition.
    methods /iwbep/if_v4_dp_basic~delete_entity redefinition.

  protected section.
  private section.
    aliases gcs_entity_set_names
       for zif_e2e001_odata_v4_so_types~gcs_entity_set_names .
    aliases gcs_entity_type_names
      for zif_e2e001_odata_v4_so_types~gcs_entity_type_names .
    aliases gty_cds_views
      for zif_e2e001_odata_v4_so_types~gty_cds_views.
    aliases gcs_nav_prop_names
      for zif_e2e001_odata_v4_so_types~gcs_nav_prop_names.
    aliases gcs_expand_expressions
      for zif_e2e001_odata_v4_so_types~gcs_expand_expressions.

    methods read_list_salesorder
      importing
        io_request        type ref to /iwbep/if_v4_requ_basic_list
        io_response       type ref to /iwbep/if_v4_resp_basic_list
        iv_orderby_string type string
        iv_where_clause   type string
        iv_select_string  type string
        iv_skip           type i
        iv_top            type i
        is_done_list      type /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list
      raising
        /iwbep/cx_gateway.
    methods read_entity_salesorder
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_read
        io_response type ref to /iwbep/if_v4_resp_basic_read
      raising
        /iwbep/cx_gateway.
    methods read_ref_key_list_salesorder
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_ref_l
        io_response type ref to /iwbep/if_v4_resp_basic_ref_l
      raising
        /iwbep/cx_gateway.

    methods read_list_salesorderitem
      importing
        io_request        type ref to /iwbep/if_v4_requ_basic_list
        io_response       type ref to /iwbep/if_v4_resp_basic_list
        iv_orderby_string type string
        iv_where_clause   type string
        iv_select_string  type string
        iv_skip           type i
        iv_top            type i
        is_done_list      type /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list
      raising
        /iwbep/cx_gateway.



    methods read_entity_salesorderitem
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_read
        io_response type ref to /iwbep/if_v4_resp_basic_read
      raising
        /iwbep/cx_gateway.
    methods create_salesorder
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_create
        io_response type ref to /iwbep/if_v4_resp_basic_create
      raising
        /iwbep/cx_gateway.
    methods create_salesorderitem
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_create
        io_response type ref to /iwbep/if_v4_resp_basic_create
      raising
        /iwbep/cx_gateway.

*         METHODS deep_create_salesorder
*      IMPORTING
*        io_request  TYPE REF TO /iwbep/if_v4_requ_adv_create
*        io_response TYPE REF TO /iwbep/if_v4_resp_adv_create
*      RAISING
*        /iwbep/cx_gateway.

    methods update_salesorder
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_update
        io_response type ref to /iwbep/if_v4_resp_basic_update
      raising
        /iwbep/cx_gateway.
    methods delete_salesorder
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_delete
        io_response type ref to /iwbep/if_v4_resp_basic_delete
      raising
        /iwbep/cx_gateway.
    methods delete_salesorderitem
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_delete
        io_response type ref to /iwbep/if_v4_resp_basic_delete
      raising
        /iwbep/cx_gateway.
    methods update_salesorderitem
      importing
        io_request  type ref to /iwbep/if_v4_requ_basic_update
        io_response type ref to /iwbep/if_v4_resp_basic_update
      raising
        /iwbep/cx_gateway.


ENDCLASS.



CLASS ZCL_E2E001_ODATA_V4_SO_DATA IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_E2E001_ODATA_V4_SO_DATA->/IWBEP/IF_V4_DP_BASIC~CREATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_CREATE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_CREATE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_v4_dp_basic~create_entity.
    data: lv_entity_type_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.


    io_request->get_entity_type( importing ev_entity_type_name = lv_entity_type_name ).

    case lv_entity_type_name.

      when gcs_entity_type_names-internal-salesorder.
        create_salesorder(
            io_request  = io_request
            io_response = io_response ).

      when gcs_entity_type_names-internal-salesorderitem.
        create_salesorderitem(
            io_request  = io_request
            io_response = io_response ).

      when others.

        super->/iwbep/if_v4_dp_basic~create_entity(
            exporting
              io_request  = io_request
              io_response = io_response ).

    endcase.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_E2E001_ODATA_V4_SO_DATA->/IWBEP/IF_V4_DP_BASIC~DELETE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_DELETE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_DELETE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_v4_dp_basic~delete_entity.

    data: lv_entity_type_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.

    io_request->get_entity_type( importing ev_entity_type_name = lv_entity_type_name ).

    case lv_entity_type_name.

      when gcs_entity_type_names-internal-salesorder.
        delete_salesorder(
          exporting
            io_request  = io_request
            io_response = io_response ).

      when gcs_entity_type_names-internal-salesorderitem.
        delete_salesorderitem(
          exporting
            io_request  = io_request
            io_response = io_response ).

      when others.
        raise exception type /iwbep/cx_v4_tea
          exporting
            http_status_code = /iwbep/cx_v4_tea=>gcs_http_status_codes-sv_not_implemented
            textid           = /iwbep/cx_v4_tea=>entity_type_not_supported
            entity_type      = lv_entity_type_name.

    endcase.


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_E2E001_ODATA_V4_SO_DATA->/IWBEP/IF_V4_DP_BASIC~READ_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_READ
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_READ
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_v4_dp_basic~read_entity.

    data: lv_entityset_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.


    io_request->get_entity_set( importing ev_entity_set_name = lv_entityset_name ).

    case lv_entityset_name.

      when gcs_entity_set_names-internal-salesorder.
        read_entity_salesorder(
          exporting
            io_request  = io_request
            io_response = io_response ).

      when gcs_entity_set_names-internal-salesorderitem.
        read_entity_salesorderitem(
          exporting
            io_request  = io_request
            io_response = io_response ).

      when others.
        super->/iwbep/if_v4_dp_basic~read_entity(
          exporting
            io_request  = io_request
            io_response = io_response ).

    endcase.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_E2E001_ODATA_V4_SO_DATA->/IWBEP/IF_V4_DP_BASIC~READ_ENTITY_LIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_LIST
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_LIST
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_v4_dp_basic~read_entity_list.

    data lv_entityset_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.

    data: ls_todo_list         type /iwbep/if_v4_requ_basic_list=>ty_s_todo_list,
          ls_done_list         type /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list,
          lv_where_clause      type string,
          lv_select_string     type string,
          lv_orderby_string    type string,
          lt_selected_property type /iwbep/if_v4_runtime_types=>ty_t_property_path,
          lv_skip              type i value 0,
          lv_top               type i value 0,
          lt_orderby_property  type abap_sortorder_tab.


    io_request->get_todos( importing es_todo_list = ls_todo_list ).


    " $orderby was called
    if ls_todo_list-process-orderby = abap_true.
      ls_done_list-orderby = abap_true.
      "** only supported as of 751 or 752
      "get Open SQL Order by Clause
      "io_request->get_osql_orderby_clause( IMPORTING ev_osql_orderby_clause = lv_orderby_string ).
*        CATCH /iwbep/cx_gateway.    "

      io_request->get_orderby( importing et_orderby_property = lt_orderby_property ).
      clear lv_orderby_string.
      loop at lt_orderby_property into data(ls_orderby_property).
        if ls_orderby_property-descending = abap_true.
          concatenate lv_orderby_string ls_orderby_property-name 'DESCENDING' into lv_orderby_string separated by space.
        else.
          concatenate lv_orderby_string ls_orderby_property-name 'ASCENDING' into lv_orderby_string separated by space.
        endif.
      endloop.

    else.
      " lv_orderby_string must not be empty.
      lv_orderby_string = 'PRIMARY KEY'.
    endif.


    " $skip / $top handling
    if ls_todo_list-process-skip = abap_true.
      ls_done_list-skip = abap_true.
      io_request->get_skip( importing ev_skip = lv_skip ).
    endif.
    if ls_todo_list-process-top = abap_true.
      ls_done_list-top = abap_true.
      io_request->get_top( importing ev_top = lv_top ).
    endif.


    " $select handling
    if ls_todo_list-process-select = abap_true.
      ls_done_list-select = abap_true.
      io_request->get_selected_properties(  importing et_selected_property = lt_selected_property ).
      concatenate lines of lt_selected_property into lv_select_string  separated by ','.
    else.
      "check coding. If no columns are specified via $select retrieve all columns from the model instead?
      lv_select_string = '*'.
      "or better to throw an exception instead?
    endif.


    " specific sales orders based on $filter?
    if ls_todo_list-process-filter = abap_true.
      ls_done_list-filter = abap_true.
      io_request->get_filter_osql_where_clause( importing ev_osql_where_clause = lv_where_clause ).
    endif.


    io_request->get_entity_set( importing ev_entity_set_name = lv_entityset_name ).

    case lv_entityset_name.

      when gcs_entity_set_names-internal-salesorder.

        read_list_salesorder(
          exporting
            io_request        = io_request
            io_response       = io_response
            iv_orderby_string = lv_orderby_string
            iv_select_string  = lv_select_string
            iv_where_clause   = lv_where_clause
            iv_skip           = lv_skip
            iv_top            = lv_top
            is_done_list      = ls_done_list ).

      when gcs_entity_set_names-internal-salesorderitem.

        read_list_salesorderitem(
          exporting
            io_request        = io_request
            io_response       = io_response
            iv_orderby_string = lv_orderby_string
            iv_select_string  = lv_select_string
            iv_where_clause   = lv_where_clause
            iv_skip           = lv_skip
            iv_top            = lv_top
            is_done_list      = ls_done_list ).

      when others.

        super->/iwbep/if_v4_dp_basic~read_entity_list( io_request  = io_request
                                                       io_response = io_response ).
    endcase.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_E2E001_ODATA_V4_SO_DATA->/IWBEP/IF_V4_DP_BASIC~READ_REF_TARGET_KEY_DATA_LIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_REF_L
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_REF_L
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_v4_dp_basic~read_ref_target_key_data_list.

    data: lv_source_entity_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.


    io_request->get_source_entity_type( importing ev_source_entity_type_name = lv_source_entity_name ).

    case lv_source_entity_name.

      when gcs_entity_type_names-internal-salesorder.
        read_ref_key_list_salesorder(
           exporting
            io_request  = io_request
            io_response = io_response ).

      when others.
        super->/iwbep/if_v4_dp_basic~read_ref_target_key_data_list(
          exporting
            io_request  = io_request
            io_response = io_response ).

    endcase.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_E2E001_ODATA_V4_SO_DATA->/IWBEP/IF_V4_DP_BASIC~UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_UPDATE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_UPDATE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_v4_dp_basic~update_entity.

    data: lv_entity_type_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.

    io_request->get_entity_type( importing ev_entity_type_name = lv_entity_type_name ).

    case lv_entity_type_name.

      when gcs_entity_type_names-internal-salesorder.
        update_salesorder(
          exporting
            io_request  = io_request
            io_response = io_response ).

      when gcs_entity_type_names-internal-salesorderitem.
        update_salesorderitem(
          exporting
            io_request  = io_request
            io_response = io_response ).


      when others.

        super->/iwbep/if_v4_dp_basic~update_entity(
         exporting
           io_request  = io_request
           io_response = io_response ).

    endcase.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->CREATE_SALESORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_CREATE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_CREATE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method create_salesorder.


    "entity type specific data types
    data: ls_salesorder         type gty_cds_views-salesorder,
          ls_salesorder_rfc     type bapi_epm_so_header,
          ls_salesorder_rfc_key type bapi_epm_so_id.

    "generic data types
    data:
      ls_todo_list              type /iwbep/if_v4_requ_basic_create=>ty_s_todo_list,
      ls_done_list              type /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list,
      lt_bapi_return            type table of bapiret2,
      ls_bapi_return            type bapiret2,
      lo_message_container      type ref to /iwbep/if_v4_message_container,
      lv_names_of_missing_props type string.


    io_request->get_todos( importing es_todo_list = ls_todo_list ).
    if ls_todo_list-process-busi_data = abap_true.
      io_request->get_busi_data( importing es_busi_data = ls_salesorder ).
      ls_done_list-busi_data = abap_true. "business data processed
    endif.

    if ls_todo_list-process-partial_busi_data = abap_true.
      "check if the mandatory properties have been provided
      "do not check for properties that are not mandatory
      "@todo: These could be annotated as Core.Computed

      if ls_salesorder-customer is not initial and
      ls_salesorder-transactioncurrency is not initial.
        ls_salesorder_rfc-buyer_id = ls_salesorder-customer.
        ls_salesorder_rfc-currency_code  = ls_salesorder-transactioncurrency.
        ls_done_list-partial_busi_data = abap_true.
      else.
        lv_names_of_missing_props = 'Customer or TransactionCurrency'.
        raise exception type zcx_e2e001_odata_v4_so
          exporting
            textid                 = zcx_e2e001_odata_v4_so=>missing_properties
            http_status_code       = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
            edm_entity_set_name    = gcs_entity_set_names-edm-salesorder
            names_of_missing_props = lv_names_of_missing_props.
      endif.
    endif.

    "Create single entity using classic API.
    "request fields have been mapped to function module parameters

    call function 'BAPI_EPM_SO_CREATE'
      exporting
        headerdata   = ls_salesorder_rfc
      importing
        salesorderid = ls_salesorder_rfc_key
      tables
        return       = lt_bapi_return.

    " Error handling
    if lt_bapi_return is not initial.
      "check if an error message is in lt_bapi_return
      loop at lt_bapi_return into ls_bapi_return.
        if ls_bapi_return-type = 'E'.

          lo_message_container = io_response->get_message_container( ).

          loop at lt_bapi_return into ls_bapi_return.
            lo_message_container->add_t100(
              exporting
                iv_msg_type                 =     ls_bapi_return-type
                iv_msg_id                   =     ls_bapi_return-id
                iv_msg_number               =     ls_bapi_return-number
                iv_msg_v1                   =     ls_bapi_return-message_v1
                iv_msg_v2                   =     ls_bapi_return-message_v2
                iv_msg_v3                   =     ls_bapi_return-message_v3
                iv_msg_v4                   =     ls_bapi_return-message_v4 ).
          endloop.

          "raise exception
          raise exception type zcx_e2e001_odata_v4_so
            exporting
              message_container = lo_message_container.

        endif.
      endloop.

    endif.


    if ls_todo_list-return-busi_data = abap_true.
      "   Read data again and set the response.
      clear ls_salesorder.
      select single * from ze2e001_c_salesorder
      into corresponding fields of @ls_salesorder
      where salesorder = @ls_salesorder_rfc_key-so_id.
      io_response->set_busi_data( ls_salesorder ).
    endif.

    io_response->set_is_done( ls_done_list ).


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->CREATE_SALESORDERITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_CREATE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_CREATE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method create_salesorderitem.

    "entity type specific data types
    data: ls_salesorderitem       type gty_cds_views-salesorderitem,
          ls_salesorderitem_rfc   type bapi_epm_so_item,
          ls_salesorderitem_x_rfc type bapi_epm_so_itemx,
          lt_salesorderitem_rfc   type standard table of bapi_epm_so_item,
          lt_salesorderitem_x_rfc type standard table of bapi_epm_so_itemx,
          ls_salesorder_rfc_key   type bapi_epm_so_id,
          lv_new_salesorderitem   type gty_cds_views-salesorderitem-salesorderitem.

    "generic data types
    data:
      ls_todo_list              type /iwbep/if_v4_requ_basic_create=>ty_s_todo_list,
      ls_done_list              type /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list,
      lt_bapi_return            type table of bapiret2,
      ls_bapi_return            type bapiret2,
      lo_message_container      type ref to /iwbep/if_v4_message_container,
      lv_names_of_missing_props type string.


    io_request->get_todos( importing es_todo_list = ls_todo_list ).
    if ls_todo_list-process-busi_data = abap_true.
      io_request->get_busi_data( importing es_busi_data = ls_salesorderitem ).
      ls_done_list-busi_data = abap_true. "business data processed
    endif.



    if ls_todo_list-process-partial_busi_data = abap_true.
      "check if the mandatory properties have been provided
      "do not check for properties that are not mandatory
      "@todo: These could be annotated as Core.Computed


      "Since we are using the BAPI BAPI_EPM_SO_CHANGE
      "sales order line items are NOT uniquely identified by the key fields salesorder and salesorderitem
      "we need in addition the product id as well as the delivery data
      "this is however a specific EPM demo data logic

      if ls_salesorderitem-salesorder is initial or
      ls_salesorderitem-product is initial or
      ls_salesorderitem-deliverydatetime is initial.

        lv_names_of_missing_props = 'Salesorder or Product or DeveliveryDateTime'.
        raise exception type zcx_e2e001_odata_v4_so
          exporting
            textid                 = zcx_e2e001_odata_v4_so=>missing_properties
            http_status_code       = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
            edm_entity_set_name    = gcs_entity_set_names-edm-salesorderitem
            names_of_missing_props = lv_names_of_missing_props.

      else.
        "the mandatory properties have been provided
        ls_done_list-partial_busi_data = abap_true.
      endif.


      ls_salesorder_rfc_key-so_id =   ls_salesorderitem-salesorder.

      " fill structure for header data
      ls_salesorderitem_rfc-so_id = ls_salesorder_rfc_key-so_id.
      ls_salesorderitem_rfc-product_id = ls_salesorderitem-product.
      ls_salesorderitem_rfc-delivery_date = ls_salesorderitem-deliverydatetime.

      " @TODO Sales order description is not yet a property of the CDS view
      ls_salesorderitem_rfc-quantity = ls_salesorderitem-quantity.
      ls_salesorderitem_rfc-quantity_unit = ls_salesorderitem-unit.

      " Map key values to x-bapi-structure
      ls_salesorderitem_x_rfc-so_id = ls_salesorderitem_rfc-so_id.
      ls_salesorderitem_x_rfc-product_id = ls_salesorderitem_rfc-product_id.
      ls_salesorderitem_x_rfc-delivery_date = ls_salesorderitem_rfc-delivery_date.

      " Map constant values to function module parameters
      " @TODO Sales order description is not yet a property of the CDS view
      ls_salesorderitem_x_rfc-quantity = abap_true.
      ls_salesorderitem_x_rfc-quantity_unit = abap_true.

      "Specify that this is an insert operation 'I'
      ls_salesorderitem_x_rfc-actioncode = 'I'.

      append ls_salesorderitem_rfc to lt_salesorderitem_rfc.
      append ls_salesorderitem_x_rfc to lt_salesorderitem_x_rfc.

* update data

      call function 'BAPI_EPM_SO_CHANGE'
        exporting
          so_id       = ls_salesorder_rfc_key
        tables
          soitemdata  = lt_salesorderitem_rfc
          soitemdatax = lt_salesorderitem_x_rfc
          return      = lt_bapi_return.
      " Error handling
      if lt_bapi_return is not initial.
        "check if an error message is in lt_bapi_return
        loop at lt_bapi_return into ls_bapi_return.
          if ls_bapi_return-type = 'E'.

            lo_message_container = io_response->get_message_container( ).

            loop at lt_bapi_return into ls_bapi_return.
              lo_message_container->add_t100(
                exporting
                  iv_msg_type                 =     ls_bapi_return-type
                  iv_msg_id                   =     ls_bapi_return-id
                  iv_msg_number               =     ls_bapi_return-number
                  iv_msg_v1                   =     ls_bapi_return-message_v1
                  iv_msg_v2                   =     ls_bapi_return-message_v2
                  iv_msg_v3                   =     ls_bapi_return-message_v3
                  iv_msg_v4                   =     ls_bapi_return-message_v4 ).
            endloop.

            "raise exception
            raise exception type zcx_e2e001_odata_v4_so
              exporting
                message_container = lo_message_container.

          endif.
        endloop.

      else.

        ls_salesorderitem_rfc = lt_salesorderitem_rfc[ 1 ].

      endif.



      if ls_todo_list-return-busi_data = abap_true.
        "   Read data again and set the response.
        clear ls_salesorderitem.

        select * from ze2e001_c_salesorderitem
        where salesorder = @ls_salesorderitem_rfc-so_id
        order by salesorderitem descending
        into corresponding fields of @ls_salesorderitem
        up to 1 rows       .
        endselect.






        io_response->set_busi_data( ls_salesorderitem ).
      endif.
    endif.
    io_response->set_is_done( ls_done_list ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->DELETE_SALESORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_DELETE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_DELETE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method delete_salesorder.
    "entity type specific data types
    data: ls_key_salesorder type gty_cds_views-salesorder,
          ls_so_id          type bapi_epm_so_id.

    "generic data types
    data:
      ls_todo_list         type /iwbep/if_v4_requ_basic_delete=>ty_s_todo_list,
      ls_done_list         type /iwbep/if_v4_requ_basic_delete=>ty_s_todo_process_list,
      lt_bapi_return       type table of bapiret2,
      lo_message_container type ref to /iwbep/if_v4_message_container.



    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    " read the key data
    io_request->get_key_data( importing es_key_data = ls_key_salesorder ).
    ls_done_list-key_data = abap_true.

    ls_so_id-so_id = ls_key_salesorder-salesorder.

    " Delete data
    call function 'BAPI_EPM_SO_DELETE'
      exporting
        so_id  = ls_so_id
      tables
        return = lt_bapi_return.

    " Error handling
    if lt_bapi_return is not initial.
      lo_message_container = io_response->get_message_container( ).

      loop at lt_bapi_return into data(ls_bapi_return).
        lo_message_container->add_t100(
          exporting
            iv_msg_type                 =     ls_bapi_return-type
            iv_msg_id                   =     ls_bapi_return-id
            iv_msg_number               =     ls_bapi_return-number
            iv_msg_v1                   =     ls_bapi_return-message_v1
            iv_msg_v2                   =     ls_bapi_return-message_v2
            iv_msg_v3                   =     ls_bapi_return-message_v3
            iv_msg_v4                   =     ls_bapi_return-message_v4 ).
      endloop.

      "custom exception
      raise exception type zcx_e2e001_odata_v4_so
        exporting
          message_container = lo_message_container.

    endif.

    io_response->set_is_done( ls_done_list ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->DELETE_SALESORDERITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_DELETE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_DELETE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method delete_salesorderitem.

    "entity type specific data types
    data: ls_salesorderitem         type gty_cds_views-salesorderitem,
          ls_key_salesorderitem     type gty_cds_views-salesorderitem,
          ls_itemdatax              type bapi_epm_so_itemx,
          lt_itemdatax              type standard table of bapi_epm_so_itemx,
          ls_itemdata               type bapi_epm_so_item,
          lt_itemdata               type standard table of bapi_epm_so_item,
          ls_so_id                  type snwd_so_id,
          ls_so_item                type snwd_so_item_pos,
          ls_salesorder_rfc_key     type bapi_epm_so_id,
          lv_key_edm_salesorderitem type string,
          lv_helper_int             type i.



    "generic data types
    data:
      ls_todo_list         type /iwbep/if_v4_requ_basic_delete=>ty_s_todo_list,
      ls_done_list         type /iwbep/if_v4_requ_basic_delete=>ty_s_todo_process_list,
      lt_bapi_return       type table of bapiret2,
      lo_message_container type ref to /iwbep/if_v4_message_container.



    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    " read the key data
    io_request->get_key_data( importing es_key_data = ls_key_salesorderitem ).
    ls_done_list-key_data = abap_true.

    ls_so_id = ls_key_salesorderitem-salesorder.
    ls_so_item = ls_key_salesorderitem-salesorderitem.
    ls_salesorder_rfc_key-so_id =   ls_key_salesorderitem-salesorder.

    select single * from ze2e001_c_salesorderitem
    into corresponding fields of @ls_salesorderitem
    where salesorder = @ls_key_salesorderitem-salesorder
    and  salesorderitem = @ls_key_salesorderitem-salesorderitem.

    if ls_salesorderitem is  initial.
      "Move data first to an integer to remove leading zeros from the response
      lv_key_edm_salesorderitem = lv_helper_int = ls_key_salesorderitem-salesorder.
      lv_key_edm_salesorderitem = lv_key_edm_salesorderitem && ','.
      lv_helper_int = ls_key_salesorderitem-salesorderitem.
      lv_key_edm_salesorderitem = lv_key_edm_salesorderitem && lv_helper_int.

      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid              = zcx_e2e001_odata_v4_so=>entity_not_found
          http_status_code    = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-not_found
          edm_entity_set_name = gcs_entity_set_names-edm-salesorderitem
          entity_key          = lv_key_edm_salesorderitem.
    else.

      ls_itemdata-so_id = ls_salesorderitem-salesorder.
      ls_itemdata-so_item_pos = ls_salesorderitem-salesorderitem.
      ls_itemdata-product_id = ls_salesorderitem-product.
      ls_itemdata-delivery_date = ls_salesorderitem-deliverydatetime.
      append ls_itemdata to lt_itemdata.

      "lt_itemdata[ 1 ] = ls_salesorderitem.

      ls_itemdatax-so_id = ls_salesorderitem-salesorder.
      ls_itemdatax-so_item_pos = ls_salesorderitem-salesorderitem.
      ls_itemdatax-product_id = ls_salesorderitem-product.
      ls_itemdatax-delivery_date = ls_salesorderitem-deliverydatetime.
      ls_itemdatax-actioncode = 'D'.
      append ls_itemdatax to lt_itemdatax.

      " Delete data
      call function 'BAPI_EPM_SO_CHANGE'
        exporting
          so_id       = ls_salesorder_rfc_key
        tables
          soitemdata  = lt_itemdata
          soitemdatax = lt_itemdatax
          return      = lt_bapi_return.

      " Error handling
      if lt_bapi_return is not initial.
        lo_message_container = io_response->get_message_container( ).

        loop at lt_bapi_return into data(ls_bapi_return).
          lo_message_container->add_t100(
            exporting
              iv_msg_type                 =     ls_bapi_return-type
              iv_msg_id                   =     ls_bapi_return-id
              iv_msg_number               =     ls_bapi_return-number
              iv_msg_v1                   =     ls_bapi_return-message_v1
              iv_msg_v2                   =     ls_bapi_return-message_v2
              iv_msg_v3                   =     ls_bapi_return-message_v3
              iv_msg_v4                   =     ls_bapi_return-message_v4 ).
        endloop.

        " @TODO custom exception
        raise exception type /iwbep/cx_v4_tea
          exporting
            message_container = lo_message_container.

      endif.

      io_response->set_is_done( ls_done_list ).
    endif.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->READ_ENTITY_SALESORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_READ
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_READ
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method read_entity_salesorder.

    "entity type specific data types
    data: ls_salesorder         type gty_cds_views-salesorder,
          ls_key_salesorder     type gty_cds_views-salesorder,
          lv_salesorder_key_edm type string,
          lv_helper_int         type i.
    "generic data types
    data: ls_todo_list type /iwbep/if_v4_requ_basic_read=>ty_s_todo_list,
          ls_done_list type /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    " read the key data
    io_request->get_key_data( importing es_key_data = ls_key_salesorder ).
    ls_done_list-key_data = abap_true.

    select single * from ze2e001_c_salesorder
    into corresponding fields of @ls_salesorder
    where salesorder = @ls_key_salesorder-salesorder.

    if ls_salesorder is not initial.
      io_response->set_busi_data( is_busi_data = ls_salesorder ).
    else.
      "Move data first to an integer to remove leading zeros from the response
      lv_salesorder_key_edm = lv_helper_int = ls_key_salesorder-salesorder.

      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid              = zcx_e2e001_odata_v4_so=>entity_not_found
          http_status_code    = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-not_found
          edm_entity_set_name = gcs_entity_set_names-edm-salesorder
          entity_key          = lv_salesorder_key_edm.

    endif.

    " Report list of request options handled by application
    io_response->set_is_done( ls_done_list ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->READ_ENTITY_SALESORDERITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_READ
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_READ
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method read_entity_salesorderitem.
    "entity type specific data types
    data: ls_salesorderitem         type gty_cds_views-salesorderitem,
          ls_key_salesorderitem     type gty_cds_views-salesorderitem,
          lv_key_edm_salesorderitem type string,
          lv_helper_int             type i.
    "generic data types
    data: ls_todo_list type /iwbep/if_v4_requ_basic_read=>ty_s_todo_list,
          ls_done_list type /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    " read the key data
    io_request->get_key_data( importing es_key_data = ls_key_salesorderitem ).
    ls_done_list-key_data = abap_true.

    select single * from ze2e001_c_salesorderitem
    into corresponding fields of @ls_salesorderitem
    where salesorder = @ls_key_salesorderitem-salesorder
    and  salesorderitem = @ls_key_salesorderitem-salesorderitem.

    if ls_salesorderitem is not initial.
      io_response->set_busi_data( is_busi_data = ls_salesorderitem ).
    else.
      "Move data first to an integer to remove leading zeros from the response
      lv_key_edm_salesorderitem = lv_helper_int = ls_key_salesorderitem-salesorder.
      lv_key_edm_salesorderitem = lv_key_edm_salesorderitem && ','.
      lv_helper_int = ls_key_salesorderitem-salesorderitem.
      lv_key_edm_salesorderitem = lv_key_edm_salesorderitem && lv_helper_int.

      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid              = zcx_e2e001_odata_v4_so=>entity_not_found
          http_status_code    = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-not_found
          edm_entity_set_name = gcs_entity_set_names-edm-salesorderitem
          entity_key          = lv_key_edm_salesorderitem.

    endif.

    " Report list of request options handled by application
    io_response->set_is_done( ls_done_list ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->READ_LIST_SALESORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_LIST
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_LIST
* | [--->] IV_ORDERBY_STRING              TYPE        STRING
* | [--->] IV_WHERE_CLAUSE                TYPE        STRING
* | [--->] IV_SELECT_STRING               TYPE        STRING
* | [--->] IV_SKIP                        TYPE        I
* | [--->] IV_TOP                         TYPE        I
* | [--->] IS_DONE_LIST                   TYPE        /IWBEP/IF_V4_REQU_BASIC_LIST=>TY_S_TODO_PROCESS_LIST
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method read_list_salesorder.

    "entity type specific data types
    data : lt_key_range_salesorder type zif_e2e001_odata_v4_so_types=>gt_key_range-salesorder,
           ls_key_range_salesorder type line of zif_e2e001_odata_v4_so_types=>gt_key_range-salesorder,
           lt_salesorder           type standard table of gty_cds_views-salesorder,
           lt_key_salesorder       type standard table of gty_cds_views-salesorder.

    "generic data types
    data: ls_todo_list type /iwbep/if_v4_requ_basic_list=>ty_s_todo_list,
          ls_done_list type /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list,
          lv_count     type i,
          lv_max_index type i.

    " Get the request options the application should/must handle
    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    " Get the request options the application has already handled
    ls_done_list = is_done_list.

    " specific sales orders based on navigation?
    if ls_todo_list-process-key_data = abap_true.
      io_request->get_key_data( importing et_key_data = lt_key_salesorder ).
      loop at lt_key_salesorder into data(ls_key_entity).
        append value #( sign = 'I' option = 'EQ' low = ls_key_entity-salesorder ) to lt_key_range_salesorder.
      endloop.
      ls_done_list-key_data = abap_true.
    endif.

    "================================================================
    " read_list must either be called with a filter or via navigation
    " or $top has to be used to avoid a full table scan
    if  ls_todo_list-process-filter = abap_false
    and ls_todo_list-process-key_data = abap_false
    and iv_top = 0.
      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid              = zcx_e2e001_odata_v4_so=>use_filter_top_or_nav
          http_status_code    = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
          edm_entity_set_name = gcs_entity_set_names-edm-salesorder.
    endif.

    " Return business data if requested
    if ls_todo_list-return-busi_data = abap_true.

      " read data from the CDS view
      "value for max_index must only be calculated if the request also contains a $top
      if iv_top is not initial.
        lv_max_index = iv_top + iv_skip.
      else.
        lv_max_index = 0.
      endif.

      select (iv_select_string) from ze2e001_c_salesorder
      where (iv_where_clause)
      and   salesorder in @lt_key_range_salesorder
      order by (iv_orderby_string)
      into corresponding fields of table @lt_salesorder
      up to @lv_max_index rows.

      "skipping entries specified by $skip
      "not needed as of NW751 where OFFSET is supported in Open SQL
      if iv_skip is not initial.
        delete lt_salesorder to iv_skip.
      endif.

*      "OFFSET is only supported as of NW751
*      SELECT (iv_select_string) FROM ze2e001_c_salesorder
*      WHERE (iv_where_clause)
*      AND   salesorder IN @lt_salesorder_key_range
*      ORDER BY (iv_orderby_string)
*      INTO CORRESPONDING FIELDS OF TABLE @lt_entity
*      UP TO @iv_top ROWS
*      OFFSET @iv_skip.

      io_response->set_busi_data( it_busi_data = lt_salesorder ).

    else.
      "if business data is requested count will be calculated by
      "the framework
      if ls_todo_list-return-count = abap_true.

        select count( * ) from ze2e001_c_salesorder
            where (iv_where_clause) and
           salesorder in @lt_key_range_salesorder
            into @lv_count.

        io_response->set_count( lv_count ).
      endif.
    endif.

    " Report list of request options handled by application
    io_response->set_is_done( ls_done_list ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->READ_LIST_SALESORDERITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_LIST
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_LIST
* | [--->] IV_ORDERBY_STRING              TYPE        STRING
* | [--->] IV_WHERE_CLAUSE                TYPE        STRING
* | [--->] IV_SELECT_STRING               TYPE        STRING
* | [--->] IV_SKIP                        TYPE        I
* | [--->] IV_TOP                         TYPE        I
* | [--->] IS_DONE_LIST                   TYPE        /IWBEP/IF_V4_REQU_BASIC_LIST=>TY_S_TODO_PROCESS_LIST
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method read_list_salesorderitem.

    "entity type specific data types
    data : lt_key_range_salesorder     type zif_e2e001_odata_v4_so_types=>gt_key_range-salesorder,
           ls_key_range_salesorder     type line of zif_e2e001_odata_v4_so_types=>gt_key_range-salesorder,
           lt_key_range_salesorderitem type zif_e2e001_odata_v4_so_types=>gt_key_range-itemposition,
           ls_key_range_salesorderitem type line of zif_e2e001_odata_v4_so_types=>gt_key_range-itemposition,
           lt_salesorderitem           type standard table of gty_cds_views-salesorderitem,
           lt_key_salesorderitem       type standard table of gty_cds_views-salesorderitem.

    "generic data types
    data: ls_todo_list type /iwbep/if_v4_requ_basic_list=>ty_s_todo_list,
          ls_done_list type /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list,
          lv_count     type i,
          lv_max_index type i.

    " Get the request options the application should/must handle
    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    " Get the request options the application has already handled
    ls_done_list = is_done_list.

    " specific sales orders based on navigation?
    if ls_todo_list-process-key_data = abap_true.
      io_request->get_key_data( importing et_key_data = lt_key_salesorderitem ).
      loop at lt_key_salesorderitem into data(ls_key_entity).
        append value #( sign = 'I' option = 'EQ' low = ls_key_entity-salesorder ) to lt_key_range_salesorder.
        append value #( sign = 'I' option = 'EQ' low = ls_key_entity-salesorderitem ) to lt_key_range_salesorderitem.
      endloop.

      "the first key field (salesoder) is always the same
      delete adjacent duplicates from lt_key_range_salesorder.
      ls_done_list-key_data = abap_true.
    endif.


    "================================================================
    " read_list must either be called with a filter or via navigation
    " or $top has to be used to avoid a full table scan
    if  ls_todo_list-process-filter = abap_false
    and ls_todo_list-process-key_data = abap_false
    and iv_top = 0.
      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid              = zcx_e2e001_odata_v4_so=>use_filter_top_or_nav
          http_status_code    = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
          edm_entity_set_name = gcs_entity_set_names-edm-salesorder.
    endif.

    " Return business data if requested
    if ls_todo_list-return-busi_data = abap_true.

      " read data from the CDS view

*      "OFFSET is only supported as of NW751
*      SELECT (iv_select_string) FROM ze2e001_c_salesorder
*      WHERE (iv_where_clause)
*      AND   salesorder IN @lt_salesorder_key_range
*      ORDER BY (iv_orderby_string)
*      INTO CORRESPONDING FIELDS OF TABLE @lt_entity
*      UP TO @iv_top ROWS
*      OFFSET @iv_skip.

      "value for max_index must only be calculated if the request also contains a $top
      if iv_top is not initial.
        lv_max_index = iv_top + iv_skip.
      else.
        lv_max_index = 0.
      endif.

      select (iv_select_string) from ze2e001_c_salesorderitem
      where (iv_where_clause)
      and   salesorder in @lt_key_range_salesorder
      and   salesorderitem in @lt_key_range_salesorderitem
      order by (iv_orderby_string)
      into corresponding fields of table @lt_salesorderitem
      up to @lv_max_index rows.

      "skipping entries specified by $skip
      "not needed as of NW751 where OFFSET is supported in Open SQL
      if iv_skip is not initial.
        delete lt_salesorderitem to iv_skip.
      endif.

      io_response->set_busi_data( it_busi_data = lt_salesorderitem ).

    else.
      "if business data is requested count will be calculated by
      "the framework
      if ls_todo_list-return-count = abap_true.

        select count( * ) from ze2e001_c_salesorderitem
            where (iv_where_clause)
            and   salesorder in @lt_key_range_salesorder
            and   salesorderitem in @lt_key_range_salesorderitem
            into @lv_count.

        io_response->set_count( lv_count ).
      endif.
    endif.

    " Report list of request options handled by application
    io_response->set_is_done( ls_done_list ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->READ_REF_KEY_LIST_SALESORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_REF_L
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_REF_L
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method read_ref_key_list_salesorder.

    "entity type specific data types
    data: ls_salesorder_key_data     type  gty_cds_views-salesorder,
          lt_salesorderitem_key_data type standard table of gty_cds_views-salesorderitem,
          ls_todo_list               type /iwbep/if_v4_requ_basic_ref_l=>ty_s_todo_list.
    "generic data types
    data: ls_done_list         type /iwbep/if_v4_requ_basic_ref_l=>ty_s_todo_process_list,
          lv_nav_property_name type /iwbep/if_v4_med_element=>ty_e_med_internal_name.

    " Get the request options the application should/must handle
    io_request->get_todos( importing es_todo_list = ls_todo_list ).

    if ls_todo_list-process-source_key_data = abap_true.
      io_request->get_source_key_data( importing es_source_key_data =  ls_salesorder_key_data ).
      ls_done_list-source_key_data = abap_true.
    endif.

    io_request->get_navigation_prop( importing ev_navigation_prop_name = lv_nav_property_name ).

    case lv_nav_property_name.
      when gcs_nav_prop_names-internal-salesorder_to_items.

        select salesorder , salesorderitem from ze2e001_c_salesorderitem
        into corresponding fields of table @lt_salesorderitem_key_data
        where salesorder = @ls_salesorder_key_data-salesorder.

        io_response->set_target_key_data( lt_salesorderitem_key_data ).

      when others.

        raise exception type zcx_e2e001_odata_v4_so
          exporting
            http_status_code = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-sv_not_implemented.

    endcase.

    " Report list of request options handled by application
    io_response->set_is_done( ls_done_list ).


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->UPDATE_SALESORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_UPDATE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_UPDATE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method update_salesorder.

    "entity type specific data types
    data: ls_salesorder         type gty_cds_views-salesorder,
          ls_key_salesorder     type gty_cds_views-salesorder,
          ls_salesorder_rfc     type bapi_epm_so_header,
          ls_salesorder_x_rfc   type bapi_epm_so_headerx,
          ls_salesorder_rfc_key type bapi_epm_so_id,
          lv_salesorder_key_edm type string,
          lv_helper_int         type i.
    "generic data types
    data: ls_todo_list         type /iwbep/if_v4_requ_basic_update=>ty_s_todo_list,
          ls_done_list         type /iwbep/if_v4_requ_basic_update=>ty_s_todo_process_list,
          lt_bapi_return       type table of bapiret2,
          lo_message_container type ref to /iwbep/if_v4_message_container.

    io_request->get_todos( importing es_todo_list = ls_todo_list ).
    if ls_todo_list-process-busi_data = abap_true.
      io_request->get_busi_data( importing es_busi_data = ls_salesorder ).
      ls_done_list-busi_data = abap_true. "business data processed
    endif.

    " Read the key data
    io_request->get_key_data( importing es_key_data = ls_key_salesorder ).
    ls_done_list-key_data = abap_true.


    "check if key data matches key data provided in the payload
    "only needed if update instead of patch is used

    if ls_salesorder-salesorder <> ls_key_salesorder-salesorder and
    ls_todo_list-process-partial_busi_data = abap_false.

      "Move data first to an integer to remove leading zeros from the response
      lv_salesorder_key_edm = lv_helper_int = ls_key_salesorder-salesorder.

      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid           = zcx_e2e001_odata_v4_so=>entity_keys_do_not_match
          http_status_code = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
          entity_key       = lv_salesorder_key_edm.
    endif.

    " Update single entity using classic API.

    " fill structure for header data
    ls_salesorder_rfc-so_id = ls_key_salesorder-salesorder.
    ls_salesorder_rfc-buyer_id = ls_salesorder-customer.
    ls_salesorder_rfc-currency_code  = ls_salesorder-transactioncurrency.
    " @TODO Sales order description is not yet a property of the CDS view

    " Map constant values to function module parameters
    ls_salesorder_x_rfc-so_id = ls_key_salesorder-salesorder.
    ls_salesorder_x_rfc-buyer_id = 'X'.
    ls_salesorder_x_rfc-currency_code  = 'X'.
    " @TODO Sales order description is not yet a property of the CDS view

    ls_salesorder_rfc_key-so_id = ls_key_salesorder-salesorder.

* update data

    call function 'BAPI_EPM_SO_CHANGE'
      exporting
        so_id         = ls_salesorder_rfc_key
        soheaderdata  = ls_salesorder_rfc
        soheaderdatax = ls_salesorder_x_rfc
      tables
        return        = lt_bapi_return.

    " Error handling
    if lt_bapi_return is not initial.
      lo_message_container = io_response->get_message_container( ).

      loop at lt_bapi_return into data(ls_bapi_return).
        lo_message_container->add_t100(
          exporting
            iv_msg_type                 =     ls_bapi_return-type
            iv_msg_id                   =     ls_bapi_return-id
            iv_msg_number               =     ls_bapi_return-number
            iv_msg_v1                   =     ls_bapi_return-message_v1
            iv_msg_v2                   =     ls_bapi_return-message_v2
            iv_msg_v3                   =     ls_bapi_return-message_v3
            iv_msg_v4                   =     ls_bapi_return-message_v4 ).
      endloop.

      raise exception type zcx_e2e001_odata_v4_so
        exporting
          message_container = lo_message_container.

    endif.

    " In OData V4 an update request has to return data by default unless specified otherwise using
    " the http header ...
    if ls_todo_list-return-busi_data = abap_true.
      "   Read data again and set the response.
      select single * from ze2e001_c_salesorder
      into corresponding fields of @ls_salesorder
      where salesorder = @ls_salesorder_rfc_key-so_id.
      io_response->set_busi_data( ls_salesorder ).
    endif.
    io_response->set_is_done( ls_done_list ).



  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_DATA->UPDATE_SALESORDERITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_REQUEST                     TYPE REF TO /IWBEP/IF_V4_REQU_BASIC_UPDATE
* | [--->] IO_RESPONSE                    TYPE REF TO /IWBEP/IF_V4_RESP_BASIC_UPDATE
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method update_salesorderitem.

    "entity type specific data types
    data: ls_salesorderitem         type gty_cds_views-salesorderitem,
          ls_key_salesorderitem     type gty_cds_views-salesorderitem,
          ls_salesorderitem_rfc     type bapi_epm_so_item,
          ls_salesorderitem_x_rfc   type bapi_epm_so_itemx,
          lt_salesorderitem_rfc     type standard table of bapi_epm_so_item,
          lt_salesorderitem_x_rfc   type standard table of bapi_epm_so_itemx,
          ls_salesorder_rfc_key     type bapi_epm_so_id,
          lv_salesorderitem_key_edm type string,
          lv_helper_int             type i,
          lv_names_of_missing_props type string.

    "generic data types
    data: ls_todo_list         type /iwbep/if_v4_requ_basic_update=>ty_s_todo_list,
          ls_done_list         type /iwbep/if_v4_requ_basic_update=>ty_s_todo_process_list,
          lt_bapi_return       type table of bapiret2,
          ls_bapi_return       type bapiret2,
          lo_message_container type ref to /iwbep/if_v4_message_container.

    io_request->get_todos( importing es_todo_list = ls_todo_list ).
    if ls_todo_list-process-busi_data = abap_true.
      io_request->get_busi_data( importing es_busi_data = ls_salesorderitem ).
      ls_done_list-busi_data = abap_true. "business data processed
    endif.

    " Read the key data
    io_request->get_key_data( importing es_key_data = ls_key_salesorderitem ).
    ls_done_list-key_data = abap_true.


    "check if key data matches key data provided in the payload
    "only needed if update instead of patch is used

    if ( ls_salesorderitem-salesorder <> ls_key_salesorderitem-salesorder or
         ls_salesorderitem-salesorderitem <> ls_key_salesorderitem-salesorderitem ) and
         ls_todo_list-process-partial_busi_data = abap_false.

      "Move data first to an integer to remove leading zeros from the response
      lv_salesorderitem_key_edm = lv_helper_int = ls_key_salesorderitem-salesorder.
      lv_helper_int = ls_key_salesorderitem-salesorderitem.
      lv_salesorderitem_key_edm = lv_salesorderitem_key_edm && lv_helper_int.

      raise exception type zcx_e2e001_odata_v4_so
        exporting
          textid           = zcx_e2e001_odata_v4_so=>entity_keys_do_not_match
          http_status_code = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
          entity_key       = lv_salesorderitem_key_edm.
    endif.

    if ls_todo_list-process-partial_busi_data = abap_true.
      "check if the mandatory properties have been provided
      "do not check for properties that are not mandatory
      "@todo: These could be annotated as Core.Computed

      if ls_salesorderitem-salesorder is initial or
      ls_salesorderitem-product is initial or
      ls_salesorderitem-deliverydatetime is initial.

        lv_names_of_missing_props = 'Salesorder or Product or DeveliveryDateTime'.
        raise exception type zcx_e2e001_odata_v4_so
          exporting
            textid                 = zcx_e2e001_odata_v4_so=>missing_properties
            http_status_code       = zcx_e2e001_odata_v4_so=>gcs_http_status_codes-bad_request
            edm_entity_set_name    = gcs_entity_set_names-edm-salesorderitem
            names_of_missing_props = lv_names_of_missing_props.

      else.
        "the mandatory properties have been provided
        ls_done_list-partial_busi_data = abap_true.
      endif.

    endif.

    ls_salesorder_rfc_key-so_id =   ls_key_salesorderitem-salesorder.


    " fill structure for header data
    ls_salesorderitem_rfc-so_id = ls_key_salesorderitem-salesorder.
    ls_salesorderitem_rfc-so_item_pos = ls_salesorderitem-salesorderitem.
    ls_salesorderitem_rfc-product_id = ls_salesorderitem-product.
    ls_salesorderitem_rfc-delivery_date = ls_salesorderitem-deliverydatetime.

    " @TODO Sales order description is not yet a property of the CDS view
    ls_salesorderitem_rfc-quantity = ls_salesorderitem-quantity.
    ls_salesorderitem_rfc-quantity_unit = ls_salesorderitem-unit.

    " Map key values to x-bapi-structure
    ls_salesorderitem_x_rfc-so_id = ls_key_salesorderitem-salesorder.
    ls_salesorderitem_x_rfc-so_item_pos = ls_salesorderitem-salesorderitem.
    ls_salesorderitem_x_rfc-product_id = ls_salesorderitem-product.
    ls_salesorderitem_x_rfc-delivery_date = ls_salesorderitem-deliverydatetime.

    " Map constant values to function module parameters
    " @TODO Sales order description is not yet a property of the CDS view
    ls_salesorderitem_x_rfc-quantity = abap_true.
    ls_salesorderitem_x_rfc-quantity_unit = abap_true.

    "Specify that this is an update operation 'U'
    ls_salesorderitem_x_rfc-actioncode = 'U'.

    append ls_salesorderitem_rfc to lt_salesorderitem_rfc.
    append ls_salesorderitem_x_rfc to lt_salesorderitem_x_rfc.

* update data

    call function 'BAPI_EPM_SO_CHANGE'
      exporting
        so_id       = ls_salesorder_rfc_key
      tables
        soitemdata  = lt_salesorderitem_rfc
        soitemdatax = lt_salesorderitem_x_rfc
        return      = lt_bapi_return.
    " Error handling
    if lt_bapi_return is not initial.
      "check if an error message is in lt_bapi_return
      loop at lt_bapi_return into ls_bapi_return.
        if ls_bapi_return-type = 'E'.

          lo_message_container = io_response->get_message_container( ).

          loop at lt_bapi_return into ls_bapi_return.
            lo_message_container->add_t100(
              exporting
                iv_msg_type                 =     ls_bapi_return-type
                iv_msg_id                   =     ls_bapi_return-id
                iv_msg_number               =     ls_bapi_return-number
                iv_msg_v1                   =     ls_bapi_return-message_v1
                iv_msg_v2                   =     ls_bapi_return-message_v2
                iv_msg_v3                   =     ls_bapi_return-message_v3
                iv_msg_v4                   =     ls_bapi_return-message_v4 ).
          endloop.

          raise exception type zcx_e2e001_odata_v4_so
            exporting
              message_container = lo_message_container.

        endif.
      endloop.

    else.

      ls_salesorderitem_rfc = lt_salesorderitem_rfc[ 1 ].

    endif.



    if ls_todo_list-return-busi_data = abap_true.
      "   Read data again and set the response.
      clear ls_salesorderitem.

      select single * from ze2e001_c_salesorderitem
      where salesorder = @ls_key_salesorderitem-salesorder and
            salesorderitem = @ls_key_salesorderitem-salesorderitem
      into corresponding fields of @ls_salesorderitem.

      io_response->set_busi_data( ls_salesorderitem ).

    endif.
    io_response->set_is_done( ls_done_list ).





  endmethod.
ENDCLASS.
