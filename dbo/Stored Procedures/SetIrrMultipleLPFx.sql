CREATE PROC [dbo].[SetIrrMultipleLPFx]
(@vehicleID     INT, 
 @LPID          INT, 
 @irrGross      DECIMAL(18, 6), 
 @multipleGross DECIMAL(18, 6), 
 @irrNet        DECIMAL(18, 6), 
 @multipleNet   DECIMAL(18, 6)
)
AS
    BEGIN
        --UPDATE tbl_LpPerformance
        --  SET
        --      IRRGrossFX = @irrGross,
        --      MultipleGrossFX = @multipleGross,
        --      IRRNetFX = @irrnet,
        --      MultipleNetFX = @multipleNet
        --WHERE vehicleID = @vehicleID
        --      AND LPID = @LPID;
        SELECT 1 Result;
    END;
