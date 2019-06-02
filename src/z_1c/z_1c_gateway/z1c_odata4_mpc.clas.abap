CLASS z1c_odata4_mpc DEFINITION
  PUBLIC
    INHERITING FROM /iwbep/cl_v4_abs_model_prov
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_data,
        file_name TYPE string,
        file_data TYPE string,
        file_log  TYPE string,
      END OF ts_data.
    CONSTANTS:
      BEGIN OF gc_entities,
        BEGIN OF file_data,
          internal_name TYPE /iwbep/if_v4_med_types=>ty_e_med_internal_name VALUE 'FILE_DATA1',
          external_name TYPE /iwbep/if_v4_med_types=>ty_e_med_edm_name VALUE 'FILE_DATA_EXT1',
        END OF file_data,
      END OF gc_entities.
    CONSTANTS:
      BEGIN OF gc_entity_sets,
        BEGIN OF file_data_set,
          internal_name TYPE /iwbep/if_v4_med_types=>ty_e_med_internal_name VALUE 'FILE_DATA_SET1',
          external_name TYPE /iwbep/if_v4_med_types=>ty_e_med_edm_name VALUE 'FILE_DATA_SET_EXT1',
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


    DATA ls_data TYPE ts_data.
    DATA(lo_entity_type) = io_model->create_entity_type_by_struct(
        iv_entity_type_name          = gc_entities-file_data-internal_name
        is_structure                 = ls_data
        iv_add_conv_to_prim_props    = abap_true
        iv_add_f4_help_to_prim_props = abap_true
        iv_gen_prim_props            = abap_true ).

    lo_entity_type->set_edm_name( gc_entities-file_data-external_name ).

    DATA(lo_primitive_property) = lo_entity_type->get_primitive_property( 'FILE_NAME' ).
    lo_primitive_property->set_is_key( ).

    DATA(lo_entity_set) = lo_entity_type->create_entity_set( gc_entity_sets-file_data_set-internal_name ).
    lo_entity_set->set_edm_name( gc_entity_sets-file_data_set-external_name ).

  ENDMETHOD.

ENDCLASS.
