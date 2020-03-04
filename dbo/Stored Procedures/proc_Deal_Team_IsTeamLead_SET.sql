CREATE PROCEDURE [dbo].[proc_Deal_Team_IsTeamLead_SET] --1,518,true  
@DealID       INT = NULL, 
@IndividualID INT = NULL, 
@IsTeamLead   BIT = NULL
AS
    BEGIN
        UPDATE [dbo].[tbl_DealTeam]
          SET 
              IsTeamLead = 0
        WHERE DealID = ISNULL(@DealID, DealID);
        IF(@IsTeamLead = 1)
            BEGIN
                UPDATE [dbo].[tbl_DealTeam]
                  SET 
                      IsTeamLead = @IsTeamLead
                WHERE DealID = @DealID
                      AND IndividualID = @IndividualID;
        END;
        SELECT 1 Result;
    END;  
