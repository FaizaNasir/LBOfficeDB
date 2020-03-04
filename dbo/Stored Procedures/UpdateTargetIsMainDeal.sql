CREATE PROC [dbo].[UpdateTargetIsMainDeal]
(@dealID   INT, 
 @targetID INT, 
 @isMain   BIT
)
AS
    BEGIN
        UPDATE tbl_DealTarget
          SET 
              ismain = 0
        WHERE dealid = @dealid;
        UPDATE tbl_DealTarget
          SET 
              ismain = @ismain
        WHERE dealid = @dealid
              AND ModuleObjectID = @targetID;
        UPDATE tbl_deals
          SET 
              DealCurrentTargetID = @targetID
        WHERE dealID = @dealID;
        SELECT 1 Result;
    END;
