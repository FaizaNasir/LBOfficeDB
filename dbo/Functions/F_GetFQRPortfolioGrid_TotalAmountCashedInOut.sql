  
CREATE FUNCTION [dbo].[F_GetFQRPortfolioGrid_TotalAmountCashedInOut]  
(@vehicleid INT,   
 @fileName  VARCHAR(100),   
 @date      DATETIME  
)  
RETURNS DECIMAL(18, 2)  
AS  
     BEGIN  
         DECLARE @result DECIMAL(18, 2);  
         SET @result = ISNULL(  
         (  
             SELECT SUM(amount)  
             FROM tbl_PortfolioShareholdingOperations sho  
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
             WHERE po.FileName = @fileName  
                   AND sho.FromID = @vehicleid  
                   AND sho.Date <= @date  
                   AND sho.isConditional = 0  
                   AND sho.FromTypeID = 3  
         ), 0);  
         SET @result = @result + ISNULL(  
         (  
             SELECT SUM(AmountDue)  
             FROM tbl_PortfolioShareholdingOperations sho  
                  JOIN tbl_PortfolioFollowOnPayment f ON f.ShareholdingOperationID = sho.ShareholdingOperationID  
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
             WHERE po.FileName = @fileName  
                   AND sho.FromID = @vehicleid  
                   AND sho.Date <= @date  
                   AND sho.isConditional = 0  
                   AND sho.FromTypeID = 3  
         ), 0);  
         SET @result = @result + ISNULL(  
         (  
             SELECT SUM(CASE  
                            WHEN TypeID IN(6, 7)  
                            THEN-1 * amount  
                            ELSE amount  
                        END)  
             FROM tbl_PortfolioGeneralOperation sho  
                  JOIN tbl_PortfolioOptional po ON po.PortfolioID = sho.PortfolioID  
             WHERE po.FileName = @fileName  
                   AND ((sho.ToID = @vehicleid  
                         AND sho.ToModuleID = 3)  
                        OR (sho.FromID = @vehicleid  
                            AND sho.fromModuleID = 3))  
                   AND sho.Date <= @date  
                   AND sho.isConditional = 0  
                   AND sho.TypeID IN(1, 2, 3, 6, 7)  
         ), 0);  
         RETURN @result;  
     END;