CREATE PROC test  
(@vehicleID INT,   
 @date      DATETIME  
)  
AS  
    BEGIN  
        SET @date = CONVERT(VARCHAR(10), CAST(@date AS DATETIME), 20) + ' 23:59:59';  
        DECLARE @tblMCT TABLE  
        (ModuleID INT,   
         ObjectID INT  
        );  
        DECLARE @RVPI DECIMAL(18, 6);  
        DECLARE @Calls DECIMAL(18, 6);  
	   DECLARE @CallsAB DECIMAL(18, 6); 
        DECLARE @DPI DECIMAL(18, 6);  
        DECLARE @TVPI DECIMAL(18, 6);  
        DECLARE @PICC DECIMAL(18, 6);  
        DECLARE @shares VARCHAR(1000);  
        DECLARE @distributionID INT;  
        DECLARE @capitalcallid INT;  
        DECLARE @vehiclenavID INT;  
        DECLARE @LPShare DECIMAL(18, 6);  
        DECLARE @LPSharePer DECIMAL(18, 6);  
        DECLARE @GPShare DECIMAL(18, 6);  
        DECLARE @GPSharePer DECIMAL(18, 6);  
        DECLARE @ShareAB DECIMAL(18, 6);  
        DECLARE @ShareA DECIMAL(18, 6);  
        DECLARE @ShareB DECIMAL(18, 6);  
        DECLARE @nominalValA DECIMAL(18, 6);  
        DECLARE @ShareAPer DECIMAL(18, 6);  
        DECLARE @nominalValB DECIMAL(18, 6);  
        DECLARE @ShareC DECIMAL(18, 6);  
        DECLARE @nominalValC DECIMAL(18, 6);  
        DECLARE @ShareCPer DECIMAL(18, 6);  
        DECLARE @TotalCommitedCapital DECIMAL(18, 6);  
        DECLARE @TotalCommitedCapitalPer DECIMAL(18, 6);  
        DECLARE @TransactionFees DECIMAL(18, 6);  
        DECLARE @TransactionFeesPer DECIMAL(18, 6);  
        DECLARE @GPFees DECIMAL(18, 6);  
        DECLARE @GPFeesPer DECIMAL(18, 6);  
        DECLARE @CashOverDraft DECIMAL(18, 6);  
        DECLARE @CashOverDraftPer DECIMAL(18, 6);  
        DECLARE @RevenueExpenses DECIMAL(18, 6);  
        DECLARE @RevenueExpensesPer DECIMAL(18, 6);  
        DECLARE @TotalDrawdown DECIMAL(18, 6);  
        DECLARE @TotalDrawdownPer DECIMAL(18, 6);  
        DECLARE @TotalDistribution DECIMAL(18, 6);  
        DECLARE @TotalDistributionPer DECIMAL(18, 6);  
        DECLARE @DistributionA DECIMAL(18, 6);  
        DECLARE @ShareAName VARCHAR(100);  
        DECLARE @DistributionAPer DECIMAL(18, 6);  
        DECLARE @DistributionB DECIMAL(18, 6);  
        DECLARE @ShareBName VARCHAR(100);  
        DECLARE @DistributionBPer DECIMAL(18, 6);  
        DECLARE @DistributionC DECIMAL(18, 6);  
        DECLARE @ShareCName VARCHAR(100);  
        DECLARE @DistributionCPer DECIMAL(18, 6);  
        DECLARE @NetInvestment DECIMAL(18, 6);  
        DECLARE @RetainedProceeds DECIMAL(18, 6);  
        DECLARE @NetInvestmentPer DECIMAL(18, 6);  
        DECLARE @RealisedGains DECIMAL(18, 6);  
        DECLARE @OperatingProfits DECIMAL(18, 6);  
        DECLARE @GainLosses DECIMAL(18, 6);  
        DECLARE @CarriedInterestAccrued1 DECIMAL(18, 6);  
        DECLARE @ValueOfFund DECIMAL(18, 6);  
        DECLARE @CurrentPortfolio DECIMAL(18, 6);  
        DECLARE @NetCash DECIMAL(18, 6);  
        DECLARE @CarriedInterestAccrued2 DECIMAL(18, 6);  
        DECLARE @WorkingCapital DECIMAL(18, 6);  
        DECLARE @IncorporationExpenses DECIMAL(18, 6);  
        DECLARE @NAV DECIMAL(18, 6);  
        DECLARE @NAVRVPI DECIMAL(18, 6);  
        DECLARE @NavPerA DECIMAL(18, 6);  
        DECLARE @NavPerB DECIMAL(18, 6);  
        DECLARE @NavPerC DECIMAL(18, 6);  
        SET @shares = '';  
        SELECT @shares = @shares + sharename + '&'  
        FROM tbl_vehicleshare  
        WHERE VehicleID = @vehicleID  
              AND sharename IN('A', 'B');            
        -- AND IncludedReport = 1;            
        SET @ShareAName =  
        (  
            SELECT sharename  
            FROM tbl_vehicleshare  
            WHERE vehicleid = @vehicleid  
                  AND sharename LIKE 'A'  
        );  
        SET @ShareBName =  
        (  
            SELECT sharename  
            FROM tbl_vehicleshare  
            WHERE vehicleid = @vehicleid  
                  AND sharename LIKE 'B'  
        );  
        SET @ShareCName =  
        (  
            SELECT sharename  
            FROM tbl_vehicleshare  
            WHERE vehicleid = @vehicleid  
                  AND sharename LIKE 'C'  
        );  
        SET @nominalValA =  
        (  
            SELECT TOP 1 b.NominalValue  
            FROM tbl_vehicleshare a  
                 JOIN tbl_VehicleShareDetail b ON a.VehicleShareID = b.ShareID  
            WHERE a.vehicleid = @vehicleid  
                  AND b.ShareDate <= @date  
                  AND sharename LIKE 'A'  
            ORDER BY b.ShareDate DESC  
        );  
        SET @nominalValB =  
        (  
            SELECT TOP 1 b.NominalValue  
            FROM tbl_vehicleshare a  
                 JOIN tbl_VehicleShareDetail b ON a.VehicleShareID = b.ShareID  
            WHERE a.vehicleid = @vehicleid  
                  AND b.ShareDate <= @date  
                  AND sharename LIKE 'B'  
            ORDER BY b.ShareDate DESC  
        );  
        SET @nominalValC =  
        (  
            SELECT TOP 1 b.NominalValue  
            FROM tbl_vehicleshare a  
                 JOIN tbl_VehicleShareDetail b ON a.VehicleShareID = b.ShareID  
            WHERE a.vehicleid = @vehicleid  
                  AND b.ShareDate <= @date  
                  AND sharename LIKE 'C'  
            ORDER BY b.ShareDate DESC  
        );  
        --AND IncludedReport = 1;            
        SET @capitalcallid =  
        (  
            SELECT TOP 1 capitalcallid  
            FROM tbl_CapitalCall  
            WHERE FundID = @vehicleID  
                  AND DueDate <= @date  
            ORDER BY DueDate DESC  
        );  
        SELECT @Calls = SUM(amount)  ,@CallsAB = SUM(case when ShareName in ('A','B') then amount else 0 end)
        FROM tbl_CapitalCallLimitedPartner lcp  
             JOIN tbl_vehicleshare vs ON vs.VehicleShareID = lcp.ShareID  
        WHERE vs.VehicleID = @vehicleID            
              --AND vs.IncludedReport = 1            
              AND lcp.CapitalCallID = @capitalcallid;  

		     SELECT @CallsAB = SUM(case when ShareName in ('A','B') then amount else 0 end)
        FROM tbl_CapitalCallLimitedPartner lcp  
	   join tbl_CapitalCall c on c.CapitalCallID = lcp.CapitalCallID
             JOIN tbl_vehicleshare vs ON vs.VehicleShareID = lcp.ShareID  
        WHERE vs.VehicleID = @vehicleID            
	    AND DueDate <= @date  

        IF LEN(@shares) > 0  
            SET @shares = SUBSTRING(@shares, 0, LEN(@shares));  
        INSERT INTO @tblMCT  
               SELECT 5,   
                      ParameterValue  
               FROM tbl_DefaultParameters  
               WHERE ParameterName = 'ManagementCompanyID';  
        INSERT INTO @tblMCT  
               SELECT DISTINCT   
                      4,   
                      ContactIndividualID  
               FROM tbl_CompanyIndividuals  
                    JOIN @tblMCT ON CompanyContactID = objectid  
                                    AND TeamTypeName = 'Executive Team';  
        SELECT  --dbo.F_GetObjectModuleName(lp.objectid,lp.moduleid)Name, amount,sharename,*        
        @LPShare = SUM(CASE  
                           WHEN mct.ModuleID IS NULL  
                                AND vs.ShareName IN('A', 'B')  
                           THEN Amount  
                       END),   
        @GPShare = SUM(CASE  
                           WHEN mct.ModuleID IS NOT NULL  
                                AND vs.ShareName IN('A', 'B')  
                           THEN Amount  
                       END),   
        @ShareAB = SUM(CASE  
                           WHEN ISNULL(vs.CarriedInterest, 0) = 0  
                                AND vs.ShareName IN('A', 'B')  
                           THEN Amount  
                       END),   
        @ShareA = SUM(CASE  
                          WHEN ISNULL(vs.CarriedInterest, 0) = 0  
                               AND vs.ShareName IN('A')  
                          THEN Amount  
                      END),   
        @ShareB = SUM(CASE  
                          WHEN ISNULL(vs.CarriedInterest, 0) = 0  
                               AND vs.ShareName IN('B')  
                          THEN Amount  
                      END),   
        @ShareC = SUM(CASE  
                          WHEN vs.ShareName IN('C')  
                          THEN Amount  
                      END)  
        FROM tbl_LimitedPartner lp  
             JOIN tbl_LimitedPartnerDetail lpd ON lp.LimitedPartnerID = lpd.LimitedPartnerID  
             JOIN tbl_vehicleshare vs ON vs.VehicleShareID = lpd.ShareID  
             LEFT JOIN @tblMCT mct ON mct.ModuleID = lp.ModuleID  
                      AND mct.ObjectID = lp.ObjectID  
        WHERE lp.VehicleID = @vehicleID  
              AND lp.ModuleID <> 0  
              AND lp.Date <= @date;  
        SET @distributionID =  
        (  
            SELECT TOP 1 distributionID  
            FROM tbl_Distribution  
            WHERE Date <= @date  
            ORDER BY date DESC  
        );  
        SET @vehiclenavID =  
        (  
            SELECT TOP 1 VehicleNavID  
            FROM tbl_VehicleNav  
            WHERE NavDate <= @date  
            ORDER BY NavDate DESC  
        );  
        SELECT @DistributionA = SUM(CASE  
                                        WHEN vs.ShareName = 'A'  
                                        THEN TotalDistribution  
                                        ELSE NULL  
                                    END),   
               @DistributionB = SUM(CASE  
                                        WHEN vs.ShareName = 'B'  
                                        THEN TotalDistribution  
                                        ELSE NULL  
                                    END),   
               @DistributionC = SUM(CASE  
                                        WHEN vs.ShareName = 'C'  
                                        THEN TotalDistribution  
                                        ELSE NULL  
                                    END)  
        FROM tbl_DistributionOperation do  
             JOIN tbl_Distribution d ON d.DistributionID = do.DistributionID  
             JOIN tbl_vehicleshare vs ON vs.vehicleid = do.FundID  
                                         AND do.ShareID = vs.VehicleShareID  
        WHERE           
        --AND vs.IncludedReport = 1            
        vs.VehicleID = @vehicleID  
        AND d.date <= @date;  
        SET @TotalDistribution = ISNULL(@DistributionA, 0) + ISNULL(@DistributionB, 0) + ISNULL(@DistributionC, 0);  
        SELECT @TransactionFees = TransactionFees,   
               @GPFees = GPFees,   
               @CashOverDraft = CashOverDraft,   
               @RevenueExpenses = RevenueExpenses,   
               @RealisedGains = RealisedGains,   
               @OperatingProfits = OperatingProfits,   
               @GainLosses = GainLossesRevaluationToFV,   
               @CurrentPortfolio = PortfolioNAV,   
               @NetCash = Cash,   
               @CarriedInterestAccrued2 = CarriedInterestAccrued,   
               @IncorporationExpenses = Expenses,   
               @WorkingCapital = WorkingCapital,   
               @RetainedProceeds = RetainedProceeds  
        FROM tbl_VehicleNav  
        WHERE VehicleNavID = @vehiclenavID;  
        SET @NavPerA =  
        (  
            SELECT NavPerShare  
            FROM tbl_VehicleNavDetails vd  
                 JOIN tbl_vehicleshare vs ON vd.ShareID = vs.VehicleShareID  
            WHERE vd.VehicleNavID = @vehiclenavID  
                  AND vs.ShareName = @ShareAName  
        );  
        SET @NavPerB =  
        (  
            SELECT NavPerShare  
            FROM tbl_VehicleNavDetails vd  
                 JOIN tbl_vehicleshare vs ON vd.ShareID = vs.VehicleShareID  
            WHERE vd.VehicleNavID = @vehiclenavID  
                  AND vs.ShareName = @ShareBName  
        );  
        SET @NavPerC =  
        (  
            SELECT NavPerShare  
            FROM tbl_VehicleNavDetails vd  
                 JOIN tbl_vehicleshare vs ON vd.ShareID = vs.VehicleShareID  
            WHERE vd.VehicleNavID = @vehiclenavID  
                  AND vs.ShareName = @ShareCName  
        );  
        --AND vs.IncludedReport = 1;            
        SET @TotalCommitedCapital = ISNULL(@ShareAB, 0) + ISNULL(@ShareC, 0);  
        SET @TotalDrawdown = ISNULL(@TransactionFees, 0) + ISNULL(@GPFees, 0) + ISNULL(@CashOverDraft, 0) + ISNULL(@RevenueExpenses, 0) + ISNULL(@RetainedProceeds, 0);  
        SET @NAV = ISNULL(@CurrentPortfolio, 0) + ISNULL(@NetCash, 0) + ISNULL(@CarriedInterestAccrued2, 0);  
        SET @NAVRVPI = ISNULL(@CurrentPortfolio, 0) + ISNULL(@NetCash, 0) + ISNULL(@WorkingCapital, 0) + ISNULL(@IncorporationExpenses, 0);  
        SET @NetInvestment = ISNULL(@TotalDrawdown, 0) - ISNULL(@TotalDistribution, 0);  
        SET @ValueOfFund = ISNULL(@NetInvestment, 0) + ISNULL(@RealisedGains, 0) + ISNULL(@OperatingProfits, 0) + ISNULL(@GainLosses, 0) + ISNULL(@CarriedInterestAccrued2, 0);  
	   IF ISNULL(@nav, 0) <> 0  
            BEGIN  
                SET @RVPI = @ValueOfFund / @CallsAB;  
                SET @DPI = (@TotalDistribution-@DistributionC) / @CallsAB;  
                SET @TVPI = ISNULL(@RVPI, 0) + ISNULL(@DPI, 0);  
        END;  
        IF(ISNULL(@LPShare, 0) + ISNULL(@GPShare, 0)) > 0  
            SET @PICC = @TotalDrawdown / (ISNULL(@LPShare, 0) + ISNULL(@GPShare, 0));  
        SELECT @shares Shares,   
               @LPShare LPShare,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@LPShare, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END LPSharePer,   
               @GPShare GPShare,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@GPShare, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END GPSharePer,   
               @ShareAB ShareAB,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@ShareAB, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END ShareABPer,   
               @ShareC ShareC,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@ShareC, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END ShareCPer,   
               @TotalCommitedCapital TotalCommitedCapital,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@TotalCommitedCapital, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END TotalCommitedCapitalPer,   
               @TransactionFees TransactionFees,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@TransactionFees, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END TransactionFeesPer,   
               @GPFees GPFees,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@GPFees, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END GPFeesPer,   
               @CashOverDraft CashOverDraft,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@CashOverDraft, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END CashOverDraftPer,   
               @RetainedProceeds RetainedProceeds,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@RetainedProceeds, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END RetainedProceedsPer,   
               @RevenueExpenses RevenueExpenses,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@RevenueExpenses, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END RevenueExpensesPer,   
               @TotalDrawdown TotalDrawdown,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@TotalDrawdown, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END TotalDrawdownPer,   
               @TotalDistribution TotalDistribution,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@TotalDistribution, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END TotalDistributionPer,   
               @DistributionA DistributionA,   
               @ShareAName ShareAName,  
               CASE  
                   WHEN @ShareAB != 0  
                   THEN 100 * ISNULL(@DistributionA, 0) / @ShareAB  
                   ELSE NULL  
               END DistributionABPer,   
               @DistributionB DistributionB,   
               @ShareBName ShareBName,  
               CASE  
                   WHEN @ShareC != 0  
                   THEN 100 * ISNULL(@DistributionB, 0) / @ShareC  
                   ELSE NULL  
               END DistributionBPer,   
               @DistributionC DistributionC,   
               @ShareCName ShareCName,  
               CASE  
                   WHEN @ShareC != 0  
                   THEN 100 * ISNULL(@DistributionC, 0) / @ShareC  
                   ELSE NULL  
               END DistributionCPer,   
               @NetInvestment NetInvestment,  
               CASE  
                   WHEN @TotalCommitedCapital != 0  
                   THEN 100 * ISNULL(@NetInvestment, 0) / @TotalCommitedCapital  
                   ELSE NULL  
               END NetInvestmentPer,   
               @RealisedGains RealisedGains,   
               @OperatingProfits OperatingProfits,   
               @GainLosses GainLosses,   
               @CarriedInterestAccrued1 CarriedInterestAccrued1,   
               @ValueOfFund ValueOfFund,   
               @CurrentPortfolio CurrentPortfolio,   
               @NetCash NetCash,   
               @CarriedInterestAccrued2 CarriedInterestAccrued2,   
               @NAV NAV,   
               @NavPerA NavPerA,   
               @NavPerB NavPerB,   
               @NavPerC NavPerC,   
               @RVPI RVPI,   
               @DPI DPI,   
               @TVPI TVPI,   
               @PICC PICC,  
               CASE  
                   WHEN ISNULL(@nominalValA, 0) <> 0  
                   THEN @ShareA / @nominalValA  
               END NumOfShareA,  
               CASE  
                   WHEN ISNULL(@nominalValB, 0) <> 0  
                   THEN @ShareB / @nominalValB  
               END NumOfShareB,  
               CASE  
                   WHEN ISNULL(@nominalValC, 0) <> 0  
                   THEN @ShareC / @nominalValC  
               END NumOfShareC;  
    END;    
