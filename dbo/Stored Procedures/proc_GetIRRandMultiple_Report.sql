
/********************************************************************
** Name			    :	[proc_GetIRRandMultiple_Report]
** Author			    :	Faisal Ashraf
** Create Date		    :	22 Nov, 2015
** 
** Description / Page   :	Portfolio - IRR and Multiple for report generation
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

--[proc_GetIRRandMultiple_Report] 66,663    

CREATE PROC [dbo].[proc_GetIRRandMultiple_Report]
(@vehicleID INT, 
 @companyID INT
)
AS
     DECLARE @portfolioID INT;
     SET @portfolioID =
     (
         SELECT portfolioID
         FROM tbl_portfolio
         WHERE targetportfolioID = @companyID
     );
     DECLARE @cashout DECIMAL(18, 2);
     DECLARE @cashint DECIMAL(18, 2);
     DECLARE @tmp TABLE
     (isInclude               INT, 
      Date                    DATETIME, 
      Amount                  DECIMAL(18, 2), 
      Category                VARCHAR(MAX), 
      OperationTypeID         INT, 
      TotypeID                INT, 
      FromtypeID              INT, 
      PortfolioSecurityTypeID INT, 
      Type                    VARCHAR(MAX)
     );
     INSERT INTO @tmp
     EXEC [dbo].[proc_PortfolioPerformanceGet] 
          @portfolioID, 
          @vehicleID, 
          3, 
          NULL, 
          NULL;
     SET @cashout =
     (
         SELECT SUM(t.amount)
         FROM @tmp t
         WHERE t.Amount < 0
               AND t.Type <> 'Exit fees'
     );
     SET @cashint =
     (
         SELECT SUM(t.amount)
         FROM @tmp t
         WHERE t.Amount > 0
     );
     SELECT CAST(CAST(ROUND((@cashint / @cashout) * -1, 2) AS DECIMAL(18, 2)) AS VARCHAR(1000)) + 'x' Multiple;
