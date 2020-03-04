
-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
-- =============================================            
CREATE PROCEDURE [dbo].[proc_FundCatchup_GET]            
-- Add the parameters for the stored procedure here            
@FundID    INT = NULL, 
@CatchupID INT = NULL
AS
    BEGIN
        SELECT CatchupID, 
               cu.FundID, 
               Rate, 
               Capitalized, 
               StartDate, 
               EndDate, 
               Basis, 
               CreatedDate, 
               CreatedBy, 
               ModifiedDate, 
               ModifiedBy
        FROM [LBOffice].[dbo].[tbl_fundCatchUp] cu
        WHERE cu.FundID = ISNULL(@FundID, cu.FundID)
              AND CatchupID = ISNULL(@CatchupID, CatchupID);
    END;
