
-- created by : syed zain ali     

CREATE PROCEDURE [dbo].[proc_MeetingLinked_GET]
(@MeetingID INT, 
 @ModuleID  INT, 
 @ObjectID  INT, 
 @IsMCUser  BIT
)
AS
     SELECT MeetingLinkedToID, 
            MeetingID, 
            ModuleID, 
            ObjectID,
            CASE
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
            END ObjectName, 
            ismcuser
     FROM tbl_MeetingLinkedTo
     WHERE MeetingID = ISNULL(@MeetingID, MeetingID)
           AND ModuleID = ISNULL(@ModuleID, ModuleID)
           AND isMCUser = ISNULL(@isMCUser, isMCUser)
           AND ObjectID = ISNULL(@ObjectID, ObjectID);
