CREATE PROCEDURE [dbo].[proc_Quotation_GET]
AS
    BEGIN
        SELECT [QuotationID], 
               [QuotationName], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM tbl_Quotation
        WHERE Active = 1;
    END;
