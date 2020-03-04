CREATE PROC [dbo].[proc_vehicleNav_get]
(@vehicleID    INT, 
 @vehicleNavID INT
)
AS
    BEGIN
        SELECT VehicleNavID, 
               VehicleID, 
               NavDate, 
               PortfolioNAV, 
               WorkingCapital, 
               Cash, 
               Other, 
               Audited, 
               Notes, 
               Active, 
               CreatedDateTime, 
               CreatedBy, 
               ModifiedDateTime, 
               ModifiedBy, 
               ISNULL(PortfolioNAV, 0) + ISNULL(WorkingCapital, 0) + ISNULL(Cash, 0) + ISNULL(Other, 0) + ISNULL(Expenses, 0) FundNav, 
        (
            SELECT CurrencyCode
            FROM tbl_vehicle v
                 JOIN tbl_currency c ON c.currencyid = v.currencyid
            WHERE v.vehicleID = @vehicleid
        ) CurrencyCode, 
               ISNULL(
        (
            SELECT COUNT(*)
            FROM tbl_vehiclenavlimitedpartner inndist
            WHERE inndist.VehicleNavID = S.VehicleNavID
        ), 0) AS LPBreakDownCount, 
               ISNULL(IsApproved1, 0) IsApproved1, 
               Log1, 
               ISNULL(IsApproved2, 0) IsApproved2, 
               Log2, 
               TotalValidationReq, 
               UserRole1, 
               UserRole2, 
               Expenses, 
               UnrealizedHedging, 
               DocStatus, 
               RealisedGains, 
               OperatingProfits, 
               GainLossesRevaluationToFV, 
               CarriedInterestAccrued, 
               TransactionFees, 
               GPFees, 
               CashOverDraft, 
               RevenueExpenses, 
               Expenses1, 
               Revenue, 
               NetSurplusDeficit, 
               NetSurplusPeriod, 
               ExpensesManagementFees, 
               ExpensesTransactionFees, 
               ExpensesAbortionFees, 
               ExpensesOthers, 
               RealizsedMarketableSecurities, 
               RealizsedPortfolioInvestments, 
               UnrealisedMarketableSecurities, 
               UnrealisedAccruedInterest, 
               UnrealisedRevaluationInvestments, 
               RetainedProceeds, 
               UnrealisedGains, 
               PotentialLiabilities
        FROM tbl_vehiclenav S
        WHERE vehicleID = @vehicleID
              AND VehicleNavID = ISNULL(@VehicleNavID, VehicleNavID)
        ORDER BY NavDate DESC;
    END;