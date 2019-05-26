CLASS z1coz_products DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF t_product,
        ozon_id TYPE string,
      END OF t_product.
    METHODS get_products.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z1coz_products IMPLEMENTATION.
  METHOD get_products.

  ENDMETHOD.

ENDCLASS.
