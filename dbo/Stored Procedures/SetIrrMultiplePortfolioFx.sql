CREATE PROC [dbo].[SetIrrMultiplePortfolioFx]
(@portfolioID   INT, 
 @vehicleID     INT, 
 @irrGross      DECIMAL(18, 6), 
 @multipleGross DECIMAL(18, 6), 
 @irrNet        DECIMAL(18, 6), 
 @multipleNet   DECIMAL(18, 6)
)
AS
    BEGIN
        UPDATE tbl_portfoliovehicle
          SET 
              IRRGrossFX = @irrGross, 
              multiplegrossFx = @multipleGross, 
              IRRNetFX = @irrnet, 
              MultipleNetFX = @multipleNet
        WHERE portfolioid = @portfolioid
              AND vehicleID = @vehicleID;
        SELECT 1 Result;
    END;
