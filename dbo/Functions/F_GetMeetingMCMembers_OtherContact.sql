CREATE FUNCTION [dbo].[F_GetMeetingMCMembers_OtherContact]
(@MeetingID INT, 
 @ModuleID  INT, 
 @ObjectID  INT, 
 @IsMCUser  BIT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' / ', '') + ci.IndividualFullName
         FROM tbl_MeetingLinkedTo mlt
              JOIN tbl_ContactIndividual ci ON mlt.ObjectID = ci.IndividualID
         WHERE mlt.MeetingID = ISNULL(@MeetingID, mlt.MeetingID)
               AND mlt.ModuleID = ISNULL(@ModuleID, mlt.ModuleID)
               AND mlt.isMCUser = ISNULL(@isMCUser, mlt.isMCUser)
               AND mlt.ObjectID = ISNULL(@ObjectID, mlt.ObjectID);
         RETURN @VouvherNo;
     END;
