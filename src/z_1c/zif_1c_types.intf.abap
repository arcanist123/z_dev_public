INTERFACE zif_1c_types
  PUBLIC .

  TYPES:
    BEGIN OF t_document,
      date              TYPE string,
      time              TYPE string,
      knd               TYPE string,
      document_name     TYPE string,
      organisation_name TYPE string,
      document_meaning  TYPE string,
      function          TYPE string,
    END  OF t_document.
  TYPES:
    BEGIN OF t_info_edo_sender,
      inn               TYPE string,
      edo_id            TYPE string,
      organisation_name TYPE string,
    END OF t_info_edo_sender.
  TYPES:
    BEGIN OF t_document_info,
      sender_id       TYPE string,
      receiver_id     TYPE string,
      info_edo_sender TYPE t_info_edo_sender,
    END OF t_document_info.
  TYPES:
    BEGIN OF t_file,
      program_version TYPE string,
      form_version    TYPE string,
      file_id         TYPE string,
      document_into   TYPE t_document_info,
    END OF t_file.

ENDINTERFACE.
