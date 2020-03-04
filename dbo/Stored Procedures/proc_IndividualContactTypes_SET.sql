CREATE PROCEDURE [dbo].[proc_IndividualContactTypes_SET] @IndividualID   INT           = NULL, 
                                                         @ContactTypeIDs VARCHAR(1000) = NULL
AS
    BEGIN

        --insert into tbl_Temp
        --select '@NewContactID',@IndividualID
        --insert into tbl_Temp
        --select 'contacttypes',@ContactTypeIDs

        DELETE FROM tbl_ContactIndividualContactTypes
        WHERE ContactIndividualID = @IndividualID;
        INSERT INTO tbl_ContactIndividualContactTypes
        (ContactIndividualID, 
         ContactIndividualTypeID
        )
               SELECT @IndividualID, 
                      items
               FROM SplitCSV(@ContactTypeIDs, ',');
    END;
--------------------------------
