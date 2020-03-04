CREATE PROCEDURE [dbo].[proc_GET_IndividualID] @individualfullname VARCHAR(100) = NULL
AS
    BEGIN
        SELECT individualID
        FROM [tbl_ContactIndividual]
        WHERE individualfullname = ISNULL(@individualfullname, individualfullname);
    END;
