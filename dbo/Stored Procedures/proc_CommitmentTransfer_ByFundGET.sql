CREATE PROCEDURE [dbo].[proc_CommitmentTransfer_ByFundGET]  --29     

@FundID INT = NULL
AS
    BEGIN
        SELECT c.[CommitmentTransferID], 
               c.Date, 
               c.[SubscriptionPremium], 
               c.[FromModuleID], 
               c.[FromObjectID],
               CASE
                   WHEN c.FromModuleID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = c.FromObjectID
        )
                   WHEN c.FromModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = c.FromObjectID
        )
               END AS 'From LPName', 
               c.[ToModuleID], 
               c.[ToObjectID],
               CASE
                   WHEN c.ToModuleID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = c.ToObjectID
        )
                   WHEN c.ToModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = c.ToObjectID
        )
               END AS 'To LPName', 
               c.[FundID], 
               c.[Notes], 
               c.[Active]
        FROM [tbl_CommitmentTransfer] c
        WHERE c.FundID = ISNULL(@FundID, c.FundID);
    END;
