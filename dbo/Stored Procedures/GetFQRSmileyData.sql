CREATE PROC GetFQRSmileyData  
(@vehicleID INT,   
 @date      DATETIME  
)  
AS  
    BEGIN  
        SELECT t.*,   
               bu.Rate,   
        (  
            SELECT TOP 1 Rate  
            FROM tbl_CompanyBusinessUpdates bu  
            WHERE bu.CompanyID = t.CompanyContactID  
                  AND bu.date <= @date  
                  AND bu.CompanyBusinessID < t.CompanyBusinessID  
            ORDER BY bu.date DESC  
        ) Rate_1,   
               dbo.[F_GetFQRPortfolioGrid_CurrentValuation](@vehicleID, CompanyName, @date, 1) / 1000 FMVValue,   
               dbo.F_GetFQRPortfolioGrid_CurrentCostValue(@vehicleID, CompanyName, @date) / 1000 Cost  
        FROM  
        (  
            SELECT cc.CompanyContactID,   
                   p.PortfolioID,   
                   po.FileName CompanyName,   
            (  
                SELECT TOP 1 CompanyBusinessID  
                FROM tbl_CompanyBusinessUpdates bu  
                WHERE bu.CompanyID = cc.CompanyContactID  
                      AND bu.date <= @date  
                ORDER BY bu.date DESC  
            ) CompanyBusinessID  
            FROM tbl_portfolio p  
                 JOIN tbl_portfoliovehicle pv ON p.portfolioid = pv.portfolioid  
                 JOIN tbl_companycontact cc ON cc.companycontactid = p.targetportfolioid  
                 LEFT JOIN tbl_PortfolioOptional po ON po.PortfolioID = p.PortfolioID  
            WHERE pv.VehicleID = @vehicleID  
                  AND po.StatusID = 'Unrealized'  
        ) t  
        JOIN tbl_CompanyBusinessUpdates bu ON t.CompanyBusinessID = bu.CompanyBusinessID;  
    END;  