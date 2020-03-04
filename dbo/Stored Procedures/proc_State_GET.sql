CREATE PROCEDURE [dbo].[proc_State_GET] @CountryID INT = NULL
AS
    BEGIN
        SELECT [StateID], 
               [StateTitle], 
               [StateDesc], 
               [Active], 
               [CreateDateTime], 
               [CountryID]
        FROM tbl_State
        WHERE CountryID = ISNULL(@CountryID, CountryID);
    END;
