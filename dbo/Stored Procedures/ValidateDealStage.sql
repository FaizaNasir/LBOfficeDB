CREATE PROC [dbo].[ValidateDealStage]
(@dealID  INT, 
 @stageID INT
)
AS
    BEGIN
        IF @stageID = 12
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 1
                  AND [Validation] = 'Yes'
        )
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 2
                  AND [Validation] = 'Yes'
        )
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 4
                  AND [Validation] = 'Yes'
        )
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 5
                  AND [Validation] = 'Yes'
        )
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 6
                  AND [Validation] = 'Yes'
        )
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 7
                  AND [Validation] = 'Yes'
        )
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 8
                  AND [Validation] = 'Yes'
        )
           AND EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_dealstatusdetails
            WHERE Dealid = @Dealid
                  AND DealStatusID = 11
                  AND [Validation] = 'Yes'
        )
            BEGIN
                SELECT 1 Result;
        END;
            ELSE
            IF @stageID = 13
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 1
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 2
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 4
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 5
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 6
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 7
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 8
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 11
                      AND [Validation] = 'Yes'
            )
               AND EXISTS
            (
                SELECT TOP 1 1
                FROM tbl_dealstatusdetails
                WHERE Dealid = @Dealid
                      AND DealStatusID = 12
                      AND [Validation] = 'Yes'
            )
                BEGIN
                    SELECT 1 Result;
            END;
                ELSE
                IF @stageID NOT IN(12, 13)
                    SELECT 1 Result;
    END;
