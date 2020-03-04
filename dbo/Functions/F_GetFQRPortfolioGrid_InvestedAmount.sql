  
CREATE FUNCTION [dbo].[F_GetFQRPortfolioGrid_InvestedAmount](@vehicleid INT,   
                                                            @fileName  VARCHAR(100),   
                                                            @date      DATETIME)  
RETURNS DECIMAL(18, 2)  
AS  
     BEGIN  
         DECLARE @result DECIMAL(18, 2);  
         DECLARE @portfolioid INT;  
         DECLARE @portageShares DECIMAL(18, 2);  
         SET @result = ISNULL(  
         (  
             SELECT SUM(amount)  
             FROM tbl_PortfolioShareholdingOperations sho  
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
             WHERE po.FileName = @fileName  
                   AND sho.ToID = @vehicleid  
                   AND sho.Date <= @date  
                   AND sho.isConditional = 0  
                   AND sho.ToTypeID = 3  
         ), 0);  
         SET @result = @result + ISNULL(  
         (  
             SELECT SUM(amountdue)  
             FROM tbl_PortfolioShareholdingOperations sho  
                  JOIN tbl_PortfolioFollowOnPayment f ON sho.ShareholdingOperationID = f.ShareholdingOperationID  
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
             WHERE po.FileName = @fileName  
                   AND sho.ToID = @vehicleid  
                   AND sho.Date <= @date  
                   AND f.Date <= @date  
                   AND sho.isConditional = 0  
                   AND sho.ToTypeID = 3  
         ), 0);  
         SET @result = @result + ISNULL(  
         (  
             SELECT SUM(amount)  
             FROM tbl_PortfolioGeneralOperation sho  
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
             WHERE po.FileName = @fileName  
                   AND ((sho.ToID = @vehicleid  
                         AND sho.ToModuleID = 3)  
                        OR (sho.FromID = @vehicleid  
                            AND sho.fromModuleID = 3))  
                   AND sho.Date <= @date  
                   AND sho.isConditional = 0  
                   AND sho.TypeID IN(5, 12)  
         ), 0);  
         SET @portageShares = dbo.[F_GetFQRPortfolioGrid_CostOfSecurity](@vehicleid, @fileName, @date, 1);  
         SET @result = @result - ISNULL(@portageShares, 0);  
         RETURN @result;  
     END;