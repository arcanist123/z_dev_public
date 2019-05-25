class ZCO_NDFD_XMLPORT_TYPE definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods CORNER_POINTS
    importing
      !INPUT type ZCORNER_POINTS
    exporting
      !OUTPUT type ZCORNER_POINTS_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods GML_LAT_LON_LIST
    importing
      !INPUT type ZGML_LAT_LON_LIST
    exporting
      !OUTPUT type ZGML_LAT_LON_LIST_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods GML_TIME_SERIES
    importing
      !INPUT type ZGML_TIME_SERIES
    exporting
      !OUTPUT type ZGML_TIME_SERIES_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods LAT_LON_LIST_CITY_NAMES
    importing
      !INPUT type ZLAT_LON_LIST_CITY_NAMES
    exporting
      !OUTPUT type ZLAT_LON_LIST_CITY_NAMES_RESPO
    raising
      CX_AI_SYSTEM_FAULT .
  methods LAT_LON_LIST_LINE
    importing
      !INPUT type ZLAT_LON_LIST_LINE
    exporting
      !OUTPUT type ZLAT_LON_LIST_LINE_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods LAT_LON_LIST_SQUARE
    importing
      !INPUT type ZLAT_LON_LIST_SQUARE
    exporting
      !OUTPUT type ZLAT_LON_LIST_SQUARE_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods LAT_LON_LIST_SUBGRID
    importing
      !INPUT type ZLAT_LON_LIST_SUBGRID
    exporting
      !OUTPUT type ZLAT_LON_LIST_SUBGRID_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods LAT_LON_LIST_ZIP_CODE
    importing
      !INPUT type ZLAT_LON_LIST_ZIP_CODE
    exporting
      !OUTPUT type ZLAT_LON_LIST_ZIP_CODE_RESPONS
    raising
      CX_AI_SYSTEM_FAULT .
  methods NDFDGEN
    importing
      !INPUT type ZNDFDGEN
    exporting
      !OUTPUT type ZNDFDGEN_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods NDFDGEN_BY_DAY
    importing
      !INPUT type ZNDFDGEN_BY_DAY
    exporting
      !OUTPUT type ZNDFDGEN_BY_DAY_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods NDFDGEN_BY_DAY_LAT_LON_LIST
    importing
      !INPUT type ZNDFDGEN_BY_DAY_LAT_LON_LIST
    exporting
      !OUTPUT type ZNDFDGEN_BY_DAY_LAT_LON_LIST_R
    raising
      CX_AI_SYSTEM_FAULT .
  methods NDFDGEN_LAT_LON_LIST
    importing
      !INPUT type ZNDFDGEN_LAT_LON_LIST
    exporting
      !OUTPUT type ZNDFDGEN_LAT_LON_LIST_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCO_NDFD_XMLPORT_TYPE IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_NDFD_XMLPORT_TYPE'
    logical_port_name   = logical_port_name
  ).

  endmethod.


  method CORNER_POINTS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'CORNER_POINTS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GML_LAT_LON_LIST.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GML_LAT_LON_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GML_TIME_SERIES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GML_TIME_SERIES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LAT_LON_LIST_CITY_NAMES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'LAT_LON_LIST_CITY_NAMES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LAT_LON_LIST_LINE.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'LAT_LON_LIST_LINE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LAT_LON_LIST_SQUARE.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'LAT_LON_LIST_SQUARE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LAT_LON_LIST_SUBGRID.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'LAT_LON_LIST_SUBGRID'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LAT_LON_LIST_ZIP_CODE.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'LAT_LON_LIST_ZIP_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method NDFDGEN.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'NDFDGEN'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method NDFDGEN_BY_DAY.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'NDFDGEN_BY_DAY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method NDFDGEN_BY_DAY_LAT_LON_LIST.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'NDFDGEN_BY_DAY_LAT_LON_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method NDFDGEN_LAT_LON_LIST.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'NDFDGEN_LAT_LON_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
