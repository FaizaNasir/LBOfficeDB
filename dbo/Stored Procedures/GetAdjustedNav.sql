
--  select dbo.[F_GetAdjustedNav](6,475,5,1093,10,'2016-12-21')    

CREATE PROC [dbo].[GetAdjustedNav]
(@DistributionID   INT, 
 @ObjectID         INT, 
 @ModuleID         INT, 
 @vehicleID        INT, 
 @ShareID          INT, 
 @DistributionDate DATETIME
)
AS
     SELECT dbo.F_GetAdjustedNav(@DistributionID, @ObjectID, @ModuleID, @vehicleID, @ShareID, @DistributionDate) Result;
