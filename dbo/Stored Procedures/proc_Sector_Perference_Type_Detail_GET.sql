CREATE PROCEDURE [dbo].[proc_Sector_Perference_Type_Detail_GET] @AppetiteSectorPerferenceTypeID INT = NULL
AS
    BEGIN
        SELECT [SectorPerferenceTypeDetailID], 
               [SectorPerferenceTypeID], 
               [AppetiteSectorPerferenceTypeID]
        FROM tbl_SectorPerferenceTypeDetail
        WHERE AppetiteSectorPerferenceTypeID = ISNULL(@AppetiteSectorPerferenceTypeID, AppetiteSectorPerferenceTypeID);
    END;
