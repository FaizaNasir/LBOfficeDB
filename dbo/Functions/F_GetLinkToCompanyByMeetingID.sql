CREATE FUNCTION [dbo].[F_GetLinkToCompanyByMeetingID]
(@MeetingID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @compnies VARCHAR(MAX);
         SET @compnies = '';
         SELECT @compnies = @compnies + CompanyName + ', '
         FROM tbl_meetingcompanies(NOLOCK) mc
              JOIN tbl_CompanyContact(NOLOCK) cc ON mc.CompanyID = cc.CompanyContactID
         WHERE mc.MeetingID = @MeetingID;
         IF @compnies <> ''
             SET @compnies =
             (
                 SELECT SUBSTRING(@compnies, 0, LEN(@compnies))
             );
         RETURN @compnies;
     END;
