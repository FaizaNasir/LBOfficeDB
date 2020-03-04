CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_Country_GET] @VehicleID INT          = NULL, 
                                                           @RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT VehicleStrategyCountryID, 
               tbl_VehicleStrategyCountry.CountryID, 
               'Type' = CASE IsInclude
                            WHEN '1'
                            THEN 'Include'
                            WHEN '0'
                            THEN 'Exclude'
                        END, 
               Percentage, 
               IsInclude, 
               VehicleID, 
               CreatedBy, 
               ModifiedBy, 
               tbl_VehicleStrategyCountry.CreatedDateTime, 
               tbl_VehicleStrategyCountry.ModifiedDateTime, 
               tbl_Country.CountryName, 
               tbl_VehicleStrategyCountry.Active
        FROM tbl_VehicleStrategyCountry
             LEFT OUTER JOIN tbl_Country ON tbl_VehicleStrategyCountry.CountryID = tbl_Country.CountryID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
