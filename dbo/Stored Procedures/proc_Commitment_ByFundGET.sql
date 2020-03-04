CREATE PROCEDURE [dbo].[proc_Commitment_ByFundGET]  --29     

@FundID INT = NULL
AS
    BEGIN
        SELECT c.[CommitmentID], 
               c.Date, 
               c.[SubscriptionPremium], 
               c.[ModuleID], 
               c.[ObjectID],
               CASE
                   WHEN c.ModuleID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = c.ObjectID
        )
                   WHEN c.ModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = c.ObjectID
        )
               END AS 'LPName', 
               c.[FundID], 
               c.[Notes], 
               c.[Active]
        FROM [tbl_Commitment] c
        WHERE c.FundID = ISNULL(@FundID, c.FundID);
    END;
