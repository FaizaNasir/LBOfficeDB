CREATE PROC GetFQRChart2  

(@vehicleID INT,   

 @date      DATETIME  

)  

AS  

    BEGIN  

        DECLARE @Calls DECIMAL(18, 6);  

        DECLARE @RealizedGains DECIMAL(18, 6);  

        DECLARE @Revenues DECIMAL(18, 6);  

        DECLARE @Expenses DECIMAL(18, 6);  

        DECLARE @Distribution DECIMAL(18, 6);  

        DECLARE @UnrealizedGains DECIMAL(18, 6);  

        DECLARE @CarriedInterest DECIMAL(18, 6);  

        DECLARE @NAV DECIMAL(18, 6);  

        SET @Calls =  

        (  

            SELECT SUM(amount)  

            FROM tbl_CapitalCallLimitedPartner clp  

                 JOIN tbl_CapitalCall c ON c.CapitalCallID = clp.CapitalCallID  

                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID  

                                             AND vs.ShareName IN('A', 'B')  

            WHERE c.FundID = @vehicleID  

                  AND c.DueDate <= @date  

        );  

        SET @Distribution =  

        (  

            SELECT SUM(amount)  

            FROM tbl_DistributionLimitedPartner clp  

                 JOIN tbl_Distribution c ON c.DistributionID = clp.DistributionID  

                 JOIN tbl_vehicleshare vs ON vs.VehicleShareID = clp.ShareID  

                                             AND vs.ShareName IN('A', 'B')  

            WHERE c.FundID = @vehicleID  

                  AND c.Date <= @date  

        );  

        SELECT TOP 1 @Revenues = Revenue,   

                     @RealizedGains = RealisedGains,   

                     @UnrealizedGains = UnrealizedHedging,   

                     @Expenses = Expenses1,   

                     @NAV = ISNULL(PortfolioNAV, 0) + ISNULL(WorkingCapital, 0) + ISNULL(Cash, 0) + ISNULL(Other, 0) + ISNULL(Expenses, 0),   

                     @CarriedInterest =  

        (  

            SELECT SUM(ISNULL(a.CarriedInterest, 0))  

            FROM tbl_VehicleNavDetails a  

                 JOIN tbl_vehicleshare b ON a.ShareID = b.VehicleShareID  

                                            AND b.ShareName IN('A', 'B')  

                                            AND a.VehicleNavID = c.VehicleNavID  

                                            AND ISNULL(b.CarriedInterest, 0) <> 0  

        )  

        FROM tbl_VehicleNav c  

        WHERE c.VehicleID = @vehicleID  

              AND c.NavDate < @date;  

        SET @Calls = 177000000;  

        SET @RealizedGains = 81000000;  

        SET @Revenues = 16000000;  

        SET @Expenses = -31000000;  

        SET @Distribution = -170000000;  

        SET @UnrealizedGains = 57000000;  

        SET @CarriedInterest = -26000000;  

        SET @NAV = 102000000;  

        SELECT ISNULL(@Calls, 0) / 1000000 Calls,   

               ISNULL(@RealizedGains, 0) / 1000000 RealizedGains,   

               ISNULL(@Revenues, 0) / 1000000 Revenues,   

               ISNULL(@Expenses, 0) / 1000000 Expenses,   

               ISNULL(@Distribution, 0) / 1000000 Distribution,   

               ISNULL(@UnrealizedGains, 0) / 1000000 UnrealizedGains,   

               ISNULL(@CarriedInterest, 0) / 1000000 CarriedInterest,   

               ISNULL(@NAV, 0) / 1000000 NAV;  

    END; 