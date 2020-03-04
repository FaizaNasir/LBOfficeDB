
-- created by	:	syed zain ali
--

CREATE PROC [dbo].[proc_get_dealStage]
AS
     SELECT DealStageID, 
            DealStageTitle, 
            DealStageDecs, 
            Active, 
            CreatedDateTime
     FROM tbl_DealStages;
