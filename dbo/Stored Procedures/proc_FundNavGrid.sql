
-- [proc_PortfolioValuationGrid]  1           

CREATE PROCEDURE [dbo].[proc_FundNavGrid](@vehicleID INT = NULL)
AS
    BEGIN
        SELECT [FundNavID], 
               [FundID], 
               Date, 
               TypeID,
               CASE
                   WHEN TypeID = 0
                   THEN '------'
                   WHEN TypeID = 1
                   THEN 'At cost'
                   WHEN TypeID = 2
                   THEN 'Fair value'
               END AS TypeName, 
               [ValuationLevel], 
               [NAV], 
               [WorkingCapital], 
               [Cash], 
               [AdjustedNAV], 
               [Notes]
        FROM tbl_FundNav a
        WHERE [FundID] = @vehicleID
        ORDER BY Date DESC;
    END; 
