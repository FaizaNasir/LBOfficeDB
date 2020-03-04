CREATE PROCEDURE [dbo].[proc_Region_GET] @CountryID INT
AS
    BEGIN
        SELECT [RegionID], 
               [RegionName], 
               [CountryID], 
               [Active], 
               [CreatedDateTime], 
               [ModifiedDateTime], 
               [CreatedBy], 
               [ModifiedBy]
        FROM [tbl_Region]
        WHERE Active = 1;
    END;
