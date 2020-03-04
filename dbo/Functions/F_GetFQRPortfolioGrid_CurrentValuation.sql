    
CREATE FUNCTION [dbo].[F_GetFQRPortfolioGrid_CurrentValuation]    
(@vehicleid               INT,     
 @fileName                VARCHAR(100),     
 @date                    DATETIME,     
 @AccruedinterestsAllowed BIT    
)    
RETURNS DECIMAL(18, 2)    
AS    
     BEGIN    
         DECLARE @result DECIMAL(18, 2);    
         DECLARE @Accruedinterests DECIMAL(18, 2);    
         SET @Accruedinterests =    
         (    
             SELECT TOP 1 amount    
             FROM tbl_PortfolioGeneralOperation sho    
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID    
             WHERE po.FileName = @fileName    
                   AND sho.typeid IN(4, 8)    
                  AND sho.Date <= @date    
             ORDER BY sho.Date DESC    
         );    
         DECLARE @id INT;    
         SET @id = ISNULL(    
         (    
             SELECT TOP 1 ValuationID    
             FROM tbl_PortfolioValuation sho    
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID    
             WHERE po.FileName = @fileName    
                   AND sho.vehicleid = @vehicleid    
                   AND sho.Date <= @date    
             ORDER BY sho.Date DESC    
         ), 0);    
         IF    
         (    
             SELECT FinalValuation    
             FROM tbl_PortfolioValuation    
             WHERE ValuationID = @id    
         ) = 0    
         AND EXISTS    
         (    
             SELECT TOP 1 1    
             FROM tbl_PortfolioVehicle pv    
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = pv.PortfolioID    
             WHERE po.FileName = @fileName    
                   AND vehicleid = @vehicleid    
                   AND po.statusid = 'Realized'    
         )    
             BEGIN    
                 SET @id = ISNULL(    
                 (    
                     SELECT TOP 1 ValuationID    
                     FROM tbl_PortfolioValuation sho    
                          JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID    
                     WHERE po.FileName = @fileName    
                           AND sho.vehicleid = @vehicleid    
                           AND sho.Date <= @date    
                           AND ValuationID < @id    
                           AND FinalValuation <> 0    
                     ORDER BY sho.Date DESC    
                 ), 0);    
         END;    
         SET @result =    
         (    
             SELECT FinalValuation    
             FROM tbl_PortfolioValuation    
             WHERE ValuationID = @id    
         );    
         IF @AccruedinterestsAllowed = 0    
             SET @Accruedinterests = 0;    
         RETURN @result - ISNULL(@Accruedinterests, 0);    
     END;