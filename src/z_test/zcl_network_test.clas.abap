CLASS zcl_network_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*"* public components of class ZCL_CS2_COURSE_RPT_DYNP_CONT
*"* do not include other source files here!!!

    EVENTS display_student_registration .
    EVENTS display_course_prereqs .

    METHODS constructor .
    METHODS free_controls .
    METHODS pai
      IMPORTING
        !iv_ok_code TYPE syucomm .
    METHODS pbo .
*"* protected components of class ZCL_CS2_COURSE_RPT_DYNP_CONT
*"* do not include other source files here!!!
*"* protected components of class ZCL_CS2_COURSE_RPT_DYNP_CONT
*"* do not include other source files here!!!
  PROTECTED SECTION.
  PRIVATE SECTION.
*"* private components of class ZCL_CS2_COURSE_RPT_DYNP_CONT
*"* do not include other source files here!!!


    "! network of controls
    DATA go_network TYPE REF TO if_gui_rsgm_network.


    DATA gr_custom_container TYPE REF TO cl_gui_custom_container .



    METHODS _create_controls .

ENDCLASS.



CLASS ZCL_NETWORK_TEST IMPLEMENTATION.


  METHOD constructor.



  ENDMETHOD.                    "CONSTRUCTOR


  METHOD free_controls.


    CALL METHOD me->go_network->free_it.
    me->gr_custom_container->free( ).
    CLEAR me->gr_custom_container.

  ENDMETHOD.                    "free_controls


  METHOD pai.

    CASE iv_ok_code.
      WHEN 'DSPREG'.
        RAISE EVENT display_student_registration.
      WHEN 'DSPPREQ'.
        RAISE EVENT display_course_prereqs.
    ENDCASE.

  ENDMETHOD.                    "pai


  METHOD pbo.

    IF me->gr_custom_container IS INITIAL.
      me->_create_controls( ).
    ENDIF.

  ENDMETHOD.                    "PBO


  METHOD _create_controls.
    DATA: ls_key      TYPE salv_s_layout_key,
          lo_table_01 TYPE REF TO if_rsnetgraphic_table.

    CREATE OBJECT me->gr_custom_container
      EXPORTING
        container_name = 'CONTAINER'.


    "now initialize the network
    CALL METHOD cl_gui_rsgm_network=>get_network_object
      EXPORTING
        i_r_parent  = me->gr_custom_container   " Abstract Container for GUI Controls
*       i_lifetime  = CNTL_LIFETIME_IMODE
*       i_shellstyle   =
*       i_t_events  =
*       i_s_ctxmnu_use =     " Required Context Menus
      IMPORTING
        e_r_netplan = go_network.     " Returns Reference to a Network Object

*        DATA lo_table TYPE REF TO string.
    DATA ls_node1_coordinates TYPE rsng_s_pos.
    ls_node1_coordinates-toppos = 10.
    ls_node1_coordinates-leftpos = 10.
    ls_node1_coordinates-rightpos = 50.
    ls_node1_coordinates-bottompos = 50.
    CALL METHOD go_network->add_node_to_network
      EXPORTING
        i_icon       = '@08@'   " Size Icon
*       i_s_icons    =     " Icon bar
        i_desc       = 'NODE1'    " Description
        i_name       = 'NODE1'        " Technical Name
        i_s_position = ls_node1_coordinates " X/Y Position of the Node
      IMPORTING
        e_r_table    = lo_table_01.     " Reference to a Generated Table Object in the Network

    DATA ls_node2_coordinates TYPE rsng_s_pos.
    ls_node2_coordinates-toppos = 110.
    ls_node2_coordinates-leftpos = 110.
    ls_node2_coordinates-rightpos = 150.
    ls_node2_coordinates-bottompos = 150.

    CALL METHOD go_network->add_node_to_network
      EXPORTING
        i_icon       = '@08@'     " Size Icon
**                i_s_icons    =     " Icon bar
        i_desc       = 'NODE2'        " Description
        i_name       = 'NODE2'            " Technical Name
        i_s_position = ls_node2_coordinates  " X/Y Position of the Node
      IMPORTING
        e_r_table    = DATA(lo_table_02).    " Reference to a Generated Table Object in the Network

    CALL METHOD go_network->add_link_to_network
      EXPORTING
        i_r_table_source = lo_table_01    " Reference to Start Node
        i_r_table_target = lo_table_02     " Reference to Target Nodes
*       i_icon           =     " Icon on the Link
*       i_style          =     " Style (Color, Line Thickness...)
*       i_tooltip        =     " Tooltip Text
      IMPORTING
        r_r_link         = DATA(lo_link).     " Reference to Link
    go_network->arrange_objects( ).
    go_network->send_data_to_frontend( ).




  ENDMETHOD.                    "create_controls
ENDCLASS.
