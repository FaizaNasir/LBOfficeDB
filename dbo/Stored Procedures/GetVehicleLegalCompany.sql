CREATE PROC [dbo].[GetVehicleLegalCompany](@vehicleID INT)
AS
    BEGIN
        SELECT CompanyContactID, 
               CompanyName
        FROM tbl_vehiclelegalcompany v
             JOIN tbl_companycontact cc ON cc.companycontactid = v.companyid
        WHERE v.vehicleid = @vehicleID;
    END;
