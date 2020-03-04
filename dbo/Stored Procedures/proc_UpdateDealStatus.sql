-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE PROCEDURE [dbo].[proc_UpdateDealStatus] @DealID INT
AS
    BEGIN
        UPDATE tbl_Deals
          SET 
              DealStatusID =
        (
            SELECT TOP 1 DealStatusID
            FROM tbl_DealStatusDetails
            WHERE dealid = @DealID
            ORDER BY DealStatusDetailsID DESC
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
                ORDER BY DealStatusDetailsID DESC
            )
        )
        WHERE dealid = @dealid;
        SELECT 1 Result;
    END;
