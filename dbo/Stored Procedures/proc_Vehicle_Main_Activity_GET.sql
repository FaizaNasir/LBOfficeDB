CREATE PROCEDURE [dbo].[proc_Vehicle_Main_Activity_GET] --2

@VehicleID INT = NULL
AS
    BEGIN
        SELECT VA.ActivityID, 
               A.ActiviteName,

               --,V.MainActivity 'isMain',

               (CASE
                    WHEN V.MainActivity = A.ActiviteID
                    THEN 1
                    ELSE 0
                END) 'isMain'
        FROM tbl_VehicleActivity VA
             INNER JOIN tbl_Activities A ON A.ActiviteID = VA.ActivityID
             JOIN tbl_Vehicle V ON VA.VehicleID = V.VehicleID
        WHERE VA.vehicleid = @VehicleID;
    END;
