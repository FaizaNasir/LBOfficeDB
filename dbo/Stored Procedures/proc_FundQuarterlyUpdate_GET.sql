
-- created by	:	Syed Zain ALi
-- [proc_FundQuarterlyUpdate_GET] 8,'OverView',null     

CREATE PROCEDURE [dbo].[proc_FundQuarterlyUpdate_GET] --62,'OverView',null          
@FundID                INT           = NULL, 
@UpdateType            VARCHAR(100)  = NULL, 
@FundQuarterlyUpdateID INT           = NULL, 
@SearchKey             NVARCHAR(100) = NULL
AS
    BEGIN
        IF(@SearchKey IS NULL)
            BEGIN
                SELECT [FundQuarterlyUpdateID], 
                       [FundID], 
                       [Date], 
                       [Comments], 
                       [UpdateType], 
                       f.individualid, 
                       ci.individualFullName, 
                       f.CreatedDate
                FROM [LBOffice].[dbo].[tbl_FundQuarterlyUpdates] f
                     LEFT JOIN tbl_contactindividual ci ON ci.individualid = f.individualid
                WHERE FundID = ISNULL(@FundID, FundID)
                      AND UpdateType = ISNULL(@UpdateType, UpdateType)
                      AND FundQuarterlyUpdateID = ISNULL(@FundQuarterlyUpdateID, FundQuarterlyUpdateID)
                ORDER BY [Date] DESC;
        END;
            ELSE
            BEGIN
                SELECT [FundQuarterlyUpdateID], 
                       [FundID], 
                       [Date], 
                       [Comments], 
                       [UpdateType], 
                       f.individualid, 
                       ci.individualFullName, 
                       f.CreatedDate
                FROM [LBOffice].[dbo].[tbl_FundQuarterlyUpdates] f
                     LEFT JOIN tbl_contactindividual ci ON ci.individualid = f.individualid
                WHERE FundID = ISNULL(@FundID, FundID)
                      AND UpdateType = ISNULL(@UpdateType, UpdateType)
                      AND FundQuarterlyUpdateID = ISNULL(@FundQuarterlyUpdateID, FundQuarterlyUpdateID)
                      AND [Comments] LIKE ISNULL('%' + @SearchKey + '%', [Comments])
                ORDER BY [Date] DESC;
        END;
    END;
