CREATE PROCEDURE [dbo].[proc_CompanyContactTypes_SET] @CompanyID           INT, 
                                                      @CompanyContactTypes VARCHAR(1000)
AS
    BEGIN
        DELETE FROM tbl_CompanyContactType
        WHERE CompanyContactID = @CompanyID;
        INSERT INTO tbl_CompanyContactType
        (CompanyContactID, 
         ContactTypeID
        )
               SELECT @CompanyID, 
                      items
               FROM SplitCSV(@CompanyContactTypes, ',');
    END;  
