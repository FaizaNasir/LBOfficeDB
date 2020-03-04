CREATE FUNCTION [dbo].[F_CheckDealPortfolioLink]
(@deal INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @result INT;
         SET @result =
         (
             SELECT TOP 1 p.portfolioid
             FROM tbl_deals d
                  JOIN tbl_portfolio p ON d.DealCurrentTargetID = p.TargetPortfolioID
             WHERE dealid = @deal
         );
         RETURN ISNULL(@result, 0);
     END;
