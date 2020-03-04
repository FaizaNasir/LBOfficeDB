
/********************************************************************
** Name			    :	[proc_Portfolio_DealTeam_GET]
** Author			    :	Zain Ali
** Create Date		    :	29 Oct, 2014
** 
** Description / Page   :	Portfolio - Deal Team - Get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_DealTeam_GET] @PortfolioID INT = NULL
AS
    BEGIN
        SELECT pdt.[PortfolioDealTeamID], 
               pdt.[PortfolioID], 
               pdt.[ContactIndividualID], 
               pdt.[RoleID], 
               pdt.[Active], 
               pdt.[CreatedDateTime], 
               pdt.[ModifiedDateTime], 
               pdt.[CreatedBy], 
               pdt.[ModifiedBy], 
               ci.IndividualFullName, 
               ci.IndividualFirstName, 
               ci.IndividualLastName
        FROM [tbl_PortfolioDealTeam] pdt
             LEFT OUTER JOIN tbl_ContactIndividual ci ON pdt.ContactIndividualID = ci.IndividualID
        WHERE PortfolioID = ISNULL(@PortfolioID, PortfolioID);
    END;
