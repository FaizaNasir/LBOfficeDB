CREATE PROCEDURE [dbo].[proc_Deal_Investment_Types_GET]
AS
    BEGIN
        SELECT *
        FROM dbo.tbl_DealInvestmentType;
    END;
