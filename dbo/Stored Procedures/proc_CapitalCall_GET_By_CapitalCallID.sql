CREATE PROCEDURE [dbo].[proc_CapitalCall_GET_By_CapitalCallID] @CapitalCallID INT = NULL
AS
    BEGIN
        SELECT s.CallName, 
               s.CallNameFr, 
               s.CapitalCallID, 
               s.DueDate, 
               s.FundID, 
               s.Notes, 
               s.NotesFr, 
               s.TotalAmount, 
               s.IsBreakDown, 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy, 
               S.CallDate, 
               s.ClosingID, 
               IsApproved1, 
               s.Log1, 
               s.IsApproved2, 
               s.Log2, 
               TotalValidationReq, 
               UserRole1, 
               UserRole2
        FROM tbl_CapitalCall S
        WHERE S.CapitalCallID = @CapitalCallID;
    END;
