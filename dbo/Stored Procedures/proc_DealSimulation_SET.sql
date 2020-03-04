CREATE PROCEDURE [dbo].[proc_DealSimulation_SET]
(@DealID        INT, 
 @TransectionID INT
)
AS
     DECLARE @DealSimulationID INT= NULL;
    BEGIN
        DELETE FROM tbl_DealSimulation
        WHERE DealID = @DealID
              AND TransectionTypeID = @TransectionID;
        INSERT INTO tbl_DealSimulation
        (DealID, 
         TransectionTypeID
        )
        VALUES
        (@DealID, 
         @TransectionID
        );
        SET @DealSimulationID = SCOPE_IDENTITY();
        SELECT 'SUCESS' AS RESULT, 
               @DealSimulationID 'DealSimulationID';
    END;
