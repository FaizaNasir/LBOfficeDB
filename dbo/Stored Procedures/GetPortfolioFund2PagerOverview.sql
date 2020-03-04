CREATE PROC [dbo].[GetPortfolioFund2PagerOverview]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT DISTINCT 
               b.CompanyName, 
               b.InvestmentDate Date, 
               BusinessAreaTitle Sector, 
			   BusinessAreaTitleFr SectorFr, 
               Invested / 1000000 Invested, 
               Proceeds / 1000000 Proceeds, 
               NAV / 1000000 NAV, 
               (ISNULL(Proceeds, 0) + ISNULL(NAV, 0)) / 1000000 TotalValue, 
               RemainingCommitment / 1000000 RemainingCommitment, 
               (CASE
                    WHEN ISNULL(Invested, 0) > 0
                    THEN(ISNULL(Proceeds, 0) + ISNULL(NAV, 0)) / Invested
                    ELSE 0
                END) / 1000000 Multiple,
               CASE
                   WHEN ISNULL(b.exitdate, 0) = 0
                   THEN 0
                   ELSE 1
               END IsExit, 
               a.IRR
        FROM tbl_PortfolioFundUnderlyingInvestments b
             LEFT JOIN tbl_PortfolioFundUnderlyingInvestmentsTrimester a ON a.PortfolioFundUnderlyingInvestmentsID = b.PortfolioFundUnderlyingInvestmentsID
             LEFT JOIN
        (
            SELECT
            (
                SELECT TOP 1 b.PortfolioFundUnderlyingInvestmentsTrimesterID
                FROM tbl_PortfolioFundUnderlyingInvestmentsTrimester b
                WHERE a.PortfolioFundUnderlyingInvestmentsID = b.PortfolioFundUnderlyingInvestmentsID
                      AND b.Date <= @date
                ORDER BY Date DESC
            ) PortfolioFundUnderlyingInvestmentsTrimesterID
            FROM tbl_PortfolioFundUnderlyingInvestments a
            WHERE vehicleid = @vehicleID
        ) t ON a.PortfolioFundUnderlyingInvestmentsTrimesterID = t.PortfolioFundUnderlyingInvestmentsTrimesterID
             LEFT JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = b.BusinessAreaID
        WHERE b.VehicleID = @vehicleID;
    END;
