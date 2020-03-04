CREATE PROC [dbo].[GetVehicleNavDetail](@vehicleNavID INT = NULL)
AS
    BEGIN
        SELECT S.ShareID, 
               vs.ShareName, 
        (
            SELECT SUM(amount)
            FROM tbl_capitalcall c
                 JOIN tbl_capitalcalllimitedpartner clp ON c.capitalcallid = clp.capitalcallid
            WHERE c.FundID = nv.VehicleID
                  AND clp.shareid = s.shareid
                  AND c.dueDate <= NavDate
        ) CapitalCalls, 
               CAST(S.TotalNav AS DECIMAL(18, 2)) AS TotalNav, 
               CAST(S.NavPerShare AS DECIMAL(18, 2)) AS NavPerShare, 
               CAST(S.CarriedInterest AS DECIMAL(18, 2)) AS CarriedInterest, 
               CAST(S.InitialShareValueReimbursement AS DECIMAL(18, 2)) AS InitialShareValueReimbursement, 
               CAST(S.PreferredReturn AS DECIMAL(18, 2)) AS PreferredReturn, 
               CAST(S.ACShares AS DECIMAL(18, 2)) AS ACShares, 
               CAST(S.NetSurplusPaidInCash AS DECIMAL(18, 2)) AS NetSurplusPaidInCash
        FROM tbl_VehicleNavDetails S
             JOIN tbl_vehiclenav nv ON nv.vehiclenavid = s.VehicleNavID
             JOIN tbl_vehicleshare vs ON S.ShareID = vs.VehicleShareID
        WHERE S.VehicleNavID = ISNULL(@VehicleNavID, S.VehicleNavID);
    END;
