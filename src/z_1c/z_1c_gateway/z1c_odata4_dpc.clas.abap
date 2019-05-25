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
    io_request->get_entity_type( IMPORTING ev_entity_type_name = DATA(lv_entity_type_name) ).
  ENDMETHOD.

  METHOD /iwbep/if_v4_dp_basic~delete_entity.

  ENDMETHOD.

  METHOD /iwbep/if_v4_dp_basic~read_entity.

  ENDMETHOD.

  METHOD /iwbep/if_v4_dp_basic~update_entity.

  ENDMETHOD.

ENDCLASS.
