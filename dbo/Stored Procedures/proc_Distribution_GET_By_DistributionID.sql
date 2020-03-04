CREATE PROCEDURE [dbo].[proc_Distribution_GET_By_DistributionID] @DistributionID INT = NULL
AS
    BEGIN
        SELECT s.Name, 
               s.NameFr, 
               s.DistributionID, 
               s.Date, 
               s.FundID, 
               s.Notes, 
               s.NotesFr, 
               s.TotalAmount, 
               s.PaidCarriedInterest, 
               s.PendingCarriedInterest, 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy, 
               S.IsApproved1, 
               replace(s.Log1, '.', '/') Log1, 
               S.IsApproved2, 
               replace(s.Log2, '.', '/') Log2, 
               RecallableDistributionAmount, 
               TotalValidationReq, 
               UserRole1, 
               UserRole2
        FROM tbl_Distribution S
        WHERE S.DistributionID = @DistributionID;
    END;
