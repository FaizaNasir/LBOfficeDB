CREATE PROC [dbo].[proc_get_office]
AS
     SELECT OfficeID, 
            OfficeName, 
            CreatedDateTime, 
            ModifiedDateTime
     FROM tbl_Office;
