CREATE PROCEDURE [dbo].[proc_Report_Portfolio]
(@FundID VARCHAR(100), 
 @Date   DATETIME
)
AS
    BEGIN
        DECLARE @vehicletmp TABLE
        (ID        INT IDENTITY(1, 1), 
         vehicleid INT
        );
        INSERT INTO @vehicletmp
               SELECT *
               FROM dbo.[SplitCSV](@FundID, ',');
        DECLARE @vehicleid INT;
        DECLARE @count INT;
        SET @count = 1;
        DECLARE @vehicleresult TABLE
        (STATUS           INT, 
         vehicleid        INT, 
         Fundname         VARCHAR(100), 
         CompanyContactid INT, 
         Company_name     VARCHAR(MAX), 
         Industry         VARCHAR(MAX), 
         Sector           VARCHAR(MAX), 
         Closing_Date     DATETIME, 
         Investment       DECIMAL(18, 2), 
         Divestment       DECIMAL(18, 2), 
         Last_Valuation   DECIMAL(18, 2), 
         Dividends        DECIMAL(18, 2), 
         Acquisition_fees DECIMAL(18, 2), 
         SPVFees          DECIMAL(18, 2), 
         ManagementFees   DECIMAL(18, 2), 
         PortfolioID      INT, 
         FX_Hedging_Gain  DECIMAL(18, 2), 
         FX_Hedging_Loss  DECIMAL(18, 2)
        );
        DECLARE @result TABLE
        (STATUS           INT, 
         CompanyContactid INT, 
         Company_name     VARCHAR(MAX), 
         Industry         VARCHAR(MAX), 
         Sector           VARCHAR(MAX), 
         Investment       DECIMAL(18, 2), 
         Divestment       DECIMAL(18, 2), 
         Last_Valuation   DECIMAL(18, 2), 
         Dividends        DECIMAL(18, 2), 
         Acquisition_fees DECIMAL(18, 2), 
         SPVFees          DECIMAL(18, 2), 
         ManagementFees   DECIMAL(18, 2), 
         Closing_Date     DATETIME, 
         Multiple         DECIMAL(18, 2), 
         PortfolioID      INT, 
         FX_Hedging_Gain  DECIMAL(18, 2), 
         FX_Hedging_Loss  DECIMAL(18, 2)
        );
        WHILE(@count) <=
        (
            SELECT COUNT(vehicleid)
            FROM @vehicletmp
        )
            BEGIN
                SET @vehicleid =
                (
                    SELECT vehicleid
                    FROM @vehicletmp
                    WHERE id = @count
                );
                INSERT INTO @vehicleresult
                       SELECT *
                       FROM dbo.[F_PortfolioCal](@vehicleid, @Date);
                SET @count = @count + 1;
            END;
        INSERT INTO @result
               SELECT *
               FROM
               (
                   SELECT r.STATUS, 
                          r.CompanyContactid, 
                          r.Company_name, 
                          r.Industry, 
                          r.Sector, 
                          SUM(r.Investment) AS 'Investment', 
                          SUM(r.Divestment) AS 'Divestment', 
                          SUM(r.Last_Valuation) AS 'Last_Valuation', 
                          SUM(r.Dividends) AS 'Dividends', 
                          SUM(r.Acquisition_fees) AS 'Acquisition_fees', 
                          SUM(r.SPVFees) AS 'SPVFees', 
                          SUM(r.ManagementFees) AS 'ManagementFees', 
                          r.Closing_Date, 
                          (SUM(ISNULL(r.Divestment, 0)) + SUM(ISNULL(r.Last_Valuation, 0)) + SUM(ISNULL(r.FX_Hedging_Gain, 0)) + SUM(ISNULL(r.Dividends, 0))) / NULLIF((SUM(ISNULL(r.Investment, 0)) + SUM(ISNULL(r.Acquisition_fees, 0)) + SUM(ISNULL(r.SPVFees, 0)) + SUM(ISNULL(r.FX_Hedging_Loss, 0)) + SUM(ISNULL(r.ManagementFees, 0))), 0) AS 'Multiple', 
                          r.PortfolioID, 
                          SUM(r.FX_Hedging_Gain) AS 'FX_Hedging_Gain', 
                          SUM(r.FX_Hedging_Loss) AS 'FX_Hedging_Loss'
                   FROM @vehicleresult r
                   GROUP BY r.STATUS, 
                            r.CompanyContactid, 
                            r.Company_name, 
                            r.Industry, 
                            r.Sector, 
                            r.Closing_Date, 
                            r.PortfolioID
                   UNION ALL
                   SELECT r.STATUS, 
                          r.CompanyContactid, 
                          r.Company_name, 
                          r.Industry, 
                          r.Sector, 
                          SUM(r.Investment) AS 'Investment', 
                          SUM(r.Divestment) AS 'Divestment', 
                          SUM(r.Last_Valuation) AS 'Last_Valuation', 
                          SUM(r.Dividends) AS 'Dividends', 
                          SUM(r.Acquisition_fees) AS 'Acquisition_fees', 
                          SUM(r.SPVFees) AS 'SPVFees', 
                          SUM(r.ManagementFees) AS 'ManagementFees', 
                          '', 
                          (SUM(ISNULL(r.Divestment, 0)) + SUM(ISNULL(r.Last_Valuation, 0)) + SUM(ISNULL(r.FX_Hedging_Gain, 0)) + SUM(ISNULL(r.Dividends, 0))) / NULLIF((SUM(ISNULL(r.Investment, 0)) + SUM(ISNULL(r.Acquisition_fees, 0)) + SUM(ISNULL(r.SPVFees, 0)) + SUM(ISNULL(r.FX_Hedging_Loss, 0)) + SUM(ISNULL(r.ManagementFees, 0))), 0) AS 'Multiple', 
                          r.PortfolioID, 
                          SUM(r.FX_Hedging_Gain) AS 'FX_Hedging_Gain', 
                          SUM(r.FX_Hedging_Loss) AS 'FX_Hedging_Loss'
                   FROM @vehicleresult r
                   GROUP BY r.STATUS, 
                            r.CompanyContactid, 
                            r.Company_name, 
                            r.Industry, 
                            r.Sector, 
                            r.PortfolioID
               ) t
               WHERE t.Closing_Date = '1900-01-01 00:00:00.000'
               ORDER BY t.Company_name ASC;
        SELECT STATUS, 
               CompanyContactid, 
               Company_name, 
               Industry, 
               Sector, 
               Investment, 
               Divestment, 
               Last_Valuation, 
               Dividends, 
               Acquisition_fees, 
               SPVFees, 
               ManagementFees, 
               FX_Hedging_Gain, 
               FX_Hedging_Loss, 
               [dbo].[F_ClosingDateMultipleFund](@FundID, PortfolioID) AS 'Closing_Date', 
               Multiple
        FROM @result
        WHERE STATUS IN(4, 1);
    END;
