
--  select  dbo.F_GetCostPrice  

CREATE FUNCTION [dbo].[F_GetCostPriceDisplay]
(@PortfolioID INT, 
 @vehicleID   INT
)
RETURNS DECIMAL(18, 1)
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
         DECLARE @r VARCHAR(100);
         SET @r = CAST((ISNULL(@a, 0) + ISNULL(@b, 0)) / 1000000 AS VARCHAR(100));
         RETURN CAST(SUBSTRING(@r, 0,
                                   CASE
                                       WHEN CHARINDEX('.', @r, 0) <> 0
                                       THEN CHARINDEX('.', @r, 0) + 2
                                       ELSE LEN(@r) + 1
                                   END) AS DECIMAL(18, 1));
     END;
