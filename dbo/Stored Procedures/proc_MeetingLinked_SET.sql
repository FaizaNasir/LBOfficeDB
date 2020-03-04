CREATE PROCEDURE [dbo].[proc_MeetingLinked_SET]
(@MeetingID INT, 
 @ModuleID  INT, 
 @ObjectID  INT, 
 @IsMCUser  BIT
)
AS
     INSERT INTO [dbo].[tbl_MeetingLinkedTo]
     (MeetingID, 
      ModuleID, 
      ObjectID, 
      ismcuser
     )
     VALUES
     (@MeetingID, 
      @ModuleID, 
      @ObjectID, 
      @IsMCUser
     );
     SET @MeetingID =
     (
         SELECT SCOPE_IDENTITY()
     );
     SELECT 'Success' AS Success, 
            @MeetingID AS MeetingID;
