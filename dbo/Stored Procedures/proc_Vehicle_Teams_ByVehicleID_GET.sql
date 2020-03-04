CREATE PROCEDURE [dbo].[proc_Vehicle_Teams_ByVehicleID_GET] --1,'Executive Team',''
@VehicleID INT          = NULL,
--,@VehicleTeamType varchar(100)=NULL 
@RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleTeamID, 
               VehicleID, 
               CompanyID, 
               ContactID, 
               VehicleTeamType, 
               Position, 
               ISNULL([IsonInvestmentCommittee], 0) IsonInvestmentCommittee, 
               JoinedOn, 
               LeftOn, 
               Comments, 
               Department, 
               VT.Active, 
               CreatedDateTime, 
               CreatedBy, 
               ModifiedDateTime, 
               ModifiedBy, 
               C.CompanyName, 
               CI.IndividualFullName, 
               CI.IndividualFirstName, 
               CI.IndividualLastName
        FROM [tbl_VehicleTeam] AS VT
             LEFT OUTER JOIN tbl_CompanyContact AS C ON VT.CompanyID = C.CompanyContactID
             LEFT OUTER JOIN tbl_ContactIndividual AS CI ON CI.IndividualID = VT.ContactID
        WHERE  
        --VT.VehicleTeamType = ISNULL(@VehicleTeamType,VT.VehicleTeamType) and 
        VT.VehicleID = ISNULL(@VehicleID, VT.VehicleID);
    END;
