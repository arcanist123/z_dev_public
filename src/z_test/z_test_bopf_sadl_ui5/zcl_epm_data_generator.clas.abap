CLASS zcl_epm_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: constructor,
      execute.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
* general types
      BEGIN OF ty_description,
        langu TYPE char2,
        text  TYPE snwd_desc,
      END OF ty_description .
    TYPES:
      BEGIN OF ty_web_resource,
        web_address        TYPE string,
        detail_description TYPE  ty_description,
        type(3)            TYPE c,
      END OF ty_web_resource .
    TYPES:
* Types for Business Partner
      BEGIN OF ty_address,
        city           TYPE snwd_city,
        postal_code    TYPE snwd_postal_code,
        street         TYPE snwd_street,
        building       TYPE snwd_building,
        country        TYPE snwd_country,
        latitude       TYPE string,
        longitude      TYPE string,
        type           TYPE snwd_address_type,
        val_date_start TYPE string,
        val_date_end   TYPE string,
        description    TYPE STANDARD TABLE OF ty_description WITH NON-UNIQUE KEY langu,
      END OF ty_address .
    TYPES:
      tt_address TYPE STANDARD TABLE OF ty_address .
    TYPES:
      BEGIN OF ty_phone,
        phone_number    TYPE snwd_phone_number,
        phone_extension TYPE snwd_phone_number,
        validity_date   TYPE string,
      END OF ty_phone .
    TYPES:
      BEGIN OF ty_email,
        email_address TYPE snwd_email_address,
        validity_date TYPE string,
      END OF ty_email .
    TYPES:
      BEGIN OF ty_webaddress,
        web_address   TYPE snwd_email_address,
        validity_date TYPE string,
      END OF ty_webaddress .
    TYPES:
      BEGIN OF ty_bp,
        partner_id   TYPE snwd_partner_id,
        currency     TYPE snwd_curr_code,
        company_name TYPE snwd_company_name,
        legal_form   TYPE snwd_legal_form,
        firstname    TYPE snwd_first_name,
        lastname     TYPE snwd_last_name,
        middlename   TYPE snwd_middle_name,
        title        TYPE snwd_title,
        nickname     TYPE snwd_nickname,
        sex          TYPE string,
        role_code    TYPE string,
        address      TYPE STANDARD TABLE OF ty_address WITH NON-UNIQUE KEY city,
        phone        TYPE STANDARD TABLE OF ty_phone WITH NON-UNIQUE KEY phone_number,
        email        TYPE ty_email,
        webaddress   TYPE ty_webaddress,
      END OF ty_bp .
    TYPES:
* Types for Product
      BEGIN OF ty_prod_name,
        langu TYPE char2,
        name  TYPE snwd_desc,
      END OF ty_prod_name .
    TYPES:
      BEGIN OF ty_dimensions,
        width  TYPE snwd_dimension,
        depth  TYPE snwd_dimension,
        height TYPE snwd_dimension,
        unit   TYPE snwd_dim_unit,
      END OF ty_dimensions .
    TYPES:
      BEGIN OF ty_product,
        product_id     TYPE snwd_product_id,
        type_code      TYPE snwd_product_type_code,
        category_id    TYPE snwd_product_category,
        main_category  TYPE snwd_product_category,
        tax_tarif_code TYPE snwd_product_tax_tarif_code,
        measure_unit   TYPE snwd_quantity_unit,
        weight_measure TYPE snwd_weight_measure,
        weight_unit    TYPE snwd_quantity_unit,
        description    TYPE ty_description,
        prod_name      TYPE ty_prod_name,
        web_resource   TYPE ty_web_resource,
        price          TYPE snwd_unit_price,
        dimensions     TYPE ty_dimensions,
      END OF ty_product .
    TYPES:
* Sales order
      BEGIN OF ty_so_item,
        id         TYPE snwd_so_item_pos,
        product_id TYPE /bobf/epm_product_id,
        quantity   TYPE snwd_quantity,
      END OF ty_so_item .
    TYPES:
      BEGIN OF ty_so,
        buyer_party_id(30),   "/bobf/epm_bp_id,
        seller_id(30),   " /bobf/epm_bp_id,
        note               TYPE ty_description,
        item               TYPE STANDARD TABLE OF ty_so_item WITH NON-UNIQUE KEY id,
      END OF ty_so .

    DATA:
