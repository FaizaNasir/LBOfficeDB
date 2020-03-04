CREATE PROCEDURE [dbo].[proc_IndividualCommentsByIndividualId_GET] @IndividualID INT = NULL
AS
    BEGIN
        SELECT l.[Id], 
               l.[Comments], 
               l.[CreatedTime], 
               w.IndividualFullName, 
               l.[IndividualID]
        FROM tbl_IndividualComments l
             JOIN tbl_ContactIndividual w ON l.[CreatedBy] = w.IndividualID
        WHERE l.IndividualID = @IndividualID
        ORDER BY l.[CreatedTime] DESC;
    END;
