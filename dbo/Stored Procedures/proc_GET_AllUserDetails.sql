CREATE PROCEDURE [dbo].[proc_GET_AllUserDetails]
AS
    BEGIN
        SELECT(ISNULL(ci.IndividualLastName, '') + ' ' + ISNULL(ci.IndividualFirstName, '')) AS 'IndividualFullName', 
              u.UserName, 
              m.createDate, 
              m.LastPasswordChangedDate, 
              DATEADD(mm, 3, m.LastPasswordChangedDate) AS ExpireDate, 
              RoleName
        FROM dbo.aspnet_Users u
             JOIN aspnet_UsersInRoles ur ON u.userid = ur.userid
             JOIN aspnet_Roles r ON r.RoleId = ur.RoleId
             INNER JOIN dbo.aspnet_Membership m ON u.UserId = m.UserId
             JOIN tbl_Individualuser iu ON u.UserName = iu.UserName
             LEFT OUTER JOIN tbl_ContactIndividual ci ON iu.IndividualID = ci.IndividualID
        ORDER BY ISNULL(ci.IndividualLastName, '');
    END;
