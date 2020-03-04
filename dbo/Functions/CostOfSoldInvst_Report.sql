CREATE FUNCTION [dbo].[CostOfSoldInvst_Report]
(@shoID       INT, 
 @sho         SHOTYPE READONLY, 
 @PortfolioID INT, 
 @SecurityID  INT
)
RETURNS DECIMAL(18, 6)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 6);
         DECLARE @akAmount DECIMAL(18, 6);
         DECLARE @akNumber DECIMAL(18, 6);
         DECLARE @date DATETIME;
         SELECT @date = date
         FROM @sho
         WHERE ShareholdingOperationID = @shoID;
         SELECT @akAmount = SUM(Amount), 
                @akNumber = SUM(Number)
         FROM @sho
         WHERE date < @date
               AND ToTypeID = 3
               AND portfolioid = @portfolioid
               AND securityid = @securityID;
         RETURN @akAmount / @akNumber;
     END;
