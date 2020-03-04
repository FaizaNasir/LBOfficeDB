
-- GetSameGroupPortalUsers 5,3393

CREATE PROC [dbo].[GetSameGroupPortalUsers]
(@moduleID INT, 
 @objectID INT
)
AS
    BEGIN
        DECLARE @groupName VARCHAR(100);
        IF @moduleID = 5
            SET @groupName =
            (
                SELECT TOP 1 groupname
                FROM tbl_companyOptionalBis
                WHERE CompanyId = @objectID
            );
            ELSE
            IF @moduleID = 4
                SET @groupName =
                (
                    SELECT TOP 1 groupname
                    FROM tbl_ContactIndividualOptional
                    WHERE IndividualID = @objectID
                );
        SELECT DISTINCT 
               CAST(ModuleID AS VARCHAR(10)) + '|' + CAST(objectid AS VARCHAR(10)) Combined, 
               *
        FROM
        (
            SELECT 4 ModuleID, 
                   ci.individualid ObjectID, 
                   IndividualFullName Name
            FROM tbl_ContactIndividual ci
                 JOIN tbl_ContactIndividualOptional cio ON cio.IndividualID = ci.IndividualID
            WHERE groupname = @groupName
            UNION ALL
            SELECT 5 ModuleID, 
                   ci.companycontactid ObjectID, 
                   CompanyName
            FROM tbl_companycontact ci
                 JOIN tbl_companyOptionalBis cio ON cio.CompanyId = ci.companycontactid
            WHERE groupname = @groupName
        ) t
        WHERE 1 = CASE
                      WHEN EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_portaluser
            WHERE objectid = @objectID
                  AND ModuleID = @moduleID
                  AND IsAllowed = 1
        )
                      THEN 1
                      WHEN t.ObjectID = @objectID
                           AND t.ModuleID = @moduleID
                      THEN 1
                      ELSE 0
                  END
        ORDER BY name;
    END;
