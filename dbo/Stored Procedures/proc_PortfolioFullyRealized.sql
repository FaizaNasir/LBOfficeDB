CREATE PROC [dbo].[proc_PortfolioFullyRealized]  
(@fundiD   INT,   
 @userrole VARCHAR(100),   
 @date     DATETIME  
)  
AS  
    BEGIN  
        DECLARE @temp1 TABLE  
        (companyid   INT,   
         companyname VARCHAR(100),   
         portfolioid INT  
        );  
        DECLARE @temp2 TABLE  
        (companyid   INT,   
         companyname VARCHAR(100),   
         portfolioid INT  
        );  
        DECLARE @vehicleresult TABLE  
        (STATUS           INT,   
         vehicleid        INT,   
         Fundname         VARCHAR(100),   
         CompanyContactid INT,   
         Company_name     VARCHAR(MAX),   
         Industry         VARCHAR(MAX),   
         Sector           VARCHAR(MAX),   
         Closing_Date     DATETIME,   
         Investment       DECIMAL(18, 2),   
         Divestment       DECIMAL(18, 2),   
         Last_Valuation   DECIMAL(18, 2),   
         Dividends        DECIMAL(18, 2),   
         Acquisition_fees DECIMAL(18, 2),   
         SPVFees          DECIMAL(18, 2),   
         ManagementFees   DECIMAL(18, 2),   
         PortfolioID      INT,   
         FX_Hedging_Gain  DECIMAL(18, 2),   
         FX_Hedging_Loss  DECIMAL(18, 2)  
        );  
        INSERT INTO @vehicleresult  
               SELECT *  
               FROM dbo.[F_PortfolioCal](@fundiD, GETDATE());  
        INSERT INTO @temp1  
               SELECT DISTINCT   
                      p.TargetPortfolioID,   
                      c.CompanyName,   
                      p.PortfolioID  
               FROM tbl_PortfolioVehicle pv  
                    JOIN tbl_Portfolio p ON pv.PortfolioID = p.PortfolioID  
                    JOIN tbl_companycontact c ON c.CompanyContactID = p.TargetPortfolioID  
               WHERE VehicleID = @fundiD  
                     AND STATUS = 4;  
        INSERT INTO @temp2  
               SELECT DISTINCT   
                      s.ObjectID,   
                      c.CompanyName,   
                      p.PortfolioID  
               FROM tbl_Shareholders S  
                    INNER JOIN tbl_Portfolio p ON p.TargetPortfolioID = s.ObjectID  
                    INNER JOIN tbl_PortfolioVehicle pv ON pv.PortfolioID = p.PortfolioID  
                    INNER JOIN tbl_companycontact c ON c.CompanyContactID = s.ObjectID  
               WHERE s.ModuleID = 5  
                     AND VehicleID = @fundiD  
                     AND STATUS = 4;  
        SELECT t4.*,   
               vr.Dividends,   
               vr.Acquisition_fees  
        FROM  
        (  
            SELECT DISTINCT   
                   t1.PortfolioID,   
                   po.FileNumber,   
                   po.FileName,   
                   t1.companyid AS 'CompanyContactID',   
                   t1.companyname 'ComapanyName',   
                   b.BusinessAreaTitle 'Sector',   
                   CAST(  
            (  
                SELECT TOP 1 YEAR(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.FromID = @fundiD  
                      AND pso.FromTypeID = 3  
                      AND date <= @date  
                      AND pso.PortfolioID = t1.PortfolioID  
                ORDER BY Date DESC  
            ) -  
            (  
                SELECT TOP 1 YEAR(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.ToID = @fundiD  
                      AND pso.ToTypeID = 3  
                      AND date <= @date  
                      AND pso.PortfolioID = t1.PortfolioID  
                ORDER BY Date ASC  
            ) + ((  
            (  
                SELECT TOP 1 MONTH(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.FromID = @fundiD  
                      AND pso.PortfolioID = t1.PortfolioID  
                      AND pso.FromTypeID = 3  
                      AND date <= @date  
                ORDER BY Date DESC  
            ) -  
            (  
                SELECT TOP 1 MONTH(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.ToID = @fundiD  
                      AND pso.PortfolioID = t1.PortfolioID  
                      AND pso.ToTypeID = 3  
                      AND date <= @date  
                ORDER BY Date ASC  
            )) * 1.0 / 12) AS DECIMAL(18, 2)) 'Durationinportfolio',   
                   CAST(  
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.FromID = @fundiD  
                      AND date <= @date  
                      AND pso.FromTypeID = 3  
            ) / (CASE  
                     WHEN  
            (  
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations  
                WHERE ToTypeID = 3  
                      AND ToID = @fundiD  
                      AND PortfolioID = t1.PortfolioID  
                      AND ISNULL(IsConditional, 0) = 0  
                      AND date <= @date  
            )  
            ) = 0  
                     THEN 1  
                     ELSE  
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations  
                WHERE ToTypeID = 3  
                      AND ToID = @fundiD  
                      AND PortfolioID = t1.PortfolioID  
                      AND ISNULL(IsConditional, 0) = 0  
                      AND date <= @date  
            )  
                 END) AS DECIMAL(18, 2)) 'Cash Multiple',   
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations  
                WHERE ToTypeID = 3  
                      AND ToID = @fundiD  
                      AND PortfolioID = t1.PortfolioID  
                      AND Date <= @date  
                      AND isConditional = 0  
            ) AS 'AmountInvested',   
                   c.CompanyBusinessDesc 'CompanyComments',   
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations  
                WHERE FromTypeID = 3  
                      AND FromID = @fundiD  
                      AND PortfolioID = t1.PortfolioID  
                      AND Date <= @date  
                      AND isConditional = 0  
            ) AS 'Proceeds'  
            FROM @temp1 t1  
                 JOIN tbl_Shareholders S ON t1.companyid = s.TargetPortfolioID  
                                            AND s.ModuleID = 5  
                 JOIN tbl_companycontact c ON c.CompanyContactID = t1.companyid  
                 LEFT JOIN tbl_portfoliooptional po ON po.portfolioid = t1.portfolioid  
                 LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID  
            WHERE s.ObjectID NOT IN  
            (  
                SELECT companyid  
                FROM @temp2  
            )  
            UNION ALL  
            SELECT t.PortfolioID,   
                   po.FileNumber,   
                   po.FileName,   
                   t.companyid AS 'CompanyContactID',   
                   t.companyname 'ComapanyName',   
                   b.BusinessAreaTitle 'Sector',   
                   CAST(  
            (  
                SELECT TOP 1 YEAR(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.FromID = @fundiD  
                      AND pso.FromTypeID = 3  
                      AND pso.PortfolioID = t.PortfolioID  
                      AND Date <= @date  
                ORDER BY Date DESC  
            ) -  
            (  
                SELECT TOP 1 YEAR(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.ToID = @fundiD  
                      AND pso.ToTypeID = 3  
                      AND pso.PortfolioID = t.PortfolioID  
                      AND Date <= @date  
                ORDER BY Date ASC  
            ) + ((  
            (  
                SELECT TOP 1 MONTH(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
            WHERE pso.FromID = @fundiD  
                      AND pso.PortfolioID = t.PortfolioID  
                      AND pso.FromTypeID = 3  
                      AND Date <= @date  
                ORDER BY Date DESC  
            ) -  
            (  
                SELECT TOP 1 MONTH(Date)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.ToID = @fundiD  
                      AND pso.PortfolioID = t.PortfolioID  
                      AND pso.ToTypeID = 3  
                      AND Date <= @date  
                ORDER BY Date ASC  
            )) * 1.0 / 12) AS DECIMAL(18, 2)) 'Durationinportfolio',   
                   CAST(  
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations pso  
                WHERE pso.FromID = @fundiD  
                      AND pso.FromTypeID = 3  
                      AND Date <= @date  
            ) /  
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations  
                WHERE ToTypeID = 3  
                      AND ToID = @fundiD  
                      AND PortfolioID = t.PortfolioID  
                      AND ISNULL(IsConditional, 0) = 0  
                      AND Date <= @date  
            ) AS DECIMAL(18, 2)) 'Cash Multiple',   
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations  
                WHERE ToTypeID = 3  
                      AND ToID = @fundiD  
                      AND PortfolioID = t.PortfolioID  
                      AND Date <= @date  
                      AND isConditional = 0  
            ) AS 'AmountInvested',   
                   c.CompanyBusinessDesc 'CompanyComments',   
            (  
                SELECT SUM(Amount)  
                FROM tbl_PortfolioShareholdingOperations  
                WHERE FromTypeID = 3  
                      AND FromID = @fundiD  
                      AND PortfolioID = t.PortfolioID  
                      AND Date <= @date  
                      AND isConditional = 0  
            ) AS 'PotentialProceeds'  
            FROM @temp1 t  
                 JOIN tbl_companycontact c ON c.CompanyContactID = t.companyid  
                 LEFT JOIN tbl_portfoliooptional po ON po.portfolioid = t.portfolioid  
                 LEFT JOIN tbl_businessarea b ON c.CompanyBusinessAreaID = b.BusinessAreaID  
            WHERE t.companyid NOT IN  
            (  
                SELECT DISTINCT   
                       s.TargetPortfolioID  
                FROM @temp1 t1  
                     JOIN tbl_Shareholders S ON t1.companyid = s.TargetPortfolioID  
                                                AND s.ModuleID = 5  
            )  
        ) t4  
        LEFT JOIN @vehicleresult vr ON t4.portfolioid = vr.PortfolioID  
        ORDER BY FileNumber;  
    END;   