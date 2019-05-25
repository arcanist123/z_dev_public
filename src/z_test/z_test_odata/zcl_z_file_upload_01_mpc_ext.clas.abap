CLASS zcl_z_file_upload_01_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_z_file_upload_01_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS define
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_Z_FILE_UPLOAD_01_MPC_EXT IMPLEMENTATION.


  METHOD define.
    DATA: lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
          lo_property TYPE REF TO /iwbep/if_mgw_odata_property.
    CALL METHOD super->define.
    CALL METHOD model->get_entity_type
      EXPORTING
        iv_entity_name = 'ZUI5_ATTACHMENT'
      RECEIVING
        ro_entity_type = lo_entity.
    IF lo_entity IS BOUND.
      CALL METHOD lo_entity->get_property
        EXPORTING
          iv_property_name = 'Mimetype'
        RECEIVING
          ro_property      = lo_property.
      CALL METHOD lo_property->set_as_content_type.
*            CATCH /iwbep/cx_mgw_med_exception.    "
*  CATCH /iwbep/cx_mgw_med_exception.    "

    ENDIF.

*      CATCH /iwbep/cx_mgw_med_exception.    "
  ENDMETHOD.
ENDCLASS.
