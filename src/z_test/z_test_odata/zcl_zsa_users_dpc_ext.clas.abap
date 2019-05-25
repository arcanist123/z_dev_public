class ZCL_ZSA_USERS_DPC_EXT definition
  public
  inheriting from ZCL_ZSA_USERS_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods USERSET_CREATE_ENTITY
    redefinition .
  methods USERSET_DELETE_ENTITY
    redefinition .
  methods USERSET_GET_ENTITY
    redefinition .
  methods USERSET_GET_ENTITYSET
    redefinition .
  methods USERSET_UPDATE_ENTITY
    redefinition .
  methods USERPHOTOSET_GET_ENTITY
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZSA_USERS_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.
    DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair,
          lt_key_tab TYPE /iwbep/t_mgw_name_value_pair,
          ls_photo   TYPE zsa_photos,
          lv_email   TYPE char100.

    CASE iv_entity_name.
      WHEN 'UserPhoto'.
        READ TABLE it_key_tab WITH KEY name = 'Email' INTO ls_key_tab.

        ls_photo-email = ls_key_tab-value.
        ls_photo-mimetype = is_media_resource-mime_type.
        ls_photo-filename = iv_slug.
        ls_photo-content = is_media_resource-value.
        DELETE FROM zsa_photos WHERE email = ls_photo-email.
        INSERT INTO zsa_photos VALUES ls_photo.

        userphotoset_get_entity(
          EXPORTING
            iv_entity_name     = iv_entity_name
            iv_entity_set_name = iv_entity_set_name
            iv_source_name     = iv_source_name
            it_key_tab         = it_key_tab
            it_navigation_path = it_navigation_path
          IMPORTING
            er_entity          = ls_photo ).

        copy_data_to_ref( EXPORTING is_data = ls_photo
                          CHANGING  cr_data = er_entity ).
    ENDCASE.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    DATA: ls_key      TYPE /iwbep/s_mgw_name_value_pair,
          lv_email    TYPE char100,
          ls_photo    TYPE zsa_photos,
          ls_lheader  TYPE ihttpnvp,
          ls_stream   TYPE ty_s_media_resource,
          lv_filename TYPE string.

    CASE iv_entity_name.
      WHEN 'UserPhoto'.

        READ TABLE it_key_tab WITH KEY name = 'Email' INTO ls_key.
        lv_email = ls_key-value.

        SELECT SINGLE * FROM zsa_photos INTO CORRESPONDING FIELDS OF ls_photo WHERE email = lv_email.
        ls_stream-value = ls_photo-content.
        ls_stream-mime_type = ls_photo-mimetype.

        lv_filename = ls_photo-filename.
        lv_filename = escape( val = lv_filename
                              format = cl_abap_format=>e_url ).
        ls_lheader-name = 'Content-Disposition'.
        ls_lheader-value = |inline; filename="{ lv_filename }"|.
        set_header( is_header = ls_lheader ).

        copy_data_to_ref( EXPORTING is_data = ls_stream
                          CHANGING  cr_data = er_stream ).
    ENDCASE.
  ENDMETHOD.


 METHOD userphotoset_get_entity.
   DATA: ls_key   TYPE /iwbep/s_mgw_name_value_pair,
         lv_email TYPE char100,
         ls_photo TYPE zsa_photos.

   READ TABLE it_key_tab WITH KEY name = 'Email' INTO ls_key.
   lv_email = ls_key-value.

   SELECT SINGLE filename email mimetype FROM zsa_photos INTO CORRESPONDING FIELDS OF ls_photo WHERE email = lv_email.
   er_entity = ls_photo.
 ENDMETHOD.


  METHOD userset_create_entity.
    DATA ls_data TYPE zsa_users.
    CALL METHOD io_data_provider->read_entry_data
      IMPORTING
        es_data = ls_data.

    MODIFY zsa_users FROM ls_data.
    er_entity = ls_data.

  ENDMETHOD.


  METHOD userset_delete_entity.
    DATA: lt_keys  TYPE /iwbep/t_mgw_tech_pairs,
          ls_key   TYPE /iwbep/s_mgw_tech_pair,
          lv_email TYPE char100.

    lt_keys = io_tech_request_context->get_keys( ).
    READ TABLE lt_keys WITH KEY name = 'EMAIL' INTO ls_key.
    lv_email = ls_key-value.

    DELETE FROM zsa_users WHERE email = lv_email.
  ENDMETHOD.


  METHOD userset_get_entity.

    DATA: lt_keys  TYPE /iwbep/t_mgw_tech_pairs,
          ls_key   TYPE /iwbep/s_mgw_tech_pair,
          lv_email TYPE char100,
          ls_user  TYPE zsa_users.

    lt_keys = io_tech_request_context->get_keys( ).
    READ TABLE lt_keys WITH KEY name = 'EMAIL' INTO ls_key.
    lv_email = ls_key-value.

    SELECT SINGLE * FROM zsa_users INTO CORRESPONDING FIELDS OF ls_user WHERE email = lv_email.

    er_entity = ls_user.
  ENDMETHOD.


  METHOD userset_get_entityset.
    DATA lt_users TYPE TABLE OF zsa_users.

    SELECT * FROM zsa_users INTO TABLE lt_users.
    et_entityset = lt_users.
  ENDMETHOD.


  METHOD userset_update_entity.

    DATA: ls_user   TYPE zsa_users.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_user ).
    UPDATE zsa_users SET
      firstname = ls_user-firstname
      lastname  = ls_user-lastname
      age       = ls_user-age
      address   = ls_user-address
      WHERE email = ls_user-email.

    er_entity = ls_user.
  ENDMETHOD.
ENDCLASS.
