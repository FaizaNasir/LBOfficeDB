
--  select dbo.[F_CapitalTable_VotingRatio]('31 Dec,2015',1,574,28,3)    

CREATE FUNCTION [dbo].[F_CapitalTable_VotingRatio]
(@date              DATETIME, 
 @portfolioid       INT, 
 @TargetPortfolioID INT, 
 @objectid          INT, 
 @moduleid          INT
)
RETURNS DECIMAL(18, 4)
AS
     BEGIN
         DECLARE @nondiluted AS DECIMAL(18, 2);
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
         DECLARE @tblfinal TABLE
         (ObjectID     INT, 
          ModuleID     INT, 
          nondiluted   DECIMAL(18, 4), 
          diluted      DECIMAL(18, 4), 
          votingration DECIMAL(18, 4)
         );
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
         INSERT INTO @tblfinal
                SELECT ObjectID, 
                       ModuleID, 
                       (Number1 * 1.0 / @sum1) AS 'non diluted', 
                       (Number2 * 1.0 / @sum2) AS 'diluted', 
                       (Number3 * 1.0 / @sum3) AS 'voting'
                FROM @tbl
                WHERE ModuleID = @moduleid
                      AND ObjectID = @objectid
                ORDER BY ModuleID;
         SET @return_value =
         (
             SELECT TOP 1 tf.votingration
             FROM @tblfinal tf
         );
         RETURN @return_value;
     END;
