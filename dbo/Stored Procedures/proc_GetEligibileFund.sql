CREATE PROCEDURE [dbo].[proc_GetEligibileFund]
(@dealID    INT, 
 @vehicleID INT
)
AS
    BEGIN
        SELECT dbo.[f_GetEligibileFund](@dealID, @vehicleID) Result;
    END;
