
-- created by : Syed Zain ALi                     
-- [proc_PortfolioPerformanceGet] 1,28,4                     

CREATE PROCEDURE [dbo].[proc_PortfolioPerformanceGettest] @targetID     INT, 
                                                          @targetTypeID INT
AS
    BEGIN
        DECLARE @tblvaluation TABLE
        (PortfolioID INT, 
         date        DATETIME, 
         Amount      DECIMAL(18, 2), 
         Type        VARCHAR(100)
        );
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_portfolio p
                 JOIN tbl_portfoliovehicle pv ON p.PortfolioID = pv.PortfolioID
            WHERE pv.VehicleID = @targetID
                  AND pv.[Status] IN(1, 2)
        )
            BEGIN
                SET NOCOUNT ON;
                INSERT INTO @tblvaluation
                       SELECT p.PortfolioID, 
                              ISNULL(
                       (
                           SELECT TOP 1 Date
                           FROM tbl_PortfolioValuation
                           WHERE portfolioid = pv.portfolioid
                                 AND VehicleID = pv.VehicleID
                           ORDER BY Date DESC
                       ), 0), 
                              ISNULL(
                       (
                           SELECT TOP 1 InvestmentValue
                           FROM tbl_PortfolioValuation
                           WHERE portfolioid = pv.PortfolioID
                                 AND VehicleID = pv.VehicleID
                           ORDER BY Date DESC
                       ), 0), 
                              'Valuation'
                       FROM tbl_portfolio p
                            JOIN tbl_portfoliovehicle pv ON p.PortfolioID = pv.PortfolioID
                       WHERE pv.[Status] IN(1, 2)
                            AND pv.VehicleID = @targetID
                            AND EXISTS
                       (
                           SELECT TOP 1 1
                           FROM tbl_PortfolioValuation pval
                           WHERE pval.PortfolioID = pv.PortfolioID
                                 AND pval.VehicleID = pv.VehicleID
                                 AND ISNULL(pval.Active, 1) = 1
                       );
                SET NOCOUNT OFF;
        END;
        SELECT *,
               CASE
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 0
                        AND ToTypeID = 3
                   THEN 'Capital increase'
                   WHEN OperationTypeID = 0
                        AND FromTypeID <> 0
                        AND FromTypeID = 3
                   THEN 'Divestment'
                   WHEN OperationTypeID = 0
                        AND FromTypeID = 3
                        AND ToTypeID <> 0
                   THEN 'Investment'
                   WHEN OperationTypeID <> 0
                   THEN ISNULL(
        (
            SELECT TypeName
            FROM tbl_PortfolioGeneralOperationType
            WHERE TypeID = OperationTypeID
        ), '')
                   WHEN OperationTypeID = 0
                        AND Category = 'Valuation'
                   THEN 'Last valuation'
                   ELSE ''
               END Type
        FROM
        (
            SELECT PortfolioID, 
                   Date, 
                   -1 * amount Amount, 
                   'ShareholdingOperations' AS Category, 
                   0 OperationTypeID, 
                   toTypeID, 
                   FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
            WHERE toTypeID = @targetTypeID
                  AND toid = @targetID                    
            --and portfolioid = ISNULL(@portfolioID,portfolioid)                    

            UNION ALL
            SELECT PortfolioID, 
                   date, 
                   -1 * amount, 
                   'GeneralOperation', 
                   TypeID, 
                   ToModuleID, 
                   FromModuleID
            FROM tbl_PortfolioGeneralOperation s
            WHERE fromModuleID = @targetTypeID
                  AND fromid = @targetID                    
            --and portfolioid = ISNULL(@portfolioID,portfolioid)                    

            UNION ALL
            SELECT PortfolioID, 
                   date, 
                   amount, 
                   'ShareholdingOperations', 
                   0, 
                   toTypeID, 
                   FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
            WHERE fromTypeID = @targetTypeID
                  AND fromid = @targetID                    
            --and portfolioid = ISNULL(@portfolioID,portfolioid)                    

            UNION ALL
            SELECT PortfolioID, 
                   date, 
                   amount, 
                   'GeneralOperation', 
                   TypeID, 
                   ToModuleID, 
                   FromModuleID
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = @targetTypeID
                  AND toid = @targetID                    
            --and portfolioid = ISNULL(@portfolioID,portfolioid)                    

            UNION ALL
            SELECT *, 
                   0, 
                   0, 
                   0
            FROM @tblvaluation
        ) t;
    END;
