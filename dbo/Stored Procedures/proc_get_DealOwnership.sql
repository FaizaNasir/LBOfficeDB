CREATE PROC [dbo].[proc_get_DealOwnership]
AS
     SELECT DealOwnershipID, 
            DealOwnershipName, 
            createdDatetime, 
            ModifiedDateTime
     FROM tbl_DealOwnership;
