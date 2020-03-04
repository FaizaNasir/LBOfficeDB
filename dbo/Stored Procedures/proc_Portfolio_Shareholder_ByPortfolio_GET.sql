
/********************************************************************

** Name			    :	[proc_Portfolio_Shareholder_ByPortfolio_GET]

** Author			    :	Naveed Bashani

** Create Date		    :	2 Jan, 2014

** 

** Description / Page   :	Portfolio - Get shareholders by portfolio id

**

**

********************************************************************

** Change History

**

**      Date		    Author		Description	

** --   --------	    ------		------------------------------------

** 01   15 Mar, 2013    Zain Ali		Add @TargetPortfolioID

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_Shareholder_ByPortfolio_GET] --614,28         

@TargetPortfolioID INT = NULL, 
@FundID            INT = NULL
AS
    BEGIN
        SELECT

        --S.ShareholderID    

        p.PortfolioID AS 'ShareholderID', 
        S.ModuleID, 
        S.TargetPortfolioID 'ObjectID', 
        S.ObjectID 'TargetPortfolioID',
        CASE
            WHEN s.ModuleID = 4
            THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = S.ObjectID
        )
        END AS 'Individual Name',
        CASE
            WHEN s.ModuleID = 5
            THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = S.TargetPortfolioID
        )
        END + ' (' + STR(CAST(ROUND((dbo.[F_CapitalTable_NonDiluted](GETDATE(), p.PortfolioID, s.TargetPortfolioID, s.ObjectID, 5) * 100), 2) AS VARCHAR(1000)), 8, 2) + '%)' AS 'Company Name', 
        S.Active, 
        S.CreatedDateTime, 
        S.ModifiedDateTime, 
        S.CreatedBy, 
        S.ModifiedBy
        FROM tbl_Shareholders S
             INNER JOIN tbl_Portfolio p ON p.TargetPortfolioID = s.TargetPortfolioID
             INNER JOIN tbl_PortfolioVehicle pv ON pv.PortfolioID = p.PortfolioID
        WHERE S.ObjectID = ISNULL(@TargetPortfolioID, S.TargetPortfolioID)
              AND s.ModuleID = 5
              AND pv.VehicleID = @FundID;
    END;
