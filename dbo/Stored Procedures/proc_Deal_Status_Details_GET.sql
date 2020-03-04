CREATE PROCEDURE [dbo].[proc_Deal_Status_Details_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT DealStatusDetailsID, 
               DealID, 
               Validation, 
               DealStatusID, 
               ISNULL(DealStatusDateTime, GETDATE()) DealStatusDateTime, 
               DealStatusComments, 
               d.Active, 
               UserID, 
               CreateDateTime
        FROM tbl_DealStatusDetails ds
             JOIN tbl_DealStatus d ON ds.DealStatusID = d.ProjectStatusID
        WHERE ds.DealID = ISNULL(@DealID, ds.DealID)
              AND d.Active = 1;
    END;
