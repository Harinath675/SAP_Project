@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quality Inspection Interface View'
define root view entity ZI_QM_INSPECTION
  as select from zqm_inspection
{
  key lot_id          as LotId,
      shipment_id     as ShipmentId,
      vendor_id       as VendorId,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      received_qty    as ReceivedQty,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      accepted_qty    as AcceptedQty,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      rejected_qty    as RejectedQty,
      unit            as Unit,
      status          as Status,
      vendor_grade    as VendorGrade,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt
}
