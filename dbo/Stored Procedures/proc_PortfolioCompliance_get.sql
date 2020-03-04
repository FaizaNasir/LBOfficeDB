CREATE PROC [dbo].[proc_PortfolioCompliance_get](@portfolioID INT)
AS
    BEGIN
        SELECT PortfolioComplianceID, 
               PortfolioID, 
               PartnerAgreement, 
               ExitClause, 
               EdRBoardRepresentation, 
               LiquidityClause, 
               SetupCosts, 
               Other
        FROM tbl_PortfolioCompliance
        WHERE portfolioid = @portfolioid;
    END;
