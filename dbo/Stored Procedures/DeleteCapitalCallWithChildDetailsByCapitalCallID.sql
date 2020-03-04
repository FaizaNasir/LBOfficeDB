CREATE PROC [dbo].[DeleteCapitalCallWithChildDetailsByCapitalCallID](@CapitalCallID INT = NULL)
AS
    BEGIN
        DELETE FROM tbl_CapitalCallOperation
        WHERE CapitalCallID = @CapitalCallID;
        DELETE FROM tbl_CapitalCallLimitedPartner
        WHERE CapitalCallID = @CapitalCallID;
        DELETE FROM tbl_CapitalCallPortfolioCompany
        WHERE CapitalCallID = @CapitalCallID;
        DELETE FROM tbl_LPReport
        WHERE ContextID = @CapitalCallID
              AND DocumentTypeID = 1
              AND vehicleid =
        (
            SELECT TOP 1 fundid
            FROM tbl_capitalcall c
            WHERE c.CapitalCallID = @CapitalCallID
        );
        DELETE FROM tbl_CapitalCall
        WHERE CapitalCallID = @CapitalCallID;
        SELECT 1;
    END;
