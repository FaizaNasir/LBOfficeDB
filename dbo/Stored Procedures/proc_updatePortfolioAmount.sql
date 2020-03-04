CREATE PROC [dbo].[proc_updatePortfolioAmount]
(@portfolioID INT, 
 @fundiD      INT
)
AS
     DECLARE @PortfolioVehicleID INT;
    BEGIN
        UPDATE tbl_PortfolioVehicle
          SET 
              Amount =
        (
            SELECT SUM(Amount)
            FROM tbl_PortfolioShareholdingOperations
            WHERE ToTypeID = 3
                  AND ToID = @fundiD
                  AND PortfolioID = @portfolioID
        )
        WHERE PortfolioID = @portfolioID
              AND VehicleID = @fundiD;
        SET @PortfolioVehicleID = @@IDENTITY;
        SELECT 'Success' AS Result, 
               @PortfolioVehicleID AS 'PortfolioVehicleID';
    END;
