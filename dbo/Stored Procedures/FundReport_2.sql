
-- FundReport_2 29,'12-31-2016'

CREATE PROC [dbo].[FundReport_2]
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
                  AND sho.FromTypeID = 3
                  AND sho.Fromid = @fundID
                  AND sho.date > DATEADD(month, -6, @date)
        );
    END;
