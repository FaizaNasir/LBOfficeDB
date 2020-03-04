CREATE PROC [dbo].[GetLPTemplateConfigDetail](@LPTemplateConfigID INT)
AS
    BEGIN
        SELECT LPTemplateConfigDetailID, 
               LPTemplateConfigID, 
               ModuleID, 
               ObjectID, 
               Active, 
               CreatedDate, 
               ModifiedDate, 
               CreatedBy, 
               ModifiedBy, 
               dbo.F_GetObjectModuleName(ObjectID, ModuleID) ObjectName
        FROM tbl_LPTemplateConfigDetail
        WHERE LPTemplateConfigID = @LPTemplateConfigID;
    END;
