class ZCL_ZDEMO_FILE_MPC definition
  public
  inheriting from /IWBEP/CL_V4_ABS_MODEL_PROV
  create public .

public section.

  types:
     begin of TS_FILE,
         FILENAME type STRING,
         FILEDATA type STRING,
     end of TS_FILE .
  types:
     TT_FILE type standard table of TS_FILE .

  methods /IWBEP/IF_V4_MP_BASIC~DEFINE
    redefinition .
protected section.
private section.

  methods DEFINE_FILE
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
ENDCLASS.



CLASS ZCL_ZDEMO_FILE_MPC IMPLEMENTATION.


  method /IWBEP/IF_V4_MP_BASIC~DEFINE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 05.05.2019 22:01:30 in client 001
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - ZCL_ZDEMO_FILE_MPC_EXT
*&-----------------------------------------------------------------------------------------------*
  define_file( io_model ).
  endmethod.


  method DEFINE_FILE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 05.05.2019 22:01:30 in client 001
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - ZCL_ZDEMO_FILE_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
***********************************************************************************************************************************
*   ENTITY - file
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type( iv_entity_type_name = 'FILE' ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'file' ).                    "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'FILENAME' ). "#EC NOTEXT
 lo_property->set_edm_name( 'file_name' ).                  "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'FILEDATA' ). "#EC NOTEXT
 lo_property->set_edm_name( 'file_data' ).                  "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'FILESET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'file_set' ).                 "#EC NOTEXT
  endmethod.
ENDCLASS.
