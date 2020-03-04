
--  select dbo.[F_Diluted](1,3,'31 Dec, 2011')      

CREATE FUNCTION [dbo].[F_GetVehicleLegalCompany]
(@id INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @ConcatString VARCHAR(MAX);
         SELECT @ConcatString = COALESCE(@ConcatString + ', ', '') + companyname
         FROM tbl_vehiclelegalcompany v
              JOIN tbl_companycontact cc ON cc.companycontactid = v.companyid
         WHERE v.vehicleid = @id;
         RETURN
         (
             SELECT @ConcatString
         );
     END;
