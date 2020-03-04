--   
/*                

                

exec [dbo].[proc_GetdealsAutoSuggest] @RoleID='LbofficeAdmin',@dealstatusid='',                  

@dealSectorid='',@dealTypeid='',@freeText='Specialized',                

@startDate=null,                  

@endDate=null,@dealSizeFrom=NULL,@dealSizeTo=NULL,@MCTeamMembers='',                  

@senderIndividual='',@senderCompany='',@fundID='',@Character=NULL ,@officeID=null                 

                      

*/

CREATE PROC [dbo].[proc_GetdealsAutoSuggest]  --'','ven'                               

(@RoleID   VARCHAR(50), 
 @dealName VARCHAR(100)
)
AS
    BEGIN
        SELECT d.DealID, 
               d.DealName, 
               d.ReceivedDate, 
               d.DealTypeID, 
               d.DealSize, 
               d.DealCurrencyCode, 
               d.Notes, 
               d.CreatedDateTime, 
               d.ModifiedDateTime, 
               c.companyName, 
               c.CompanyContactID, 
               p.CanView, 
               d.dealStageid, 
               0 AS 'PortfolioTargetTypeID'
        FROM tbl_deals d
             LEFT JOIN tbl_companycontact c ON d.DealCurrentTargetID = c.CompanyContactID
             LEFT JOIN tbl_ModuleObjectPermissions AS P ON d.dealid = P.ModuleObjectID
                                                           AND P.ModuleID = 6
                                                           AND P.RoleID = @RoleID
        WHERE d.dealname LIKE '%' + @dealName + '%'
              AND d.active = 1
              AND ISNULL(P.CanView, 1) = 1
              AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_tabspermission
            WHERE moduleID = 6
                  AND TabID IS NULL
                  AND SubTabID IS NULL
                  AND UserRole = @RoleID
                  AND IsRead = 1
        )
              AND NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_BlockedPermission b
            WHERE b.moduleName = 'Deals'
                  AND UserRole = @RoleID
                  AND b.ObjectID = DealID
        )
              AND NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_BlockedGroupPermission b
            WHERE b.moduleID = 6
                  AND UserRole = @RoleID
                  AND b.TypeID = DealTypeID
        )
        ORDER BY d.ReceivedDate DESC;
    END;
