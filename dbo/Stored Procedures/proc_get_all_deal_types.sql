CREATE PROCEDURE [dbo].[proc_get_all_deal_types]
AS
    BEGIN
        SELECT *
        FROM tbl_DealType;
    END;
