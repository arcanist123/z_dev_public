class ZCL_ZGW_PO_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_PO_DPC
  create public .

public section.
protected section.

  methods SFLIGHTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGW_PO_DPC_EXT IMPLEMENTATION.


  METHOD sflightset_get_entityset.
**TRY.
*CALL METHOD SUPER->SFLIGHTSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           = IV_ENTITY_NAME
*    IV_ENTITY_SET_NAME       = IV_ENTITY_SET_NAME
*    IV_SOURCE_NAME           = IV_SOURCE_NAME
*    IT_FILTER_SELECT_OPTIONS = IT_FILTER_SELECT_OPTIONS
*    IS_PAGING                = IS_PAGING
*    IT_KEY_TAB               = IT_KEY_TAB
*    IT_NAVIGATION_PATH       = IT_NAVIGATION_PATH
*    IT_ORDER                 = IT_ORDER
*    IV_FILTER_STRING         = IV_FILTER_STRING
*    IV_SEARCH_STRING         = IV_SEARCH_STRING
**    io_tech_request_context  = io_tech_request_context
**  IMPORTING
**    et_entityset             = et_entityset
**    es_response_context      = es_response_context
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    SELECT * FROM sflight INTO TABLE et_entityset.
  ENDMETHOD.
ENDCLASS.
