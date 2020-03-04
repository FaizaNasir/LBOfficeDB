
-- [proc_CalculateCapitalCallLimitedPartner_Get] 78,3,5000.00,'2017-01-21 00:00:00.000'

CREATE PROCEDURE [dbo].[proc_CalculateDistributionLimitedPartner_Get] @VehicleID INT, 
                                                                      @ShareID   INT, 
                                                                      @Amount    DECIMAL(18, 2), 
                                                                      @date      DATETIME
AS
    BEGIN
        DECLARE @LPCalculation TABLE
        (LPID           INT, 
         ShareID        INT, 
         AmountCommited DECIMAL(18, 5), 
         Percentage     DECIMAL(18, 5), 
         CallAmount     DECIMAL(18, 5)
        );
        INSERT INTO @LPCalculation
               SELECT MAX(b.LimitedPartnerID), 
                      b.ShareID, 
                      SUM(ISNULL(amount, 0)) AS Amount, 
                      0, 
                      0
               FROM tbl_LimitedPartner a
                    JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
               WHERE a.VehicleID = @VehicleID
                     AND b.ShareID = @ShareID
                     AND a.Date <= @date
                     AND a.ModuleID IS NOT NULL
                     AND a.ObjectID IS NOT NULL
               GROUP BY b.ShareID, 
                        a.ModuleID, 
                        a.ObjectID;
        UPDATE @LPCalculation
          SET 
              Percentage = (AmountCommited /
        (
            SELECT SUM(ISNULL(AmountCommited, 0))
            FROM @LPCalculation
        )) * 100;
        UPDATE @LPCalculation
          SET 
              CallAmount = (@Amount * Percentage) / 100;
        SELECT *
        FROM @LPCalculation;
    END;
