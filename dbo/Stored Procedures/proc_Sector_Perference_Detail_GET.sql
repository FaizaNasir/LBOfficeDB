CREATE PROCEDURE [dbo].[proc_Sector_Perference_Detail_GET] @AppetiteSectorPerferenceID INT = NULL
AS
    BEGIN
        SELECT [SectorPerferenceDetailID], 
               [SectorPerferenceID], 
               [AppetiteSectorPerferenceID]
        FROM tbl_SectorPerferenceDetails
        WHERE AppetiteSectorPerferenceID = ISNULL(@AppetiteSectorPerferenceID, AppetiteSectorPerferenceID);
    END;
