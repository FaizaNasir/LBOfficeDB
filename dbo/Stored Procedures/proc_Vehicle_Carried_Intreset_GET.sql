CREATE PROCEDURE [dbo].[proc_Vehicle_Carried_Intreset_GET] @CarriedIntresetID INT          = NULL, 
                                                           @VehicleID         INT          = NULL, 
                                                           @RoleName          VARCHAR(100) = NULL
AS
    BEGIN
        SELECT CarriedIntresetID, 
               fci.VehicleID, 
               IsIRR, 
               BetweenStartPercent, 
               BetweenEndPercent, 
               CarriedIntresetPercent, 
               IsAndOr, 
               IsFundBasedCarriedIntreset, 
               NotesCarriedInterest, 
               fci.CreatedDateTime, 
               fci.CreatedBy, 
               fci.ModifiedDateTime, 
               fci.ModifiedBy
        FROM tbl_VehicleCarriedIntreset fci
             LEFT OUTER JOIN tbl_VehicleManagement fgf ON fgf.Vehicleid = fci.Vehicleid
        WHERE fci.VehicleID = @VehicleID
              AND CarriedIntresetID = ISNULL(@CarriedIntresetID, CarriedIntresetID);
    END;
