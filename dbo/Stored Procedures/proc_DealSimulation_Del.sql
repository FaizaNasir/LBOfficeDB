CREATE PROCEDURE [dbo].[proc_DealSimulation_Del](@DealSimulationID INT)
AS
    BEGIN
        DELETE FROM tbl_DealSimulation
        WHERE DealSimulationID = @DealSimulationID;
        SELECT 1 AS RESULT;
    END;
