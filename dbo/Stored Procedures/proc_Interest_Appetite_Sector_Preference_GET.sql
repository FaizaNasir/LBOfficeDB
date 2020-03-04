CREATE PROCEDURE [dbo].[proc_Interest_Appetite_Sector_Preference_GET] @ObjectID  INT = NULL, 
                                                                      @IsCompany BIT = NULL
AS
    BEGIN
        SELECT [InterestAppetiteSectorPreferenceID], 
               [Percentage], 
               [Username], 
               [DateTime], 
               [ObjectID], 
               [IsCompany]
        FROM tbl_InterestAppetiteSectorPreference
        WHERE ObjectID = ISNULL(@ObjectID, ObjectID)
              AND IsCompany = ISNULL(@IsCompany, IsCompany);
    END;
