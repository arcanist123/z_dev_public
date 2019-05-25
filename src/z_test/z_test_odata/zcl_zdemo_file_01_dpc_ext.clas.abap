CLASS zcl_zdemo_file_01_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zdemo_file_01_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS /iwbep/if_v4_dp_basic~create_entity REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zdemo_file_01_dpc_ext IMPLEMENTATION.
  METHOD /iwbep/if_v4_dp_basic~create_entity.
    io_request->get_entity_type( IMPORTING ev_entity_type_name = DATA(lv_entity_type_name) ).

    DATA ls_data TYPE zcl_zdemo_file_01_mpc=>ts_file.
    io_request->get_todos( IMPORTING es_todo_list = DATA(ls_todo_list) ).
    IF ls_todo_list-process-busi_data = abap_true.
      io_request->get_busi_data( IMPORTING es_busi_data = ls_data ).
    ENDIF.


    DATA ls_done_list              TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list.
    ls_done_list-busi_data = abap_true.
    ls_done_list-partial_busi_data = abap_true.

    ls_data-file_data = z_1c_excel_processor=>create(
        )->process_command( iv_command    = ls_data-file_name
                            iv_data       = ls_data-file_data ).


    io_response->set_busi_data(  ls_data  ).

    io_response->set_is_done( ls_done_list ).

  ENDMETHOD.

ENDCLASS.
