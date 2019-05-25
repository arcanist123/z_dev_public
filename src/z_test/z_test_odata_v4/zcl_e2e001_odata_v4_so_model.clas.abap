class zcl_e2e001_odata_v4_so_model definition
  public
  inheriting from /iwbep/cl_v4_abs_model_prov
  final
  create public .

  public section.
    interfaces zif_e2e001_odata_v4_so_types.

    methods /iwbep/if_v4_mp_basic~define redefinition.
  protected section.
  private section.

    aliases gty_cds_views
      for zif_e2e001_odata_v4_so_types~gty_cds_views.
    aliases gcs_entity_set_names
      for zif_e2e001_odata_v4_so_types~gcs_entity_set_names .
    aliases gcs_entity_type_names
      for zif_e2e001_odata_v4_so_types~gcs_entity_type_names .
    aliases gcs_nav_prop_names
      for zif_e2e001_odata_v4_so_types~gcs_nav_prop_names.

    methods define_salesorder
      importing
        io_model type ref to /iwbep/if_v4_med_model
      raising
        /iwbep/cx_gateway .
    methods define_salesorderitem
      importing
        io_model type ref to /iwbep/if_v4_med_model
      raising
        /iwbep/cx_gateway .
ENDCLASS.



CLASS ZCL_E2E001_ODATA_V4_SO_MODEL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_E2E001_ODATA_V4_SO_MODEL->/IWBEP/IF_V4_MP_BASIC~DEFINE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_MODEL                       TYPE REF TO /IWBEP/IF_V4_MED_MODEL
* | [--->] IO_MODEL_INFO                  TYPE REF TO /IWBEP/IF_V4_MODEL_INFO
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /iwbep/if_v4_mp_basic~define.
    define_salesorder( io_model ).
    define_salesorderitem( io_model ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_MODEL->DEFINE_SALESORDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_MODEL                       TYPE REF TO /IWBEP/IF_V4_MED_MODEL
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method define_salesorder.
    data: lt_primitive_properties type /iwbep/if_v4_med_element=>ty_t_med_prim_property,
          lo_entity_set           type ref to /iwbep/if_v4_med_entity_set,
          lo_nav_prop             type ref to /iwbep/if_v4_med_nav_prop,
          lo_entity_type          type ref to /iwbep/if_v4_med_entity_type,
          lv_referenced_cds_view  type gty_cds_views-salesorder  . " As internal ABAP name we use the name of the CDS view


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "   Create entity type
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_type = io_model->create_entity_type_by_struct(
                      exporting
                        iv_entity_type_name          = gcs_entity_type_names-internal-salesorder
                        is_structure                 = lv_referenced_cds_view
                        iv_add_conv_to_prim_props    = abap_true
                        iv_add_f4_help_to_prim_props = abap_true
                        iv_gen_prim_props            = abap_true ).

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Set external EDM name for entity type
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_type->set_edm_name( gcs_entity_type_names-edm-salesorder ).



    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Rename external EDM names of properties so that CamelCase notation is used
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_type->get_primitive_properties( importing et_property = lt_primitive_properties ).

    loop at lt_primitive_properties into data(lo_primitive_property).
      lo_primitive_property->set_edm_name( to_mixed( val = lo_primitive_property->get_internal_name( ) ) ).
    endloop.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Set key field(s)
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_primitive_property = lo_entity_type->get_primitive_property( 'SALESORDER' ).
    lo_primitive_property->set_is_key( ).


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "   Create navigation property
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_nav_prop = lo_entity_type->create_navigation_property( gcs_nav_prop_names-internal-salesorder_to_items ).
    lo_nav_prop->set_edm_name( gcs_nav_prop_names-edm-salesorder_to_items ).

    lo_nav_prop->set_target_entity_type_name( gcs_entity_type_names-internal-salesorderitem ).
    lo_nav_prop->set_target_multiplicity( /iwbep/if_v4_med_element=>gcs_med_nav_multiplicity-to_many_optional ).
    lo_nav_prop->set_on_delete_action( /iwbep/if_v4_med_element=>gcs_med_on_delete_action-none ).


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "   Create entity set
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_set = lo_entity_type->create_entity_set( gcs_entity_set_names-internal-salesorder ).
    lo_entity_set->set_edm_name( gcs_entity_set_names-edm-salesorder ).

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Add the binding of the navigation path
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_set->add_navigation_prop_binding( iv_navigation_property_path = conv #( gcs_nav_prop_names-internal-salesorder_to_items )
                                                iv_target_entity_set        = gcs_entity_set_names-internal-salesorderitem ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_E2E001_ODATA_V4_SO_MODEL->DEFINE_SALESORDERITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_MODEL                       TYPE REF TO /IWBEP/IF_V4_MED_MODEL
* | [!CX!] /IWBEP/CX_GATEWAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method define_salesorderitem.
    data: lo_entity_type          type ref to /iwbep/if_v4_med_entity_type,
          lo_entity_set           type ref to /iwbep/if_v4_med_entity_set,
          lt_primitive_properties type /iwbep/if_v4_med_element=>ty_t_med_prim_property,
          lv_referenced_cds_view  type gty_cds_views-salesorderitem  . " As internal ABAP name we use the name of the CDS view


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Create entity type
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_type = io_model->create_entity_type_by_struct(
                      exporting
                        iv_entity_type_name          = gcs_entity_type_names-internal-salesorderitem
                        is_structure                 = lv_referenced_cds_view
                        iv_add_conv_to_prim_props    = abap_true
                        iv_add_f4_help_to_prim_props = abap_true
                        iv_gen_prim_props            = abap_true ).

    lo_entity_type->set_edm_name( gcs_entity_type_names-edm-salesorderitem ).


    lo_entity_type->get_primitive_properties( importing et_property = lt_primitive_properties ).

    loop at lt_primitive_properties into data(lo_primitive_property).
      lo_primitive_property->set_edm_name( to_mixed( val = lo_primitive_property->get_internal_name( ) ) ).
    endloop.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Set key field(s)
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_primitive_property = lo_entity_type->get_primitive_property( 'SALESORDER' ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SALESORDERITEM'  ).
    lo_primitive_property->set_is_key( ).


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "   Create entity set
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_set = lo_entity_type->create_entity_set( gcs_entity_set_names-internal-salesorderitem ).
    lo_entity_set->set_edm_name( gcs_entity_set_names-edm-salesorderitem ).

  endmethod.
ENDCLASS.
