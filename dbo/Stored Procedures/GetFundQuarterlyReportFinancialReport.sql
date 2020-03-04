CREATE PROC [dbo].GetFundQuarterlyReportFinancialReport
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        DECLARE @capitalContributedAShare DECIMAL(18, 6);
        DECLARE @capitalContributedBShare DECIMAL(18, 6);
        DECLARE @capitalContributedCShare DECIMAL(18, 6);
        DECLARE @capitalContributedDShare DECIMAL(18, 6);
        DECLARE @totalcapitalContributed DECIMAL(18, 6);
        DECLARE @currency VARCHAR(1000);
        DECLARE @totalCommitment DECIMAL(18, 6);
        DECLARE @capitaldistributedAShare DECIMAL(18, 6);
        DECLARE @capitaldistributedBShare DECIMAL(18, 6);
        DECLARE @capitaldistributedCShare DECIMAL(18, 6);
        DECLARE @capitaldistributedDShare DECIMAL(18, 6);
        DECLARE @totaldistributedContributed DECIMAL(18, 6);
        DECLARE @NETNVESTMENT DECIMAL(18, 6);
        DECLARE @Netsurplusyear DECIMAL(18, 6);
        DECLARE @Netsurplusperiod DECIMAL(18, 6);
        DECLARE @NetsurplusTotal DECIMAL(18, 6);
        DECLARE @NAVAShare DECIMAL(18, 6);
        DECLARE @NAVBShare DECIMAL(18, 6);
        DECLARE @NAVCShare DECIMAL(18, 6);
        DECLARE @NAVDShare DECIMAL(18, 6);
        DECLARE @TotalNAV DECIMAL(18, 6);
        DECLARE @NumAShare DECIMAL(18, 6);
        DECLARE @NumBShare DECIMAL(18, 6);
        DECLARE @NumCShare DECIMAL(18, 6);
        DECLARE @NumDShare DECIMAL(18, 6);
        DECLARE @NAVPerAShare DECIMAL(18, 6);
        DECLARE @NAVPerBShare DECIMAL(18, 6);
        DECLARE @NAVPerCShare DECIMAL(18, 6);
        DECLARE @NAVPerDShare DECIMAL(18, 6);
        DECLARE @REMAININGOPENCOMMITMENT DECIMAL(18, 6);
        DECLARE @NetcashCost DECIMAL(18, 6);
        DECLARE @NetcashValuation DECIMAL(18, 6);
        DECLARE @Total DECIMAL(18, 6);
        DECLARE @Managementfees DECIMAL(18, 6);
        DECLARE @Transactionfees DECIMAL(18, 6);
        DECLARE @Abortionfees DECIMAL(18, 6);
        DECLARE @Others DECIMAL(18, 6);
        DECLARE @Realisedmarketablesecurities DECIMAL(18, 6);
        DECLARE @Realisedportfolioinvestments DECIMAL(18, 6);
        DECLARE @UnRealisedmarketablesecurities DECIMAL(18, 6);
        DECLARE @UnrealisedAccruedinterest DECIMAL(18, 6);
        DECLARE @Unrealisedrevaluationinvestments DECIMAL(18, 6);
        DECLARE @Preliminaryexpenses DECIMAL(18, 6);
        DECLARE @GrandTotal DECIMAL(18, 6);
        DECLARE @UnrealizedHedging DECIMAL(18, 6);
        DECLARE @PotentialLiabilities DECIMAL(18, 6);

        --              
        SELECT @totalCommitment = SUM(amount)
        FROM tbl_LimitedPartner lp
             JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID
             JOIN tbl_vehicleshare vs ON vs.VehicleShareID = lpd.ShareID
                                         AND vs.VehicleID = lp.VehicleID
        WHERE lp.VehicleID = @vehicleID
              AND lp.Date <= @date;
        SELECT @totalcapitalContributed = SUM(Amount), 
               @capitalContributedAShare = SUM(CASE
                                                   WHEN vs.ShareName = 'A'
                                                   THEN amount
                                                   ELSE NULL
                                               END), 
               @capitalContributedBShare = SUM(CASE
                                                   WHEN vs.ShareName = 'B'
                                                   THEN amount
                                                   ELSE NULL
                                               END), 
               @capitalContributedCShare = SUM(CASE
                                                   WHEN vs.ShareName = 'C'
                                                   THEN amount
                                                   ELSE NULL
                                               END), 
               @capitalContributedDShare = SUM(CASE
                                                   WHEN vs.ShareName = 'D'
                                                   THEN amount
                                                   ELSE NULL
                                               END)
        FROM tbl_CapitalCall cl
             JOIN tbl_CapitalCallLimitedPartner clp ON cl.CapitalCallID = clp.CapitalCallID
             JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                         AND vs.VehicleID = cl.FundID
        WHERE cl.FundID = @vehicleID
              AND cl.DueDate <= @date;
        SELECT @totaldistributedContributed = SUM(Amount), 
               @capitaldistributedAShare = SUM(CASE
                                                   WHEN vs.ShareName = 'A'
                                                   THEN amount
                                                   ELSE NULL
                                               END), 
               @capitaldistributedBShare = SUM(CASE
                                                   WHEN vs.ShareName = 'B'
                                                   THEN amount
                                                   ELSE NULL
                                               END), 
               @capitaldistributedCShare = SUM(CASE
                                                   WHEN vs.ShareName = 'C'
                                                   THEN amount
                                                   ELSE NULL
                                               END), 
               @capitaldistributedDShare = SUM(CASE
                                                   WHEN vs.ShareName = 'D'
                                                   THEN amount
                                                   ELSE NULL
                                               END)
        FROM tbl_Distribution cl
             JOIN tbl_DistributionLimitedPartner clp ON cl.DistributionID = clp.DistributionID
             JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                         AND vs.VehicleID = cl.FundID
        WHERE cl.FundID = @vehicleID
              AND cl.Date <= @date;
        DECLARE @vehicleNavID INT;
        SET @vehicleNavID =
        (
            SELECT TOP 1 vehiclenavid
            FROM tbl_VehicleNav
            WHERE vehicleid = @vehicleid
                  AND navdate <= @date
            ORDER BY navdate DESC
        );
        SET @TotalNAV =
        (
            SELECT SUM(TotalNav)
            FROM tbl_VehicleNav cl
                 JOIN tbl_VehicleNavDetails clp ON cl.VehicleNavID = clp.VehicleNavID
                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                             AND vs.VehicleID = cl.VehicleID
            WHERE cl.VehicleID = @vehicleID
                  AND cl.VehicleNavID = @vehicleNavID
        );
        SET @NAVAShare =
        (
            SELECT TOP 1 TotalNav
            FROM tbl_VehicleNav cl
                 JOIN tbl_VehicleNavDetails clp ON cl.VehicleNavID = clp.VehicleNavID
                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                             AND vs.VehicleID = cl.VehicleID
            WHERE cl.VehicleID = @vehicleID
                  AND cl.VehicleNavID = @vehicleNavID
                  AND vs.sharename LIKE 'A'
            ORDER BY cl.NavDate DESC
        );
        SET @NAVBShare =
        (
            SELECT TOP 1 TotalNav
            FROM tbl_VehicleNav cl
                 JOIN tbl_VehicleNavDetails clp ON cl.VehicleNavID = clp.VehicleNavID
                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                             AND vs.VehicleID = cl.VehicleID
            WHERE cl.VehicleID = @vehicleID
                  AND cl.VehicleNavID = @vehicleNavID
                  AND vs.sharename LIKE 'B'
            ORDER BY cl.NavDate DESC
        );
        SET @NAVCShare =
        (
            SELECT TOP 1 TotalNav
            FROM tbl_VehicleNav cl
                 JOIN tbl_VehicleNavDetails clp ON cl.VehicleNavID = clp.VehicleNavID
                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                             AND vs.VehicleID = cl.VehicleID
            WHERE cl.VehicleID = @vehicleID
                  AND cl.VehicleNavID = @vehicleNavID
                  AND vs.sharename LIKE 'C'
            ORDER BY cl.NavDate DESC
        );
        SET @NAVPerAShare =
        (
            SELECT TOP 1 NavPerShare
            FROM tbl_VehicleNav cl
                 JOIN tbl_VehicleNavDetails clp ON cl.VehicleNavID = clp.VehicleNavID
                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                             AND vs.VehicleID = cl.VehicleID
            WHERE cl.VehicleID = @vehicleID
                  AND cl.NavDate <= @date
                  AND vs.ShareName LIKE 'A'
            ORDER BY cl.NavDate DESC
        );
        SET @NAVPerBShare =
        (
            SELECT TOP 1 NavPerShare
            FROM tbl_VehicleNav cl
                 JOIN tbl_VehicleNavDetails clp ON cl.VehicleNavID = clp.VehicleNavID
                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                             AND vs.VehicleID = cl.VehicleID
            WHERE cl.VehicleID = @vehicleID
                  AND cl.NavDate <= @date
                  AND vs.ShareName LIKE 'B'
            ORDER BY cl.NavDate DESC
        );
        SET @NAVPerCShare =
        (
            SELECT TOP 1 NavPerShare
            FROM tbl_VehicleNav cl
                 JOIN tbl_VehicleNavDetails clp ON cl.VehicleNavID = clp.VehicleNavID
                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID
                                             AND vs.VehicleID = cl.VehicleID
            WHERE cl.VehicleID = @vehicleID
                  AND cl.NavDate <= @date
                  AND vs.ShareName LIKE 'C'
            ORDER BY cl.NavDate DESC
        );
        SET @currency =
        (
            SELECT TOP 1 c.CurrencyCode
            FROM tbl_Vehicle v
                 JOIN tbl_Currency c ON c.CurrencyID = v.CurrencyID
            WHERE v.VehicleID = @vehicleID
        );
        SELECT TOP 1 @NetcashCost = Cash, 
                     @Netsurplusyear = NetSurplusDeficit, 
                     @Netsurplusperiod = NetSurplusPeriod, 
                     @NetcashValuation = Cash, 
                     @Managementfees = ExpensesManagementFees, 
                     @Transactionfees = ExpensesTransactionFees, 
                     @Abortionfees = ExpensesAbortionFees, 
                     @Others = ExpensesOthers, 
                     @Realisedmarketablesecurities = RealizsedMarketableSecurities, 
                     @UnrealizedHedging = UnrealizedHedging, 
                     @Realisedportfolioinvestments = RealizsedPortfolioInvestments, 
                     @UnRealisedmarketablesecurities = UnrealisedMarketableSecurities, 
                     @UnrealisedAccruedinterest = UnrealisedAccruedInterest, 
                     @Unrealisedrevaluationinvestments = UnrealisedRevaluationInvestments, 
                     @Preliminaryexpenses = Expenses1, 
                     @PotentialLiabilities = PotentialLiabilities
        FROM tbl_VehicleNav cl
        WHERE cl.VehicleID = @vehicleID
              AND cl.NavDate = @date;
        SET @NETNVESTMENT = ISNULL(@totalcapitalContributed, 0) - ISNULL(@totaldistributedContributed, 0);
        SET @REMAININGOPENCOMMITMENT = ISNULL(@totalCommitment, 0) - ISNULL(@totalcapitalContributed, 0);
        SET @GrandTotal = ISNULL(@Managementfees, 0) + ISNULL(@Transactionfees, 0) + ISNULL(@Abortionfees, 0) + ISNULL(@Others, 0) + ISNULL(@Realisedmarketablesecurities, 0) + ISNULL(@Realisedportfolioinvestments, 0) + ISNULL(@UnRealisedmarketablesecurities, 0) + ISNULL(@UnrealisedAccruedinterest, 0) + ISNULL(@Unrealisedrevaluationinvestments, 0);
        SELECT @capitalContributedAShare CapitalContributedAShare, 
               @capitalContributedBShare CapitalContributedBShare, 
               @capitalContributedCShare CapitalContributedCShare, 
               @capitalContributedDShare CapitalContributedDShare, 
               @totalcapitalContributed TotalCapitalContributed, 
               @currency Currency, 
               @totalCommitment TotalCommitment, 
               @capitaldistributedAShare CapitalDistributedAShare, 
               @capitaldistributedBShare CapitalDistributedBShare, 
               @capitaldistributedCShare CapitalDistributedCShare, 
               @capitaldistributedDShare CapitalDistributedDShare, 
               @totaldistributedContributed TotalDistributedContributed, 
               @NETNVESTMENT NetInvestment, 
               @Netsurplusyear NetsurplusYear, 
               @Netsurplusperiod NetsurplusPeriod, 
               @NetsurplusTotal NetsurplusTotal, 
               @NAVAShare NavAShare, 
               @NAVBShare NavBShare, 
               @NAVCShare NavCShare, 
               @NAVDShare NavDShare, 
               @TotalNAV TotalNav, 
               @NumAShare NumAShare, 
               @NumBShare NumBShare, 
               @NumCShare NumCShare, 
               @NumDShare NumDShare, 
               @NAVPerAShare NavPerAShare, 
               @NAVPerBShare NavPerBShare, 
               @NAVPerCShare NavPerCShare, 
               @NAVPerDShare NavPerDShare, 
               @REMAININGOPENCOMMITMENT RemainingOpenCommitments, 
               @NetcashCost NetcashCost, 
               @NetcashValuation NetcashValuation, 
               @Managementfees ManagementFees, 
               @Transactionfees TransactionFees, 
               @Abortionfees AbortionFees, 
               @Others Others, 
               @Realisedmarketablesecurities RealisedMarketableSecurities, 
               @Realisedportfolioinvestments RealisedportfolioInvestments, 
               @UnRealisedmarketablesecurities UnRealisedMarketableSecurities, 
               @UnrealisedAccruedinterest UnrealisedAccruedInterest, 
               @Unrealisedrevaluationinvestments UnrealisedRevaluationInvestments, 
               @Preliminaryexpenses PreliminaryExpenses, 
               @GrandTotal GrandTotal, 
               @UnrealizedHedging UnrealizedHedging, 
               @PotentialLiabilities PotentialLiabilities;
    END;
