
-- [proc_Deal_GET] 110,'Principle'

CREATE PROCEDURE [dbo].[proc_Deal_GET] @DealID INT         = NULL, 
                                       @RoleID VARCHAR(50) = NULL
AS
    BEGIN
        SELECT p.CanView, 
               D.DealID, 
               D.DealName, 
               D.DealCode, 
               D.ReceivedDate, 
               D.ReceiverID, 
               D.DealTypeID, 
               D.DealSize, 
               D.DealCurrencyCode, 
               D.Valuation, 
               D.Notes, 
               ofc.OfficeID, 
               ofc.OfficeName, 
               DT.ProjectTypeID, 
               DT.ProjectTypeTitle, 
               DT.ProjectTypeDesc, 
               D.DealCurrentTargetID, 
               D.ActivityID, 
               d.createddatetime, 
               d.ModifiedDateTime, 
               d.AssignmentFeeDebt, 
               d.AssignmentFeeEquity, 
               Sale
        FROM tbl_deals d
             LEFT JOIN tbl_ModuleObjectPermissions AS P ON d.dealid = P.ModuleObjectID
                                                           AND P.ModuleID = 6
                                                           AND P.RoleID = ISNULL(@RoleID, P.RoleID)--''--@RoleID                                    

             LEFT JOIN tbl_DealStatus ds ON ds.ProjectStatusID = d.DealStatusID
             LEFT OUTER JOIN tbl_DealType DT ON D.DealTypeId = DT.ProjectTypeID
             LEFT JOIN tbl_Office ofc ON ofc.officeid = d.officeid
        WHERE d.DealID = ISNULL(@DealID, d.DealID)
              AND p.CanView IS NULL
              AND NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_DealOfficePermission ctp
            WHERE ctp.RoleID = @RoleID
                  AND ctp.Officeid = d.officeID
        );
    END;
