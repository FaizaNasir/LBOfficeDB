-- proc_CapitalTable_Report 867 ,'9/15/2015'        

CREATE PROCEDURE [dbo].[proc_capitaltable_Report] @comapnyName INT      = NULL, 
                                                  @Date        DATETIME
AS
    BEGIN
        DECLARE @tmp TABLE
        (ModuleID          INT, 
         ObjectID          INT, 
         TargetPortfolioID INT, 
         Share             decimal(18,6), 
         Bond              decimal(18,6), 
         Other             decimal(18,6), 
         IsTeam            BIT, 
         TypeID            INT
        );
        INSERT INTO @tmp
               SELECT S.ModuleID, 
                      S.ObjectID, 
                      S.TargetPortfolioID, 
                      dbo.[F_NonDiluted_Report](S.ObjectID, S.ModuleID, @Date, p.PortfolioID, '1,3,4') Shares, 
                      dbo.[F_NonDiluted_Report](S.ObjectID, S.ModuleID, @Date, p.PortfolioID, '6,7') Bond, 
                      dbo.[F_NonDiluted_Report](S.ObjectID, S.ModuleID, @Date, p.PortfolioID, '10') Other,
                      CASE
                          WHEN EXISTS
               (
                   SELECT TOP 1 1
                   FROM tbl_CompanyIndividuals t
                   WHERE CompanyContactID = @comapnyName
                         AND ContactIndividualID = S.ObjectID
                         AND S.ModuleID = 4
                         AND TeamTypeName = 'Executive Team'
               )
                          THEN 1
                          ELSE 0
                      END IsMember, 
                      Type
               FROM tbl_Shareholders S
                    JOIN tbl_Portfolio p ON p.TargetPortfolioID = S.TargetPortfolioID
               WHERE S.TargetPortfolioID = ISNULL(@comapnyName, S.TargetPortfolioID);

        -- select * from @tmp                    

        SELECT ModuleID, 
               ObjectID, 
               Name, 
               TargetPortfolioID, 
               Share, 
               SUM(Bond) AS Bond, 
               Other
        FROM @tmp a
             JOIN tbl_Vehicle b ON a.ObjectID = b.VehicleID
        WHERE IsTeam = 0
              AND ModuleID IN(3)
        GROUP BY ModuleID, 
                 ObjectID, 
                 Name, 
                 TargetPortfolioID, 
                 Share, 
                 Other
        UNION ALL
        SELECT 0, 
               0, 
               'Management', 
               TargetPortfolioID, 
               SUM(share), 
               SUM(bond), 
               SUM(other)
        FROM @tmp
        WHERE ModuleID IN(4, 5)
        AND TypeID = 1
        GROUP BY TargetPortfolioID
        UNION ALL
        SELECT 0, 
               0, 
               'Other Financial', 
               TargetPortfolioID, 
               SUM(share), 
               SUM(bond), 
               SUM(other)
        FROM @tmp
        WHERE TypeID = 2
              AND ModuleID IN(4, 5)
        GROUP BY TargetPortfolioID
        UNION ALL
        SELECT 0, 
               0, 
               'Other', 
               TargetPortfolioID, 
               SUM(share), 
               SUM(bond), 
               SUM(other)
        FROM @tmp
        WHERE TypeID = 3
              AND ModuleID IN(4, 5)
        GROUP BY TargetPortfolioID
        UNION ALL
        SELECT 0, 
               0, 
               'Independent Admin', 
               TargetPortfolioID, 
               SUM(share), 
               SUM(bond), 
               SUM(other)
        FROM @tmp
        WHERE TypeID = 4
              AND ModuleID IN(4, 5)
        GROUP BY TargetPortfolioID;
    END;