* Business Partner data definitions
      mt_business_partners TYPE STANDARD TABLE OF ty_bp .
    DATA:
      mt_bp_root TYPE STANDARD TABLE OF /bobf/d_bp_root .
    DATA:
      mt_bp_contact TYPE STANDARD TABLE OF /bobf/d_bp_cont .
    DATA:
      mt_bp_address TYPE STANDARD TABLE OF /bobf/d_addr .
    DATA:
* Product Data definitions
      mt_products TYPE STANDARD TABLE OF ty_product .
    DATA:
      mt_product_root TYPE STANDARD TABLE OF /bobf/d_pr_root .
    DATA:
      mt_product_name TYPE STANDARD TABLE OF /bobf/d_pr_name .
    DATA:
* Sales Order
      mt_sales_orders TYPE STANDARD TABLE OF ty_so .
    DATA:
      mt_so_root TYPE STANDARD TABLE OF /bobf/d_so_root .
    DATA:
      mt_so_item TYPE STANDARD TABLE OF /bobf/d_so_item .
    DATA:
      mt_so_note TYPE STANDARD TABLE OF /bobf/d_so_note .
    DATA:
* Sales Quote
      mt_sq_root TYPE STANDARD TABLE OF /bobf/d_sq_root .
    DATA:
      mt_sq_item TYPE STANDARD TABLE OF /bobf/d_sq_item .
    DATA:
      mt_sq_note TYPE STANDARD TABLE OF /bobf/d_sq_note .
    DATA:
* Admin data (some kind of very simple randomizer...)
      mt_names TYPE STANDARD TABLE OF sy-uname .
    DATA:
      mt_ctimes TYPE STANDARD TABLE OF timestampl .
    DATA:
      mt_utimes TYPE STANDARD TABLE OF timestampl .
    DATA:
      mt_dtimes TYPE STANDARD TABLE OF timestampl .
    DATA mo_random_user TYPE REF TO cl_abap_random_int .

*
    METHODS deserialize_product_data .
    METHODS deserialize_bp_data .
    METHODS deserialize_so_data .
    METHODS update_bp_data .
    METHODS update_product_data .
    METHODS update_so_data .
    METHODS update_sq_data .
    METHODS map_bp_data .
    METHODS map_product_data .
    METHODS map_so_data .
    METHODS map_sq_data .
    METHODS map_bp_addresses
      IMPORTING
        !iv_key           TYPE /bobf/conf_key
        !is_bp            TYPE ty_bp
      RETURNING
        VALUE(rt_address) LIKE mt_bp_address .
    METHODS load_mime_file
      IMPORTING
        !file_name       TYPE csequence
      RETURNING
        VALUE(file_data) TYPE xstring .
    METHODS get_user_data
      CHANGING
        !struc TYPE any .
ENDCLASS.



