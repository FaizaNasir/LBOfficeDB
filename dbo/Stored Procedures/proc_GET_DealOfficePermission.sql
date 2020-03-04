CREATE PROCEDURE [dbo].[proc_GET_DealOfficePermission] --'ContactCompany','RestirctedUsers'		  
@RoleName NVARCHAR(50) = NULL
AS
    BEGIN
        SELECT DOP.OfficeID AS 'ID', 
               tbl_Office.OfficeName AS 'Name'
        FROM tbl_DealOfficePermission AS DOP
             INNER JOIN tbl_Office ON DOP.OfficeID = tbl_Office.OfficeID
        WHERE DOP.RoleID = ISNULL(@RoleName, DOP.RoleID);
    END;
