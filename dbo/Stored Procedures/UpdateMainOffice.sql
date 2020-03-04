CREATE PROC [dbo].[UpdateMainOffice]
(@OfficeID         INT, 
 @CompanyContactID INT
)
AS
    BEGIN
        UPDATE tbl_CompanyOffice
          SET 
              ismain = 0
        WHERE CompanyContactID = @CompanyContactID;
        UPDATE tbl_CompanyOffice
          SET 
              ismain = 1
        WHERE OfficeID = @OfficeID;
        SELECT 1 Result;
    END;
