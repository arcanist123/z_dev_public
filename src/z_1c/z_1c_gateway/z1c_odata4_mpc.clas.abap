CLASS z1c_odata4_mpc DEFINITION
  PUBLIC
    INHERITING FROM /iwbep/cl_v4_abs_model_prov
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_data,
        file_name TYPE string,
        file_data TYPE string,
      END OF t_data.
    CONSTANTS:
      BEGIN OF gc_entities,
        BEGIN OF file_data,
          internal_name TYPE /iwbep/if_v4_med_types=>ty_e_med_internal_name VALUE 'FILE_DATA',
          external_name TYPE /iwbep/if_v4_med_types=>ty_e_med_edm_name VALUE 'FILE_DATA_EXT',
        END OF file_data,
      END OF gc_entities.
    CONSTANTS:
      BEGIN OF gc_entity_sets,
        BEGIN OF file_data_set,
          internal_name TYPE /iwbep/if_v4_med_types=>ty_e_med_internal_name VALUE 'FILE_DATA_SET',
          external_name TYPE /iwbep/if_v4_med_types=>ty_e_med_edm_name VALUE 'FILE_DATA_SET_EXT',
        END OF file_data_set,
      END OF gc_entity_sets.


    METHODS /iwbep/if_v4_mp_basic~define REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS define_file_data
      IMPORTING
        io_model TYPE REF TO /iwbep/if_v4_med_model
      RAISING
        /iwbep/cx_gateway .
ENDCLASS.



CLASS z1c_odata4_mpc IMPLEMENTATION.
  METHOD /iwbep/if_v4_mp_basic~define.
    define_file_data( io_model ).
  ENDMETHOD.

  METHOD define_file_data.

*    DATA: lt_primitive_properties TYPE /iwbep/if_v4_med_element=>ty_t_med_prim_property,
*          lo_entity_set           TYPE REF TO /iwbep/if_v4_med_entity_set,
*          lo_nav_prop             TYPE REF TO /iwbep/if_v4_med_nav_prop,
*          lo_entity_type          TYPE REF TO /iwbep/if_v4_med_entity_type,
*          lv_referenced_cds_view  TYPE gty_cds_views-salesorder  . " As internal ABAP name we use the name of the CDS view
*

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "   Create entity type
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA ls_data TYPE t_data.
    DATA(lo_entity_type) = io_model->create_entity_type_by_struct(
        iv_entity_type_name          = gc_entities-file_data-internal_name
        is_structure                 = ls_data
        iv_add_conv_to_prim_props    = abap_true
        iv_add_f4_help_to_prim_props = abap_true
        iv_gen_prim_props            = abap_true ).

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Set external EDM name for entity type
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_entity_type->set_edm_name( gc_entities-file_data-external_name ).
*
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Rename external EDM names of properties so that CamelCase notation is used
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    lo_entity_type->get_primitive_properties( IMPORTING et_property = lt_primitive_properties ).
*
*    LOOP AT lt_primitive_properties INTO DATA(lo_primitive_property).
*      lo_primitive_property->set_edm_name( to_mixed( val = lo_primitive_property->get_internal_name( ) ) ).
*    ENDLOOP.
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Set key field(s)
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA(lo_primitive_property) = lo_entity_type->get_primitive_property( 'FILE_NAME' ).
    lo_primitive_property->set_is_key( ).
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    "   Create navigation property
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    lo_nav_prop = lo_entity_type->create_navigation_property( gcs_nav_prop_names-internal-salesorder_to_items ).
*    lo_nav_prop->set_edm_name( gcs_nav_prop_names-edm-salesorder_to_items ).
*
*    lo_nav_prop->set_target_entity_type_name( gcs_entity_type_names-internal-salesorderitem ).
*    lo_nav_prop->set_target_multiplicity( /iwbep/if_v4_med_element=>gcs_med_nav_multiplicity-to_many_optional ).
*    lo_nav_prop->set_on_delete_action( /iwbep/if_v4_med_element=>gcs_med_on_delete_action-none ).
*
*
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    "   Create entity set
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA(lo_entity_set) = lo_entity_type->create_entity_set( gc_entity_sets-file_data_set-internal_name ).
    lo_entity_set->set_edm_name( gc_entity_sets-file_data_set-external_name ).

*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    " Add the binding of the navigation path
*    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    lo_entity_set->add_navigation_prop_binding( iv_navigation_property_path = CONV #( gcs_nav_prop_names-internal-salesorder_to_items )
*                                                iv_target_entity_set        = gcs_entity_set_names-internal-salesorderitem ).

  ENDMETHOD.

ENDCLASS.
