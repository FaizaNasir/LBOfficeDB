CREATE PROC [dbo].[GetPortfolioFund2PagerKeyIndicator]
(@vehicleID       INT, 
 @parentVehicleID INT, 
 @date            DATETIME
)
AS
    BEGIN
        DECLARE @TotalContributions DECIMAL(18, 3);
        DECLARE @TotalCommitment DECIMAL(18, 3);
        DECLARE @TotalCommitmentsPer DECIMAL(18, 3);
        DECLARE @CumulatedDistributions DECIMAL(18, 3);
        DECLARE @RecallableDistributions DECIMAL(18, 3);
        DECLARE @NetAssetValue DECIMAL(18, 3);
        DECLARE @IncludingPortfolioInvestments DECIMAL(18, 3);
        DECLARE @IncludingPortfolioReevaluation DECIMAL(18, 3);
        DECLARE @IncludingFundCash DECIMAL(18, 3);
        DECLARE @IncludingConstitutionFees DECIMAL(18, 3);
        DECLARE @IncludingWorkingCapital DECIMAL(18, 3);
        DECLARE @IncludingFXHedging DECIMAL(18, 3);
        DECLARE @IncludingBankDebt DECIMAL(18, 3);
        DECLARE @DistributionsContributions DECIMAL(18, 3);
        DECLARE @NAVContributions DECIMAL(18, 3);
        DECLARE @TotalValueContributions DECIMAL(18, 3);
        DECLARE @OtherCommitments DECIMAL(18, 3);
        DECLARE @ExitInvestments DECIMAL(18, 3);
        DECLARE @TotalInvestedORCommittedInPortfolio DECIMAL(18, 3);
        DECLARE @grossIRR DECIMAL(18, 3);
        --SELECT @TotalContributions = SUM(Amount)
        --FROM tbl_PortfolioFundGeneralOperation
        --WHERE VehicleID = @vehicleID
        --      AND TypeID = 2
        --      AND Date <= @date;
        SELECT TOP 1 @TotalContributions = TotalInvested,
		@OtherCommitments = RemainingCommitments,
		@ExitInvestments = RealizedProceeds
        FROM tbl_PortfolioFundNav
        WHERE VehicleID = @vehicleID
              AND Date <= @date
        ORDER BY date DESC;
        --SELECT @TotalCommitment = SUM(Amount)
        --FROM tbl_PortfolioFundGeneralOperation
        --WHERE VehicleID = @vehicleID
        --      AND TypeID = 1
        --      AND Date <= @date;
		SELECT top 1 @TotalCommitment = Size
        FROM tbl_vehicle
        WHERE VehicleID = @vehicleID
        IF ISNULL(@TotalCommitment, 0) <> 0
            BEGIN
                SET @TotalCommitmentsPer = 100 * ISNULL(@TotalContributions, 0) / ISNULL(@TotalCommitment, 0);
        END;
        SELECT @CumulatedDistributions = SUM(Amount)
        FROM tbl_PortfolioFundGeneralOperation
        WHERE TypeID = 3
              AND VehicleID = @vehicleID
              AND Date <= @date;
        SELECT @RecallableDistributions = SUM(Amount)
        FROM tbl_PortfolioFundGeneralOperation
        WHERE TypeID = 5
              AND Date <= @date
              AND VehicleID = @vehicleID;
        SELECT TOP 1 @NetAssetValue = TotalNAV, 
                     @IncludingPortfolioInvestments = PortfolioInvestments, 
                     @IncludingPortfolioReevaluation = PortfolioReevaluation, 
                     @IncludingFundCash = IncludingCash, 
                     @IncludingConstitutionFees = IncludingConstitutionFees, 
                     @IncludingWorkingCapital = IncludingWorkingCapital, 
                     @IncludingFXHedging = IncludingFXHedging, 
                     @IncludingBankDebt = IncludingBankDebt, 
                     @grossIRR = grossIRR
        FROM tbl_PortfolioFundNav
        WHERE VehicleID = @vehicleID
              AND Date <= @date
        ORDER BY date DESC;
        IF @TotalContributions IS NOT NULL
            BEGIN
                SET @DistributionsContributions = ISNULL(@CumulatedDistributions, 0) / @TotalContributions;
                SET @NAVContributions = ISNULL(@NetAssetValue, 0) / @TotalContributions;
                SET @TotalValueContributions = (ISNULL(@NetAssetValue, 0) + ISNULL(@CumulatedDistributions, 0)) / @TotalContributions;
        END;
        SELECT --@OtherCommitments = SUM(RemainingCommitment), 
               --@ExitInvestments = SUM(CASE
               --                           WHEN ExitDate IS NOT NULL
               --                           THEN Invested
               --                           ELSE 0
               --                       END), 
               @TotalInvestedORCommittedInPortfolio = ISNULL(SUM(Invested), 0) + ISNULL(SUM(RemainingCommitment), 0)
        FROM tbl_PortfolioFundUnderlyingInvestments a
             CROSS APPLY
        (
            SELECT TOP 1 *
            FROM tbl_PortfolioFundUnderlyingInvestmentsTrimester b
            WHERE a.PortfolioFundUnderlyingInvestmentsID = b.PortfolioFundUnderlyingInvestmentsID
        ) b
        WHERE vehicleID = @vehicleID;
        SELECT @TotalContributions TotalContributions, 
               @TotalCommitmentsPer TotalCommitmentsPer, 
               @CumulatedDistributions CumulatedDistributions, 
               @RecallableDistributions RecallableDistributions, 
               @NetAssetValue NetAssetValue, 
               @IncludingPortfolioInvestments IncludingPortfolioInvestments, 
               @IncludingPortfolioReevaluation IncludingPortfolioReevaluation, 
               @IncludingFundCash IncludingFundCash, 
               @IncludingConstitutionFees IncludingConstitutionFees, 
               @IncludingWorkingCapital IncludingWorkingCapital, 
               @IncludingFXHedging IncludingFXHedging, 
               @IncludingBankDebt IncludingBankDebt, 
               @DistributionsContributions DistributionsContributions, 
               @NAVContributions NAVContributions, 
               @TotalValueContributions TotalValueContributions, 
               @OtherCommitments OtherCommitments, 
               @ExitInvestments ExitInvestments, 
               @grossIRR GrossIRR, 
               @IncludingPortfolioInvestments + @OtherCommitments + @ExitInvestments TotalInvestedORCommittedInPortfolio;
    END;
