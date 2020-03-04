
-- GetCommitmentsLimitedPartnerByTransfers 1185,1089,3,5,461,1

CREATE PROC [dbo].[GetCommitmentsLimitedPartnerByTransfers]
(@callID    INT, 
 @vehicleID INT, 
 @shareID   INT, 
 @moduleID  INT, 
 @objectID  INT, 
 @factorID  INT
)
AS
    BEGIN
        DECLARE @CapitalCallLimitedPartnerID INT;
        SELECT @CapitalCallLimitedPartnerID = CapitalCallLimitedPartnerID
        FROM tbl_CapitalCall c
             JOIN tbl_CapitalCallLimitedPartner cd ON cd.CapitalCallID = c.CapitalCallID
             JOIN tbl_LimitedPartner lp ON lp.LimitedPartnerID = cd.LimitedPartnerID
        WHERE c.FundID = @vehicleID
              AND c.CapitalCallID = @callID
              AND cd.ShareID = @shareID
              AND lp.ModuleID = @moduleID
              AND lp.ObjectID = @objectID;
        SELECT @CapitalCallLimitedPartnerID Result;
    END;
