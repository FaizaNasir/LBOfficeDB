CREATE PROCEDURE [dbo].[proc_VehicleHeadquarter_GET]
AS
    BEGIN
        SELECT [VehicleHeadquarterID], 
               [VehicleHeadquarterName], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM [tbl_VehicleHeadquarter]
        WHERE Active = 1;
    END;
