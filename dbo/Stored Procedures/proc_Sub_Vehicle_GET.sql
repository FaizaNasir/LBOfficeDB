CREATE PROCEDURE [dbo].[proc_Sub_Vehicle_GET] @VehicleID INT
AS
    BEGIN
        SELECT [SubVehicleID], 
               [Name], 
               [Jurisdiction], 
               [Ratio], 
               [Hasitsowncallsdistributions], 
               [VehicleID], 
               [CreatedDateTime], 
               [CreatedBy], 
               [ModifiedDateTime], 
               [ModifiedBy], 
               [Active], 
               ISNULL(
        (
            SELECT IsRatioBasedOnCommitments
            FROM [tbl_VehicleManagement]
            WHERE VehicleID = @VehicleID
        ), 0) IsRatioBasedOnCommitments
        FROM [tbl_SubVehicles]
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);

        --ORDER BY Name asc      

    END;
