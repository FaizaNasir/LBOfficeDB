--  select  dbo.[F_BeforeLast_Valuation](66,60,'12-31-2016')      

CREATE FUNCTION [dbo].[F_GetPortfolioLegalCapital]
(@portfolioid INT
)
RETURNS DECIMAL(30, 6)
AS
     BEGIN
         DECLARE @CapitalCalculation DECIMAL(18, 2)= NULL;
         SET @CapitalCalculation = (
         (
             SELECT SUM(psho.Number)
             FROM tbl_PortfolioShareholdingOperations psho
             WHERE psho.FromID = -1
                   AND psho.PortfolioID = @PortfolioID
         ) *
         (
             SELECT TOP 1 ps.NominalValue
             FROM tbl_PortfolioShareholdingOperations psho
                  LEFT OUTER JOIN tbl_PortfolioSecurity ps ON psho.SecurityID = ps.PortfolioSecurityID
                                                              AND ps.PortfolioID = psho.PortfolioID
             WHERE psho.FromID = -1
                   AND psho.PortfolioID = @PortfolioID
         ));
         RETURN @CapitalCalculation;
     END;