CLASS zcl_epm_data_generator IMPLEMENTATION.


  METHOD constructor.

    mt_names = VALUE #( ( 'BLOOMLEO' )
                        ( 'DEDALUSSTEPH' )
                        ( 'GOGARTYOLIV' )
                        ( 'MULLIGANB' )
                        ( 'BLOOMMOLLY' )
                        ( 'BERGMANNALF' )
                        ( 'CUNNINGHAM' )
                        ( 'MACDOWELLG' )
                        ( 'PUREFROYM' )
                        ( 'COHENSBELLA' ) ).

    DO 10 TIMES.
      DATA(lv_date) = sy-datum - ( sy-index MOD 3 ).
      CONVERT DATE lv_date TIME sy-uzeit INTO TIME STAMP DATA(lv_time) TIME ZONE 'UTC'.
      APPEND lv_time TO mt_utimes.
      lv_date = sy-datum - ( 3 * sy-index ).
      CONVERT DATE lv_date TIME sy-uzeit INTO TIME STAMP lv_time TIME ZONE 'UTC'.
      APPEND lv_time TO mt_ctimes.
      lv_date = sy-datum + sy-index.
      CONVERT DATE lv_date TIME sy-uzeit INTO TIME STAMP lv_time TIME ZONE 'UTC'.
      APPEND lv_time TO mt_dtimes.
    ENDDO.

    mo_random_user = cl_abap_random_int=>create( seed = 1 min = 1 max = lines( mt_names ) ).

  ENDMETHOD.


  METHOD deserialize_bp_data.

    TRY.
        DATA(lv_data_file) = load_mime_file( 'SAP/PUBLIC/BC/NWDEMO_MODEL/Business_Partners1.xml' ).
        CALL TRANSFORMATION /bobf/tr_business_partner_data
          SOURCE XML lv_data_file
            RESULT business_partner = mt_business_partners.

      CATCH cx_transformation_error INTO DATA(error).
        DATA(text) = error->get_text( ).
        error->get_source_position( IMPORTING source_line = DATA(pos) ).
        ASSERT 1 = 0.
      CATCH cx_exm_api_exception.
        ASSERT 1 = 0.
    ENDTRY.

  ENDMETHOD.


  METHOD deserialize_product_data.

    TRY.
        DATA(lv_data_file) = load_mime_file( 'SAP/PUBLIC/BC/NWDEMO_MODEL/Products1.xml' ).
        CALL TRANSFORMATION /bobf/tr_product_data
          SOURCE XML lv_data_file
            RESULT products = mt_products.

      CATCH cx_transformation_error INTO DATA(error).
        DATA(text) = error->get_text( ).
        error->get_source_position( IMPORTING source_line = DATA(pos) ).
        ASSERT 1 = 0.
      CATCH cx_exm_api_exception.
        ASSERT 1 = 0.
    ENDTRY.

  ENDMETHOD.


  METHOD deserialize_so_data.

    TRY.
        DATA(lv_data_file) = load_mime_file( 'SAP/PUBLIC/BC/NWDEMO_MODEL/Sales_Orders.xml' ).
        CALL TRANSFORMATION /bobf/tr_sales_order_data
          SOURCE XML lv_data_file
            RESULT salesorder = mt_sales_orders.

      CATCH cx_transformation_error INTO DATA(error).
        DATA(text) = error->get_text( ).
        error->get_source_position( IMPORTING source_line = DATA(pos) ).
        ASSERT 1 = 0.
      CATCH cx_exm_api_exception.
        ASSERT 1 = 0.
    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    " parse
    deserialize_bp_data( ).
    deserialize_product_data( ).
    deserialize_so_data( ).

    " map
    map_bp_data( ).
    map_product_data( ).
    map_so_data( ).
    map_sq_data( ).

    " db_update
    update_product_data( ).
    update_bp_data( ).
    update_so_data( ).
    update_sq_data( ).
    COMMIT WORK.

  ENDMETHOD.


  METHOD get_user_data.

    ASSIGN COMPONENT 'CREA_DATE_TIME' OF STRUCTURE struc TO FIELD-SYMBOL(<cd>).
    ASSIGN COMPONENT 'CREA_UNAME' OF STRUCTURE struc TO FIELD-SYMBOL(<cn>).
    ASSIGN COMPONENT 'LCHG_DATE_TIME' OF STRUCTURE struc TO FIELD-SYMBOL(<ud>).
    ASSIGN COMPONENT 'LCHG_UNAME' OF STRUCTURE struc TO FIELD-SYMBOL(<un>).

    READ TABLE mt_ctimes INDEX mo_random_user->get_next( ) INTO <cd>.
    READ TABLE mt_utimes INDEX mo_random_user->get_next( ) INTO <ud>.
    READ TABLE mt_names INDEX mo_random_user->get_next( ) INTO <cn>.
    READ TABLE mt_names INDEX mo_random_user->get_next( ) INTO <un>.

  ENDMETHOD.


  METHOD load_mime_file.

    cl_mime_repository_api=>if_mr_api~get_api( )->get(
      EXPORTING
        i_url     = file_name
      IMPORTING
        e_content = file_data
      EXCEPTIONS
        OTHERS    = 99 ).
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.

  ENDMETHOD.


  METHOD map_bp_addresses.

    DATA lv_pcnt TYPE i.
    DATA(lv_pnum) = lines( is_bp-phone ).

    LOOP AT is_bp-address ASSIGNING FIELD-SYMBOL(<f>).
      DATA ls_address TYPE /bobf/d_addr.
      CLEAR ls_address.
      TRY.
          ls_address-db_key = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          ASSERT 1 = 0.
      ENDTRY.
      ls_address-parent_key = iv_key.
