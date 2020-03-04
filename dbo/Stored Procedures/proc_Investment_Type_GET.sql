CREATE PROCEDURE [dbo].[proc_Investment_Type_GET]
AS
    BEGIN
        SELECT InvestmentTypeID, 
               Title, 
               Description, 
               IsActive
        FROM tbl_InvestmentType;
    END;
