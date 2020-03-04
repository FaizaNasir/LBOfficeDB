
--[proc_IBMultiple]

CREATE PROCEDURE [dbo].[proc_IBMultiple]
AS
    BEGIN
        --DECLARE @companyID int = Null
        --set @companyID = (Select p.TargetPortfolioID from tbl_Portfolio p                              
        --where p.PortfolioID = @portfolioID)
        DECLARE @date DATETIME= NULL;
        SET @date =
        (
            SELECT GETDATE()
        );
        DECLARE @performance TABLE
        (PortfolioID     INT, 
         ID              INT, 
         Date            DATETIME, 
         amount          DECIMAL(18, 2), 
         Number          INT, 
         Category        VARCHAR(1000), 
         OperationTypeID INT, 
         Totypeid        INT, 
         FromTypeID      INT, 
         Cashout         DECIMAL(18, 2), 
         Cashin          DECIMAL(18, 2), 
         Type            VARCHAR(100)
        );
        DECLARE @cashin TABLE
        (cashin      DECIMAL(18, 2), 
         PortfolioID INT
        );
        DECLARE @cashout TABLE
        (Cashout     DECIMAL(18, 2), 
         PortfolioID INT
        );
        INSERT INTO @performance
        EXEC [dbo].[proc_BIPerformance] 
             28, 
             @date;
        INSERT INTO @cashin
               SELECT SUM(Cashin), 
                      PortfolioID
               FROM @performance
               GROUP BY PortfolioID;
        INSERT INTO @cashout
               SELECT SUM(Cashout), 
                      PortfolioID
               FROM @performance
               GROUP BY PortfolioID;

        --Select * from @cashin
        --Select * from @cashout

        SELECT p.TargetPortfolioID 'CompanyID', 
               ci.portfolioid, 
               ci.Cashin, 
               co.Cashout, 
        (
            SELECT TOP 1 pv.investmentvalue
            FROM tbl_PortfolioValuation pv
            WHERE pv.vehicleid = 28
                  AND DATE <= @date
                  AND pv.portfolioid = ci.portfolioid
            ORDER BY date DESC
        ) 'Last Valuation'
        FROM @cashin ci
             LEFT OUTER JOIN @cashout co ON ci.portfolioid = co.portfolioid
             INNER JOIN tbl_portfolio p ON ci.portfolioid = p.portfolioid;
    END;
