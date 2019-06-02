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

    METHODS get_log
      RETURNING
        VALUE(r_result) TYPE string.
ENDCLASS.



CLASS z1c_odata4_dpc IMPLEMENTATION.


  METHOD get_log.
    DATA(lt_messages) = zblog_service_provider=>get_default_service( )->get_messages_bapiret( ).
    r_result = /ui2/cl_json=>serialize( lt_messages ).
  ENDMETHOD.
  METHOD /iwbep/if_v4_dp_basic~create_entity.
    TRY.
        "get the source data
        DATA ls_data TYPE  z1c_odata4_mpc=>ts_data.
        io_request->get_busi_data(  IMPORTING es_busi_data = ls_data ).

        CASE z1c_entity_types=>get_entity_type( ls_data-file_name ).
          WHEN z1c_entity_types=>json_to_upd.
            ls_data-file_data = z_1c_json_to_upd_parser=>create( ls_data-file_data )->parse(  ).
        ENDCASE.

        ls_data-file_log = get_log( ).

        io_response->set_busi_data( ls_data ).

        io_response->set_is_done( VALUE #( busi_data = abap_true partial_busi_data = abap_true )  ).
      CATCH zcx_exception INTO DATA(lo_ex).
    ENDTRY.
  ENDMETHOD.


  METHOD /iwbep/if_v4_dp_basic~delete_entity.

  ENDMETHOD.


  METHOD /iwbep/if_v4_dp_basic~read_entity.

  ENDMETHOD.


  METHOD /iwbep/if_v4_dp_basic~update_entity.

  ENDMETHOD.





ENDCLASS.
