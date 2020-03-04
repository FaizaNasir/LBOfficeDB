CREATE PROCEDURE [dbo].[proc_ShareholderCompliant_GET] @ShareholderID INT = NULL
AS
    BEGIN
        SELECT CompliantID, 
               ShareholderID, 
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
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_ShareholderCompliant S
        WHERE S.ShareholderID = @ShareholderID;
    END;
