
-- [proc_PortfolioValuation_GET]  1,1       

CREATE PROCEDURE [dbo].[proc_FundNav_GET] @FundNavID INT = NULL, 
                                          @FundID    INT = NULL
AS
    BEGIN
        SELECT [FundNavID], 
               [FundID], 
               [Date], 
               [TypeID], 
               [ValuationLevel], 
               [NAV], 
               [WorkingCapital], 
               [Cash], 
               [AdjustedNAV], 
               [Notes], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM [tbl_FundNav]
        WHERE FundNavID = ISNULL(@FundNavID, FundNavID)

              --and PortfolioID = ISNULL(@PortfolioID, PortfolioID)          

              AND FundID = @FundID;
    END; 
