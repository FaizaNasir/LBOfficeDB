CREATE PROC [dbo].[proc_UpdatePortfolioFundKeyFigures]
(@PortfolioFundUnderlyingInvestmentsID INT, 
 @vehicleID                            INT, 
 @Name                                 VARCHAR(1000), 
 @year                                 VARCHAR(1000), 
 @data                                 VARCHAR(1000), 
 @seq                                  INT           = NULL, 
 @dateHistory                          DATETIME, 
 @Type                                 NVARCHAR(100) = NULL
)
AS
     IF @data = 'CLEAR'
        OR @data = '----'
         SET @data = '';
	    set @year = CONVERT(datetime, @year, 105) 
     DECLARE @PortfolioFundKeyfigureConfigID INT;
     SET @PortfolioFundKeyfigureConfigID =
     (
         SELECT TOP 1 PortfolioFundKeyfigureConfigID
         FROM tbl_PortfolioFundKeyfigureConfig
         WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
               AND Name = @Name

     --AND date = @dateHistory

     );
    BEGIN
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioFundKeyFigure
            WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                  AND VehicleID = @vehicleID
                  AND PortfolioFundKeyfigureConfigID = @PortfolioFundKeyfigureConfigID

                  --AND date = @dateHistory

                  AND YEAR(Year) = YEAR(CAST(@year AS DATETIME))
        )
            BEGIN
                UPDATE tbl_PortfolioFundKeyFigure
                  SET 
                      amount = ISNULL(@data, amount)
                WHERE PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID
                      AND VehicleID = @vehicleID
                      AND PortfolioFundKeyfigureConfigID = @PortfolioFundKeyfigureConfigID

                      --AND date = @dateHistory

                      AND YEAR(Year) = YEAR(CAST(@year AS DATETIME));
        END;
            ELSE
            BEGIN
                INSERT INTO tbl_PortfolioFundKeyFigure
                (PortfolioFundUnderlyingInvestmentsID, 
                 VehicleID, 
                 PortfolioFundKeyfigureConfigID, 
                 Year, 
                 Amount,

                 --Date,

                 Type
                )
                       SELECT @PortfolioFundUnderlyingInvestmentsID, 
                              @vehicleID, 
                              @PortfolioFundKeyfigureConfigID, 
                              CAST(@year AS DATETIME), 
                              @data,

                              --@dateHistory,

                              ISNULL(@Type, 'year');
        END;
        SELECT 1;
    END;
