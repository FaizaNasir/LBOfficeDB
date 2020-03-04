-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
-- =============================================            
CREATE PROCEDURE [dbo].[proc_FundHurdleRate_GET]            
-- Add the parameters for the stored procedure here            
@FundID       INT = NULL, 
@HurdleRateID INT = NULL
AS
    BEGIN
        SELECT HurdleRateID, 
               h.FundID, 
               Rate, 
               Capitalized, 
               StartDate, 
               EndDate, 
               Basis, 
               CreatedDate, 
               CreatedBy, 
               ModifiedDate, 
               ModifiedBy
        FROM [LBOffice].[dbo].[tbl_FundHurdleRate] h
        WHERE h.FundID = ISNULL(@FundID, h.FundID)
              AND HurdleRateID = ISNULL(@HurdleRateID, HurdleRateID);
    END;
