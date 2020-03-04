CREATE PROC [dbo].[proc_LP_Del](@LPID INT)
AS
    BEGIN
        DELETE FROM tbl_LimitedPartnerDetail
        WHERE LimitedPartnerID = @LPID;
        DELETE FROM tbl_LimitedPartner
        WHERE LimitedPartnerID = @LPID;
        SELECT 1 Result;
    END;
