CREATE PROCEDURE [dbo].[proc_GET_Country] @CountryID INT = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_Country
        WHERE CountryID = ISNULL(@CountryID, CountryID)
              AND Active = 1;
    END;
