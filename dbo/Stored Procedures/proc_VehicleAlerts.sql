
-- [proc_VehicleAlerts] 

CREATE PROC [dbo].[proc_VehicleAlerts]
AS
    BEGIN
        SELECT *
        FROM
        (
            SELECT v.Name, 
                   ve.EligibilityRatio50Date AS 'Important date', 
                   'Date de rapprochement d’atteinte du ratio 50%' AS Description
            FROM tbl_VehicleEligibility ve
                 INNER JOIN tbl_vehicle v ON ve.vehicleid = v.vehicleid
            WHERE ve.EligibilityRatio50Date > DATEADD(month, 2, GETDATE())

            --year(ve.EligibilityRatio50Date) 
            --= year(DATEADD(month, 2, GETDATE()))
            --and month(ve.EligibilityRatio50Date) = month(DATEADD(month, 2, GETDATE()))
            --and day(ve.EligibilityRatio50Date) = day(DATEADD(month, 2, GETDATE()))

            UNION ALL
            SELECT v.Name, 
                   ve.EligibilityRatio0Date AS 'Important date', 
                   'Date de rapprochement d’atteinte du ratio 100%' AS Description
            FROM tbl_VehicleEligibility ve
                 INNER JOIN tbl_vehicle v ON ve.vehicleid = v.vehicleid
            WHERE ve.EligibilityRatio0Date > DATEADD(month, 2, GETDATE())

            --year(ve.EligibilityRatio0Date)
            --= year(DATEADD(month, 2, GETDATE()))
            --and month(ve.EligibilityRatio0Date) = month(DATEADD(month, 2, GETDATE()))
            --and day(ve.EligibilityRatio0Date) = day(DATEADD(month, 2, GETDATE()))

        ) alert
        ORDER BY 'Important date';
    END;
