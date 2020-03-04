CREATE FUNCTION [dbo].[CostOfSoldInvst_ExcelReport]
(@date        DATETIME, 
 @vehicleID   INT, 
 @PortfolioID INT, 
 @SecurityID  INT
)
RETURNS DECIMAL(18, 6)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 6);
         DECLARE @akAmount DECIMAL(18, 6);
         DECLARE @akNumber DECIMAL(18, 6);
         SELECT @akAmount = SUM(Amount), 
                @akNumber = SUM(Number)
         FROM tbl_PortfolioShareholdingOperations sho
         WHERE date < @date
               AND ToTypeID = 3
               AND portfolioid = @portfolioid
               AND ToID = @vehicleID
               AND SecurityID = @securityID;
         RETURN @akAmount / @akNumber;
     END;
