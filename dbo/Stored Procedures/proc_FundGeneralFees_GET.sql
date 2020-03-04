
-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
-- =============================================            
CREATE PROCEDURE [dbo].[proc_FundGeneralFees_GET]            
-- Add the parameters for the stored procedure here            
@FundID            INT = NULL, 
@FundGeneralFeesID INT = NULL
AS
    BEGIN
        SELECT FundGeneralFeesID, 
               FundID, 
               ManagementFeesComments, 
               HurdleFeesComments, 
               CatchUpFeesComments, 
               CarriedInterestFeesComments, 
               FeesFrequency, 
               IsFundBasedCarriedIntreset, 
               CreatedDate, 
               CreatedBy, 
               ModifiedDate, 
               ModifiedBy
        FROM [LBOffice].[dbo].[tbl_FundGeneralFees]
        WHERE FundGeneralFeesID = ISNULL(@FundGeneralFeesID, FundGeneralFeesID)
              AND FundID = ISNULL(@FundID, FundID);
    END;
