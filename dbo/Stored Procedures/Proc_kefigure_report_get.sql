CREATE PROCEDURE [dbo].[Proc_kefigure_report_get](@VehicleID VARCHAR(MAX) = NULL)
AS
    BEGIN
        SET NOCOUNT ON;
        CREATE TABLE #tmpportfoliocompany
        (portfolioid      INT, 
         companycontactid INT, 
         companyname      VARCHAR(MAX) NULL
        );
        INSERT INTO #tmpportfoliocompany
        EXEC Proc_portfolio_list_report_get 
             @VehicleID;
        DECLARE @Year AS TABLE(year INT);
        INSERT INTO @Year
               SELECT YEAR(GETDATE()) - 4
               UNION
               SELECT YEAR(GETDATE()) - 3
               UNION
               SELECT YEAR(GETDATE()) - 2
               UNION
               SELECT YEAR(GETDATE()) - 1;
        DECLARE @DynamicPivotQuery AS NVARCHAR(MAX);
        DECLARE @ColumnName AS NVARCHAR(MAX);
        SELECT A.yearrevenue, 
               portfolioid, 
               amount
        INTO #tmpkeyfigure
        FROM
        (
            SELECT DISTINCT 
                   NAME + ' ' + CAST(year AS VARCHAR) AS YearRevenue
            FROM tbl_keyfigureconfig
                 CROSS JOIN @Year
            WHERE NAME IN('Revenues', 'EBITDA', 'EBIT', 'Net profit', 'Net financial debt', 'Enterprise value')
        ) A
        LEFT JOIN
        (
            SELECT PKF.portfolioid, 
                   NAME + ' ' + CAST(YEAR(year) AS VARCHAR) AS YearRevenue, 
                   CAST(ISNULL(PKF.amount, 0) AS DECIMAL(18, 2)) AS Amount
            FROM #tmpportfoliocompany PV
                 JOIN [tbl_companycontact] CC ON CC.companycontactid = pv.companycontactid
                 LEFT JOIN tbl_portfoliokeyfigure PKF ON PKF.portfolioid = pv.portfolioid
                 JOIN tbl_keyfigureconfig KC ON PKF.portfolioid = KC.portfolioid
                                                AND PKF.keyfigureconfigid = KC.keyfigureconfigid
            WHERE NAME IN('Revenues', 'EBITDA', 'EBIT', 'Net profit', 'Net financial debt', 'Enterprise value')
                 AND YEAR(year) BETWEEN YEAR(GETDATE()) - 4 AND YEAR(GETDATE()) - 1 
        --and VehicleID in(@VehicleID) 
        ) B ON A.yearrevenue = B.yearrevenue;

        --Get distinct values of the PIVOT Column  
        SELECT @ColumnName = ISNULL(@ColumnName + ',', '') + QUOTENAME(yearrevenue)
        FROM
        (
            SELECT DISTINCT 
                   NAME + ' ' + CAST(year AS VARCHAR) AS YearRevenue
            FROM tbl_keyfigureconfig
                 CROSS JOIN @Year
            WHERE NAME IN('Revenues', 'EBITDA', 'EBIT', 'Net profit', 'Net financial debt', 'Enterprise value')
        ) AS Courses;

        --Prepare the PIVOT query using the dynamic  
        SET @DynamicPivotQuery = N'SELECT PortfolioID, ' + @ColumnName + ' FROM #tmpKeyFigure PIVOT(SUM(Amount)    FOR YearRevenue IN (' + @ColumnName + ')) AS PVTTable';

        --Execute the Dynamic Pivot Query 
        --Print @DynamicPivotQuery 
        EXEC Sp_executesql 
             @DynamicPivotQuery;
        IF OBJECT_ID('tempdb..#tmpKeyFigure') IS NOT NULL
            DROP TABLE #tmpkeyfigure;
        SET NOCOUNT OFF;
    END;
