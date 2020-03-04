
--  select dbo.[F_Sho_GetCostOfSoldInvs](null,44,null,1)    

CREATE FUNCTION [dbo].[F_Sho_GetCostOfSoldInvs_Excel]
(  
--@sho ShoType READONLY,  
@portfolioID INT, 
@NatureID    INT, 
@typeID      INT, 
@VehicleID   INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @sho AS SHOTYPE;
         INSERT INTO @sho
                SELECT ShareholdingOperationID, 
                       PortfolioID, 
                       Date, 
                       Amount, 
                       SecurityID, 
                       Number, 
                       FromID, 
                       ToID, 
                       FromTypeID, 
                       ToTypeID, 
                       NatureID
                FROM tbl_portfolioShareHoldingOperations
                WHERE 1 = (CASE
                               WHEN FromTypeID = 3
                                    AND FromID = 28
                               THEN 1
                               WHEN ToTypeID = 3
                                    AND ToID = 28
                               THEN 1
                           END);
         DECLARE @CostOfSold DECIMAL(18, 2);
         SELECT @CostOfSold = SUM(Number)
         FROM
         (
             SELECT(SUM(Amount) / SUM(Number)) * ISNULL(
             (
                 SELECT SUM(Number)
                 FROM @sho a
                 WHERE a.SecurityID = b.SecurityID
                       AND FromTypeID = 3
             ), 0) Number
             FROM @sho b
             WHERE FromTypeID <> 3
                   AND NatureID = ISNULL(@NatureID, NatureID)
                   AND 1 = CASE
                               WHEN @typeID = 1
                               THEN 1
                           END
             GROUP BY SecurityID
         ) t;
         RETURN @CostOfSold;
     END;
