CREATE PROCEDURE [dbo].[proc_Get_FundTeams] @FundID            INT = NULL, 
                                            @FundTeamType      INT = NULL, 
                                            @FundTeamMembersID INT = NULL
AS
    BEGIN
        SELECT [FundTeamMembersID], 
               [FundID], 
               i.[CompanyContactID], 
               CompanyName, 
               CI.IndividualFullName, 
               [IndividualContactID], 
               [FundTeamType], 
               ISNULL([IsInvestmentCommitteeMember], 0) IsInvestmentCommitteeMember, 
               [Role], 
               [MandateDate], 
               [EndDate], 
               [Comments]
        FROM [tbl_FundTeamMembers] AS I
             INNER JOIN tbl_CompanyContact AS C ON I.CompanyContactID = C.CompanyContactID
             INNER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = I.IndividualContactID
        WHERE I.FundTeamType = ISNULL(@FundTeamType, I.FundTeamType)
              AND i.FundID = @FundID
              AND i.FundTeamMembersID = ISNULL(@FundTeamMembersID, i.FundTeamMembersID);
    END;
