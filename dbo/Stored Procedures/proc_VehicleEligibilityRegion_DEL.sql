CREATE PROCEDURE [dbo].[proc_VehicleEligibilityRegion_DEL] @VehicleEligibilityID INT
AS
     DELETE FROM [tbl_VehicleEligibilityRegion]
     WHERE VehicleEligibilityID = @VehicleEligibilityID;
     SELECT 1 AS 'Result';
