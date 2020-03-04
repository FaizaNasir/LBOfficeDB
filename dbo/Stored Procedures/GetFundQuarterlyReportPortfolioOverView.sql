  
CREATE PROC [dbo].[GetFundQuarterlyReportPortfolioOverView]  
(@vehicleID INT,   
 @date      DATETIME  
)  
AS  
    BEGIN  
        SELECT po.FileNumber,   
               ba.BusinessAreaTitle,   
               t.*,   
               dbo.[F_GetFQRPortfolioGrid_FundPer](@vehicleID, cc.CompanyContactID, t.PortfolioID, @date) FundPer,   
        (  
            SELECT TOP 1 amount  
            FROM tbl_PortfolioGeneralOperation sho  
            WHERE sho.PortfolioID = t.PortfolioID  
                  AND sho.typeid IN(4, 8)  
            AND sho.Date <= @date  
            ORDER BY sho.Date DESC  
        ) / 1000 AccruedInterests,   
               dbo.F_ClosingDateExit(@vehicleID, t.PortfolioID, @date) DateOfExit,   
               (CASE  
                    WHEN po.StatusID = 'Unrealized'  
                    THEN 1  
                    WHEN po.StatusID = 'Realized'  
                    THEN 4  
                    ELSE 0  
                END) STATUS,   
               (CASE  
                    WHEN StatusID = 'Unrealized'  
                    THEN ISNULL(CurrentValuationWithoutAccruedinterests, 0) + ISNULL(TotalAmountCashedInOut, 0)  
                    WHEN StatusID = 'Realized'  
                    THEN TotalAmountCashedInOut  
                END) TotalValuationCashedIn,   
               (CASE  
                    WHEN StatusID = 'Unrealized'  
                    THEN CurrentCostValueCal  
                    WHEN StatusID = 'Realized'  
                    THEN 0  
                END) CurrentCostValue,   
               ISNULL(CurrentValuationWithoutAccruedinterests, 0) + ISNULL(TotalAmountCashedInOut, 0) - ISNULL(InvestedInCash, 0) IncreaseDecreaseOnInvestedCash,  
               CASE  
                   WHEN InvestedInCash != 0  
                   THEN((CASE  
                             WHEN StatusID = 'Unrealized'  
                             THEN ISNULL(CurrentValuationWithoutAccruedinterests, 0)  
                             WHEN StatusID = 'Realized'  
                             THEN 0  
                         END) + ISNULL(TotalAmountCashedInOut, 0)) / ISNULL(InvestedInCash, 0)  
               END Multiple  
        FROM  
        (  
            SELECT DISTINCT   
                   dbo.[F_GetParentPortfolioid](@vehicleID, po.FileName, @date) PortfolioID,     
            --cc.CompanyContactID,     
                   po.FileName CompanyName,     
            --ba.BusinessAreaTitle,     
            --cc.CompanyLogo,     
                   dbo.F_ClosingDateV1(@vehicleID, po.FileName, @date) Closing,   
                   dbo.[F_GetFQRPortfolioGrid_InvestedAmount](@vehicleID, po.FileName, @date) / 1000 InvestedInCash,   
                   dbo.[F_GetFQRPortfolioGrid_TotalAmountCashedInOut](@vehicleID, po.FileName, @date) / 1000 TotalAmountCashedInOut,   
                   dbo.[F_GetFQRPortfolioGrid_CurrentValuation](@vehicleID, po.FileName, @date, 1) / 1000 CurrentValuation,   
                   dbo.[F_GetFQRPortfolioGrid_CurrentValuation](@vehicleID, po.FileName, @date, 0) / 1000 CurrentValuationWithoutAccruedinterests,   
                   dbo.F_GetFQRPortfolioGrid_CurrentCostValue(@vehicleID, po.FileName, @date) / 1000 CurrentCostValueCal  
            FROM tbl_PortfolioVehicle pv  
                 JOIN tbl_portfolio p ON p.PortfolioID = pv.PortfolioID  
                 LEFT JOIN tbl_PortfolioOptional po ON po.PortfolioID = p.PortfolioID  
            WHERE pv.VehicleID = @vehicleID  
        ) t  
        JOIN tbl_PortfolioOptional po ON po.PortfolioID = t.PortfolioID  
        JOIN tbl_portfolio p ON p.PortfolioID = t.PortfolioID  
        JOIN tbl_companycontact cc ON cc.companycontactid = p.TargetPortfolioID  
        LEFT JOIN tbl_BusinessArea ba ON ba.BusinessAreaID = cc.CompanyBusinessAreaID  
        WHERE t.InvestedInCash > 100  
              AND po.StatusID IN('Realized', 'Unrealized')  
        ORDER BY STATUS,   
                 FileNumber;  
    END;  
