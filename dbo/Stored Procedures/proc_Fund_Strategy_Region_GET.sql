CREATE PROCEDURE [dbo].[proc_Fund_Strategy_Region_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT FundStrategyRegionID, 
               RegionID, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               CreatedDateTime, 
               ModifiedDateTime, 
               Percentage, 
               IsInclude, 
               FundID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_Contenents.ContenentName
        FROM tbl_FundStrategyRegion
             LEFT OUTER JOIN tbl_Contenents ON tbl_FundStrategyRegion.RegionID = tbl_Contenents.ContenentID
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
