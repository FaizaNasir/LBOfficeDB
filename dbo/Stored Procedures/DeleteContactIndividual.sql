CREATE PROC [dbo].[DeleteContactIndividual](@individualID INT)
AS
    BEGIN
        DELETE FROM tbl_CompanyIndividuals
        WHERE ContactIndividualID = @individualID;
        DELETE FROM tbl_ContactIndividualContactTypes
        WHERE ContactIndividualID = @individualID;
        DELETE FROM tbl_ContactIndividualRM
        WHERE IndividualId = @individualID;
        DELETE FROM tbl_IndividualContactExternalAdvisors
        WHERE IndividualID = @individualID;
        DELETE FROM tbl_IndividualComments
        WHERE IndividualID = @individualID;
        DELETE FROM tbl_MeetingLinkedTo
        WHERE ObjectID = @individualID
              AND moduleID = 4;
        DELETE FROM tbl_TaskLinked
        WHERE ObjectID = @individualID
              AND moduleID = 4;
        DELETE FROM tbl_PortfolioShareholdingOperations
        WHERE((FromID = @individualID
               AND FromTypeID = 4)
              OR (ToID = @individualID
                  AND ToTypeID = 4));
        DELETE FROM tbl_PortfolioGeneralOperation
        WHERE((FromID = @individualID
               AND FromModuleID = 4)
              OR (ToID = @individualID
                  AND ToModuleID = 4));
        DELETE FROM tbl_Shareholders
        WHERE ModuleID = 4
              AND ObjectID = @individualID;
        DELETE FROM tbl_ContactIndividual
        WHERE IndividualID = @individualID;
        SELECT 1 Result, 
               '' Msg;
    END;
