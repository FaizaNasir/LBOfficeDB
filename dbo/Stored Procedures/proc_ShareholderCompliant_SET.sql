﻿CREATE PROCEDURE [dbo].[proc_ShareholderCompliant_SET] @CompliantID   INT, 
                                                       @ShareholderID INT, 
                                                       @Compliant1    INT, 
                                                       @Compliant2    INT, 
                                                       @Compliant3    INT, 
                                                       @Compliant4    INT, 
                                                       @Compliant5    INT, 
                                                       @Compliant6    INT, 
                                                       @Compliant7    INT, 
                                                       @Compliant8    INT, 
                                                       @Compliant9    INT, 
                                                       @Compliant10   INT, 
                                                       @Compliant11   INT, 
                                                       @Compliant12   INT, 
                                                       @Compliant13   INT, 
                                                       @Compliant14   INT, 
                                                       @Compliant15   INT, 
                                                       @Compliant16   INT, 
                                                       @Compliant17   INT, 
                                                       @Compliant18   INT, 
                                                       @Compliant19   INT, 
                                                       @Compliant20   INT, 
                                                       @Compliant21   INT, 
                                                       @Compliant22   INT, 
                                                       @Compliant23   INT, 
                                                       @Compliant24   INT, 
                                                       @Compliant25   INT, 
                                                       @CreatedBy     VARCHAR(100)
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_ShareholderCompliant
            WHERE ShareholderID = @ShareholderID
        )
            INSERT INTO tbl_ShareholderCompliant
            (ShareholderID, 
             Compliant1, 
             Compliant2, 
             Compliant3, 
             Compliant4, 
             Compliant5, 
             Compliant6, 
             Compliant7, 
             Compliant8, 
             Compliant9, 
             Compliant10, 
             Compliant11, 
             Compliant12, 
             Compliant13, 
             Compliant14, 
             Compliant15, 
             Compliant16, 
             Compliant17, 
             Compliant18, 
             Compliant19, 
             Compliant20, 
             Compliant21, 
             Compliant22, 
             Compliant23, 
             Compliant24, 
             Compliant25, 
             Active, 
             modifieddatetime, 
             CreatedBy
            )
                   SELECT @ShareholderID, 
                          @Compliant1, 
                          @Compliant2, 
                          @Compliant3, 
                          @Compliant4, 
                          @Compliant5, 
                          @Compliant6, 
                          @Compliant7, 
                          @Compliant8, 
                          @Compliant9, 
                          @Compliant10, 
                          @Compliant11, 
                          @Compliant12, 
                          @Compliant13, 
                          @Compliant14, 
                          @Compliant15, 
                          @Compliant16, 
                          @Compliant17, 
                          @Compliant18, 
                          @Compliant19, 
                          @Compliant20, 
                          @Compliant21, 
                          @Compliant22, 
                          @Compliant23, 
                          @Compliant24, 
                          @Compliant25, 
                          1, 
                          GETDATE(), 
                          @CreatedBy;
            ELSE
            UPDATE tbl_ShareholderCompliant
              SET 
                  Compliant1 = @Compliant1, 
                  Compliant2 = @Compliant2, 
                  Compliant3 = @Compliant3, 
                  Compliant4 = @Compliant4, 
                  Compliant5 = @Compliant5, 
                  Compliant6 = @Compliant6, 
                  Compliant7 = @Compliant7, 
                  Compliant8 = @Compliant8, 
                  Compliant9 = @Compliant9, 
                  Compliant10 = @Compliant10, 
                  Compliant11 = @Compliant11, 
                  Compliant12 = @Compliant12, 
                  Compliant13 = @Compliant13, 
                  Compliant14 = @Compliant14, 
                  Compliant15 = @Compliant15, 
                  Compliant16 = @Compliant16, 
                  Compliant17 = @Compliant17, 
                  Compliant18 = @Compliant18, 
                  Compliant19 = @Compliant19, 
                  Compliant20 = @Compliant20, 
                  Compliant21 = @Compliant21, 
                  Compliant22 = @Compliant22, 
                  Compliant23 = @Compliant23, 
                  Compliant24 = @Compliant24, 
                  Compliant25 = @Compliant25, 
                  createdby = @CreatedBy, 
                  modifieddatetime = GETDATE()
            WHERE ShareholderID = @ShareholderID;
        SELECT 1 Result;
    END;
