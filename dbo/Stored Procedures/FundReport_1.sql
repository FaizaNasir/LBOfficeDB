
-- FundReport_1 29,'12-31-2016'

CREATE PROC [dbo].[FundReport_1]
(@fundID INT, 
 @date   DATETIME
)
AS
    BEGIN
        SELECT pv.PortfolioID
        FROM tbl_portfoliovehicle pv
        WHERE pv.vehicleID = @fundID
              AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioShareholdingOperations sho
                 JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = sho.SecurityID
            WHERE sho.PortfolioID = pv.portfolioid
                  AND ps.PortfolioSecurityTypeID <> 11
                  AND sho.ToTypeID = 3
                  AND sho.toid = @fundID
                  AND sho.date > DATEADD(month, -6, @date)
        );
    END;
