-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_GET_City] @CountryID INT = NULL, 
                                       @CityID    INT = NULL
AS
    BEGIN
        SELECT *
        FROM tbl_City
        WHERE CountryID = ISNULL(@CountryID, CountryID)
              AND CityID = ISNULL(@CityID, CityID);
    END;
