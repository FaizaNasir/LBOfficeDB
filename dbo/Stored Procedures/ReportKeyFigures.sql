CREATE PROC [dbo].[ReportKeyFigures](@companyID INT)
AS
    BEGIN
        DECLARE @portfolioID INT;
        SET @portfolioID =
        (
            SELECT portfolioID
            FROM tbl_Portfolio
            WHERE TargetPortfolioID = @companyID
        );
        DECLARE @SubTabID INT;
        SET @SubTabID = 1;
        DECLARE @count INT;
        DECLARE @ColumnName AS NVARCHAR(MAX);
        DECLARE @tmp TABLE
        (years    INT, 
         countyrs INT
        );
        INSERT INTO @tmp
               SELECT DISTINCT TOP 4 YEAR(year) years, 
                                     COUNT(b.year)
               FROM tbl_PortfolioKeyFigure b
               WHERE b.PortfolioID = @portfolioID
                     AND b.TargetPortfolioID = @companyID
                     AND SubTab = 1
               GROUP BY b.Year
               ORDER BY YEAR(b.year) DESC;
        SET @count =
        (
            SELECT COUNT(years)
            FROM @tmp
        );
        IF(@count = 4)
            BEGIN
                SELECT @ColumnName = ISNULL(@ColumnName + ',', '') + QUOTENAME(years)
                FROM
                (
                    SELECT TOP 4 years
                    FROM @tmp
                    ORDER BY years ASC
                ) AS h;
        END;
            ELSE
            IF(@count = 3)
                BEGIN
                    SELECT @ColumnName = ISNULL(@ColumnName + ',', '') + QUOTENAME(years)
                    FROM
                    (
                        SELECT TOP 4 years
                        FROM @tmp
                        ORDER BY years ASC
                        UNION ALL
                        SELECT TOP 1 '' AS 'years'
                        FROM @tmp
                    ) AS h;
            END;
        DECLARE @DynamicPivotQuery AS NVARCHAR(MAX);
        SET @DynamicPivotQuery = N'                

