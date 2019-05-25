REPORT zepm_data_generator_test.

START-OF-SELECTION.

  "define type
  TYPES:
    BEGIN OF ty_prod_name,
      langu TYPE char2,
      name  TYPE snwd_desc,
    END OF ty_prod_name .
  TYPES tt_prod_name TYPE STANDARD TABLE OF ty_prod_name WITH DEFAULT KEY.
  TYPES:
    BEGIN OF ty_product,
      product_id TYPE snwd_product_id,
      prod_name  TYPE tt_prod_name,
    END OF ty_product .
  TYPES tt_product TYPE STANDARD TABLE OF ty_product WITH DEFAULT KEY.

  "define the data
  DATA lt_product TYPE tt_product.

  "populate the data
  DATA ls_product LIKE LINE OF lt_product.
  ls_product-product_id = 1.
  APPEND VALUE ty_prod_name(
    langu = 'EN'
    name  = 'TEST'
  ) TO   ls_product-prod_name.

  APPEND ls_product TO lt_product.
