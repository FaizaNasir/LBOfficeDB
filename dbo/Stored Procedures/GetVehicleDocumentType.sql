CREATE PROC [dbo].[GetVehicleDocumentType](@vehicleID INT)
AS
    BEGIN
        SELECT vdt.VehicleDocumentTypeID, 
               vdt.VehicleID, 
               vdt.DocumentTypeID, 
               ISNULL(vdt.RequireApproval1, 0) RequireApproval1, 
               vdt.RoleName1, 
               ISNULL(vdt.RequireApproval2, 0) RequireApproval2, 
               vdt.RoleName2, 
               vdt.Active, 
               vdt.CreatedDate, 
               vdt.ModifiedDate, 
               vdt.CreatedBy, 
               vdt.ModifiedBy, 
               dt.DocumentTypeName
        FROM tbl_VehicleDocumentType vdt
             JOIN tbl_documenttype dt ON dt.documenttypeID = vdt.documenttypeID
        WHERE vehicleID = @vehicleID
              AND vdt.active = 1
              AND dt.active = 1;
    END;
