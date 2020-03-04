CREATE PROCEDURE [dbo].[proc_Fund_Strategy_Sector_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT FundStrategySectorID, 
               SectorID, 
               tbl_FundStrategySector.CreatedDateTime, 
               ModifiedDateTime, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               Percentage, 
               IsInclude, 
               FundID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_BusinessArea.BusinessAreaTitle
        FROM tbl_FundStrategySector
             LEFT OUTER JOIN tbl_BusinessArea ON tbl_FundStrategySector.SectorID = tbl_BusinessArea.BusinessAreaID
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
