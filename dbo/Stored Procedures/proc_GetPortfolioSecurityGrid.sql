
/********************************************************************
** Name			    :	[proc_GetPortfolioSecurityGrid]
** Author			    :	Naveed Bashani
** Create Date		    :	12 Dec, 2013
** 
** Description / Page   :	Portfolio - Security Grid
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

--  proc_GetPortfolioSecurityGrid 1      

CREATE PROC [dbo].[proc_GetPortfolioSecurityGrid]
(@portfolioID     INT, 
 @SecurityGroupID INT
)
AS
     SELECT s.PortfolioSecurityID, 
            s.Name, 
            NominalValue, 
            PortfolioSecurityTypeName, 
            ISNULL(
     (
         SELECT SUM(NUMBER)
         FROM tbl_PortfolioShareholdingOperations ps
         WHERE ps.SecurityID = s.PortfolioSecurityID
               AND ps.PortfolioID = s.PortfolioID
               AND ps.FromID = -1
     ), 0) Number, 
            Notes, 
            s.PortfolioSecurityTypeID
     FROM tbl_PortfolioSecurity s
          JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = s.PortfolioSecurityTypeID
     WHERE SecurityGroupID = @SecurityGroupID
           AND portfolioid = @portfolioID;
