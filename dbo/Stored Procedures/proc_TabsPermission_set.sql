CREATE PROC [dbo].[proc_TabsPermission_set]
(@TabsPermissionID INT, 
 @moduleID         INT, 
 @tabID            INT, 
 @subtabID         INT, 
 @roleName         VARCHAR(1000), 
 @isRead           BIT, 
 @isEdit           BIT, 
 @isCreate         BIT, 
 @isDelete         BIT, 
 @isExcel          BIT
)
AS
    BEGIN
        IF @TabsPermissionID IS NULL
            BEGIN
                INSERT INTO tbl_TabsPermission
                (ModuleID, 
                 TabID, 
                 SubTabID, 
                 UserRole, 
                 IsRead, 
                 IsEdit, 
                 IsCreate, 
                 IsDelete, 
                 IsExcel, 
                 Active, 
                 CreateDateTime, 
                 CreatedBy
                )
                       SELECT @ModuleID, 
                              @TabID, 
                              @SubTabID, 
                              @roleName, 
                              @IsRead, 
                              @IsEdit, 
                              @IsCreate, 
                              @IsDelete, 
                              @IsExcel, 
                              1, 
                              GETDATE(), 
                              @roleName;
        END;
            ELSE
            BEGIN
                UPDATE tbl_TabsPermission
                  SET 
                      ModuleID = @ModuleID, 
                      TabID = @TabID, 
                      SubTabID = @SubTabID, 
                      UserRole = @roleName, 
                      IsRead = @IsRead, 
                      IsEdit = @IsEdit, 
                      IsCreate = @IsCreate, 
                      IsDelete = @IsDelete, 
                      IsExcel = @IsExcel, 
                      Active = 1, 
                      ModifiedDateTime = GETDATE(), 
                      ModifiedBy = @roleName
                WHERE TabsPermissionID = @TabsPermissionID;
        END;
        SELECT 1 Result;
    END;
