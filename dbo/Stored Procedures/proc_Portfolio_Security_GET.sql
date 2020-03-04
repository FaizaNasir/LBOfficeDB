
/********************************************************************
** Name			    :	[proc_Portfolio_Security_GET]
** Author			    :	Zain Ali
** Create Date		    :	1 Sep, 2014
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

CREATE PROCEDURE [dbo].[proc_Portfolio_Security_GET]
AS
    BEGIN
        SELECT PortfolioSecurityID, 
               Name
        FROM tbl_PortfolioSecurity;
    END;
