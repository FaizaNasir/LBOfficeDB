CREATE PROCEDURE [dbo].[proc_Deal_Stage_Approval_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT DealApprovalID, 
               DealID, 
               tbl_DealStageApproval.ApprovedByID AS 'IndividualID', 
               IsActive, 
               CreatedDateTime, 
               ModifiedDateTime, 
               tbl_ContactIndividual.IndividualFullName, 
               RequestedStage, 
               CurrentStage, 
               IsApproved
        FROM tbl_DealStageApproval
             LEFT OUTER JOIN tbl_ContactIndividual ON tbl_DealStageApproval.ApprovedByID = tbl_ContactIndividual.IndividualID
        WHERE DealID = ISNULL(@DealID, DealID);
    END;
