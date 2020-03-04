
/********************************************************************
** Name			    :	[proc_GetValuation_Report]
** Author			    :	Faisal Ashraf
** Create Date		    :	15 Oct, 2015
** 
** Description / Page   :	Portfolio - Valuation report SP
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

--proc_GetValuation_Report 66,663,'12/31/2016'           

CREATE PROC [dbo].[proc_GetValuation_Report]
(@vehicleID INT, 
 @companyID INT, 
 @Date      DATETIME
)
AS
     DECLARE @portfolioID INT;
     SET @portfolioID =
     (
         SELECT portfolioID
         FROM tbl_portfolio
         WHERE targetportfolioID = @companyID
     );
     SELECT TOP 1 pvm.ValuationMethodName, 
                  pvt.ValuationTypeName, 
                  pv.investmentvalue, 
                  pv.Notes, 
     (
         SELECT SUM(Amount)
         FROM tbl_PortfolioShareholdingOperations
         WHERE ToTypeID = 3
               AND ToID = @vehicleID
               AND PortfolioID = @portfolioID
               AND isConditional = 0
     ) +
     (
         SELECT SUM(ISNULL(pgo.amount, 0))
         FROM tbl_PortfolioGeneralOperation pgo
         WHERE pgo.FromModuleID = 3
               AND pgo.FromID = @vehicleID
               AND pgo.TypeID = 5
               AND pgo.PortfolioID = @portfolioID
               AND isConditional = 0
     ) AS 'Total invested amount',

                  --Appliedfigures,            
                  --CurrentEnterpriseValue,          
                  dbo.[F_Quartervariation](@vehicleID, @portfolioID, @Date) AS 'Quartervariation',

     --,dbo.[F_CapitalTable_NonDiluted](@Date,@portfolioID,@companyID,@vehicleID,3)    
                  (100 / NULLIF((dbo.[F_CapitalTable_NonDiluted](@Date, @portfolioID, @companyID, @vehicleID, 3)), 0)) * pv.investmentvalue AS CurrentEnterpriseValue
     FROM tbl_PortfolioValuation pv
          LEFT OUTER JOIN tbl_PortfolioValuationMethod pvm ON pv.methodid = pvm.ValuationMethodID
          LEFT OUTER JOIN tbl_PortfolioValuationType pvt ON pv.typeid = pvt.ValuationTypeID
     WHERE pv.vehicleid = @vehicleID
           AND portfolioid = @portfolioID
           AND DATE <= @Date
     ORDER BY date DESC;
