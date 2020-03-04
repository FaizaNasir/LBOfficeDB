
-- GetCommitmentsLimitedPartnerByTransfers 1185,1089,3,5,461,1

CREATE PROC [dbo].[GetDistributionLimitedPartnerByTransfers]
(@distributionID INT, 
 @vehicleID      INT, 
 @shareID        INT, 
 @moduleID       INT, 
 @objectID       INT, 
 @factorID       INT
)
AS
    BEGIN
        DECLARE @DistributionLimitedPartnerID INT;
        SELECT @DistributionLimitedPartnerID = DistributionLimitedPartnerID
        FROM tbl_Distribution c
             JOIN tbl_distributionLimitedPartner cd ON cd.distributionID = c.distributionID
             JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = cd.LimitedPartnerID
        WHERE c.FundID = @vehicleID
              AND c.distributionID = @distributionID
              AND cd.ShareID = @shareID
              AND lp.ModuleID = @moduleID
              AND lp.ObjectID = @objectID;
        SELECT @DistributionLimitedPartnerID Result;
    END;
