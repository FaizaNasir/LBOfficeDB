CREATE PROCEDURE [dbo].[proc_VehicleEligibilityType_GET]
AS
    BEGIN
        SELECT [VehicleEligibilityTypeID], 
               [VehicleEligibilityTypeName], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM [tbl_VehicleEligibilityType]
        WHERE Active = 1;
    END;
