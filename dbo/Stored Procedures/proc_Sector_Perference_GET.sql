CREATE PROCEDURE [dbo].[proc_Sector_Perference_GET] @SectorPerferenceID INT = NULL
AS
    BEGIN
        SELECT [SectorPerferenceID], 
               [SectorPerferenceDesc]
        FROM tbl_SectorPerference
        WHERE SectorPerferenceID = ISNULL(@SectorPerferenceID, SectorPerferenceID);
    END;
