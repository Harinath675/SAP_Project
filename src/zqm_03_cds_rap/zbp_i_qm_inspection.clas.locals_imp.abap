CLASS lhc_inspection DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Inspection RESULT result.

    METHODS acceptStock FOR MODIFY
      IMPORTING keys FOR ACTION Inspection~acceptStock RESULT result.

    METHODS rejectVendor FOR MODIFY
      IMPORTING keys FOR ACTION Inspection~rejectVendor RESULT result.

    METHODS validateQuantities FOR VALIDATE ON SAVE
      IMPORTING keys FOR Inspection~validateQuantities.

    METHODS setVendorGrade FOR DETERMINE ON SAVE
      IMPORTING keys FOR Inspection~setVendorGrade.
ENDCLASS.

CLASS lhc_inspection IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validateQuantities.
    READ ENTITIES OF zi_qm_inspection IN LOCAL MODE
      ENTITY Inspection
      FIELDS ( ReceivedQty AcceptedQty RejectedQty ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_lots).

    LOOP AT lt_lots INTO DATA(ls_lot).
      IF ( ls_lot-AcceptedQty + ls_lot-RejectedQty ) <> ls_lot-ReceivedQty.
        APPEND VALUE #( %tky = ls_lot-%tky ) TO failed-inspection.
        APPEND VALUE #( %tky = ls_lot-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Accepted + Rejected Qty must equal Received Qty!' ) )
          TO reported-inspection.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setVendorGrade.
    READ ENTITIES OF zi_qm_inspection IN LOCAL MODE
      ENTITY Inspection
      FIELDS ( ReceivedQty AcceptedQty Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_lots).

    DATA(lo_grader) = NEW zcl_vendor_rating( ).
    DATA lt_update TYPE TABLE FOR UPDATE zi_qm_inspection.

    LOOP AT lt_lots INTO DATA(ls_lot).
      DATA(lv_grade) = lo_grader->zif_vendor_rating~calculate_grade(
                         iv_received = ls_lot-ReceivedQty
                         iv_accepted = ls_lot-AcceptedQty ).

      APPEND VALUE #( %tky        = ls_lot-%tky
                      VendorGrade = lv_grade
                      Status      = COND #( WHEN ls_lot-Status IS INITIAL THEN 'O' ELSE ls_lot-Status ) )
        TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF zi_qm_inspection IN LOCAL MODE
      ENTITY Inspection
      UPDATE FIELDS ( VendorGrade Status ) WITH lt_update.
  ENDMETHOD.

  METHOD acceptStock.
    MODIFY ENTITIES OF zi_qm_inspection IN LOCAL MODE
      ENTITY Inspection
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'A' ) ).

    READ ENTITIES OF zi_qm_inspection IN LOCAL MODE
      ENTITY Inspection ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_lots).

    result = VALUE #( FOR lot IN lt_lots ( %tky = lot-%tky %param = lot ) ).
  ENDMETHOD.

  METHOD rejectVendor.
    MODIFY ENTITIES OF zi_qm_inspection IN LOCAL MODE
      ENTITY Inspection
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN keys ( %tky = key-%tky Status = 'R' ) ).

    READ ENTITIES OF zi_qm_inspection IN LOCAL MODE
      ENTITY Inspection ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_lots).

    result = VALUE #( FOR lot IN lt_lots ( %tky = lot-%tky %param = lot ) ).
  ENDMETHOD.

ENDCLASS.
