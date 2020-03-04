
--  select dbo.[F_GetAdjustedNav](320,12480,4,1093,12,'3/7/2017')

CREATE FUNCTION [dbo].[F_GetAdjustedNav_V1]
(@CallID        INT, 
 @ObjectID      INT, 
 @ModuleID      INT, 
 @vehicleID     INT, 
 @ShareID       INT, 
 @Date          DATETIME, 
 @showValidated INT      = 1 -- 1=all,2=validated,3=unvalidated

)
RETURNS NUMERIC(25, 10)
AS
     BEGIN

         --DECLARE @CallID INT;
         --DECLARE @ObjectID INT;
         --DECLARE @ModuleID INT;
         --DECLARE @vehicleID INT;
         --DECLARE @ShareID INT;
         --DECLARE @Date DATETIME;
         --DECLARE @showValidated INT;
         --SET @ObjectID = 3618;
         --SET @ModuleID = 5;
         --SET @vehicleID = 1113;
         --SET @ShareID = NULL;
         --SET @Date = GETDATE();
         --SET @showValidated = 3;

         DECLARE @lastNAVAmount NUMERIC(25, 10);
         DECLARE @lastNAVDate DATETIME;
         DECLARE @calls NUMERIC(25, 10);
         DECLARE @commitments NUMERIC(25, 15);
         DECLARE @dist NUMERIC(25, 10);
         SELECT TOP 1 @lastNAVAmount = SUM(amount), 
                      @lastNAVDate = navdate
         FROM tbl_VehicleNav n
              JOIN tbl_VehicleNavLimitedPartner nlp ON n.VehicleNavID = nlp.VehicleNavID
              JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = nlp.limitedpartnerid
         WHERE n.NAVDate <= ISNULL(@Date, n.NAVDate)
               AND lp.moduleid = @moduleid
               AND lp.objectid = @objectID
               AND lp.vehicleid = @vehicleID
               AND nlp.shareid = ISNULL(@ShareID, nlp.shareid)
               AND 1 = CASE
                           WHEN @showValidated = 1
                           THEN 1
                           WHEN @showValidated = 2
                                AND (CASE
                                         WHEN n.TotalValidationReq = 0
                                         THEN 1
                                         WHEN n.DocStatus IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                     END) = 1
                           THEN 1
                           WHEN @showValidated = 3
                                AND (CASE
                                         WHEN n.TotalValidationReq = 0
                                         THEN 1
                                         WHEN n.DocStatus IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                     END) = 0
                           THEN 1
                           ELSE 0
                       END
         GROUP BY navdate
         ORDER BY n.navdate DESC;
         SET @calls =
         (
             SELECT SUM(AMOUNT)
             FROM tbl_CapitalCall n
                  JOIN tbl_capitalcalllimitedpartner nlp ON n.CapitalCallID = nlp.CapitalCallID
                  JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = nlp.limitedpartnerid
             WHERE n.CallDate >= ISNULL(@lastNAVDate, n.Calldate)
                   AND n.CallDate <= @Date
                   AND nlp.shareid = ISNULL(@ShareID, nlp.shareid)
                   AND lp.moduleid = @moduleid
                   AND lp.objectid = @objectID
                   AND n.FundID = @vehicleID
                   AND 1 = CASE
                               WHEN @showValidated = 1
                               THEN 1
                               WHEN @showValidated = 2
                                    AND (CASE
                                             WHEN n.TotalValidationReq = 0
                                             THEN 1
                                             WHEN n.DocStatus IS NOT NULL
                                             THEN 1
                                             ELSE 0
                                         END) = 1
                               THEN 1
                               WHEN @showValidated = 3
                                    AND (CASE
                                             WHEN n.TotalValidationReq = 0
                                             THEN 1
                                             WHEN n.DocStatus IS NOT NULL
                                             THEN 1
                                             ELSE 0
                                         END) = 0
                               THEN 1
                               ELSE 0
                           END
         );
         SELECT @dist = SUM(amount)
         FROM tbl_Distribution n
              JOIN tbl_DistributionLimitedPartner nlp ON n.DistributionID = nlp.DistributionID
              JOIN tbl_limitedpartner lp ON lp.limitedpartnerid = nlp.limitedpartnerid
         WHERE n.Date >= ISNULL(@lastNAVDate, n.Date)
               AND n.Date <= @Date
               AND lp.moduleid = @moduleid
               AND lp.objectid = @objectID
               AND nlp.shareid = ISNULL(@ShareID, nlp.shareid)
               AND lp.vehicleid = @vehicleID
               AND 1 = CASE
                           WHEN @showValidated = 1
                           THEN 1
                           WHEN @showValidated = 2
                                AND (CASE
                                         WHEN n.TotalValidationReq = 0
                                         THEN 1
                                         WHEN n.DocStatus IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                     END) = 1
                           THEN 1
                           WHEN @showValidated = 3
                                AND (CASE
                                         WHEN n.TotalValidationReq = 0
                                         THEN 1
                                         WHEN n.DocStatus IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                     END) = 0
                           THEN 1
                           ELSE 0
                       END;
         RETURN ISNULL(@lastNAVAmount, 0) + ISNULL(@calls, 0) - ISNULL(@dist, 0);
     END;
