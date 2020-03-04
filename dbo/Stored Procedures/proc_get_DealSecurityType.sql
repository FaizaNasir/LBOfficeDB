CREATE PROC [dbo].[proc_get_DealSecurityType]
AS
     SELECT DealSecurityTypeID, 
            DealSecurityTypeName, 
            createdDatetime, 
            ModifiedDateTeime
     FROM tbl_DealSecurityType;
