CREATE PROCEDURE [dbo].[proc_Portfolio_SET] @TargetPortfolioID INT          = NULL, 
                                            @ModuleID          INT          = NULL, 
                                            @Active            BIT          = NULL, 
                                            @CreatedBy         VARCHAR(100) = NULL, 
                                            @CreatedDateTime   DATETIME     = NULL, 
                                            @ModifiedBy        VARCHAR(100) = NULL, 
                                            @ModifiedDateTime  DATETIME     = NULL
AS
     DECLARE @PortfolioID INT= NULL;
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM tbl_Portfolio
            WHERE TargetPortfolioID = @TargetPortfolioID
                  AND ModuleID = @ModuleID
        )
            BEGIN
                INSERT INTO [tbl_Portfolio]
                (TargetPortfolioID, 
                 ModuleID, 
                 Active, 
                 CreatedBy, 
                 CreatedDateTime, 
                 ModifiedBy, 
                 ModifiedDateTime
                )
                VALUES
                (@TargetPortfolioID, 
                 @ModuleID, 
                 @Active, 
                 @CreatedBy, 
                 @CreatedDateTime, 
                 @ModifiedBy, 
                 @ModifiedDateTime
                );
                SET @PortfolioID = @@IDENTITY;
                SELECT 'Success' AS Result, 
                       @PortfolioID AS 'PortfolioID';
        END;
            ELSE
            BEGIN
                SET @PortfolioID =
                (
                    SELECT PortfolioID
                    FROM tbl_Portfolio
                    WHERE TargetPortfolioID = @TargetPortfolioID
                          AND ModuleID = @ModuleID
                );
        END;
        IF NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_KeyfigureConfig cc
            WHERE cc.PortfolioID = @PortfolioID
                  AND CONVERT(DATE, date) = CONVERT(DATE, date)
        )
            BEGIN
                INSERT INTO tbl_KeyfigureConfig
                (PortfolioID, 
                 Name, 
                 Seq, 
                 IsReport, 
                 SubTab, 
                 Active, 
                 Date
                )
                       SELECT @PortfolioID, 
                              name, 
                              seq, 
                              1, 
                              1, 
                              1, 
                              CONVERT(DATE, GETDATE())
                       FROM
                       (
                           SELECT 0 seq, 
                                  'Include in report' name
                           UNION ALL
                           SELECT 1 seq, 
                                  'Category'
                           UNION ALL
                           SELECT 2, 
                                  'Start date'
                           UNION ALL
                           SELECT 3, 
                                  'End date'
                           UNION ALL
                           SELECT 4, 
                                  'Revenues'
                           UNION ALL
                           SELECT 5, 
                                  'EBITDA'
                           UNION ALL
                           SELECT 6, 
                                  'EBIT'
                           UNION ALL
                           SELECT 7, 
                                  'Net profit'
                           UNION ALL
                           SELECT 8, 
                                  'Net financial debt'
                           UNION ALL
                           SELECT 9, 
                                  'Enterprise value'
                       ) t;
        END;
        SELECT 'Fail' AS Result, 
               @PortfolioID AS 'PortfolioID';
    END;
