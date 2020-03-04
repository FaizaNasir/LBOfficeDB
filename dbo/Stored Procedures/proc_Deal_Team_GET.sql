CREATE PROCEDURE [dbo].[proc_Deal_Team_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT DealPartyID, 
               DealID, 
               tbl_DealTeam.IndividualID, 
               IsTeamLead, 
               CreationDate, 
               IsActive, 
               tbl_ContactIndividual.IndividualFullName
        FROM tbl_DealTeam
             LEFT OUTER JOIN tbl_ContactIndividual ON tbl_DealTeam.IndividualID = tbl_ContactIndividual.IndividualID
        WHERE DealID = ISNULL(@DealID, DealID);
    END;
