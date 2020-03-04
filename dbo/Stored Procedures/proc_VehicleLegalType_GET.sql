CREATE PROCEDURE [dbo].[proc_VehicleLegalType_GET]
AS
    BEGIN
        SELECT [LegalTypeVehicleID], 
               [LegalTypeVehicleName], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM [tbl_LegalTypeVehicle]
        WHERE Active = 1;
    END;
