
-- [proc_ShareholderCompliant_Report] 1554      

CREATE PROCEDURE [dbo].[proc_ShareholderCompliant_Report] @ShareholderID INT = NULL
AS
    BEGIN
        SELECT CompliantID, 
               sc.ShareholderID, 
               Compliant1, 
               Compliant2, 
               Compliant3, 
               Compliant4, 
               Compliant5, 
               Compliant6, 
               Compliant7, 
               Compliant8, 
               Compliant9, 
               Compliant10, 
               Compliant11, 
               Compliant12, 
               Compliant13, 
               Compliant14, 
               Compliant15, 
               Compliant16, 
               Compliant17, 
               Compliant18, 
               Compliant19, 
               Compliant20, 
               Compliant21, 
               Compliant22, 
               Compliant23, 
               Compliant24, 
               Compliant25, 
               dbo.F_GetObjectModuleName(ObjectID, ModuleID) ShareHolderName
        FROM tbl_ShareholderCompliant Sc
             JOIN tbl_Shareholders s ON s.ShareholderID = sc.ShareholderID
        WHERE S.ShareholderID = @ShareholderID;
    END;
