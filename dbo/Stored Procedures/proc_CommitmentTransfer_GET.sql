CREATE PROCEDURE [dbo].[proc_CommitmentTransfer_GET] @FundID               INT = NULL, 
                                                     @CommitmentTransferID INT = NULL
AS
    BEGIN
        SELECT c.[CommitmentTransferID], 
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
               END AS 'From Individual Name',
               CASE
                   WHEN c.FromModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = c.FromObjectID
        )
               END AS 'From Company Name', 
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
               END AS 'To Individual Name',
               CASE
                   WHEN c.ToModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = c.ToObjectID
        )
               END AS 'To Company Name', 
               c.[FundID], 
               c.[Notes], 
               c.[Active], 
               cfs.fundshareid, 
               fs.ShareName, 
               cfs.ShareAmount
        FROM [tbl_CommitmentTransfer] c
             INNER JOIN tbl_CommitmentFundShare cfs ON cfs.CommitmentID = c.commitmentTransferid
             INNER JOIN tbl_FundShare fs ON fs.FundShareID = cfs.fundshareid
        WHERE c.FundID = ISNULL(@FundID, c.FundID)
              AND c.CommitmentTransferID = ISNULL(@CommitmentTransferID, c.CommitmentTransferID);
    END;
