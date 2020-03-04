﻿CREATE PROCEDURE [dbo].[aspnet_Profile_SetProperties] @ApplicationName      NVARCHAR(256), 
                                                      @PropertyNames        NTEXT, 
                                                      @PropertyValuesString NTEXT, 
                                                      @PropertyValuesBinary IMAGE, 
                                                      @UserName             NVARCHAR(256), 
                                                      @IsUserAnonymous      BIT, 
                                                      @CurrentTimeUtc       DATETIME
AS
    BEGIN
        DECLARE @ApplicationId UNIQUEIDENTIFIER;
        SELECT @ApplicationId = NULL;
        DECLARE @ErrorCode INT;
        SET @ErrorCode = 0;
        DECLARE @TranStarted BIT;
        SET @TranStarted = 0;
        IF(@@TRANCOUNT = 0)
            BEGIN
                BEGIN TRANSACTION;
                SET @TranStarted = 1;
        END;
            ELSE
            SET @TranStarted = 0;
        EXEC dbo.aspnet_Applications_CreateApplication 
             @ApplicationName, 
             @ApplicationId OUTPUT;
        IF(@@ERROR <> 0)
            BEGIN
                SET @ErrorCode = -1;
                GOTO Cleanup;
        END;
        DECLARE @UserId UNIQUEIDENTIFIER;
        DECLARE @LastActivityDate DATETIME;
        SELECT @UserId = NULL;
        SELECT @LastActivityDate = @CurrentTimeUtc;
        SELECT @UserId = UserId
        FROM dbo.aspnet_Users
        WHERE ApplicationId = @ApplicationId
              AND LoweredUserName = LOWER(@UserName);
        IF(@UserId IS NULL)
            EXEC dbo.aspnet_Users_CreateUser 
                 @ApplicationId, 
                 @UserName, 
                 @IsUserAnonymous, 
                 @LastActivityDate, 
                 @UserId OUTPUT;
        IF(@@ERROR <> 0)
            BEGIN
                SET @ErrorCode = -1;
                GOTO Cleanup;
        END;
        UPDATE dbo.aspnet_Users
          SET 
              LastActivityDate = @CurrentTimeUtc
        WHERE UserId = @UserId;
        IF(@@ERROR <> 0)
            BEGIN
                SET @ErrorCode = -1;
                GOTO Cleanup;
        END;
        IF(EXISTS
        (
            SELECT *
            FROM dbo.aspnet_Profile
            WHERE UserId = @UserId
        ))
            UPDATE dbo.aspnet_Profile
              SET 
                  PropertyNames = @PropertyNames, 
                  PropertyValuesString = @PropertyValuesString, 
                  PropertyValuesBinary = @PropertyValuesBinary, 
                  LastUpdatedDate = @CurrentTimeUtc
            WHERE UserId = @UserId;
            ELSE
            INSERT INTO dbo.aspnet_Profile
            (UserId, 
             PropertyNames, 
             PropertyValuesString, 
             PropertyValuesBinary, 
             LastUpdatedDate
            )
            VALUES
            (@UserId, 
             @PropertyNames, 
             @PropertyValuesString, 
             @PropertyValuesBinary, 
             @CurrentTimeUtc
            );
        IF(@@ERROR <> 0)
            BEGIN
                SET @ErrorCode = -1;
                GOTO Cleanup;
        END;
        IF(@TranStarted = 1)
            BEGIN
                SET @TranStarted = 0;
                COMMIT TRANSACTION;
        END;
        RETURN 0;
        Cleanup:
        IF(@TranStarted = 1)
            BEGIN
                SET @TranStarted = 0;
                ROLLBACK TRANSACTION;
        END;
        RETURN @ErrorCode;
    END;
