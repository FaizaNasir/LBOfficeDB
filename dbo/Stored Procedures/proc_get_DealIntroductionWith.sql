CREATE PROC [dbo].[proc_get_DealIntroductionWith]
AS
     SELECT DealIntroductionWithID, 
            DealIntroductionWithName, 
            createdDatetime, 
            ModifiedDateTime
     FROM tbl_DealIntroductionWith;
