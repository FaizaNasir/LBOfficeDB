CREATE PROC [dbo].[DeletePortfolioCompany](@portfolioID INT)
AS
    BEGIN
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioGeneralOperation
            WHERE portfolioid = @portfolioid
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, you need first to delete the operations linked to the company, in order to delete the portfolio company itself' Msg;
                RETURN;
        END;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioShareholdingOperations
            WHERE portfolioid = @portfolioid
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, you need first to delete the operations linked to the company, in order to delete the portfolio company itself' Msg;
                RETURN;
        END;
        DELETE FROM tbl_PortfolioCompliance
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioDealTeam
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioDebtCovenant
        WHERE PortfolioSecurityID IN
        (
            SELECT PortfolioSecurityID
            FROM tbl_PortfolioSecurity
            WHERE portfolioid = @portfolioid
        );
        DELETE FROM tbl_PortfolioDebtSecurities
        WHERE PortfolioSecurityID IN
        (
            SELECT PortfolioSecurityID
            FROM tbl_PortfolioSecurity
            WHERE portfolioid = @portfolioid
        );
        DELETE FROM tbl_PortfolioValuationDetails
        WHERE SecurityID IN
        (
            SELECT PortfolioSecurityID
            FROM tbl_PortfolioSecurity
            WHERE portfolioid = @portfolioid
        );
        DELETE FROM tbl_PortfolioVariableRate
        WHERE PortfolioSecurityID IN
        (
            SELECT PortfolioSecurityID
            FROM tbl_PortfolioSecurity
            WHERE portfolioid = @portfolioid
        );
        DELETE FROM tbl_PortfolioShareholdingOperationsUnderConditions
        WHERE ShareholdingOperationID IN
        (
            SELECT ShareholdingOperationID
            FROM tbl_PortfolioShareholdingOperations
            WHERE portfolioid = @portfolioid
        );
        DELETE FROM tbl_PortfolioFollowOnPayment
        WHERE ShareholdingOperationID IN
        (
            SELECT ShareholdingOperationID
            FROM tbl_PortfolioShareholdingOperations
            WHERE portfolioid = @portfolioid
        );
        DELETE FROM tbl_PortfolioGeneralOperation
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_KeyFigureConfig
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioKeyFigure
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioLegal
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioLegalEvent
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioOptional
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioShareholdingOperations
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioSecurity
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_PortfolioVehicle
        WHERE portfolioid = @portfolioid;
        DELETE FROM tbl_Portfolio
        WHERE portfolioid = @portfolioid;
        SELECT 1 Result, 
               '' Msg;
    END;
