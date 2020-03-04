CREATE PROC [dbo].[GetLPEmailConfigDetail](@LPEmailConfigDetailID INT)
AS
    BEGIN
        SELECT LPEmailConfigDetailID, 
               LPEmailConfigID, 
               ContactID, 
               IndividualFullName, 
               IndividualEmail, 
               IsCC, 
               config.Active, 
               config.CreatedDate, 
               ModifiedDate, 
               config.CreatedBy, 
               config.ModifiedBy
        FROM tbl_LPEmailConfigDetail config
             JOIN tbl_ContactIndividual i ON i.individualID = config.contactID
        WHERE LPEmailConfigID = @LPEmailConfigDetailID;
    END;
