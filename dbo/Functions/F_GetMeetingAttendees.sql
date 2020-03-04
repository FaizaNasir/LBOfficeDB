CREATE FUNCTION [dbo].[F_GetMeetingAttendees]
(@MeetingID INT, 
 @moduleID  INT, 
 @isMCUser  BIT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @MeetingAttendees VARCHAR(MAX);
         SET @MeetingAttendees = '';
         SELECT @MeetingAttendees = @MeetingAttendees + CASE
                                                            WHEN ModuleID = 4
                                                            THEN
         (
             SELECT IndividualFullName
             FROM tbl_contactindividual i
             WHERE i.individualid = ObjectID
         )
                                                            WHEN ModuleID = 5
                                                            THEN
         (
             SELECT companyname
             FROM tbl_companycontact c
             WHERE c.CompanyContactID = ObjectID
         )
                                                            WHEN moduleid = 6
                                                            THEN
         (
             SELECT dealname
             FROM tbl_deals
             WHERE dealID = objectid
         )
                                                        END + ', '
         FROM tbl_MeetingLinkedTo
         WHERE MeetingID = ISNULL(@MeetingID, MeetingID)
               AND ModuleID = ISNULL(@ModuleID, ModuleID)
               AND isMCUser = ISNULL(@isMCUser, isMCUser);
         IF @MeetingAttendees <> ''
             SET @MeetingAttendees =
             (
                 SELECT SUBSTRING(@MeetingAttendees, 0, LEN(@MeetingAttendees))
             );
         RETURN @MeetingAttendees;
     END;
