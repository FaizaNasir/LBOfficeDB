    
-- select dbo.[F_Last_Valuation](28,11,GETDATE())        
    
CREATE FUNCTION [dbo].[F_ClosingDateV1]    
(@vehicleid INT,     
 @fileName  VARCHAR(100),     
 @Date      DATETIME    
)    
RETURNS DATETIME    
AS    
     BEGIN    
         DECLARE @portfolioid INT;    
         DECLARE @beforelastvalue DATETIME;    
         SELECT @beforelastvalue =    
         (    
             SELECT TOP 1 pso.ClosingDate    
             FROM tbl_PortfolioTransactionStructure pso    
                  JOIN tbl_PortfolioOptional po ON po.portfolioid = pso.portfolioid    
             WHERE po.FileName = @fileName    
         );    
         RETURN @beforelastvalue;    
     END;