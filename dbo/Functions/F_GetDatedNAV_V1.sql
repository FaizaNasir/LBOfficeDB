--  test 1093,3265,632,'03-01-2017'     

CREATE FUNCTION [dbo].[F_GetDatedNAV_V1]
(@vehicleid   INT, 
 @portfolioid INT, 
 @companyID   INT, 
 @Date        DATETIME, 
 @isFx        BIT      = 0
)
RETURNS DECIMAL(18, 2)
AS
     BEGIN
         DECLARE @holdingCompanyID INT;
         SELECT TOP 1 @holdingCompanyID = objectID
         FROM tbl_ShareholdersOwned s
         WHERE s.targetportfolioid = @companyID
               AND s.ShareholderOwnedDateId =
         (
             SELECT TOP 1 ShareholderDateId
             FROM tbl_ShareholdersOwnedDate sd
             WHERE sd.TargetPortfolioId = s.targetportfolioid
         )
               AND NOT EXISTS
         (
             SELECT TOP 1 1
             FROM tbl_ShareholdersOwned s1
             WHERE objectid = @companyID
         );
         DECLARE @lastValuation DECIMAL(18, 2);
         DECLARE @lastValuationDate DATETIME;
         DECLARE @investment DECIMAL(18, 2);
         DECLARE @divestment DECIMAL(18, 2);
         SELECT TOP 1 @lastValuation = CASE
                                           WHEN @isFx = 0
                                           THEN FinalValuation
                                           ELSE InvestmentValue
                                       END, 
                      @lastValuationDate = date
         FROM tbl_portfoliovaluation pv
         WHERE pv.Date <= @Date
               AND pv.PortfolioID = @portfolioid
               AND pv.VehicleID = @vehicleid
         ORDER BY pv.date DESC;
         SET @investment =
         (
             SELECT SUM(CASE
                            WHEN @isFx = 0
                            THEN Amount
                            ELSE ForeignCurrencyAmount
                        END)
             FROM tbl_PortfolioShareholdingOperations sho
             WHERE sho.Date >= @lastValuationDate
                   AND sho.PortfolioID = @portfolioid
                   AND sho.ToTypeID = 3
                   AND sho.ToID = @vehicleid
         );
         SET @divestment =
         (
             SELECT SUM(CASE
                            WHEN @isFx = 0
                            THEN Amount
                            ELSE ForeignCurrencyAmount
                        END)
             FROM tbl_PortfolioShareholdingOperations sho
             WHERE sho.Date >= @lastValuationDate
                   AND sho.PortfolioID = @portfolioid
                   AND sho.FromTypeID = 3
                   AND sho.FromID = @vehicleid
         );
         IF(@holdingCompanyID IS NOT NULL)
             BEGIN
                 SELECT @portfolioid = portfolioid
                 FROM tbl_portfolio p
                 WHERE p.targetportfolioid = @holdingCompanyID;
                 SET @companyID = @holdingCompanyID;
                 SELECT TOP 1 @lastValuation = ISNULL(@lastValuation, 0) + CASE
                                                                               WHEN @isFx = 0
                                                                               THEN FinalValuation
                                                                               ELSE InvestmentValue
                                                                           END, 
                              @lastValuationDate = date
                 FROM tbl_portfoliovaluation pv
                 WHERE pv.Date <= @Date
                       AND pv.PortfolioID = @portfolioid
                       AND pv.VehicleID = @vehicleid
                 ORDER BY pv.date DESC;
                 SET @investment = ISNULL(@investment, 0) + ISNULL(
                 (
                     SELECT SUM(CASE
                                    WHEN @isFx = 0
                                    THEN Amount
                                    ELSE ForeignCurrencyAmount
                                END)
                     FROM tbl_PortfolioShareholdingOperations sho
                     WHERE sho.Date >= @lastValuationDate
                           AND sho.PortfolioID = @portfolioid
                           AND sho.ToTypeID = 3
                           AND sho.ToID = @vehicleid
                 ), 0);
                 SET @divestment = ISNULL(@divestment, 0) + ISNULL(
                 (
                     SELECT SUM(CASE
                                    WHEN @isFx = 0
                                    THEN Amount
                                    ELSE ForeignCurrencyAmount
                                END)
                     FROM tbl_PortfolioShareholdingOperations sho
                     WHERE sho.Date >= @lastValuationDate
                           AND sho.PortfolioID = @portfolioid
                           AND sho.FromTypeID = 3
                           AND sho.FromID = @vehicleid
                 ), 0);
         END;
         RETURN ISNULL(@lastValuation, 0) + ISNULL(@investment, 0) - ISNULL(@divestment, 0);
     END;
