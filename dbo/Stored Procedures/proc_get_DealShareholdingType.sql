CREATE PROC [dbo].[proc_get_DealShareholdingType]
AS
     SELECT DealShareholdingTypeID, 
            DealShareholdingTypeName, 
            createdDatetime, 
            ModifiedDateTime
     FROM tbl_DealShareholdingType;
