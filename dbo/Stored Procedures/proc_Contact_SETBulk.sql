
-- created by : Syed Zain ALi  
-- =============================================          
-- Author:  <Author,,Zain Ali>          
-- Create date: <Created Date,,02 Oct, 2013>          
-- Description: <Description,,This funtion will return the info of individual/company based on input values.         
--         if the value does not exists then it ill create and return them as well>          
-- =============================================          
-- [proc_Contact_SETBulk] 'DAVIGOLD MANAGEMENT,DAVIGOLD MANAGEMENT Testing','Company'        

CREATE PROCEDURE [dbo].[proc_Contact_SETBulk] @name VARCHAR(MAX), 
                                              @type VARCHAR(100)
AS
    BEGIN
        IF(@type = 'Individual')
            BEGIN
                INSERT INTO dbo.tbl_ContactIndividual
                (IndividualLastName, 
                 IndividualFirstName, 
                 IndividualFullName
                )
                       SELECT SUBSTRING(i.items, 0,
                                                 CASE
                                                     WHEN CHARINDEX(' ', i.items) = 0
                                                     THEN LEN(i.items) + 1
                                                     ELSE CHARINDEX(' ', i.items)
                                                 END), 
                              SUBSTRING(i.items,
                                          CASE
                                              WHEN CHARINDEX(' ', i.items) = 0
                                              THEN LEN(i.items) + 1
                                              ELSE CHARINDEX(' ', i.items) + 1
                                          END, LEN(i.items)), 
                              i.items
                       FROM dbo.tbl_ContactIndividual ci
                            RIGHT JOIN
                       (
                           SELECT *
                           FROM dbo.SplitCSV(@name, ',')
                       ) i ON i.items = IndividualFirstName + ' ' + IndividualLastName
                       WHERE ci.IndividualID IS NULL;
                SELECT ci.IndividualID AS ObjectID, 
                       ci.IndividualFullName AS ObjectName
                FROM dbo.tbl_ContactIndividual ci
                WHERE IndividualLastName + ' ' + IndividualFirstName IN
                (
                    SELECT *
                    FROM dbo.SplitCSV(@name, ',')
                );
        END;
            ELSE
            IF(@type = 'Company')
                BEGIN
                    INSERT INTO dbo.tbl_CompanyContact(CompanyName)
                           SELECT i.items
                           FROM dbo.tbl_CompanyContact ci
                                RIGHT JOIN
                           (
                               SELECT *
                               FROM dbo.SplitCSV(@name, ',')
                           ) i ON i.items = CompanyName
                           WHERE ci.CompanyContactID IS NULL;
                    SELECT ci.CompanyContactID AS ObjectID, 
                           ci.CompanyName AS ObjectName
                    FROM dbo.tbl_CompanyContact ci
                    WHERE CompanyName IN
                    (
                        SELECT *
                        FROM dbo.SplitCSV(@name, ',')
                    );
            END;
    END;
