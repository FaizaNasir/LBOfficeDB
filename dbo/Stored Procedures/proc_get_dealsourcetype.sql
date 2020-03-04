CREATE PROC [dbo].[proc_get_dealsourcetype]
AS
     SELECT DealSourceTypeID, 
            DealSourceTypeName, 
            createdDatetime, 
            ModifiedDateTime
     FROM tbl_DealSourceType;
