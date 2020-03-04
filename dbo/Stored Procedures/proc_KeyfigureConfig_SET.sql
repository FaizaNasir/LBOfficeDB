CREATE PROCEDURE [dbo].[proc_KeyfigureConfig_SET]
(@KeyFigureConfigID INT, 
 @PortfolioID       INT, 
 @Name              VARCHAR(1000), 
 @NameFr            VARCHAR(1000), 
 @Seq               INT, 
 @IsReport          BIT, 
 @IsChart           BIT, 
 @SubTab            INT, 
 @Active            BIT, 
 @CreatedBy         VARCHAR(100), 
 @ModifiedBy        VARCHAR(100), 
 @date              DATETIME
)
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM tbl_KeyfigureConfig
            WHERE KeyFigureConfigID = @KeyFigureConfigID
        )
            BEGIN
                INSERT INTO tbl_KeyfigureConfig
                (PortfolioID, 
                 Name, 
                 NameFr, 
                 Seq, 
                 IsReport, 
                 IsChart, 
                 SubTab, 
                 Active, 
                 CreatedDateTime, 
                 CreatedBy, 
                 date
                )
                VALUES
                (@PortfolioID, 
                 @Name, 
                 @NameFr, 
                 ISNULL(@Seq, 0), 
                 @IsReport, 
                 @IsChart, 
                 @SubTab, 
                 1, 
                 GETDATE(), 
                 @CreatedBy, 
                 @date
                );
                SET @KeyFigureConfigID = @@IDENTITY;
                IF EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_PortfolioKeyFigure
                    WHERE PortfolioID = @PortfolioID
                          AND ISNULL(Active, 1) = 1
                          AND date = @date
                )
                    BEGIN
                        INSERT INTO tbl_PortfolioKeyFigure
                        (PortfolioID, 
                         TargetPortfolioID, 
                         KeyFigureConfigID, 
                         Year, 
                         Amount, 
                         Active, 
                         CreatedDateTime, 
                         CreatedBy, 
                         SubTab, 
                         date
                        )
                               SELECT PortfolioID, 
                                      TargetPortfolioID, 
                                      @KeyFigureConfigID, 
                                      Year, 
                                      Amount, 
                                      1, 
                                      GETDATE(), 
                                      @CreatedBy, 
                                      SubTab, 
                                      @date
                               FROM tbl_PortfolioKeyFigure
                               WHERE PortfolioID = @PortfolioID
                                     AND ISNULL(active, 1) = 1
                                     AND KeyFigureConfigID =
                               (
                                   SELECT TOP 1 KeyFigureConfigID
                                   FROM tbl_keyfigureconfig kc
                                   WHERE kc.PortfolioID = @PortfolioID
                                         AND date = @date
                               );
                END;
        END;
            ELSE
            BEGIN
                UPDATE [dbo].tbl_KeyfigureConfig
                  SET 
                      PortfolioID = @PortfolioID, 
                      Name = @Name, 
                      NameFr = @NameFr, 
                      Seq = ISNULL(@Seq, 0), 
                      IsReport = @IsReport, 
                      IsChart = @IsChart, 
                      SubTab = @SubTab, 
                      Active = @Active, 
                      ModifiedDateTime = GETDATE(), 
                      ModifiedBy = @ModifiedBy
                WHERE KeyFigureConfigID = @KeyFigureConfigID;
        END;
        SELECT 'Success' AS Result, 
               @KeyFigureConfigID AS 'KeyFigureConfigID';
    END;
