CREATE PROCEDURE [dbo].[proc_PortfolioSecurityClass_GET]
AS
    BEGIN
        SELECT [ClassID], 
               [ClassNumber], 
               CAST([ClassNumber] AS VARCHAR(10)) + ' - ' + [ClassName] AS [ClassName], 
               [CreatedBy], 
               [CreatedDateTime], 
               [ModifiedBy], 
               [ModifiedDateTime], 
               [Active]
        FROM [LBOffice].[dbo].[tbl_PortfolioSecurityClass];
    END;
