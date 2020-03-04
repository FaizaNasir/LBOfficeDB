CREATE PROCEDURE [dbo].[proc_Fund_Report_GET]
AS
    BEGIN
        SELECT VehicleID, 
               Name
        FROM tbl_Vehicle
        WHERE Active = 1;
    END;
