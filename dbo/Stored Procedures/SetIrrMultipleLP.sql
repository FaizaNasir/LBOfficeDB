CREATE PROC [dbo].[SetIrrMultipleLP]
(@vehicleID     INT, 
 @objectid      INT, 
 @moduleID      INT, 
 @irrGross      DECIMAL(18, 6), 
 @multipleGross DECIMAL(18, 6), 
 @irrNet        DECIMAL(18, 6), 
 @multipleNet   DECIMAL(18, 6)
)
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_LpPerformance
            WHERE vehicleid = @vehicleid
                  AND moduleid = @moduleid
                  AND objectid = @objectid
        )
            BEGIN
                INSERT INTO tbl_LpPerformance
                (VehicleID, 
                 ModuleID, 
                 ObjectID, 
                 IRRNet, 
                 MultipleNet
                )
                       SELECT @vehicleid, 
                              @moduleid, 
                              @objectid, 
                              @irrNet, 
                              @multipleNet;
        END;
            ELSE
            BEGIN
                UPDATE tbl_LpPerformance
                  SET 
                      IRRGross = @irrGross, 
                      MultipleGross = @multipleGross, 
                      IRRNet = @irrnet, 
                      MultipleNet = @multipleNet
                WHERE vehicleID = @vehicleID
                      AND objectid = @objectid
                      AND moduleid = @moduleid;
        END;
        SELECT 1 Result;
    END;
