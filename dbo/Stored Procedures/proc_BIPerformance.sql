
-- [proc_PortfolioPerformanceGet_Report] 574,28,'12/31/2015'                               

CREATE PROCEDURE [dbo].[proc_BIPerformance] @vehicleID INT, 
                                            @date      DATETIME
AS
    BEGIN                            
        --DECLARE @portfolioID int = Null                            
        DECLARE @targetTypeID INT= NULL;                            
        -- set @portfolioID = (Select p.PortfolioID from tbl_Portfolio p                              
        --where p.TargetPortfolioID = @companyID)                              
        SET @targetTypeID = 3;
        SELECT *, --, row_number() over (order by date) as ID                              
               CASE
                   WHEN OperationTypeID = 0
                        AND toTypeID = 3
                   THEN Amount
                   WHEN OperationTypeID IN(5)
                   THEN amount
                   WHEN OperationTypeID IN(6)
                   THEN(Amount * -1)
                   ELSE 0
               END AS 'CashOut',
               CASE
                   WHEN OperationTypeID = 0
                        AND (fromTypeID = 3
                             OR toTypeID = 5)
                   THEN Amount
                   WHEN OperationTypeID IN(1, 2, 3, 9, 10, 11)
                   THEN Amount
                   ELSE 0
               END AS 'CashIn',

               --,case when OperationTypeID <> 0 then ISNULL((select TypeName from tbl_PortfolioGeneralOperationType where TypeID = OperationTypeID),'')                                          
               -- else (select top 1 pst.PortfolioSecurityTypeName from tbl_PortfolioSecurity ps                             
               --      join tbl_PortfolioSecurityType pst                             
               --      on ps.PortfolioSecurityID = ID and                       
               --      ps.PortfolioSecurityTypeID = pst.PortfolioSecurityTypeID) end Type  
               CASE
                   WHEN FromTypeID = 0
                        AND ToTypeID = 3
                   THEN 'Capital increase'
                   WHEN FromTypeID <> 0
                        AND FromTypeID = 3
                   THEN 'Divestment'
                   WHEN FromTypeID = 3
                        AND ToTypeID <> 0
                   THEN 'Investment'
                   ELSE 'Investment'
               END Type
        FROM
        (
            SELECT s.PortfolioID, 
                   SecurityID ID, 
                   Date, 
                   amount Amount, 
                   Number, 
                   'ShareholdingOperations' AS Category, 
                   0 OperationTypeID, 
                   toTypeID, 
                   FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
            WHERE toTypeID = @targetTypeID
                  AND toid = @vehicleID
                  AND isConditional = 0
                  AND DATE <= @date
            UNION ALL
            SELECT s.PortfolioID, 
                   OperationID ID, 
                   date, 
                   amount, 
                   0, 
                   'GeneralOperation', 
                   TypeID, 
                   ToModuleID, 
                   FromModuleID
            FROM tbl_PortfolioGeneralOperation s
            WHERE fromModuleID = @targetTypeID
                  AND fromid = @vehicleID
                  AND isConditional = 0
                  AND DATE <= @date
            UNION ALL
            SELECT s.PortfolioID, 
                   SecurityID ID, 
                   date, 
                   amount, 
                   Number, 
                   'ShareholdingOperations', 
                   0, 
                   toTypeID, 
                   FromTypeID
            FROM tbl_PortfolioShareholdingOperations s
            WHERE fromTypeID = @targetTypeID
                  AND fromid = @vehicleID
                  AND isConditional = 0
                  AND DATE <= @date
            UNION ALL
            SELECT s.PortfolioID, 
                   OperationID ID, 
                   date, 
                   amount, 
                   0, 
                   'GeneralOperation', 
                   TypeID, 
                   ToModuleID, 
                   FromModuleID
            FROM tbl_PortfolioGeneralOperation s
            WHERE toModuleID = @targetTypeID
                  AND toid = @vehicleID
                  AND isConditional = 0
                  AND DATE <= @date
            UNION ALL

            --follow on payment           
            SELECT s.PortfolioID, 
                   s.SecurityID ID, 
                   pfp.Date, 
                   pfp.AmountDue Amount, 
                   0, 
                   'ShareholdingOperations' AS Category, 
                   0, 
                   s.toTypeID, 
                   0
            FROM tbl_PortfolioFollowOnPayment pfp
                 INNER JOIN tbl_PortfolioShareholdingOperations s ON s.ShareholdingOperationID = pfp.ShareholdingOperationID
            WHERE s.isConditional = 0
                  AND pfp.DATE <= @date
        ) t
        WHERE t.OperationTypeID NOT IN(4, 8);
    END; 
