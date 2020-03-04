CREATE PROC [dbo].[GetKeyfigureYears]
(@PortfolioID       INT, 
 @TargetPortfolioID INT, 
 @SubTabID          INT
)
AS
     DECLARE @tmp TABLE(years INT);
     INSERT INTO @tmp
            SELECT *
            FROM
            (
                SELECT DISTINCT TOP 4 YEAR(year) years
                FROM tbl_PortfolioKeyFigure b
                WHERE b.PortfolioID = @PortfolioID
                      AND b.TargetPortfolioID = @TargetPortfolioID
                      AND SubTab = 1
                GROUP BY b.Year
                ORDER BY YEAR(b.year) DESC
            ) t
            ORDER BY years;
    BEGIN
        WITH data
             AS (SELECT-1 PortfolioID, 
                       -1 TargetPortfolioID, 
                       Code, 
                       Location
                 FROM(VALUES
                 ('Years', 
                 (
                     SELECT SUBSTRING(
                     (
                         SELECT ',' + t.years
                         FROM
                         (
                             SELECT TOP 4 REPLACE(years, '()', '') years
                             FROM
                             (
                                 SELECT SUBSTRING(Amount, 7, 4) + '(' +
                                 (
                                     SELECT TOP 1 --isnull(Amount,'')

                                     CASE
                                         WHEN ISNULL(Amount, '') = 'A'
                                         THEN 'Actual'
                                         WHEN ISNULL(Amount, '') = 'B'
                                         THEN 'budget'
                                         WHEN ISNULL(Amount, '') = 'E'
                                         THEN 'Estimated'
                                         ELSE ISNULL(Amount, '')
                                     END
                                     FROM tbl_PortfolioKeyFigure KF
                                          JOIN tbl_KeyfigureConfig c ON kf.KeyFigureConfigID = c.KeyFigureConfigID
                                     WHERE YEAR(KF.Year) = YEAR(B.year)
                                           AND KF.PortfolioID = @PortfolioID
                                           AND KF.TargetPortfolioID = @TargetPortfolioID
                                           AND KF.SubTab = @SubTabID
                                           AND c.Name = 'Category'
                                 ) + ')' years, 
                                        YEAR(year) Y
                                 FROM tbl_PortfolioKeyFigure b
                                      JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
                                 WHERE b.PortfolioID = @PortfolioID
                                       AND b.TargetPortfolioID = @TargetPortfolioID
                                       AND b.SubTab = @SubTabID
                                       AND Name = 'End date'
                                       AND YEAR(year) IN
                                 (
                                     SELECT years
                                     FROM @tmp
                                 )
                             ) t
                         ) t FOR XML PATH('')
                     ), 2, 200000)
                 )
                 )) data(Code, Location)),
             shredded
             AS (SELECT-1 PortfolioID, 
                       -1 TargetPortfolioID, 
                       Code, 
                       Location, 
                       t.*
                 FROM data
                      CROSS APPLY [dbo].[DelimitedSplit8K_keyfigure](data.Location, ',') AS t)
             SELECT-1 PortfolioID, 
                   -1 TargetPortfolioID, 
                   pvt.Code, 
                   CAST(ISNULL(pvt.[1], ' ') AS VARCHAR(15)) AS Loc1, 
                   CAST(ISNULL(pvt.[2], ' ') AS VARCHAR(15)) AS Loc2, 
                   CAST(ISNULL(pvt.[3], ' ') AS VARCHAR(15)) AS Loc3, 
                   CAST(ISNULL(pvt.[4], ' ') AS VARCHAR(15)) AS Loc4
             FROM shredded PIVOT(MAX(Item) FOR ItemNumber IN([1], 
                                                             [2], 
                                                             [3], 
                                                             [4])) pvt;
    END;
