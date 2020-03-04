CREATE PROCEDURE [dbo].[proc_Deal_Stages_GET]
AS
    BEGIN
        SELECT [DealStageID], 
               [DealStageTitle], 
               [DealStageDecs], 
               [Active], 
               [CreatedDateTime]
        FROM tbl_DealStages;
    END;
