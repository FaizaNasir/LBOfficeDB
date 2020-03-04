CREATE PROC [dbo].[proc_Individul_Type_Set]
(@individualID            INT, 
 @ContactIndividualTypeID INT
)
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_ContactIndividualContactTypes
            WHERE contactindividualid = @individualID
                  AND ContactIndividualTypeID = @ContactIndividualTypeID
        )
            INSERT INTO tbl_ContactIndividualContactTypes
            (ContactIndividualID, 
             ContactIndividualTypeID, 
             Active, 
             CreateDateTime
            )
                   SELECT @individualID, 
                          @ContactIndividualTypeID, 
                          1, 
                          GETDATE();
        SELECT 1;
    END;
