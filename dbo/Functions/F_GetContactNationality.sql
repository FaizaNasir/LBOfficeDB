CREATE FUNCTION [dbo].[F_GetContactNationality]
(@id INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' / ', '') + c.CountryName
         FROM tbl_Country c
              JOIN tbl_Nationality n ON c.CountryID = n.CountryID
         WHERE IndividualID = @id;
         RETURN @VouvherNo;
     END;
