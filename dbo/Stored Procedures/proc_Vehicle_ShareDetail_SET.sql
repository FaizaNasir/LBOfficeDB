CREATE PROCEDURE [dbo].[proc_Vehicle_ShareDetail_SET] @VehicleShareDetailID INT             = NULL, 
                                                     @VehicleID            INT             = NULL, 
                                                     @ShareID              INT             = NULL, 
                                                     @ShareDate            DATETIME        = NULL, 
                                                     @nominalValue         NUMERIC(25, 12)  = NULL, 
                                                     @CreatedDateTime      DATETIME        = NULL, 
                                                     @CreatedBy            VARCHAR(100), 
                                                     @ModifiedDateTime     DATETIME        = NULL, 
                                                     @ModifiedBy           VARCHAR(100)    = NULL, 
                                                     @Active               BIT             = NULL
AS
    BEGIN
        SET @VehicleShareDetailID =
        (
            SELECT TOP 1 VehicleShareDetailID
            FROM tbl_VehicleShareDetail
            WHERE VehicleID = @VehicleID
                  AND ShareID = @ShareID
                  AND ShareDate = @ShareDate
        );
        IF @VehicleShareDetailID IS NULL
            BEGIN
                INSERT INTO tbl_VehicleShareDetail
                (VehicleID, 
                 ShareID, 
                 ShareDate, 
                 nominalValue, 
                 CreatedDateTime, 
                 CreatedBy, 
                 ModifiedDateTime, 
                 ModifiedBy, 
                 Active
                )
                VALUES
                (@VehicleID, 
                 @ShareID, 
                 @ShareDate, 
                 @nominalValue, 
                 @CreatedDateTime, 
                 @CreatedBy, 
                 @ModifiedDateTime, 
                 @ModifiedBy, 
                 @Active
                );
        END;
            ELSE
            BEGIN
                UPDATE tbl_VehicleShareDetail
                  SET 
                      VehicleID = @VehicleID, 
                      ShareID = @ShareID, 
                      ShareDate = @ShareDate, 
                      nominalValue = @nominalValue, 
                      CreatedDateTime = @CreatedDateTime, 
                      CreatedBy = @CreatedBy, 
                      ModifiedDateTime = @ModifiedDateTime, 
                      ModifiedBy = @ModifiedBy, 
                      Active = @Active
                WHERE VehicleID = @VehicleID
                      AND VehicleShareDetailID = @VehicleShareDetailID;
        END;
        SET @VehicleShareDetailID = @@IDENTITY;
        SELECT 'Success' AS Result, 
               @VehicleShareDetailID AS 'VehicleShareDetailID';
    END;
