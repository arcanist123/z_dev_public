interface zif_e2e001_odata_v4_so_types
  public .
  types:
    begin of gty_cds_views,
      salesorderitem type ze2e001_c_salesorderitem,
      salesorder     type ze2e001_c_salesorder,
    end of gty_cds_views.

  types: begin of gty_s_so_soi .
      include type gty_cds_views-salesorder.
  types:
    _item type standard table of gty_cds_views-salesorderitem with default key,
    end of gty_s_so_soi .

  types:
    begin of gt_key_range,
      salesorder   type range of gty_cds_views-salesorder-salesorder,
      itemposition type range of gty_cds_views-salesorderitem-salesorderitem,
    end of gt_key_range.

  constants:

    begin of gcs_cds_view_names,
      salesorderitem type /iwbep/if_v4_med_element=>ty_e_med_internal_name value 'SEPM_ODATA_C_SALESORDERITEM',
      salesorder     type /iwbep/if_v4_med_element=>ty_e_med_internal_name value 'SEPM_ODATA_C_SALESORDER',
    end of gcs_cds_view_names,

    begin of gcs_entity_type_names,
      begin of internal,
        salesorderitem type /iwbep/if_v4_med_element=>ty_e_med_internal_name value 'SEPM_ODATA_C_SALESORDERITEM',
        salesorder     type /iwbep/if_v4_med_element=>ty_e_med_internal_name value 'SEPM_ODATA_C_SALESORDER',
      end of internal,
      begin of edm,
        salesorderitem type /iwbep/if_v4_med_element=>ty_e_med_edm_name value 'SalesOrderItemType',
        salesorder     type /iwbep/if_v4_med_element=>ty_e_med_edm_name value 'SalesOrderType',
      end of edm,
    end of gcs_entity_type_names,

    begin of gcs_entity_set_names,
      begin of internal,
        salesorderitem type /iwbep/if_v4_med_element=>ty_e_med_internal_name value 'SEPM_ODATA_C_SALESORDERITEM',
        salesorder     type /iwbep/if_v4_med_element=>ty_e_med_internal_name value 'SEPM_ODATA_C_SALESORDER',
      end of internal,
      begin of edm,
        salesorderitem type /iwbep/if_v4_med_element=>ty_e_med_edm_name value 'SalesOrderItem',
        salesorder     type /iwbep/if_v4_med_element=>ty_e_med_edm_name value 'SalesOrder',
      end of edm,
    end of gcs_entity_set_names ,

    begin of gcs_nav_prop_names,
      begin of internal,
        salesorder_to_items type /iwbep/if_v4_med_element=>ty_e_med_internal_name value '_ITEM',
      end of internal,
      begin of edm,
        salesorder_to_items type /iwbep/if_v4_med_element=>ty_e_med_edm_name value '_Item',
      end of edm,
    end of gcs_nav_prop_names,

    begin of gcs_expand_expressions,
      "BEGIN OF internal,
      salesorder_with_items type /iwbep/if_v4_runtime_types=>ty_expand_expression value '_ITEM',
      "END OF internal,
      "BEGIN OF edm,

    end of gcs_expand_expressions .


endinterface.
