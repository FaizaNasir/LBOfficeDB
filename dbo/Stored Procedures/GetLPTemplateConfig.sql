CREATE PROC [dbo].[GetLPTemplateConfig]
(@LPTemplateConfigID INT, 
 @Vehicleid          INT, 
 @DocumentTypeID     INT, 
 @moduleID           INT, 
 @objectID           INT, 
 @lang               VARCHAR(100)
)
AS
    BEGIN
        SELECT LPTemplateConfigID, 
               VehicleID, 
               DocumentTypeID, 
               Name, 
               Report, 
               Subject, 
               Email, 
               Notes, 
               Active, 
               CreatedDate, 
               ModifiedDate, 
               CreatedBy, 
               ModifiedBy, 
               Lang
        FROM tbl_LPTemplateConfig c
        WHERE LPTemplateConfigID = ISNULL(@LPTemplateConfigID, LPTemplateConfigID)
              AND VehicleID = ISNULL(@VehicleID, VehicleID)
              AND DocumentTypeID = ISNULL(@DocumentTypeID, DocumentTypeID)
              AND ISNULL(Lang, 0) = ISNULL(@lang, ISNULL(Lang, 0))
              AND 1 = CASE
                          WHEN @moduleID IS NOT NULL
                               AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_LPTemplateConfigDetail d
            WHERE d.ModuleID = @moduleID
                  AND d.ObjectID = @objectid
                  AND d.LPTemplateConfigID = c.LPTemplateConfigID
        )
                          THEN 1
                          WHEN @moduleID IS NOT NULL
                          THEN 0
                          ELSE 1
                      END;
    END;
