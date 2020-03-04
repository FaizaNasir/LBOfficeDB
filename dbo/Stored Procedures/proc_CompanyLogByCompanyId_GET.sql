CREATE PROCEDURE [dbo].[proc_CompanyLogByCompanyId_GET] @CompanyID INT         = NULL, 
                                                        @Log_Type  VARCHAR(10)
AS
    BEGIN
        SELECT l.[Id], 
               l.[Company_Id], 
               l.[Value], 
               w.IndividualFullName, 
               l.[Comment], 
               l.[Log_Type], 
               l.CreationDate
        FROM tbl_CompanyLogs l
             JOIN tbl_ContactIndividual w ON l.[Contact_Id] = w.IndividualID
        WHERE Company_Id = @CompanyID
              AND Log_Type = @Log_Type;

        --select * from tbl_ContactIndividual tbl_CompanyContact
    END;
