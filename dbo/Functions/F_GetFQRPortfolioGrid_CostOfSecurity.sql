  
CREATE FUNCTION [dbo].[F_GetFQRPortfolioGrid_CostOfSecurity](@vehicleid    INT,   
                                                            @fileName     VARCHAR(100),   
                                                            @date         DATETIME,   
                                                            @PortageShare BIT)  
RETURNS DECIMAL(18, 2)  
AS  
     BEGIN  
         DECLARE @result DECIMAL(18, 2);  
         DECLARE @tbl TABLE  
         (ID         INT IDENTITY(1, 1),   
          SecurityID INT,   
          Number     DECIMAL(18, 6),   
          Cost       DECIMAL(18, 6)  
         );  
         DECLARE @costOfRealized DECIMAL(18, 2);  
         INSERT INTO @tbl  
                SELECT SecurityID,   
                       SUM(number),   
                       NULL  
                FROM tbl_PortfolioShareholdingOperations sho  
                     JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
                WHERE po.FileName = @fileName  
                      AND sho.FromID = @vehicleid          
                      --AND sho.isConditional = 0          
                      AND sho.Date <= @date  
                      AND sho.FromTypeID = 3  
                      AND 1 = CASE  
                                  WHEN @PortageShare = 1  
                                       AND sho.SecurityID = 11 --PortageShare                
                                  THEN 1  
                                  WHEN @PortageShare = 0  
                                  THEN 1  
                                  ELSE 0  
                              END  
                GROUP BY SecurityID;  
         UPDATE s  
           SET   
               Cost =  
         (  
             SELECT SUM(ISNULL(amount, 0)) / (CASE  
                                                  WHEN SUM(ISNULL(Number, 0)) = 0  
                                                  THEN 1  
                                                  ELSE SUM(ISNULL(Number, 0))  
                                              END)  
             FROM tbl_PortfolioShareholdingOperations sho  
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
             WHERE po.FileName = @fileName  
                   AND sho.ToID = @vehicleid  
                   AND sho.Date <= @date          
                   --AND sho.isConditional = 0          
                   AND sho.ToTypeID = 3  
                   AND sho.SecurityID = s.SecurityID  
         )  
         FROM @tbl s;  
         SET @costOfRealized =  
         (  
             SELECT SUM(ISNULL(number, 0) * ISNULL(cost, 0))  
             FROM @tbl  
         );  
         RETURN ISNULL(@costOfRealized, 0);  
     END;