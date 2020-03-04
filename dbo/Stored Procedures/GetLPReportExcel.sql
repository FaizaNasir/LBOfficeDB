CREATE PROC [dbo].[GetLPReportExcel](@vehicleID INT)
AS
    BEGIN
        SELECT v.Name VehicleName, 
               dbo.F_GetObjectName(lpr.ModuleID, lpr.ObjectID) ObjectName, 
               lpr.ModuleID, 
               lpr.ObjectID, 
               dt.DocumentTypeName, 
               lpr.DocumentTypeID, 
               cc.CallName, 
               cc.CallDate, 
               cc.Log1, 
               cc.Log2, 
               lpr.ReportLocation, 
               lpr.PdfLocation, 
               cc.TotalValidationReq, 
               cc.UserRole1, 
               cc.UserRole2
        FROM tbl_lpreport lpr
             JOIN tbl_vehicle v ON v.VehicleID = lpr.vehicleid
             JOIN tbl_DocumentType dt ON dt.DocumentTypeID = lpr.DocumentTypeID
             JOIN tbl_CapitalCall cc ON cc.CapitalCallID = lpr.ContextID
        WHERE lpr.DocumentTypeID = 1
              AND lpr.VehicleID = ISNULL(@vehicleID, lpr.VehicleID)
        ORDER BY objectname;
    END;
