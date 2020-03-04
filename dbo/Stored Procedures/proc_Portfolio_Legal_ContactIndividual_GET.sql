
/********************************************************************
** Name			    :	[proc_Portfolio_Legal_ContactIndividual_GET]
** Author			    :	Naveed Bashani
** Create Date		    :	22 Dec, 2013
** 
** Description / Page   :	Portfolio - Legal contact info get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_Legal_ContactIndividual_GET] @PortfolioLegalID INT = NULL
AS
    BEGIN
        SELECT plci.PortfolioLegalContactIndividualID, 
               plci.ContactIndividualID, 
               plci.PortfolioLegalID, 
               plci.Active, 
               plci.CreatedDateTime, 
               plci.ModifiedDateTime, 
               plci.CreatedBy, 
               plci.ModifiedBy, 
               ci.IndividualFullName
        FROM tbl_PortfolioLegalContactIndividual plci
             LEFT OUTER JOIN tbl_ContactIndividual ci ON plci.ContactIndividualID = ci.IndividualID
        WHERE PortfolioLegalID = ISNULL(@PortfolioLegalID, PortfolioLegalID);
    END;
