CREATE PROC [dbo].[UpdateFundNavPerShare]
(@fundID      INT, 
 @date        DATETIME, 
 @shareID     INT, 
 @NavPerShare DECIMAL(18, 10)
)
AS
    BEGIN
        DECLARE @ID INT;
        SET @ID =
        (
            SELECT TOP 1 vehicleNAVID
            FROM tbl_VehicleNav
            WHERE vehicleid = @fundID
                  AND NavDate = @date
            ORDER BY VehicleNavID DESC
        );
        IF @ID IS NOT NULL
            BEGIN
                UPDATE tbl_VehicleNavDetails
                  SET 
                      Undrawn = @NavPerShare
                WHERE VehicleNavID = @ID
                      AND shareid = @shareID;
        END;
        SELECT 1 Result;
    END;
