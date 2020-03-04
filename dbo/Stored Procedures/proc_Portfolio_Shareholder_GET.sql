
/********************************************************************
** Name			    :	[proc_Portfolio_Shareholder_GET]
** Author			    :	Zain Ali
** Create Date		    :	8 Apr, 2014
** 
** Description / Page   :	Portfolio - ShareHolder get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
** 01   18 Apr, 2014    Zain Ali		Column individual name has been added
********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_Shareholder_GET] @TargetPortfolioID INT = NULL
AS
    BEGIN
        SELECT S.ShareholderID, 
               S.ModuleID, 
               S.ObjectID, 
               S.TargetPortfolioID,
               CASE
                   WHEN ModuleID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = S.ObjectID
        )
               END AS 'Individual Name',
               CASE
                   WHEN ModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = S.ObjectID
        )
               END AS 'Company Name', 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy
        FROM tbl_Shareholders S
        WHERE S.TargetPortfolioID = ISNULL(@TargetPortfolioID, S.TargetPortfolioID);
    END;
