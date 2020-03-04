CREATE PROC [dbo].[SetIrrMultiplePortfolio]
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
              irrgross = @irrGross, 
              multiplegross = @multipleGross, 
              irrnet = @irrnet, 
              multiplenet = @multipleNet
        WHERE portfolioid = @portfolioid
              AND vehicleID = @vehicleID;
        SELECT 1 Result;
    END;
