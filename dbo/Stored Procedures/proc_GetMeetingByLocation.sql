
-- created by	:	Syed Zain ALi
-- proc_GetMeetingByLocation    

CREATE PROC [dbo].[proc_GetMeetingByLocation](@location VARCHAR(1000))
AS
     SELECT DISTINCT 
            [Address], 
     (
         SELECT CityName
         FROM tbl_City
         WHERE m.CityID = tbl_City.CityID
     ) CityName, 
            ZipCode, 
            MeetingLocation, 
            m.CountryID, 
     (
         SELECT CountryName
         FROM dbo.tbl_Country c
         WHERE c.CountryID = m.CountryID
     ) CountryName, 
            StateID, 
            PhNumber
     FROM tbl_meetings m
     WHERE m.MeetingLocation LIKE '%' + @location + '%';
