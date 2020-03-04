  
CREATE FUNCTION [dbo].[F_GetParentPortfolioid](@vehicleid INT,   
                                              @fileName  VARCHAR(100),   
                                              @date      DATETIME)  
RETURNS INT  
AS  
     BEGIN  
         DECLARE @result INT;  
         SET @result =  
         (  
             SELECT TOP 1 p.portfolioid  
             FROM tbl_PortfolioOptional po  
                  JOIN tbl_portfolio p ON p.PortfolioID = po.PortfolioID  
                  JOIN tbl_ShareholdersOwned so ON so.TargetPortfolioID = p.TargetPortfolioID  
             WHERE po.FileName = @fileName  
         );  
         IF @result IS NULL  
             SET @result =  
             (  
                 SELECT top 1 portfolioid  
                 FROM tbl_PortfolioOptional  
                 WHERE FileName = @fileName  
             );  
         RETURN @result;  
     END;  