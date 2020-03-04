CREATE PROCEDURE [dbo].[proc_Vehicle_Activities_GET] @VehicleID INT = NULL
AS
    BEGIN
        SELECT VA.ActivityID, 
               A.ActiviteName, 
               VA.Active
        FROM tbl_VehicleActivity VA
             INNER JOIN tbl_Activities A ON A.ActiviteID = VA.ActivityID
        WHERE VA.vehicleid = @VehicleID;
    END;
