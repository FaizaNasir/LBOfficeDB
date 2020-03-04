
-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
-- =============================================            
CREATE PROCEDURE [dbo].[proc_FundManagementFees_GET]            
-- Add the parameters for the stored procedure here            
@FundID               INT = NULL, 
@FundManagementFeesID INT = NULL
AS
    BEGIN
        SELECT FundManagementFeesID, 
               fmf.FundID, 
               BasisPercent, 
               BasisAmount, 
               FeesAmount, 
               BasedOn, 
               StartingOn, 
               EndsOn, 
               fmf.CreatedDate, 
               fmf.CreatedBy, 
               fmf.ModifiedDate, 
               fmf.ModifiedBy, 
               ManagementFeesComments, 
               FeesFrequency
        FROM [LBOffice].[dbo].[tbl_FundManagementFees] fmf
             LEFT JOIN tbl_FundGeneralFees fgf ON fmf.FundID = fgf.FundID
        WHERE FundManagementFeesID = ISNULL(@FundManagementFeesID, FundManagementFeesID)
              AND fmf.FundID = ISNULL(@FundID, fmf.FundID);
    END;
