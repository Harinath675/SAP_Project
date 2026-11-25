@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quality Inspection Consumption View'
@Metadata.allowExtensions: true
define root view entity ZC_QM_INSPECTION
  provider contract transactional_query
  as projection on ZI_QM_INSPECTION
{
  key LotId,
      ShipmentId,
      VendorId,
      ReceivedQty,
      AcceptedQty,
      RejectedQty,
      Unit,
      Status,
      VendorGrade,
      LastChangedAt
}