*      ls_address-host_bo_key = /bobf/if_epm_bus_partner_c=>sc_bo_key.
*      ls_address-host_node_key = /bobf/if_epm_bus_partner_c=>sc_node-root.
*      ls_address-host_key = iv_key.
      ls_address-city = <f>-city.
      ls_address-postal_code = <f>-postal_code.
      ls_address-street = <f>-street.
      ls_address-building = <f>-building.
      ls_address-country = <f>-country.
      ls_address-latitude = <f>-latitude.
      ls_address-longitude = <f>-longitude.
      ls_address-address_type = <f>-type.
      " Description ?????
      " Phone Number
      IF lv_pcnt < lv_pnum.
        lv_pcnt = lv_pcnt + 1.
      ELSEIF lv_pnum = lv_pcnt.
        lv_pcnt = 1.
      ENDIF.
      IF lv_pnum >= 1.
        READ TABLE is_bp-phone ASSIGNING FIELD-SYMBOL(<p>) INDEX lv_pcnt.
        ls_address-phone_number = <p>-phone_number.
        ls_address-fax_number = <p>-phone_extension.
      ENDIF.
      ls_address-email_address = is_bp-email-email_address.
      ls_address-web_address = is_bp-webaddress-web_address.
      APPEND ls_address TO rt_address.
    ENDLOOP.

    APPEND LINES OF rt_address TO mt_bp_address.

  ENDMETHOD.


  METHOD map_bp_data.

    DATA ls_root      TYPE /bobf/d_bp_root.
    DATA ls_contact   TYPE /bobf/d_bp_cont.
    DATA lv_old_name  TYPE /bobf/d_bp_root-company_name.
    DATA lv_years_end TYPE i.
    DATA lv_years_beg TYPE i.
    DATA lv_addr_cnt  TYPE i VALUE 1.
    DATA lv_bp_cnt    TYPE i.

    lv_years_end = sy-datum - 6500.
    lv_years_beg = sy-datum - 23000.
    DATA(lo_random_birth) = cl_abap_random_int=>create( seed = 1 min = lv_years_beg max = lv_years_end ).

    SORT mt_business_partners BY company_name.
    LOOP AT mt_business_partners ASSIGNING FIELD-SYMBOL(<f>).
      " BO root node key needed
      IF lv_old_name <> <f>-company_name.
        TRY.
            DATA(lv_root_key) = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
            ASSERT 1 = 0.
        ENDTRY.
      ENDIF.
      " addresses needed for relationship
      DATA(lt_address) = map_bp_addresses( iv_key = lv_root_key is_bp = <f> ).
      " Create new BO instance
      IF lv_old_name <> <f>-company_name.
        lv_old_name = <f>-company_name.
        CLEAR ls_root.
        ls_root-db_key = lv_root_key.
        lv_bp_cnt = lv_bp_cnt + 1.
        UNPACK lv_bp_cnt TO ls_root-bp_id.
        ls_root-bp_id(1) = '9'.
        ls_root-company_name = <f>-company_name.
        ls_root-legal_form = <f>-legal_form.
        ls_root-currency_code = <f>-currency.
        READ TABLE lt_address INDEX 1 ASSIGNING FIELD-SYMBOL(<a>).
        ls_root-main_address = <a>-db_key.
        get_user_data( CHANGING struc = ls_root ).
        APPEND ls_root TO mt_bp_root.
        DATA(lv_addr_num) = lines( lt_address ).
      ENDIF.
      CLEAR ls_contact.
      TRY.
          ls_contact-db_key = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          ASSERT 1 = 0.
      ENDTRY.
      ls_contact-parent_key = lv_root_key.
      ls_contact-title = <f>-title.
      ls_contact-first_name = <f>-firstname.
      ls_contact-middle_name = <f>-middlename.
      ls_contact-last_name = <f>-lastname.
      ls_contact-nickname = <f>-nickname.
      CONCATENATE <f>-lastname(1) <f>-firstname(1) <f>-middlename(1) INTO ls_contact-initials.
      IF <f>-sex = 'female'.
        ls_contact-sex = 'F'.
      ELSE.
        ls_contact-sex = 'M'.
      ENDIF.
      ls_contact-language = 'EN'.
      ls_contact-date_of_birth = lo_random_birth->get_next( ).
      READ TABLE <f>-phone ASSIGNING FIELD-SYMBOL(<p>) INDEX 1.
      ls_contact-phone_number = <p>-phone_number.
      ls_contact-fax_number = <p>-phone_extension.
      ls_contact-email_address = <f>-email-email_address.
      lv_addr_cnt = lv_addr_cnt + 1.
      IF lv_addr_cnt > lv_addr_num.
        lv_addr_cnt = 1.
      ENDIF.
      READ TABLE lt_address ASSIGNING <a> INDEX lv_addr_cnt.
      ls_contact-address = <a>-db_key.
      APPEND ls_contact TO mt_bp_contact.
    ENDLOOP.

  ENDMETHOD.


  METHOD map_product_data.

    DATA ls_root TYPE /bobf/d_pr_root.
    DATA ls_name TYPE /bobf/d_pr_name.

    DATA(lv_cnt) = lines( mt_bp_root ).
    DATA(lo_random_bp) = cl_abap_random_int=>create( seed = 1 min = 1 max = lv_cnt  ).

    LOOP AT mt_products ASSIGNING FIELD-SYMBOL(<f>).

      CLEAR ls_root.
      CLEAR ls_name.

      TRY.
          ls_root-db_key      = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          ASSERT 1 = 0.
      ENDTRY.
      ls_root-product_id      = <f>-product_id.
      ls_root-type_code       = <f>-type_code.
      ls_root-category        = <f>-category_id.
      ls_root-product_pic_url = <f>-web_resource-web_address.
      IF lv_cnt > 0.
        lv_cnt = lo_random_bp->get_next( ).
        READ TABLE mt_bp_root INDEX lv_cnt ASSIGNING FIELD-SYMBOL(<n>).
        ls_root-supplier_id = <n>-bp_id.
      ENDIF.
      ls_root-tax_tarif_code  = <f>-tax_tarif_code.
      ls_root-measure_unit    = <f>-measure_unit.
      ls_root-weight_measure  = <f>-weight_measure.
      ls_root-weight_unit     = <f>-weight_unit.
      ls_root-currency_code   = 'EUR'.
      ls_root-price           = <f>-price.
      ls_root-width           = <f>-dimensions-width.
      ls_root-depth           = <f>-dimensions-depth.
      ls_root-height          = <f>-dimensions-height.
      ls_root-dim_unit        = to_upper( <f>-dimensions-unit ).
      get_user_data( CHANGING struc = ls_root ).
      APPEND ls_root TO mt_product_root.

      TRY.
          ls_name-db_key    = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          ASSERT 1 = 0.
      ENDTRY.
      ls_name-parent_key    = ls_root-db_key.
      ls_name-language_code = <f>-description-langu.
      ls_name-name          = <f>-prod_name-name.
      ls_name-description   = <f>-description-text.
      APPEND ls_name TO mt_product_name.

    ENDLOOP.

  ENDMETHOD.


  METHOD map_so_data.

    DATA ls_root TYPE /bobf/d_so_root.
    DATA ls_item TYPE /bobf/d_so_item.
    DATA ls_note TYPE /bobf/d_so_note.
    DATA lt_item LIKE mt_so_item.
    DATA lv_so_id TYPE i.
    DATA lv_so_st TYPE i.
    DATA lt_bp_excl TYPE STANDARD TABLE OF /bobf/d_so_root-buyer_party_id.
    DATA lv_rc TYPE sy-subrc.

    DATA(lv_bp_cnt) = lines( mt_bp_root ).
    DATA(lo_random_bp) = cl_abap_random_int=>create( seed = 1 min = 1 max = lv_bp_cnt  ).
    DATA(lo_random_st) = cl_abap_random_int=>create(  seed = 1 min = 1 max = 4 ).

    TRY.

        LOOP AT mt_sales_orders ASSIGNING FIELD-SYMBOL(<f>).
          CLEAR ls_root.
          " root key
          ls_root-db_key = cl_system_uuid=>create_uuid_x16_static( ).
          DATA(lv_so_cnt) = lo_random_st->get_next( ).
          CASE lv_so_cnt.
            WHEN 1. ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_new.
            WHEN 2. ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_inprocess.
            WHEN 3. ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_closed.
            WHEN 4. ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_cancelled.
          ENDCASE.
          IF ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_closed
            OR ( ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_inprocess AND sy-tabix MOD 3 = 0 ).
            ls_root-billing_status = if_epm_so_header=>gc_billing_status_paid.
          ENDIF.
          IF ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_closed
            OR ( ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_inprocess AND sy-tabix MOD 4 = 0 ).
            ls_root-delivery_status = if_epm_so_header=>gc_delivery_status_delivered.
          ENDIF.
          get_user_data( CHANGING struc = ls_root ).
          " map items and schedule line
          CLEAR lt_item.
          LOOP AT <f>-item ASSIGNING FIELD-SYMBOL(<i>).
            CLEAR: ls_item, lt_bp_excl.
            ls_item-db_key = cl_system_uuid=>create_uuid_x16_static( ).
            ls_item-parent_key = ls_root-db_key.
            ls_item-item_position = <i>-id.
            ls_item-product_id = <i>-product_id.
            ls_item-quantity = <i>-quantity.
            IF ls_root-delivery_status = if_epm_so_header=>gc_delivery_status_delivered.
              ls_item-delivery_date = ls_root-lchg_date_time.
            ELSEIF ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_new
              OR ls_root-so_status = if_epm_so_header=>gc_lifecycle_status_inprocess.
              DATA(lv_d_index) = mo_random_user->get_next( ).
              READ TABLE mt_dtimes INDEX lv_d_index INTO ls_item-delivery_date.
            ENDIF.
            APPEND ls_item TO lt_item.
            " business partner id
            READ TABLE mt_product_root WITH KEY product_id = <i>-product_id ASSIGNING FIELD-SYMBOL(<product>).
            APPEND <product>-supplier_id TO lt_bp_excl.
          ENDLOOP.
          " Header data continued
          lv_so_id = lv_so_id + 1.
          UNPACK lv_so_id TO ls_root-so_id.
          ls_root-so_id(1) = '9'.
          " Buyer Id determined only after items -> a buyer should be different to the supplier of the ordered procuts
          IF lv_bp_cnt > 0.
            lv_rc = 1.
            WHILE lv_rc <> 0.
              lv_bp_cnt = lo_random_bp->get_next( ).
              READ TABLE mt_bp_root INDEX lv_bp_cnt ASSIGNING FIELD-SYMBOL(<n>).
              READ TABLE lt_bp_excl FROM <n>-bp_id TRANSPORTING NO FIELDS.
              IF sy-subrc = 0 OR sy-index > 15. lv_rc = 0. ENDIF.
            ENDWHILE.
            ls_root-buyer_party_id   = <n>-bp_id.
            ls_root-bill_to_party_id = <n>-bp_id.
            ls_root-ship_to_party_id = <n>-bp_id.
          ENDIF.

          " currency conversion and price calculation
          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<item>).
            READ TABLE mt_product_root WITH KEY product_id = <item>-product_id ASSIGNING FIELD-SYMBOL(<p>).

            <item>-currency_code = /bobf/if_epm_constants_c=>sc_company_currency_code.
            <item>-quantity_unit = <p>-measure_unit.
            <item>-gross_amount  = <p>-price.
            IF NOT <p>-currency_code IS INITIAL AND
               <p>-currency_code NE /bobf/if_epm_constants_c=>sc_company_currency_code.
              DATA l_delivery_date LIKE sy-datum.
              IF NOT <item>-delivery_date IS INITIAL.
                CONVERT TIME STAMP <item>-delivery_date TIME ZONE 'UTC' INTO DATE l_delivery_date.
              ELSE.
                CONVERT TIME STAMP ls_root-admin_data-crea_date_time TIME ZONE 'UTC' INTO DATE l_delivery_date.
              ENDIF.

              CALL FUNCTION 'SAPBC_GLOBAL_FOREIGN_CURRENCY'
                EXPORTING
                  local_amount     = <p>-price
                  local_currency   = <p>-currency_code
                  foreign_currency = /bobf/if_epm_constants_c=>sc_company_currency_code
                IMPORTING
                  foreign_amount   = <item>-gross_amount
                EXCEPTIONS
                  OTHERS           = 4.
            ENDIF.
            IF sy-subrc <> 0.
