CREATE PROCEDURE [dbo].[proc_Meeting_SET]
(@MeetingID         INT, 
 @MeetingName       VARCHAR(100), 
 @isPrivate         BIT, 
 @MeetingDesc       VARCHAR(MAX), 
 @MeetingDate       DATETIME, 
 @MeetingEndDate    DATETIME, 
 @MeetingStartTime  TIME, 
 @MeetingEndTime    TIME, 
 @MeetingLocationID INT, 
 @MeetingLocation   VARCHAR(100), 
 @LastMeetingID     BIT, 
 @isRecurring       BIT, 
 @RecuringFrequency VARCHAR(100), 
 @UsersCanNotEdit   VARCHAR(100), 
 @UserCanNotRead    VARCHAR(100), 
 @MeetingType       VARCHAR(50), 
 @MeetingComments   VARCHAR(MAX), 
 @MeetingRoom       VARCHAR(100), 
 @AlertComments     VARCHAR(50), 
 @Duration          INT, 
 @Address           VARCHAR(250), 
 @ZipCode           VARCHAR(100), 
 @CityID            INT, 
 @CountryID         INT, 
 @ParentMeetingID   INT          = -1, 
 @alertIntervalID   INT, 
 @stateID           INT, 
 @PhNumber          VARCHAR(100)
)
AS
     IF @ParentMeetingID = -1
         SET @ParentMeetingID = NULL;
    BEGIN
        IF(@MeetingID = -1
           OR @MeetingID IS NULL)
            BEGIN
                INSERT INTO [dbo].[tbl_Meetings]
                (MeetingName, 
                 isPrivate, 
                 MeetingDesc, 
                 MeetingDate, 
                 MeetingEndDate, 
                 MeetingStartTime, 
                 MeetingEndTime, 
                 MeetingLocationID, 
                 MeetingLocation, 
                 LastMeetingID, 
                 isRecurring, 
                 RecuringFrequency, 
                 UsersCanNotEdit, 
                 UserCanNotRead, 
                 MeetingType, 
                 MeetingComments, 
                 MeetingRoom, 
                 AlertComments, 
                 Duration, 
                 Address, 
                 ZipCode, 
                 CityID, 
                 CountryID, 
                 parentmeetingid, 
                 AlertIntervalID, 
                 stateid, 
                 PhNumber
                )
                VALUES
                (@MeetingName, 
                 @isPrivate, 
                 @MeetingDesc, 
                 @MeetingDate, 
                 @MeetingEndDate, 
                 @MeetingStartTime, 
                 @MeetingEndTime, 
                 @MeetingLocationID, 
                 @MeetingLocation, 
                 @LastMeetingID, 
                 @isRecurring, 
                 @RecuringFrequency, 
                 @UsersCanNotEdit, 
                 @UserCanNotRead, 
                 @MeetingType,
                 CASE
                     WHEN @ParentMeetingID IS NOT NULL
                     THEN NULL
                     ELSE @MeetingComments
                 END, 
                 @MeetingRoom, 
                 @AlertComments, 
                 @Duration, 
                 @Address, 
                 @ZipCode, 
                 @CityID, 
                 @CountryID, 
                 @ParentMeetingID, 
                 @alertIntervalID, 
                 @stateID, 
                 @PhNumber
                );
                SET @MeetingID =
                (
                    SELECT SCOPE_IDENTITY()
                );
        END;
            ELSE
            BEGIN
                UPDATE [dbo].[tbl_Meetings]
                  SET                        
                -- MeetingName = ISNULL(@MeetingName,MeetingName)                  
                --,MeetingDesc = ISNULL(@MeetingDesc,MeetingDesc)                  
                --,isPrivate = ISNULL(@isPrivate,isPrivate)                  
                --,MeetingDate = ISNULL(@MeetingDate,MeetingDate)                  
                --,MeetingEndDate = ISNULL(@MeetingEndDate,MeetingEndDate)                  
                --,MeetingStartTime = ISNULL(@MeetingStartTime,MeetingStartTime)                  
                --,MeetingEndTime = ISNULL(@MeetingEndTime,MeetingEndTime)                  
                --,MeetingLocationID = ISNULL(@MeetingLocationID,MeetingLocationID)                  
                --,MeetingLocation = ISNULL(@MeetingLocation,MeetingLocation)                  
                --,LastMeetingID = ISNULL(@LastMeetingID,LastMeetingID)                  
                --,isRecurring = ISNULL(@isRecurring,isRecurring)                  
                --,RecuringFrequency = ISNULL(@RecuringFrequency,RecuringFrequency)                  
                --,UsersCanNotEdit = ISNULL(@UsersCanNotEdit,UsersCanNotEdit)                  
                --,UserCanNotRead = ISNULL(@UserCanNotRead,UserCanNotRead)                  
                --,MeetingType = ISNULL(@MeetingType,MeetingType)                  
                --,MeetingComments = ISNULL(@MeetingComments,MeetingComments)                  
                --,MeetingRoom = ISNULL(@MeetingRoom,MeetingRoom)                  
                --,AlertComments = ISNULL(@AlertComments,AlertComments)                  
                --,Duration = ISNULL(@Duration,Duration)                  
                --,[Address] = ISNULL(@Address,[Address])                  
                --,ZipCode = ISNULL(@ZipCode,ZipCode)                  
                --,CityID = ISNULL(@CityID,CityID)                  
                --,CountryID = ISNULL(@CountryID,CountryID)              
                --,AlertIntervalID = ISNULL(@alertIntervalID,AlertIntervalID)                  

                      MeetingName = @MeetingName, 
                      MeetingDesc = @MeetingDesc, 
                      isPrivate = @isPrivate, 
                      MeetingDate = @MeetingDate, 
                      MeetingEndDate = @MeetingEndDate, 
                      MeetingStartTime = @MeetingStartTime, 
                      MeetingEndTime = @MeetingEndTime, 
                      MeetingLocationID = @MeetingLocationID, 
                      MeetingLocation = @MeetingLocation, 
                      LastMeetingID = @LastMeetingID, 
                      isRecurring = @isRecurring, 
                      RecuringFrequency = @RecuringFrequency, 
                      UsersCanNotEdit = @UsersCanNotEdit, 
                      UserCanNotRead = @UserCanNotRead, 
                      MeetingType = @MeetingType, 
                      MeetingComments = @MeetingComments, 
                      MeetingRoom = @MeetingRoom, 
                      AlertComments = @AlertComments, 
                      Duration = @Duration, 
                      [Address] = @Address, 
                      ZipCode = @ZipCode, 
                      CityID = @CityID, 
                      CountryID = @CountryID, 
                      AlertIntervalID = @alertIntervalID, 
                      stateid = @stateid, 
                      PhNumber = @PhNumber
                WHERE MeetingID = @MeetingID;
        END;
        SELECT 'Success' AS Success, 
               @MeetingID AS MeetingID;
    END;
