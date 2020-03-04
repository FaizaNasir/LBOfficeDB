
/********************************************************************



** Name			    :	[proc_Report_Portfolio_ForeginCurrency]



** Author			    :	Naveed Bashani



** Create Date		    :	22 Dec, 2013



** 



** Description / Page   :	Portfolio - ForeginCurrency for report generation



**



**



********************************************************************



** Change History



**



**      Date		    Author		Description	



** --   --------	    ------		------------------------------------



** 01   22 Dec, 2013    Zain Ali		Add created date column



** 02   4 Jun, 2014	    Faisal ashraf	Add new parameters for portfolio id



********************************************************************/

--[proc_Report_Portfolio_ForeginCurrency]  '28,29'    

CREATE PROCEDURE [dbo].[proc_Report_Portfolio_ForeginCurrency] @FundID VARCHAR(100)
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

        --Select * from @vehicletmp  

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
         PortfolioID      INT
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
         Closing_Date     DATETIME, 
         Multiple         DECIMAL(18, 2), 
         PortfolioID      INT
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

                --Select @vehicleid  

                INSERT INTO @vehicleresult
                       SELECT *
                       FROM dbo.[F_PortfolioCal_ForeginCurrency](@vehicleid);
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
                          r.Closing_Date, 
                          (SUM(ISNULL(r.Divestment, 0)) + SUM(ISNULL(r.Last_Valuation, 0)) + SUM(ISNULL(r.Dividends, 0))) / NULLIF((SUM(ISNULL(r.Investment, 0)) + SUM(ISNULL(r.Acquisition_fees, 0))), 0) AS 'Multiple', 
                          r.PortfolioID
                   FROM @vehicleresult r
                   GROUP BY r.STATUS, 
                            r.CompanyContactid, 
                            r.Company_name, 
                            r.Industry, 
                            r.Sector, 
                            r.Closing_Date, 
                            r.PortfolioID

                   --order by r.Company_name asc 

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
                          '', 
                          (SUM(ISNULL(r.Divestment, 0)) + SUM(ISNULL(r.Last_Valuation, 0)) + SUM(ISNULL(r.Dividends, 0))) / NULLIF((SUM(ISNULL(r.Investment, 0)) + SUM(ISNULL(r.Acquisition_fees, 0))), 0) AS 'Multiple', 
                          r.PortfolioID
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
               [dbo].[F_ClosingDateMultipleFund](@FundID, PortfolioID) AS 'Closing_Date', 
               Multiple
        FROM @result;
    END;