* Implement suitable error handling here
            ENDIF.

            <item>-gross_amount = <item>-gross_amount * <item>-quantity.
            CASE <p>-tax_tarif_code.
              WHEN 1. <item>-tax_amount   = <item>-gross_amount * /bobf/if_epm_constants_c=>sc_vat_full / 100.
              WHEN 2. <item>-tax_amount   = <item>-gross_amount * /bobf/if_epm_constants_c=>sc_vat_reduced / 100.
              WHEN OTHERS. <item>-tax_amount   = 0.
            ENDCASE.
            <item>-net_amount   = <item>-gross_amount - <item>-tax_amount.
            ls_root-gross_amount = ls_root-gross_amount + <item>-gross_amount.
            ls_root-tax_amount   = ls_root-tax_amount   + <item>-tax_amount.
            ls_root-net_amount   = ls_root-net_amount   + <item>-net_amount.
          ENDLOOP.
          APPEND LINES OF lt_item TO mt_so_item.
          ls_root-currency_code = /bobf/if_epm_constants_c=>sc_company_currency_code.
          APPEND ls_root TO mt_so_root.
          " map note
          CLEAR ls_note.
          ls_note-db_key = cl_system_uuid=>create_uuid_x16_static( ).
          ls_note-parent_key = ls_root-db_key.
          ls_note-note = <f>-note-text.
          APPEND ls_note TO mt_so_note.
        ENDLOOP.

      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

  ENDMETHOD.


  METHOD map_sq_data.

    DATA lv_i TYPE i.
    DATA lv_j TYPE i.
    DATA ls_sq_root TYPE /bobf/d_sq_root.
    DATA ls_sq_item TYPE /bobf/d_sq_item.
    DATA lt_sq_item LIKE mt_sq_item.

    TRY.

        " not all sales orders have been created from a sales_quote
        LOOP AT mt_so_root ASSIGNING FIELD-SYMBOL(<r>).
          lv_i = lv_i + 1.
          CLEAR: ls_sq_root, lt_sq_item[].
          ls_sq_root-db_key          = cl_system_uuid=>create_uuid_x16_static( ).
          LOOP AT mt_so_item ASSIGNING FIELD-SYMBOL(<i>) WHERE parent_key = <r>-db_key.
            ls_sq_item-parent_key    = ls_sq_root-db_key.
            ls_sq_item-db_key        = cl_system_uuid=>create_uuid_x16_static( ).
            ls_sq_item-item_pos      = <i>-item_position.
            ls_sq_item-product_id    = <i>-product_id.
            ls_sq_item-quantity      = <i>-quantity.
            ls_sq_item-quantity_unit = <i>-quantity_unit.
            ls_sq_item-net_amount    = <i>-net_amount.
            ls_sq_item-tax_amount    = <i>-tax_amount.
            ls_sq_item-gross_amount  = <i>-gross_amount.
            ls_sq_item-currency_code = <i>-currency_code.
            ls_sq_item-discount      = <i>-discount.
            APPEND ls_sq_item TO lt_sq_item.

            IF <i>-delivery_date > ls_sq_root-delivery_date.
              ls_sq_root-delivery_date = <i>-delivery_date.
            ENDIF.
          ENDLOOP.
          " header
          ls_sq_root-bp_id         = <r>-buyer_party_id.
          ls_sq_root-currency_code = <r>-currency_code.
          UNPACK lv_i TO ls_sq_root-quote_id.
          ls_sq_root-quote_id(1)   = 'Z'.
          get_user_data( CHANGING struc = ls_sq_root ).

          IF lv_i MOD 6 = 0.
            ls_sq_root-quote_status = /bobf/if_epm_sales_quote_ext=>sc_root_quote_status-draft.
            APPEND LINES OF lt_sq_item TO mt_sq_item.
            APPEND ls_sq_root TO mt_sq_root.
          ELSEIF lv_i MOD 5 = 0.
            ls_sq_root-quote_status = /bobf/if_epm_sales_quote_ext=>sc_root_quote_status-rejected.
            APPEND LINES OF lt_sq_item TO mt_sq_item.
            APPEND ls_sq_root TO mt_sq_root.
          ELSEIF lv_i MOD 4 = 0.
            ls_sq_root-quote_status = /bobf/if_epm_sales_quote_ext=>sc_root_quote_status-published.
            APPEND LINES OF lt_sq_item TO mt_sq_item.
            APPEND ls_sq_root TO mt_sq_root.
          ELSEIF lv_i MOD 3 = 0.
            APPEND LINES OF lt_sq_item TO mt_sq_item.
            ls_sq_root-quote_status = /bobf/if_epm_sales_quote_ext=>sc_root_quote_status-closed.
            ls_sq_root-sales_order_id = <r>-so_id.
            IF ls_sq_root-lchg_date_time > <r>-crea_date_time.
              ls_sq_root-crea_date_time   = <r>-crea_date_time.
              ls_sq_root-lchg_date_time   = <r>-crea_date_time.
            ENDIF.
            APPEND ls_sq_root TO mt_sq_root.
          ELSEIF lv_i MOD 2 = 0.
            ls_sq_root-quote_status = /bobf/if_epm_sales_quote_ext=>sc_root_quote_status-accepted.
            APPEND LINES OF lt_sq_item TO mt_sq_item.
            APPEND ls_sq_root TO mt_sq_root.
            IF lv_i MOD 7 = 0.
              ls_sq_root-quote_status = /bobf/if_epm_sales_quote_ext=>sc_root_quote_status-cancelled.
              ls_sq_root-db_key = cl_system_uuid=>create_uuid_x16_static( ).
              get_user_data( CHANGING struc = ls_sq_root ).
              ls_sq_root-quote_id+3(1) = '5'.
              APPEND ls_sq_root TO mt_sq_root.
              LOOP AT lt_sq_item ASSIGNING FIELD-SYMBOL(<si>).
                <si>-parent_key = ls_sq_root-db_key.
                <si>-db_key = cl_system_uuid=>create_uuid_x16_static( ).
              ENDLOOP.
              APPEND LINES OF lt_sq_item TO mt_sq_item.
            ENDIF.
          ENDIF.
        ENDLOOP.

      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

  ENDMETHOD.


  METHOD update_bp_data.

    DELETE FROM /bobf/d_bp_root.                        "#EC CI_NOWHERE
    DELETE FROM /bobf/d_bp_cont.                        "#EC CI_NOWHERE
    DELETE FROM /bobf/d_addr.                           "#EC CI_NOWHERE

    INSERT /bobf/d_bp_root FROM TABLE mt_bp_root.
    INSERT /bobf/d_bp_cont FROM TABLE mt_bp_contact.
    INSERT /bobf/d_addr FROM TABLE mt_bp_address.

  ENDMETHOD.


  METHOD update_product_data.

    DELETE FROM /bobf/d_pr_name.                        "#EC CI_NOWHERE
    DELETE FROM /bobf/d_pr_root.                        "#EC CI_NOWHERE

    INSERT /bobf/d_pr_name FROM TABLE mt_product_name.
    INSERT /bobf/d_pr_root FROM TABLE mt_product_root.

  ENDMETHOD.


  METHOD update_so_data.

    DELETE FROM /bobf/d_so_root.                        "#EC CI_NOWHERE
    DELETE FROM /bobf/d_so_item.                        "#EC CI_NOWHERE
    DELETE FROM /bobf/d_so_note.                        "#EC CI_NOWHERE

    INSERT /bobf/d_so_root FROM TABLE mt_so_root.
    INSERT /bobf/d_so_item FROM TABLE mt_so_item.
    INSERT /bobf/d_so_note FROM TABLE mt_so_note.

  ENDMETHOD.


  METHOD update_sq_data.

    DELETE FROM /bobf/d_sq_root.                        "#EC CI_NOWHERE
    DELETE FROM /bobf/d_sq_item.                        "#EC CI_NOWHERE
    DELETE FROM /bobf/d_sq_note.                        "#EC CI_NOWHERE

    INSERT /bobf/d_sq_root FROM TABLE mt_sq_root.
    INSERT /bobf/d_sq_item FROM TABLE mt_sq_item.
    INSERT /bobf/d_sq_note FROM TABLE mt_sq_note.

  ENDMETHOD.
ENDCLASS.
