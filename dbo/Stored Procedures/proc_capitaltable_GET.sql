CREATE PROCEDURE [dbo].[proc_capitaltable_GET]
(@date              DATETIME, 
 @TargetPortfolioID INT, 
 @portfolioID       INT
)
AS
    BEGIN
        DECLARE @tbl TABLE
        (ShareHolderID INT, 
         Number1       DECIMAL(18, 2), 
         Number2       DECIMAL(18, 2), 
         Number3       DECIMAL(18, 2), 
         ObjectID      INT, 
         ModuleID      INT, 
         IsTeam        BIT
        );
        DECLARE @sum1 INT;
        DECLARE @sum2 INT;
        DECLARE @sum3 INT;
        INSERT INTO @tbl
               SELECT ShareHolderID, 
                      dbo.[F_NonDiluted](SH.ObjectID, SH.ModuleID, @date, @portfolioID) AS Number1, 
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
        SELECT ObjectID, 
               ModuleID,
               CASE
                   WHEN ModuleID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = ObjectID
        )
                   WHEN ModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = ObjectID
        )
                   WHEN ModuleID = 3
                   THEN
        (
            SELECT TOP 1 V.Name
            FROM [tbl_Vehicle] V
            WHERE V.VehicleID = ObjectID
        )
               END AS 'Name', 
               Number1, 
               (Number1 * 1.0 / @sum1) * 100 AS 'non diluted', 
               Number2, 
               (Number2 * 1.0 / @sum2) * 100 AS 'diluted', 
               Number3, 
               (Number3 * 1.0 / @sum3) * 100 AS 'voting', 
               IsTeam, 
               ShareHolderID
        FROM @tbl
        ORDER BY IsTeam, 
                 ModuleID;
    END;
