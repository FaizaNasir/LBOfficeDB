
-- [proc_capitaltable_Report] '20 Oct, 2015',14,11

CREATE FUNCTION [dbo].[F_capitaltable_Report]
(@date              DATETIME, 
 @TargetPortfolioID INT, 
 @portfolioID       INT
)
RETURNS DECIMAL(18, 4)
AS
     BEGIN
         DECLARE @return_value DECIMAL(18, 4);
         DECLARE @tbl TABLE
         (Number1  INT, 
          Number2  INT, 
          Number3  INT, 
          ObjectID INT, 
          ModuleID INT, 
          IsTeam   BIT
         );
         DECLARE @sum1 INT;
         DECLARE @sum2 INT;
         DECLARE @sum3 INT;
         INSERT INTO @tbl
                SELECT dbo.[F_NonDiluted](SH.ObjectID, SH.ModuleID, @date, @portfolioID) AS Number1, 
                       dbo.[F_Diluted](SH.ObjectID, SH.ModuleID, @date, @portfolioID) AS Number2, 
                       dbo.[F_Voting](SH.ObjectID, SH.ModuleID, @date, @portfolioID) AS Number3, 
                       SH.ObjectID, 
                       SH.ModuleID,
                       CASE
                           WHEN EXISTS
                (
                    SELECT TOP 1 1
                    FROM tbl_CompanyIndividuals t
                    WHERE CompanyContactID = @TargetPortfolioID
                          AND ContactIndividualID = SH.ObjectID
                          AND SH.ModuleID = 4
                          AND TeamTypeName = 'Executive Team'
                )
                           THEN 1
                           ELSE 0
                       END
                FROM tbl_Shareholders SH
                WHERE TargetPortfolioID = @TargetPortfolioID;
         SELECT @sum1 = (CASE
                             WHEN SUM(Number1) = 0
                             THEN 1
                             ELSE SUM(Number1)
                         END)
         FROM @tbl;
         SELECT @sum2 = (CASE
                             WHEN SUM(Number2) = 0
                             THEN 1
                             ELSE SUM(Number2)
                         END)
         FROM @tbl;
         SELECT @sum3 = (CASE
                             WHEN SUM(Number3) = 0
                             THEN 1
                             ELSE SUM(Number3)
                         END)
         FROM @tbl;
         SET @return_value =
         (
             SELECT TOP 1(Number1 * 1.0 / @sum1) * 100 AS 'non diluted'
             FROM @tbl
         );
         RETURN @return_value;
     END;
