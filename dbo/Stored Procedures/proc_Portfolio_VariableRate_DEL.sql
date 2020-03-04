CREATE PROCEDURE [dbo].[proc_Portfolio_VariableRate_DEL] @PortfolioSecurityID INT = NULL
AS
     DELETE FROM [tbl_PortfolioVariableRate]
     WHERE PortfolioSecurityID = ISNULL(@PortfolioSecurityID, PortfolioSecurityID);
     SELECT 1 AS 'Column1';
