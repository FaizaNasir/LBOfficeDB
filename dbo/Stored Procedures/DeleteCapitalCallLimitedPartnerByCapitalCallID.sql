CREATE PROC [dbo].[DeleteCapitalCallLimitedPartnerByCapitalCallID](@CapitalCallID INT = NULL)
AS
    BEGIN
        DELETE FROM tbl_CapitalCallLimitedPartner
        WHERE CapitalCallID = @CapitalCallID;
        SELECT 1;
    END;
