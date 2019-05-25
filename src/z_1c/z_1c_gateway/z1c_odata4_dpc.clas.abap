CLASS z1c_odata4_dpc DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_data_provider
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS /iwbep/if_v4_dp_basic~read_entity REDEFINITION .


    METHODS /iwbep/if_v4_dp_basic~create_entity REDEFINITION.
    METHODS /iwbep/if_v4_dp_basic~update_entity REDEFINITION.
    METHODS /iwbep/if_v4_dp_basic~delete_entity REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z1c_odata4_dpc IMPLEMENTATION.
  METHOD /iwbep/if_v4_dp_basic~create_entity.

    "get the source data
    DATA ls_data TYPE  z1c_odata4_mpc=>t_data.
    io_request->get_busi_data(  IMPORTING es_busi_data = ls_data ).

    "depending on type of request - execute different type of processing
    CASE z1c_entity_types=>get_entity_type( ls_data-file_name ).
      WHEN z1c_entity_types=>json_to_upd.
        ls_data-file_data = z_1c_json_to_upd_parser=>create( ls_data-file_data )->parse(  ).
    ENDCASE.

    io_response->set_busi_data( ls_data ).

    io_response->set_is_done( VALUE #( busi_data = abap_true )  ).

  ENDMETHOD.

  METHOD /iwbep/if_v4_dp_basic~delete_entity.

  ENDMETHOD.

  METHOD /iwbep/if_v4_dp_basic~read_entity.

  ENDMETHOD.

  METHOD /iwbep/if_v4_dp_basic~update_entity.

  ENDMETHOD.

ENDCLASS.
