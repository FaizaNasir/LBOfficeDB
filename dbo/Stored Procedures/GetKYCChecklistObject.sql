
CREATE PROC [dbo].[GetKYCChecklistObject]
(@moduleID INT, 
 @objectID INT, 
 @typeID   INT
)
AS
    BEGIN
        SELECT c.Notes ItemName, 
               c.KYCChecklistConfigID, 
               c.TypeID, 
               o.KYCChecklistObjectID, 
               ISNULL(o.ModifiedBy, o.CreatedBy) CreatedBy, 
               ISNULL(o.ModifiedDate, o.CreatedDate) CreatedDate, 
               o.Active
        FROM KYCChecklistConfig c
             LEFT JOIN KYCChecklistObject o ON c.KYCChecklistConfigID = o.KYCChecklistID
                                               AND o.ObjectID = @objectID
                                               AND o.ModuleID = @moduleID
                                               AND o.TypeID = ISNULL(@typeID, o.TypeID)
        WHERE c.ModuleID = @moduleID
              AND c.TypeID = ISNULL(@typeID, c.TypeID);
    END;
