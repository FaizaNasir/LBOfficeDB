CREATE PROC [dbo].[SetBlockedPermission]
(@BlockedPermissionID INT, 
 @ModuleName          VARCHAR(1000), 
 @ObjectID            INT, 
 @UserRole            VARCHAR(100), 
 @CreatedBy           VARCHAR(100), 
 @ModifiedBy          VARCHAR(100)
)
AS
    BEGIN
        IF @BlockedPermissionID IS NULL
            INSERT INTO tbl_BlockedPermission
            (ModuleName, 
             ObjectID, 
             UserRole, 
             Active, 
             CreateDateTime, 
             CreatedBy
            )
                   SELECT @ModuleName, 
                          @ObjectID, 
                          @UserRole, 
                          1, 
                          GETDATE(), 
                          @CreatedBy;
        SELECT 1 Result;
    END;
