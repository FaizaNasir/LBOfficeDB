  
-- select dbo.[F_Last_Valuation](28,11,GETDATE())          
  
CREATE FUNCTION [dbo].[F_ClosingDateExit]  
(@vehicleid   INT,   
 @portfolioid INT,   
 @Date        DATETIME  
)  
RETURNS DATETIME  
AS  
     BEGIN  
         DECLARE @beforelastvalue DATETIME;  
         SELECT @beforelastvalue =  
         (  
             SELECT TOP 1 pso.ClosingDateExit  
             FROM tbl_PortfolioTransactionStructure pso  
             WHERE pso.portfolioid = @portfolioid  
         );  
         RETURN @beforelastvalue;  
     END;