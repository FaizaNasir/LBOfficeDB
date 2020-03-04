
/********************************************************************
** Name			    :	proc_PortfolioValuationSecurity_GET
** Author			    :	Zain Ali
** Create Date		    :	21 Nov, 2014
** 
** Description / Page   :	Portfolio - Valuation popup - Security Grid
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

-- [proc_PortfolioValuationSecurity_GET] 20,1        

CREATE PROCEDURE [dbo].[proc_PortfolioValuationSecurity_GET]
(@PortfolioID INT = NULL, 
 @vehicleID   INT
)
AS
    BEGIN
        SELECT PortfolioSecurityID, 
               Name, 
               PortfolioSecurityTypeName, 
               SUM(ISNULL(Number, 0)) Stock, 
               '' Value
        FROM
        (
            SELECT s.Name, 
                   s.PortfolioSecurityID, 
            (
                SELECT PortfolioSecurityTypeName
                FROM tbl_PortfolioSecurityType a
                WHERE a.PortfolioSecurityTypeID = s.PortfolioSecurityTypeID
            ) PortfolioSecurityTypeName,
                   CASE
                       WHEN ToTypeID = 3
                            AND ToID = @vehicleID
                       THEN Number
                       WHEN FromTypeID = 3
                            AND FromID = @vehicleID
                       THEN-1 * Number
                   END Number
            FROM tbl_PortfolioSecurity s
                 JOIN tbl_portfolioshareholdingoperations sho ON sho.portfolioID = s.PortfolioID
                                                                 AND s.PortfolioSecurityID = sho.SecurityID
            WHERE s.PortfolioID = @PortfolioID
        ) t
        GROUP BY Name, 
                 PortfolioSecurityTypeName, 
                 PortfolioSecurityID;
    END; 
