CREATE PROCEDURE [dbo].[proc_Commitment_GET] @FundID       INT = NULL, 
                                             @CommitmentID INT = NULL
AS
    BEGIN
        SELECT c.[CommitmentID], 
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
               END AS 'Individual Name',
               CASE
                   WHEN c.ModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = c.ObjectID
        )
               END AS 'Company Name', 
               c.[FundID], 
               c.[Notes], 
               c.[Active], 
               cfs.fundshareid, 
               fs.ShareName, 
               cfs.ShareAmount
        FROM [tbl_Commitment] c
             INNER JOIN tbl_CommitmentFundShare cfs ON cfs.CommitmentID = c.commitmentid
             INNER JOIN tbl_FundShare fs ON fs.FundShareID = cfs.fundshareid
        WHERE c.FundID = ISNULL(@FundID, c.FundID)
              AND c.CommitmentID = ISNULL(@CommitmentID, c.CommitmentID);
    END;
