CREATE PROC [dbo].[proc_VehicleTeam_set]
(@vehicleTeamID           INT, 
 @vehicleID               INT, 
 @companyID               INT, 
 @contactID               INT, 
 @vehicleTeamType         VARCHAR(100), 
 @isonInvestmentCommittee BIT, 
 @position                VARCHAR(100), 
 @joinedOn                DATETIME, 
 @leftOn                  DATETIME, 
 @department              VARCHAR(100), 
 @comments                VARCHAR(MAX)
)
AS
    BEGIN
        IF @vehicleTeamID IS NULL
            BEGIN
                SET @vehicleTeamID =
                (
                    SELECT TOP 1 1
                    FROM tbl_VehicleTeam
                    WHERE vehicleID = @vehicleID
                          AND ISNULL(@companyID, ISNULL(CompanyID, 0)) = ISNULL(CompanyID, 0)
                          AND ISNULL(@contactID, ISNULL(ContactID, 0)) = ISNULL(ContactID, 0)
                );
        END;
        IF @vehicleTeamID IS NOT NULL
            BEGIN
                UPDATE tbl_VehicleTeam
                  SET 
                      CompanyID = ISNULL(@companyID, CompanyID), 
                      ContactID = ISNULL(@ContactID, ContactID), 
                      VehicleTeamType = @VehicleTeamType, 
                      Position = @Position, 
                      IsonInvestmentCommittee = @IsonInvestmentCommittee, 
                      JoinedOn = @JoinedOn, 
                      LeftOn = @LeftOn, 
                      Comments = @Comments, 
                      Department = @Department, 
                      ModifiedDateTime = GETDATE()
                WHERE VehicleTeamID = @vehicleTeamID;
        END;
            ELSE
            BEGIN
                INSERT INTO tbl_VehicleTeam
                (VehicleID, 
                 CompanyID, 
                 ContactID, 
                 VehicleTeamType, 
                 Position, 
                 IsonInvestmentCommittee, 
                 JoinedOn, 
                 LeftOn, 
                 Comments, 
                 Department, 
                 Active, 
                 CreatedDateTime
                )
                       SELECT @VehicleID, 
                              @CompanyID, 
                              @ContactID, 
                              @VehicleTeamType, 
                              @Position, 
                              @IsonInvestmentCommittee, 
                              @JoinedOn, 
                              @LeftOn, 
                              @Comments, 
                              @Department, 
                              1, 
                              GETDATE();
        END;
        SELECT 1 Result;
    END;
