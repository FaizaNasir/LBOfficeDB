
--  select dbo.[F_GetAdjustedNav](320,12480,4,1093,12,'3/7/2017')

CREATE FUNCTION [dbo].[F_GetAdjustedNav]
(@CallID    INT, 
 @ObjectID  INT, 
 @ModuleID  INT, 
 @vehicleID INT, 
 @ShareID   INT, 
 @Date      DATETIME
)
RETURNS NUMERIC(25, 10)
AS
     BEGIN
         -- DECLARE @CallID   INT
         --DECLARE @ObjectID         INT
         --DECLARE @ModuleID         INT
         --DECLARE @vehicleID        INT
         --DECLARE @ShareID          INT
         --DECLARE @Date DATETIME
         --set @ObjectID = 3362
         -- set @ModuleID = 5
         --  set @vehicleID = 1113
         --   set @ShareID = 20
         -- set @Date = '2017-12-29'

         DECLARE @lastNAVAmount NUMERIC(25, 10);
         DECLARE @lastNAVDate DATETIME;
         DECLARE @calls NUMERIC(25, 10);
         DECLARE @commitments NUMERIC(25, 15);
         DECLARE @dist NUMERIC(25, 10);
         SELECT TOP 1 @lastNAVAmount = amount, 
                      @lastNAVDate = navdate
         FROM tbl_VehicleNav n
              JOIN tbl_VehicleNavLimitedPartner nlp ON n.VehicleNavID = nlp.VehicleNavID
              JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = nlp.limitedpartnerid
         WHERE n.NAVDate <= ISNULL(@Date, n.NAVDate)
               AND lp.moduleid = @moduleid
               AND lp.objectid = @objectID
               AND lp.vehicleid = @vehicleID
               AND nlp.shareid = ISNULL(@ShareID, nlp.shareid)
         ORDER BY n.navdate DESC;
         SELECT @commitments = ISNULL(
         (
             SELECT SUM(b.amount)
             FROM tbl_LimitedPartner a
                  JOIN tbl_LimitedPartnerDetail b ON a.limitedpartnerid = b.limitedpartnerid
             WHERE a.VehicleID = @vehicleID
                   AND b.ShareID = @ShareID
         ), 0);
         SELECT @calls = SUM(Amount)
         FROM
         (
             SELECT(ISNULL(nlp.InvestmentAmount, 0) + ISNULL(nlp.OtherFees, 0)) * CAST((ISNULL(
             (
                 SELECT SUM(CAST(b.amount AS FLOAT))
                 FROM tbl_LimitedPartner a
                      JOIN tbl_LimitedPartnerDetail b ON a.limitedpartnerid = b.limitedpartnerid
                 WHERE a.VehicleID = @vehicleID
                       AND b.ShareID = @ShareID
                       AND a.ObjectID = @ObjectID
                       AND a.ModuleID = @ModuleID
                       AND a.Date <= n.CallDate
             ), 0) / @commitments) AS FLOAT) Amount
             FROM tbl_CapitalCall n
                  JOIN tbl_CapitalCallOperation nlp ON n.CapitalCallID = nlp.CapitalCallID
             WHERE n.CallDate >= ISNULL(@lastNAVDate, n.Calldate)
                   AND n.CallDate <= @Date
                   AND nlp.shareid = ISNULL(@ShareID, nlp.shareid)
                   AND n.FundID = @vehicleID
         ) t;
         SELECT @dist = SUM(amount)
         FROM tbl_Distribution n
              JOIN tbl_DistributionLimitedPartner nlp ON n.DistributionID = nlp.DistributionID
              JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = nlp.limitedpartnerid
         WHERE n.Date >= ISNULL(@lastNAVDate, n.Date)
               AND n.Date <= @Date
               AND lp.moduleid = @moduleid
               AND lp.objectid = @objectID
               AND nlp.shareid = ISNULL(@ShareID, nlp.shareid)
               AND lp.vehicleid = @vehicleID;
         RETURN ISNULL(@lastNAVAmount, 0) + ISNULL(@calls, 0) - ISNULL(@dist, 0);
     END;
