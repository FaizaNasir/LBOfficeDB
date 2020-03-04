CREATE PROCEDURE [dbo].[proc_LimitedPartner_GET]       --79

@TargetFundID INT = NULL
AS
    BEGIN
        SELECT S.LimitedPartnerID, 
               S.ModuleID, 
               S.ObjectID, 
               S.VehicleID AS TargetFundID,
               CASE
                   WHEN ModuleID = 4
                   THEN
        (
            SELECT TOP 1 CI.IndividualFullName
            FROM [tbl_ContactIndividual] CI
            WHERE CI.IndividualID = S.ObjectID
        )
               END AS 'Individual Name',
               CASE
                   WHEN ModuleID = 5
                   THEN
        (
            SELECT TOP 1 CC.CompanyName
            FROM [tbl_CompanyContact] CC
            WHERE CC.CompanyContactID = S.ObjectID
        )
               END AS 'Company Name', 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy
        FROM tbl_LimitedPartner S
        WHERE S.VehicleID = ISNULL(@TargetFundID, S.VehicleID);
    END;
