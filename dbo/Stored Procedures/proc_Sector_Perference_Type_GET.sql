CREATE PROCEDURE [dbo].[proc_Sector_Perference_Type_GET] @SectorPerferenceTypeID INT = NULL
AS
    BEGIN
        SELECT [SectorPerferenceTypeID], 
               [SectorPerferenceTypeDesc]
        FROM tbl_SectorPerferenceType
        WHERE SectorPerferenceTypeID = ISNULL(@SectorPerferenceTypeID, SectorPerferenceTypeID);
    END;
