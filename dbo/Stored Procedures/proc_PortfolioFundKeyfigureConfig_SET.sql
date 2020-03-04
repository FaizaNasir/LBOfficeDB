CREATE PROCEDURE [dbo].[proc_PortfolioFundKeyfigureConfig_SET] --null,1,'ABC1',1,1,1,'test',null            
(@PortfolioFundPortfolioFundKeyfigureConfigID INT, 
 @PortfolioFundUnderlyingInvestmentsID        INT, 
 @Name                                        VARCHAR(1000), 
 @Seq                                         INT, 
 @IsReport                                    BIT, 
 @IsChart                                     BIT, 
 @Active                                      BIT, 
 @CreatedBy                                   VARCHAR(100), 
 @ModifiedBy                                  VARCHAR(100), 
 @date                                        DATETIME
)
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM tbl_PortfolioFundKeyfigureConfig
            WHERE PortfolioFundKeyfigureConfigID = @PortfolioFundPortfolioFundKeyfigureConfigID
        )
            BEGIN
                INSERT INTO tbl_PortfolioFundKeyfigureConfig
                (PortfolioFundUnderlyingInvestmentsID, 
                 Name, 
                 Seq, 
                 IsReport, 
                 IsChart, 
                 Active, 
                 CreatedDateTime, 
                 CreatedBy, 
                 date
                )
                VALUES
                (@PortfolioFundUnderlyingInvestmentsID, 
                 @Name, 
                 ISNULL(@Seq, 0), 
                 @IsReport, 
                 @IsChart, 
                 1, 
                 GETDATE(), 
                 @CreatedBy, 
                 @date
                );
                SET @PortfolioFundPortfolioFundKeyfigureConfigID = @@IDENTITY;
                IF EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_PortfolioFundKeyFigure
                    WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                          AND ISNULL(Active, 1) = 1
                          AND date = @date
                )
                    BEGIN
                        INSERT INTO tbl_PortfolioFundKeyFigure
                        (PortfolioFundUnderlyingInvestmentsID, 
                         VehicleID, 
                         PortfolioFundKeyfigureConfigID, 
                         Year, 
                         Amount, 
                         Active, 
                         CreatedDateTime, 
                         CreatedBy, 
                         SubTab, 
                         date
                        )
                               SELECT PortfolioFundUnderlyingInvestmentsID, 
                                      VehicleID, 
                                      @PortfolioFundPortfolioFundKeyfigureConfigID, 
                                      Year, 
                                      Amount, 
                                      1, 
                                      GETDATE(), 
                                      @CreatedBy, 
                                      SubTab, 
                                      @date
                               FROM tbl_PortfolioFundKeyFigure
                               WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                                     AND ISNULL(active, 1) = 1
                                     AND PortfolioFundKeyfigureConfigID =
                               (
                                   SELECT TOP 1 PortfolioFundKeyfigureConfigID
                                   FROM tbl_PortfolioFundKeyfigureConfig kc
                                   WHERE kc.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                                         AND date = @date
                               );
                END;
        END;
            ELSE
            BEGIN
                UPDATE [dbo].tbl_PortfolioFundKeyfigureConfig
                  SET 
                      PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID, 
                      Name = @Name, 
                      Seq = ISNULL(@Seq, 0), 
                      IsReport = @IsReport, 
                      IsChart = @IsChart, 
                      Active = @Active, 
                      ModifiedDateTime = GETDATE(), 
                      ModifiedBy = @ModifiedBy
                WHERE PortfolioFundKeyfigureConfigID = @PortfolioFundPortfolioFundKeyfigureConfigID;
        END;
        SELECT 'Success' AS Result, 
               @PortfolioFundPortfolioFundKeyfigureConfigID AS 'PortfolioFundKeyfigureConfigID';
    END;
