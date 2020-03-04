-- Batch submitted through debugger: SQLQuery33.sql|7|0|C:\Users\Administrator\AppData\Local\Temp\~vs4FA3.sql  
--  select  dbo.[F_Sold] (10,3,'1 Apr,2012')  

CREATE FUNCTION [dbo].[F_Sold]
(@id          INT, 
 @moduleID    INT, 
 @portfolioID INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @nominator INT;
         DECLARE @denominator INT;
         DECLARE @result INT;
         SET @nominator =
         (
             SELECT SUM(pso.number)
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = pso.SecurityID
                  JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                       AND SecurityGroupID = 1
             WHERE pso.fromid = @id
                   AND pso.FromTypeID = @moduleID
                   AND pso.PortfolioID = @portfolioID
         );
         SET @denominator =
         (
             SELECT SUM(pso.number)
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = pso.SecurityID
                  JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                       AND SecurityGroupID = 1
             WHERE pso.toid = @id
                   AND pso.ToTypeID = @moduleID
                   AND pso.PortfolioID = @portfolioID
         );
         IF(@denominator != 0)
             SET @result = ISNULL(@nominator, 0) / ISNULL(@denominator, 0);
         RETURN ISNULL(@result, 0);
     END;
