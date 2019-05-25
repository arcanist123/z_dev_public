class zcx_e2e001_odata_v4_so definition
  public
  inheriting from /iwbep/cx_gateway
  final
  create public .

  public section.

    constants:
      begin of entity_not_found,
        msgid type symsgid value 'ZCM_E2E001ODATAV4_SO',
        msgno type symsgno value '050',
        attr1 type scx_attrname value 'ENTITY_KEY',
        attr2 type scx_attrname value 'EDM_ENTITY_SET_NAME',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of entity_not_found.
    constants:
      begin of use_filter_top_or_nav,
        msgid type symsgid value 'ZCM_E2E001ODATAV4_SO',
        msgno type symsgno value '051',
        attr1 type scx_attrname value 'EDM_ENTITY_SET_NAME',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of use_filter_top_or_nav .
    constants:
      begin of entity_keys_do_not_match,
        msgid type symsgid value 'ZCM_E2E001ODATAV4_SO',
        msgno type symsgno value '052',
        attr1 type scx_attrname value 'EDM_ENTITY_KEY',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of entity_keys_do_not_match .
    constants:
      begin of missing_properties,
        msgid type symsgid value 'ZCM_E2E001ODATAV4_SO',
        msgno type symsgno value '054',
        attr1 type scx_attrname value 'EDM_ENTITY_SET_NAME',
        attr2 type scx_attrname value 'NAMES_OF_MISSING_PROPS',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of missing_properties .

    data: entity_set_name        type /iwbep/if_v4_med_element=>ty_e_med_internal_name,
          edm_entity_set_name    type /iwbep/if_v4_med_element=>ty_e_med_edm_name,
          user_name              type syuname,
          entity_key             type string read-only,
          names_of_missing_props type string.



    methods constructor
      importing
        !textid                like if_t100_message=>t100key optional
        !previous              like previous optional
        !exception_category    type ty_exception_category default gcs_excep_categories-provider
        !http_status_code      type ty_http_status_code default gcs_http_status_codes-sv_internal_server_error
        !is_for_user           type abap_bool default abap_true
        !message_container     type ref to /iwbep/if_v4_message_container optional
        !sap_note_id           type ty_sap_note_id optional
        !edm_entity_set_name   type /iwbep/if_v4_med_element=>ty_e_med_edm_name optional
        !entity_set_name       type /iwbep/if_v4_med_element=>ty_e_med_internal_name optional
        !user_name             type syuname optional
        !entity_key            type string optional
        names_of_missing_props type string optional.
  protected section.
  private section.
endclass.



class zcx_e2e001_odata_v4_so implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    call method super->constructor
      exporting
        previous           = previous
        exception_category = exception_category
        http_status_code   = http_status_code
        is_for_user        = is_for_user
        message_container  = message_container
        sap_note_id        = sap_note_id.

    me->entity_key = entity_key.
    me->user_name = user_name.
    me->entity_set_name = entity_set_name .
    me->edm_entity_set_name = edm_entity_set_name.
    me->names_of_missing_props = names_of_missing_props.

    clear me->textid.
    if textid is initial.
      if_t100_message~t100key = if_t100_message=>default_textid.
    else.
      if_t100_message~t100key = textid.
    endif.
  endmethod.
endclass.
