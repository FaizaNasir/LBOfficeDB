CREATE PROCEDURE [dbo].[proc_VehicleQuarterlyUpdate_GET] @VehicleID                INT           = NULL, 
                                                         @UpdateType               VARCHAR(100)  = NULL, 
                                                         @VehicleQuarterlyUpdateID INT           = NULL, 
                                                         @SearchKey                NVARCHAR(100) = NULL, 
                                                         @roleID                   VARCHAR(50)   = NULL, 
                                                         @date                     DATETIME
AS
    BEGIN
        IF @UpdateType = ''
            SET @UpdateType = NULL;
        IF @date IS NULL
            SET @date =
            (
                SELECT date
                FROM [tbl_VehicleQuarterlyUpdates]
                WHERE VehicleQuarterlyUpdateID = @VehicleQuarterlyUpdateID
            );
        SET @date =
        (
            SELECT TOP 1 date
            FROM [tbl_VehicleQuarterlyUpdates]
            WHERE VehicleID = ISNULL(@VehicleID, VehicleID)
                  AND UpdateType = ISNULL(@UpdateType, UpdateType)
                  AND date <= @date
            ORDER BY date DESC
        );
        IF(@SearchKey IS NULL)
            BEGIN
                SELECT [VehicleQuarterlyUpdateID], 
                       [VehicleID], 
                       [Date], 
                       [Comments], 
                       [UpdateType], 
                       f.individualid, 
                       ci.individualFullName, 
                       f.CreatedDateTime, 
                       Language
                FROM [tbl_VehicleQuarterlyUpdates] f
                     LEFT JOIN tbl_contactindividual ci ON ci.individualid = f.individualid
                WHERE VehicleID = ISNULL(@VehicleID, VehicleID)
                      AND UpdateType = ISNULL(@UpdateType, UpdateType)
                      AND VehicleQuarterlyUpdateID = ISNULL(@VehicleQuarterlyUpdateID, VehicleQuarterlyUpdateID)
                      AND date = @date
                ORDER BY [Date] DESC;
        END;
            ELSE
            BEGIN
                SELECT [VehicleQuarterlyUpdateID], 
                       [VehicleID], 
                       [Date], 
                       [Comments], 
                       [UpdateType], 
                       f.individualid, 
                       ci.individualFullName, 
                       f.CreatedDateTime, 
                       Language
                FROM [LBOffice].[dbo].[tbl_VehicleQuarterlyUpdates] f
                     LEFT JOIN tbl_contactindividual ci ON ci.individualid = f.individualid
                WHERE VehicleID = ISNULL(@VehicleID, VehicleID)
                      AND UpdateType = ISNULL(@UpdateType, UpdateType)
                      AND VehicleQuarterlyUpdateID = ISNULL(@VehicleQuarterlyUpdateID, VehicleQuarterlyUpdateID)
                      AND [Comments] LIKE ISNULL('%' + @SearchKey + '%', [Comments])
                      AND date = @date
                ORDER BY [Date] DESC;
        END;
    END;
