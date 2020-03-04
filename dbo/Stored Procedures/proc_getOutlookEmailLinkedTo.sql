
-- proc_getOutlookEmailLinkedTo 1,1385,4,1    

CREATE PROC [dbo].[proc_getOutlookEmailLinkedTo]
(@emailID  INT, 
 @objectID INT, 
 @moduleID INT, 
 @isTo     BIT
)
AS
    BEGIN
        DECLARE @tbl TABLE
        (ObjectID   INT, 
         ObjectName VARCHAR(1000)
        );
        IF @moduleID = 4
            INSERT INTO @tbl
                   SELECT IndividualID, 
                          individualFullName
                   FROM tbl_OutlookEmailLinkedTo et
                        JOIN tbl_ContactIndividual c ON c.IndividualID = et.ObjectID
                   WHERE et.ObjectID = ISNULL(@objectID, et.ObjectID)
                         AND et.ModuleID = @moduleID
                         AND et.EmailID = @emailID
                         AND et.IsEmailTo = @isTo;
        SELECT *
        FROM @tbl;
    END;
