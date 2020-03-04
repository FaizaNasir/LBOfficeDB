CREATE PROC [dbo].[GetFundReportKeyIndicator]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @isForPortfolioFund BIT;
        DECLARE @CapitalCalls DECIMAL(18, 2);
        DECLARE @Commitments DECIMAL(18, 2);
        DECLARE @Distributions DECIMAL(18, 2);
        DECLARE @DistributionsIncludingRecallable DECIMAL(18, 2);
        DECLARE @NAV DECIMAL(18, 2);
        DECLARE @IncorporationExpenses DECIMAL(18, 2);
        DECLARE @unrealizedHedging DECIMAL(18, 2);
        DECLARE @OfWhichInvestedCapital DECIMAL(18, 2);
        DECLARE @OfwhichValueAdjustments DECIMAL(18, 2);
        DECLARE @OfWhichCash DECIMAL(18, 2);
        DECLARE @OfWhichFormationExpenses DECIMAL(18, 2);
        DECLARE @OfWhichWorkingCapitalRequirements DECIMAL(18, 2);
        DECLARE @OtherInvestmentCommitments DECIMAL(18, 2);
        DECLARE @OtherInvestmentCommitmentsSold DECIMAL(18, 2);
        DECLARE @shares TABLE(ID INT);
        DECLARE @portfolio TABLE(ID INT);
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_VehiclePortfolioFund
            WHERE vehicleid = @vehicleID
        )
            SET @isForPortfolioFund = 1;
            ELSE
            SET @isForPortfolioFund = 0;
        INSERT INTO @shares
               SELECT VehicleShareID
               FROM tbl_vehicleshare
               WHERE IncludedReport = 1
                     AND vehicleid = @vehicleid;
        INSERT INTO @portfolio
               SELECT portfolioID
               FROM tbl_PortfolioVehicle
               WHERE vehicleid = @vehicleID
                     AND STATUS <> 4;
        SELECT @CapitalCalls = SUM(ISNULL(amount, 0.00))
        FROM tbl_CapitalCall c
             JOIN tbl_capitalcalllimitedpartner lpc ON c.CapitalCallID = lpc.CapitalCallID
        WHERE c.Fundid = @vehicleID
              AND c.CallDate <= @date
              AND 1 = CASE
                          WHEN c.TotalValidationReq = 0
                          THEN 1
                          WHEN c.TotalValidationReq = 1
                               AND c.IsApproved1 = 1
                          THEN 1
                          WHEN c.TotalValidationReq = 2
                               AND c.IsApproved2 = 1
                          THEN 1
                          ELSE 0
                      END
              AND lpc.ShareID IN
        (
            SELECT *
            FROM @shares
        );
        SELECT @Commitments = SUM(ISNULL(amount, 0.00))
        FROM tbl_LimitedPartnerDetail cc
             JOIN tbl_LimitedPartner ccal ON cc.LimitedPartnerID = ccal.LimitedPartnerID
        WHERE ccal.VehicleID = @VehicleID
              AND ccal.Date <= @date
              AND cc.ShareID IN
        (
            SELECT *
            FROM @shares
        );
        SELECT @Distributions = SUM(ISNULL(amount, 0.00))
        FROM tbl_distribution d
             JOIN tbl_DistributionLimitedPartner lpd ON d.DistributionID = lpd.DistributionID
        WHERE d.FundID = @vehicleID
              AND 1 = CASE
                          WHEN d.TotalValidationReq = 0
                          THEN 1
                          WHEN d.TotalValidationReq = 1
                               AND d.IsApproved1 = 1
                          THEN 1
                          WHEN d.TotalValidationReq = 2
                               AND d.IsApproved2 = 1
                          THEN 1
                          ELSE 0
                      END
              AND d.Date <= @date
              AND lpd.ShareID IN
        (
            SELECT *
            FROM @shares
        );
        SELECT @DistributionsIncludingRecallable = SUM(ISNULL(amount, 0.00))
        FROM tbl_distribution d
             JOIN tbl_DistributionLimitedPartner lpd ON d.DistributionID = lpd.DistributionID
        WHERE d.FundID = @vehicleID
              AND 1 = CASE
                          WHEN d.TotalValidationReq = 0
                          THEN 1
                          WHEN d.TotalValidationReq = 1
                               AND d.IsApproved1 = 1
                          THEN 1
                          WHEN d.TotalValidationReq = 2
                               AND d.IsApproved2 = 1
                          THEN 1
                          ELSE 0
                      END
              AND d.RecallableDistributionAmount IS NOT NULL
              AND d.Date <= @date
              AND lpd.ShareID IN
        (
            SELECT *
            FROM @shares
        );
        SELECT TOP 1 @NAV = ISNULL(PortfolioNAV, 0) + ISNULL(WorkingCapital, 0) + ISNULL(Cash, 0) + ISNULL(Other, 0) + ISNULL(Expenses, 0) + ISNULL(UnrealizedHedging, 0), 
                     @OfWhichCash = Cash, 
                     @OfWhichInvestedCapital = CASE
                                                   WHEN @isForPortfolioFund = 1
                                                   THEN ISNULL(PortfolioNAV, 0)
                                                   ELSE 0
                                               END, 
                     @OfWhichFormationExpenses = Other, 
                     @OfWhichWorkingCapitalRequirements = WorkingCapital, 
                     @IncorporationExpenses = Expenses, 
                     @unrealizedHedging = UnrealizedHedging
        FROM tbl_VehicleNav
        WHERE VehicleID = @vehicleID
              AND NavDate <= @date
              AND 1 = CASE
                          WHEN TotalValidationReq = 0
                          THEN 1
                          WHEN TotalValidationReq = 1
                               AND IsApproved1 = 1
                          THEN 1
                          WHEN TotalValidationReq = 2
                               AND IsApproved2 = 1
                          THEN 1
                          ELSE 0
                      END
        ORDER BY NavDate DESC;
        IF @isForPortfolioFund = 0
            SET @OfWhichInvestedCapital =
            (
                SELECT SUM(ISNULL(amount, 0))
                FROM tbl_PortfolioShareholdingOperations sho
                WHERE sho.Date <= @date
                      AND sho.ToTypeID = 3
                      AND sho.toid = @vehicleID
                      AND sho.PortfolioID IN
                (
                    SELECT *
                    FROM @portfolio
                )
            ) + ISNULL(
            (
                SELECT SUM(ISNULL(AmountDue, 0))
                FROM tbl_PortfolioFollowOnPayment f
                     JOIN tbl_PortfolioShareholdingOperations sho ON sho.ShareholdingOperationID = f.ShareholdingOperationID
                WHERE f.Date <= @date
                      AND sho.ToTypeID = 3
                      AND sho.toid = @vehicleID
                      AND sho.PortfolioID IN
                (
                    SELECT *
                    FROM @portfolio
                )
            ), 0) + ISNULL(
            (
                SELECT SUM(ISNULL(amount, 0))
                FROM tbl_PortfolioGeneralOperation sho
                WHERE sho.Date <= @date
                      AND sho.TypeID IN(1, 3, 7, 8)
                AND 1 = CASE
                            WHEN FromModuleID = 3
                                 AND FromID = @vehicleID
                            THEN 1
                            WHEN ToModuleID = 3
                                 AND ToID = @vehicleID
                            THEN 1
                        END
                AND sho.PortfolioID IN
                (
                    SELECT *
                    FROM @portfolio
                )
            ), 0);
        SET @OfwhichValueAdjustments =
        (
            SELECT SUM(finalvaluation)
            FROM
            (
                SELECT
                (
                    SELECT TOP 1 finalvaluation
                    FROM tbl_PortfolioValuation pv
                    WHERE pv.PortfolioID = p.ID
                          AND pv.VehicleID = @vehicleID
                          AND pv.Date <= @date
                    ORDER BY pv.date DESC
                ) finalvaluation
                FROM @portfolio p
            ) t
        ) - @OfWhichInvestedCapital;

        --select * from @portfolio

        IF @isForPortfolioFund = 0
            SET @OtherInvestmentCommitments =
            (
                SELECT SUM(ReturnCapitalEUR)
                FROM tbl_PortfolioShareholdingOperations sho
                WHERE sho.Date <= @date
                      AND sho.PortfolioID IN
                (
                    SELECT *
                    FROM @portfolio
                )
                      AND 1 = CASE
                                  WHEN ToTypeID = 3
                                       AND ToID = @vehicleID
                                  THEN 1
                                  ELSE 0
                              END
            );
            ELSE
            SET @OtherInvestmentCommitments = (ISNULL(
            (
                SELECT SUM(CASE
                               WHEN sho.typeid = 1
                               THEN Amount
                               WHEN sho.typeid = 2
                               THEN-1 * Amount
                               ELSE 0
                           END)
                FROM tbl_PortfolioFundGeneralOperation sho
                     JOIN tbl_vehicle v ON sho.vehicleid = v.vehicleid
                WHERE sho.Date <= @date
                      AND v.IsExit = 0
                      AND (ToID = @vehicleID
                           OR FromID = @vehicleID)
            ), 0));
        IF @isForPortfolioFund = 0
            SET @OtherInvestmentCommitmentsSold =
            (
                SELECT SUM(ForeignCurrencyAmount)
                FROM tbl_PortfolioShareholdingOperations sho
                WHERE sho.Date <= @date
                      AND sho.PortfolioID IN
                (
                    SELECT portfolioID
                    FROM tbl_PortfolioVehicle
                    WHERE vehicleid = @vehicleid
                          AND STATUS = 4
                )
                      AND 1 = CASE
                                  WHEN ToTypeID = 3
                                       AND ToID = @vehicleid
                                  THEN 1
                                  ELSE 0
                              END
            );
            ELSE
            SET @OtherInvestmentCommitmentsSold = (ISNULL(
            (
                SELECT SUM(CASE
                               WHEN sho.typeid = 1
                               THEN Amount
                               WHEN sho.typeid = 2
                               THEN-1 * Amount
                               ELSE 0
                           END)
                FROM tbl_PortfolioFundGeneralOperation sho
                     JOIN tbl_vehicle v ON sho.vehicleid = v.vehicleid
                WHERE sho.Date <= @date
                      AND v.IsExit = 1
                      AND (ToID = @vehicleID
                           OR FromID = @vehicleID)
            ), 0));

        --+ ISNULL(
        --              (
        --                  SELECT SUM(isnull(AmountDue, 0))
        --           FROM tbl_PortfolioFollowOnPayment f
        --                       JOIN tbl_PortfolioShareholdingOperations sho ON sho.ShareholdingOperationID = f.ShareholdingOperationID
        --                  WHERE f.Date <= @date
        --                        AND sho.PortfolioID IN
        --                  (
        --                      SELECT *
        --                      FROM @portfolio
        --                  )
        --                        AND 1 = CASE
        --                                    WHEN ToTypeID = 3
        --                                         AND ToID = @vehicleID
        --                                    THEN 1
        --                                    ELSE 0
        --                                END
        --              ), 0);

        SELECT @Capitalcalls Capitalcalls, 
               @Commitments Commitments,
               CASE
                   WHEN @Commitments != 0
                   THEN @Capitalcalls / @Commitments
                   ELSE 0
               END CommitmentsPer, 
               @Distributions Distributions,
               CASE
                   WHEN @Capitalcalls != 0
                   THEN @Distributions / @Capitalcalls
                   ELSE 0
               END DistributionsPaidCapital, 
               @DistributionsIncludingRecallable DistributionsIncludingRecallable, 
               @NAV NAV, 
               @OfWhichInvestedcapital OfWhichInvestedcapital, 
               @OfwhichValueAdjustments OfwhichValueAdjustments, 
               @OfWhichCash OfWhichCash, 
               @OfWhichFormationExpenses OfWhichFormationExpenses, 
               @OfWhichWorkingCapitalRequirements OfWhichWorkingCapitalRequirements,
               CASE
                   WHEN @Capitalcalls != 0
                   THEN @NAV / @Capitalcalls
                   ELSE 0
               END ResidualValuetoPaidin,
               CASE
                   WHEN @Capitalcalls != 0
                   THEN(@Distributions + @NAV) / @Capitalcalls
                   ELSE 0
               END TotalValuetoPaidin, 
               @OtherInvestmentCommitments OtherInvestmentCommitments, 
               @OtherInvestmentCommitmentsSold OtherInvestmentCommitmentsSold, 
               @unrealizedHedging UnrealizedHedging, 
               @IncorporationExpenses IncorporationExpenses, 
               ISNULL(@OfWhichInvestedCapital, 0) + ISNULL(@OtherInvestmentCommitments, 0) + ISNULL(@OtherInvestmentCommitmentsSold, 0) InvestedCapitalIncludingCncalledCommitments;
    END;
