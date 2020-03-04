
/********************************************************************















** Name			    :	[proc_Portfolio_ShareholdingOperations_GET]















** Author			    :	Faisal Ashraf















** Create Date		    :	6 Aug, 2015















** 















** Description / Page   :	Portfolio - ShareHolding operation get















**















**















********************************************************************















** Change History















**















**      Date		    Author		Description	















** --   --------	    ------		------------------------------------















** 01   6 Aug, 2015	    Faisal Ashraf	















********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_ShareholdingOperations_GET] @ShareholdingOperationID INT = NULL
AS
    BEGIN
        SELECT psho.[ShareholdingOperationID], 
               psho.[PortfolioID], 
               psho.[Name], 
               psho.[Date], 
               psho.[Amount], 
               psho.[SecurityID], 
               psho.[Number], 
               psho.[FromID], 
               psho.[ToID], 
               psho.[FromTypeID], 
               psho.[ToTypeID], 
               psho.[isConditional], 
               psho.[isConversion], 
               psho.[DocumentID], 
               psho.[Notes], 
               psho.[Active], 
               psho.[CreatedDateTime], 
               psho.[ModifiedDateTime], 
               psho.[CreatedBy], 
               psho.[ModifiedBy], 
               psho.ReturnCapitalEUR, 
               psho.ReturnCapitalFx,
               CASE
                   WHEN FromTypeID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = psho.[FromID]
        )
               END AS 'From Individual Name',
               CASE
                   WHEN FromTypeID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = psho.[FromID]
        )
               END AS 'From Company Name',
               CASE
                   WHEN FromTypeID = 3
                   THEN
        (
            SELECT TOP 1 V.Name
            FROM [tbl_Vehicle] V
            WHERE V.VehicleID = psho.[FromID]
        )
               END AS 'From Fund Name',
               CASE
                   WHEN ToTypeID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = psho.[ToID]
        )
               END AS 'To Individual Name',
               CASE
                   WHEN ToTypeID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = psho.[ToID]
        )
               END AS 'To Company Name',
               CASE
                   WHEN ToTypeID = 3
                   THEN
        (
            SELECT TOP 1 V.Name
            FROM [tbl_Vehicle] V
            WHERE V.VehicleID = psho.[ToID]
        )
               END AS 'To Fund Name', 
               PS.Name AS 'Security Name', 
               psho.foreigncurrencyamount
        FROM [tbl_PortfolioShareholdingOperations] psho
             LEFT OUTER JOIN tbl_PortfolioSecurity PS ON PS.PortfolioSecurityID = psho.SecurityID
        WHERE ShareholdingOperationID = ISNULL(@ShareholdingOperationID, ShareholdingOperationID);
    END;
