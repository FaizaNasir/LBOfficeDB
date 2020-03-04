CREATE PROC [dbo].[AssignPortfolioFunds]
(@vehicleID       INT, 
 @portfolioFundID INT
)
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_VehiclePortfolioFund
            WHERE VehicleID = @vehicleID
                  AND PortfolioFundID = @portfolioFundID
        )
            BEGIN
                INSERT INTO tbl_VehiclePortfolioFund
                (VehicleID, 
                 PortfolioFundID
                )
                       SELECT @vehicleID, 
                              @portfolioFundID;
        END;
        SELECT 1 Result;
    END;
