INTERFACE zif_vendor_rating PUBLIC.
  METHODS calculate_grade
    IMPORTING
      iv_received     TYPE p
      iv_accepted     TYPE p
    RETURNING
      VALUE(rv_grade) TYPE string.
ENDINTERFACE.
