--tbl_VehivleCash  

CREATE PROCEDURE [dbo].[proc_vehicle_Cash_SET] @VehicleCashID    INT            = NULL, 
                                               @VehicleID        INT            = NULL, 
                                               @Amount           DECIMAL(18, 2)  = NULL, 
                                               @Currency         VARCHAR(50)    = NULL, 
                                               @Date             DATE           = NULL, 
                                               @CreatedDateTime  DATETIME       = NULL, 
                                               @ModifiedDateTime DATETIME       = NULL, 
                                               @CreatedBy        VARCHAR(100)   = NULL, 
                                               @ModifiedBy       VARCHAR(100)   = NULL, 
                                               @Active           BIT            = NULL
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM tbl_VehicleCash
            WHERE VehicleCashID = @VehicleCashID
        )
            BEGIN
                INSERT INTO tbl_VehicleCash
                (VehicleID, 
                 Amount, 
                 Currency, 
                 Date, 
                 CreatedDateTime, 
                 ModifiedDateTime, 
                 CreatedBy, 
                 ModifiedBy, 
                 Active
                )
                VALUES
                (@VehicleID, 
                 @Amount, 
                 @Currency, 
                 @Date, 
                 @CreatedDateTime, 
                 @ModifiedDateTime, 
                 @CreatedBy, 
                 @ModifiedBy, 
                 @Active
                );
        END;
            ELSE
            BEGIN
                UPDATE tbl_VehicleCash
                  SET 
                      VehicleID = @VehicleID, 
                      Amount = @Amount, 
                      Currency = @Currency, 
                      Date = @Date, 
                      CreatedDateTime = @CreatedDateTime, 
                      ModifiedDateTime = @ModifiedDateTime, 
                      CreatedBy = @CreatedBy, 
                      ModifiedBy = @ModifiedBy, 
                      Active = @Active
                WHERE VehicleCashID = @VehicleCashID;
        END;
        SET @VehicleCashID = @@IDENTITY;
        SELECT 'Success' AS Result, 
               @VehicleCashID AS 'Vehicle Cash ID';
    END;
