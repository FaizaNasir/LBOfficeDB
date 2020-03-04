
-- created by : syed zain ali  
-- created date : 10-Dec-2013  
-- proc_GetDealSource  

CREATE PROC [dbo].[proc_GetDealSource]
(@stageID        INT, 
 @ObjectModuleID INT, 
 @SourceType     INT
)
AS
    BEGIN
        SELECT DealID, 
               DealName, 
               ReceivedDate, 
               DealSize
        FROM tbl_deals d
        WHERE 1 = CASE
                      WHEN @SourceType = 1
                           AND @ObjectModuleID = DealSourceIndividualID
                      THEN 1
                      WHEN @SourceType = 2
                           AND @ObjectModuleID = DealSourceCompanyID
                      THEN 1
                      ELSE 0
                  END
              AND d.DealStageID = ISNULL(@stageID, d.DealStageID);
    END;
