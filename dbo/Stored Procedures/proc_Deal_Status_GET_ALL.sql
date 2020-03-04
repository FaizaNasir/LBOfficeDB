CREATE PROCEDURE [dbo].[proc_Deal_Status_GET_ALL]
AS
    BEGIN
        SELECT ProjectStatusID, 
               ProjectStatusTitle, 
               ProjectStatusDesc, 
               Active, 
               CreatedDateTime, 
               DealStageID, 
               DefaultStatusID, 
               dbo.tbl_DealStatus.Seq
        FROM tbl_DealStatus
        WHERE Active = 1
        ORDER BY seq ASC;
    END;
