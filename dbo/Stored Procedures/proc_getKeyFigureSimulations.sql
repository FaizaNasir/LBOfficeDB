CREATE PROC [dbo].[proc_getKeyFigureSimulations]
(@portfolioID       INT, 
 @TargetPortfolioID INT, 
 @SubTabID          INT, 
 @date              DATETIME, 
 @isFor2Pager       BIT
)
AS
     SET @SubTabID = 1;
    BEGIN
        DECLARE @tblKeyFigure TABLE
        (PortfolioID       INT, 
         TargetPortfolioID INT, 
         Year              INT, 
         Name              VARCHAR(1000), 
         NameFr            VARCHAR(1000), 
         Amount            VARCHAR(1000), 
         Date              DATETIME
        );
        INSERT INTO @tblKeyFigure
               SELECT PortfolioID, 
                      TargetPortfolioID, 
                      YEAR(year), 
               (
                   SELECT Name
                   FROM tbl_KeyfigureConfig con
                   WHERE con.KeyFigureConfigID = b.KeyFigureConfigID
                         AND con.portfolioid = b.PortfolioID
               ) Name, 
               (
                   SELECT NameFr
                   FROM tbl_KeyfigureConfig con
                   WHERE con.KeyFigureConfigID = b.KeyFigureConfigID
                         AND con.portfolioid = b.PortfolioID
               ) NameFr, 
                      ISNULL(Amount, ''), 
                      date
               FROM tbl_PortfolioKeyFigure b
               WHERE b.PortfolioID = @portfolioID
                     AND b.TargetPortfolioID = @TargetPortfolioID
                     AND SubTab = @SubTabID
                     AND date = @date
               --      AND EXISTS
               --(
               --    SELECT TOP 1 1
               --    FROM tbl_PortfolioKeyFigure incl
               --         JOIN tbl_KeyfigureConfig inclConfig ON inclConfig.KeyFigureConfigID = incl.KeyFigureConfigID
               --    WHERE incl.PortfolioID = b.PortfolioID
               --          AND incl.SubTab = b.SubTab
               --          AND incl.Date = b.Date
               --          AND inclConfig.Name = 'Include in report'
               --          AND incl.Year = b.Year
               --          AND 1 = CASE
               --                      WHEN @isFor2Pager = 1
               --                           AND incl.Amount = 'Yes'
               --                      THEN 1
               --                      WHEN @isFor2Pager = 0
               --                      THEN 1
               --                      ELSE 0
               --                  END
               --);
        DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX);
        SELECT @cols = STUFF(
        (
            SELECT ',' + QUOTENAME(Year)
            FROM @tblKeyFigure
            GROUP BY Year
            ORDER BY Year FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
        SET @query = '    
    
declare @tblKeyFigure       
    
table(PortfolioID int,TargetPortfolioID int,Year int,Name varchar(1000),NameFr varchar(1000),Amount varchar(1000),Seq Int,Date datetime)    
    
insert into @tblKeyFigure        
    
   select b.PortfolioID,b.TargetPortfolioID,year(year),    
    
   con.Name,    
    
  con.NameFr,ISNULL(Amount,''''),      
    
  con.Seq   ,b.Date     
    
   from tbl_PortfolioKeyFigure b       
    
   join tbl_keyfigureconfig con on b.KeyFigureConfigID = con.KeyFigureConfigID    
    
   where b.PortfolioID = ' + CAST(@portfolioID AS VARCHAR(10)) + '       
    
   and b.TargetPortfolioID = ' + CAST(@TargetPortfolioID AS VARCHAR(10)) + '        
    
   and b.Date = ''' + CAST(@date AS VARCHAR(50)) + '''    
    
   and b.SubTab = ' + CAST(@SubTabID AS VARCHAR(10)) + '     
    
   
    
SELECT ' + @cols + ', Name as Millions from    
    
            (    
    
                select PortfolioID,Seq, TargetPortfolioID, Name, Year, ISNULL(Amount,0) Amount  ,Date    
    
                from @tblKeyFigure    
    
            ) x     
    
            pivot    
    
            (     
    
                MAX(Amount)    
    
                for Year in (' + @cols + ')    
    
            ) p       
    
            order by Seq ';
        PRINT(@query);
        EXECUTE (@query);
    END;
