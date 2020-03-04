
--  select  dbo.F_GetCostPrice  

CREATE FUNCTION [dbo].[F_GetCostPrice]
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
               AND ToTypeID = 3
               AND ToID = @vehicleID;
         SELECT @b = SUM(Amount)
         FROM tbl_PortfolioGeneralOperation pgo
         WHERE pgo.portfolioid = @portfolioid
               AND TypeID = 1;
         RETURN ISNULL(@a, 0) + ISNULL(@b, 0);
     END;
