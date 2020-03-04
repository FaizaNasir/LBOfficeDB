
-- created by : Syed Zain Ali  

CREATE PROC [dbo].[proc_get_all_link_to_companies_meeting]
AS
     SELECT DISTINCT 
            ci.CompanyContactID, 
            ci.CompanyName
     FROM tbl_MeetingLinkedTo mc
          JOIN tbl_CompanyContact ci ON mc.objectid = ci.CompanyContactID
                                        AND mc.moduleid = 5
     ORDER BY ci.CompanyName;