SELECT * from   
            (    
                select  b.PortfolioID, TargetPortfolioID, 
                 c.Name,YEAR(Year) Years,  
                 CASE WHEN Name = ''Start date''  
                 then dbo.[F_KeyFigures_HeaderDate] (b.PortfolioID,Year) 
                 when Name = ''NetDebt_Per''  
                 then cast(dbo.[F_KeyFigure_Per](''Net_debt_Per'',b.PortfolioID,TargetPortfolioID,1,year(Year)) as varchar(100))   
                 when Name = ''Turnover_Per''  
                 then cast(dbo.[F_KeyFigure_Per](''Turnover_Per'',b.PortfolioID,TargetPortfolioID,1,year(Year))  as varchar(100)) 
                 when Name = ''EBITDA_Per'' 
                 then cast(dbo.[F_KeyFigure_Per](''EBITDA_Per'',b.PortfolioID,TargetPortfolioID,1,year(Year))  as varchar(100))  
                 when Name not in (''Years'',''Type'',''Start date'',''Workforce'')
                 then ISNULL( CONVERT(varchar(1000),CAST(Amount AS DECIMAL(18,1))) ,'''')   
                 else ISNULL( Amount,'''') end Amount  
                from tbl_PortfolioKeyFigure b     
                join tbl_KeyfigureConfig c on b.KeyFigureConfigID=c.KeyFigureConfigID 
 where   
 c.IsReport = 1 and  
 b.PortfolioID = ' + CAST(@portfolioID AS VARCHAR(5)) + '     
 and b.TargetPortfolioID =' + CAST(@companyID AS VARCHAR(5)) + ' 
 and b.SubTab =' + CAST(@SubTabID AS VARCHAR(5)) + '      
 AND Name NOT IN  
 (      
''Category'',''End date''  
 )                  
 and Name in(''Revenues'', ''Start date'' ,  ''EBITDA'', 
  ''Net financial debt'')  
 and YEAR(year) in  
 (               
 select top 4 * from    
 (               
 select distinct YEAR(year) years 
 from tbl_PortfolioKeyFigure b 
 where b.PortfolioID = ' + CAST(@portfolioID AS VARCHAR(5)) + '  
 and b.TargetPortfolioID =' + CAST(@companyID AS VARCHAR(5)) + ' 
 and b.SubTab = ' + CAST(1 AS VARCHAR(5)) + '   
 ) t      
 order by t.years desc  
 )            
            ) x  
            pivot   
            (     
                MAX(Amount) 
                for Years in ( ' + @ColumnName + ' ) 
            ) p   
             ';
        DECLARE @result TABLE
        (PortfolioID       INT, 
         TargetPortfolioID INT, 
         Name              VARCHAR(200), 
         Year1             VARCHAR(1000), 
         Year2             VARCHAR(1000), 
         Year3             VARCHAR(1000), 
         Year4             VARCHAR(1000)
        );
        INSERT INTO @result
        EXECUTE (@DynamicPivotQuery);
        DECLARE @years TABLE
        (PortfolioID      INT, 
         TargetPortolioID INT, 
         Category         VARCHAR(1000), 
         Year1            VARCHAR(1000), 
         Year2            VARCHAR(1000), 
         Year3            VARCHAR(1000), 
         Year4            VARCHAR(1000)
        );
        DECLARE @tstruct TABLE
        (Name VARCHAR(1000), 
         Val  VARCHAR(1000)
        );
        INSERT INTO @years
        EXEC dbo.GetKeyfigureYears 
             @portfolioID, 
             @companyID, 
             @SubTabID;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM @years
            WHERE Year1 = ''
        )
            BEGIN
                UPDATE @years
                  SET 
                      Year1 = Year2;
                UPDATE @years
                  SET 
                      Year2 = Year3;
                UPDATE @years
                  SET 
                      Year3 = Year4;
                UPDATE @years
                  SET 
                      Year4 = '';
        END;
        SELECT *,
               CASE
                   WHEN Category = 'Years'
                   THEN 1
                   WHEN Category = 'Start date'
                   THEN 2
                   WHEN Category = 'Revenues'
                   THEN 3
                   WHEN Category = '% Growth Revenues'
                   THEN 4
                   WHEN Category = 'EBITDA'
                   THEN 5
                   WHEN Category = '% Growth EBITDA'
                   THEN 6
                   WHEN Category = 'EBITDA Margin'
                   THEN 7
                   WHEN Category = 'Net financial debt'
                   THEN 8
               END Seq
        FROM
        (
            SELECT t.*, 
                   ts.Val
            FROM
            (
                SELECT *
                FROM @years
                UNION ALL
                SELECT *
                FROM @result
            ) t
            LEFT JOIN @tstruct ts ON ts.Name = t.Category
            UNION ALL
            SELECT @portfolioID, 
                   3, 
                   '% Growth Revenues', 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2014, 'Revenues'), 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2015, 'Revenues'), 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2016, 'Revenues'), 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2017, 'Revenues'), 
                   NULL
            UNION ALL
            SELECT @portfolioID, 
                   3, 
                   '% Growth EBITDA', 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2014, 'EBITDA'), 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2015, 'EBITDA'), 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2016, 'EBITDA'), 
                   dbo.F_KeyFigure_GrowthR(@portfolioID, 2017, 'EBITDA'), 
                   NULL
            UNION ALL
            SELECT @portfolioID, 
                   3, 
                   'EBITDA Margin', 
                   dbo.F_KeyFigure_EBITDAMargin(@portfolioID, 2014), 
                   dbo.F_KeyFigure_EBITDAMargin(@portfolioID, 2015), 
                   dbo.F_KeyFigure_EBITDAMargin(@portfolioID, 2016), 
                   dbo.F_KeyFigure_EBITDAMargin(@portfolioID, 2017), 
                   NULL
        ) t
        ORDER BY Seq;
    END;
