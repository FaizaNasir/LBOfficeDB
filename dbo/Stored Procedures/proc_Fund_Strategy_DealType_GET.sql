CREATE PROCEDURE [dbo].[proc_Fund_Strategy_DealType_GET] @FundID INT = NULL
AS
    BEGIN
        SELECT FundStrategyDealTypeID, 
               DealTypeID, 
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
               tbl_DealType.ProjectTypeTitle
        FROM tbl_FundStrategyDealType
             LEFT OUTER JOIN tbl_DealType ON tbl_FundStrategyDealType.DealTypeID = tbl_DealType.ProjectTypeID
        WHERE FundID = ISNULL(@FundID, FundID);
    END;
