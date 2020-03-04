CREATE PROCEDURE [dbo].[proc_TaskLinked_GET] @TaskID            INT = NULL, 
                                             @ModuleID          INT = NULL, 
                                             @IsExternalAdvisor BIT = NULL, 
                                             @isMCUser          BIT = NULL
AS
    BEGIN
        SELECT TaskLinkedID, 
               TaskID, 
               ModuleID, 
               ObjectID,
               CASE
                   WHEN ModuleID = 4
                   THEN
        (
            SELECT IndividualFullName
            FROM tbl_contactindividual i
            WHERE i.individualid = ObjectID
        )
                   WHEN ModuleID = 5
                   THEN
        (
            SELECT companyname
            FROM tbl_companycontact c
            WHERE c.CompanyContactID = ObjectID
        )
                   WHEN moduleid = 6
                   THEN
        (
            SELECT dealname
            FROM tbl_deals
            WHERE dealid = objectid
        )
               END ObjectName, 
               IsExternalAdvisor, 
               ismcuser
        FROM tbl_TaskLinked
        WHERE TaskID = ISNULL(@TaskID, TaskID)
              AND ModuleID = ISNULL(@ModuleID, ModuleID)
              AND IsExternalAdvisor = ISNULL(@IsExternalAdvisor, IsExternalAdvisor)
              AND isMCUser = ISNULL(@isMCUser, isMCUser);
    END;
