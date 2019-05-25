class ZCL_ZTEST_001_DPC_EXT definition
  public
  inheriting from ZCL_ZTEST_001_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
    redefinition .
protected section.

  methods Z1COZ_RESTSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZTEST_001_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
**  EXPORTING
**    iv_entity_name          = iv_entity_name
**    iv_entity_set_name      = iv_entity_set_name
**    iv_source_name          = iv_source_name
**    it_key_tab              = it_key_tab
**    it_navigation_path      = it_navigation_path
**    io_tech_request_context = io_tech_request_context
**  IMPORTING
**    er_stream               = er_stream
**    es_response_context     = es_response_context
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
*  EXPORTING
**    iv_entity_name          = iv_entity_name
**    iv_entity_set_name      = iv_entity_set_name
**    iv_source_name          = iv_source_name
*    IS_MEDIA_RESOURCE       = IS_MEDIA_RESOURCE
**    it_key_tab              = it_key_tab
**    it_navigation_path      = it_navigation_path
**    io_tech_request_context = io_tech_request_context
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  method Z1COZ_RESTSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->Z1COZ_RESTSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          = IV_ENTITY_NAME
*    IV_ENTITY_SET_NAME      = IV_ENTITY_SET_NAME
*    IV_SOURCE_NAME          = IV_SOURCE_NAME
*    IT_KEY_TAB              = IT_KEY_TAB
**    io_request_object       = io_request_object
**    io_tech_request_context = io_tech_request_context
*    IT_NAVIGATION_PATH      = IT_NAVIGATION_PATH
**  IMPORTING
**    er_entity               = er_entity
**    es_response_context     = es_response_context
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.
ENDCLASS.
