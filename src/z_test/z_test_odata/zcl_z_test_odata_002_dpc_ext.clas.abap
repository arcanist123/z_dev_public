CLASS zcl_z_test_odata_002_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_z_test_odata_002_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS z_test_odata_002_get_entity
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_Z_TEST_ODATA_002_DPC_EXT IMPLEMENTATION.


  METHOD z_test_odata_002_get_entity.
    "simple conversion
    er_entity-ev_string = 'asdf'.
  ENDMETHOD.
ENDCLASS.
