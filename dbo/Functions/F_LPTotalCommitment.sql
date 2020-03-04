--  select dbo.[F_LPTotalCommitment](461,5,1089,null)    

CREATE FUNCTION [dbo].[F_LPTotalCommitment]
(@objectID  INT, 
 @moduleID  INT, 
 @vehicleID INT, 
 @shareID   INT
)
RETURNS DECIMAL(18, 3)
AS
     BEGIN
         DECLARE @return_value1 DECIMAL(18, 3);
         DECLARE @return_value2 DECIMAL(18, 3);
         DECLARE @return_value3 DECIMAL(18, 3);
         SELECT @return_value1 = ISNULL(SUM(lpd.Amount), 0)
         FROM tbl_LimitedPartner lp
              JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID
         WHERE lp.VehicleID = @vehicleID
               AND lp.ObjectID = @objectID
               AND lp.ModuleID = @moduleID
               AND lpd.ShareID = ISNULL(@shareID, lpd.ShareID);
         SELECT @return_value2 = -1 * ISNULL(SUM(lpd.ShareAmount), 0)
         FROM tbl_CommitmentTransfer lp
              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
         WHERE lp.FundID = @vehicleID
               AND lp.FromObjectID = @objectID
               AND lp.FromModuleID = @moduleID
               AND lpd.FundShareID = ISNULL(@shareID, lpd.FundShareID);
         SELECT @return_value3 = ISNULL(SUM(lpd.ShareAmount), 0)
         FROM tbl_CommitmentTransfer lp
              JOIN tbl_CommitmentTransferFundShare lpd ON lp.CommitmentTransferID = lpd.CommitmentTransferID
         WHERE lp.FundID = @vehicleID
               AND lp.ToObjectID = @objectID
               AND lp.ToModuleID = @moduleID
               AND lpd.FundShareID = ISNULL(@shareID, lpd.FundShareID);
         RETURN @return_value1 + @return_value2 + @return_value3;
     END;
