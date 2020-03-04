CREATE PROCEDURE [dbo].[proc_Deal_Status_Details_Del] @DealStatusDetailsID INT
AS
     DECLARE @dealid INT;
     SELECT @dealid = dealid
     FROM tbl_DealStatusDetails
     WHERE DealStatusDetailsID = @DealStatusDetailsID;
     DELETE FROM tbl_DealStatusDetails
     WHERE DealStatusDetailsID = @DealStatusDetailsID;
     DECLARE @DealStageID INT, @ProjectStatusID INT;
     SELECT TOP 1 @DealStageID = DealStageID, 
                  @ProjectStatusID = ProjectStatusID
     FROM tbl_DealStatusDetails dsd
          JOIN tbl_DealStatus ds ON ds.ProjectStatusID = DealStatusID
     WHERE dsd.dealid = @dealid
     ORDER BY DealStatusDetailsID DESC;
     UPDATE tbl_Deals
       SET 
           DealStatusID =
     (
         SELECT TOP 1 DealStatusID
         FROM tbl_DealStatusDetails
         WHERE dealid = @DealID
         ORDER BY 1 DESC
     ), 
           DealStageID =
     (
         SELECT DealStageID
         FROM tbl_DealStatus
         WHERE ProjectStatusID =
         (
             SELECT TOP 1 DealStatusID
             FROM tbl_DealStatusDetails
             WHERE dealid = @DealID
             ORDER BY 1 DESC
         )
     )
     WHERE dealid = @dealid;
     SELECT 1;
