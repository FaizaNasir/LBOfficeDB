
/********************************************************************
** Name			    :	[proc_PortfolioSecurity_GET]
** Author			    :	Zain Ali
** Create Date		    :	10 Jun, 2014
** 
** Description / Page   :	Portfolio - Security Get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_PortfolioSecurity_GET] @PortfolioSecurityID INT = NULL, 
                                                    @PortfolioID         INT = NULL
AS
    BEGIN
        SELECT PortfolioSecurityID, 
               PortfolioID, 
               Name, 
               PortfolioSecurityTypeID, 
        (
            SELECT PortfolioSecurityTypeName
            FROM tbl_PortfolioSecurityType a
            WHERE a.PortfolioSecurityTypeID = s.PortfolioSecurityTypeID
        ) PortfolioSecurityTypeName, 
               NominalValue, 
               ConversionRatio, 
               VotingRatio, 
               LimitDate, 
        (
            SELECT name
            FROM tbl_PortfolioSecurity t
            WHERE t.PortfolioSecurityID = s.PortfolioSecurityID
        ) BasedOnName, 
               BasedOn, 
               Notes, 
               ISIN, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_PortfolioSecurity s
        WHERE PortfolioSecurityID = ISNULL(@PortfolioSecurityID, PortfolioSecurityID)
              AND PortfolioID = @PortfolioID;
    END;
