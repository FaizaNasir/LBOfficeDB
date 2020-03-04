CREATE PROC [dbo].[GetVehicleReport](@vehicleID INT)
AS
    BEGIN
        SELECT VehicleReportID, 
               VehicleID, 
               Date, 
               Report, 
               Notes, 
               Active, 
               CreatedBy, 
               CreatedDateTime, 
               ModifiedBy, 
               ModifiedDateTime, 
               IsApproved1, 
               Log1, 
               IsApproved2, 
               Log2, 
               PortfolioCsv, 
               TotalValidationReq, 
               UserRole1, 
               UserRole2, 
               Lang
        FROM tbl_VehicleReport
        WHERE vehicleID = @vehicleID
        ORDER BY Date DESC;
    END;
