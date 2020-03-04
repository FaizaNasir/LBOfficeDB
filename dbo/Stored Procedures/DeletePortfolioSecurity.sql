CREATE PROC [dbo].[DeletePortfolioSecurity](@PortfolioSecurityID INT)
AS
    BEGIN
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioShareholdingOperations
            WHERE SecurityID = @PortfolioSecurityID
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, this security is being used in shareholding operations; please delete those shareholding operations first' Msg;
                RETURN;
        END;
        DELETE FROM tbl_PortfolioShareholdingOperations
        WHERE SecurityID = @PortfolioSecurityID;
        DELETE FROM tbl_PortfolioSecurity
        WHERE PortfolioSecurityID = @PortfolioSecurityID;
        SELECT 1 Result, 
               '' Msg;
    END;
