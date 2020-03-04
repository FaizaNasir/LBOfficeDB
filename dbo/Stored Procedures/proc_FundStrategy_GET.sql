CREATE PROCEDURE [dbo].[proc_FundStrategy_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT F.[FundID], 
               F.[FundManagementCompanyID], 
               F.[FundName], 
               F.FundNoOfForcastOperationFrom, 
               F.FundNoOfForcastOperationTo, 
               F.FundInvestmentSizeFrom, 
               F.FundInvestmentSizeTo
        FROM tbl_Funds F
        WHERE F.FundID = ISNULL(@FundID, F.FundID);
    END;
