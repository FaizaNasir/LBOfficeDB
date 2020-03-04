CREATE PROC [dbo].[DeleteCapitalCallChildDetailsByCapitalCallID](@CapitalCallID INT = NULL)
AS
    BEGIN
        DELETE FROM tbl_CapitalCallOperation
        WHERE CapitalCallID = @CapitalCallID;
        DELETE FROM tbl_CapitalCallLimitedPartner
        WHERE CapitalCallID = @CapitalCallID;
        DELETE FROM tbl_CapitalCallPortfolioCompany
        WHERE CapitalCallID = @CapitalCallID;
        SELECT 1;
    END;
