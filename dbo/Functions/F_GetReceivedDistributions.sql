--  select  dbo.F_GetCostPrice  

CREATE FUNCTION [dbo].[F_GetReceivedDistributions]
(@PortfolioID INT, 
 @vehicleID   INT
)
RETURNS DECIMAL(18, 6)
AS
     BEGIN
         DECLARE @a DECIMAL(18, 6);
         DECLARE @b DECIMAL(18, 6);
         SELECT @a = SUM(Amount)
         FROM tbl_PortfolioShareholdingOperations pso
         WHERE pso.portfolioid = @portfolioid
               AND FromTypeID = 3
               AND FromID = @vehicleID;
         SELECT @b = SUM(Amount)
         FROM tbl_PortfolioGeneralOperation pgo
         WHERE pgo.portfolioid = @portfolioid
               AND TypeID IN(4, 5, 6);
         RETURN ISNULL(@a, 0) + ISNULL(@b, 0);
     END;
