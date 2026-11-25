CLASS zcl_vendor_rating DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_vendor_rating.
ENDCLASS.

CLASS zcl_vendor_rating IMPLEMENTATION.
  METHOD zif_vendor_rating~calculate_grade.
    IF iv_received <= 0.
      rv_grade = 'UNRATED'.
      RETURN.
    ENDIF.

    DATA(lv_pass_rate) = ( iv_accepted / iv_received ) * 100.

    IF lv_pass_rate >= 98.
      rv_grade = 'GRADE A'.
    ELSEIF lv_pass_rate >= 90.
      rv_grade = 'GRADE B'.
    ELSE.
      rv_grade = 'BLOCKED'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
