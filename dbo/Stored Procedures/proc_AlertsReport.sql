CREATE PROC [dbo].[proc_AlertsReport]
AS
    BEGIN
        SELECT v.Name, 
               ve.EligibilityRatio50Date AS 'Important date', 
               'Date limite datteinte des 50% du ratio eligible' AS Description
        FROM tbl_VehicleEligibility ve
             INNER JOIN tbl_vehicle v ON ve.vehicleid = v.vehicleid
        WHERE ve.EligibilityRatio50Date > DATEADD(month, 2, GETDATE())
        UNION ALL
        SELECT v.Name, 
               ve.EligibilityRatio0Date AS 'Important date', 
               'Date limite datteinte des 100% du ratio eligible' AS Description
        FROM tbl_VehicleEligibility ve
             INNER JOIN tbl_vehicle v ON ve.vehicleid = v.vehicleid
        WHERE ve.EligibilityRatio0Date > DATEADD(month, 2, GETDATE())
        UNION ALL
        SELECT v.Name, 
               ve.ConstitutionDate AS 'Important date', 
               'Date of fund constitution' AS Description
        FROM tbl_VehicleEligibility ve
             INNER JOIN tbl_vehicle v ON ve.vehicleid = v.vehicleid;
    END;
