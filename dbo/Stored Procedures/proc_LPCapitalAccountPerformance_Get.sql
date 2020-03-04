CREATE PROCEDURE [dbo].[proc_LPCapitalAccountPerformance_Get] @objectID      INT      = NULL, 
                                                              @moduleID      INT, 
                                                              @FundID        INT      = NULL, 
                                                              @shareID       INT      = NULL, 
                                                              @date          DATETIME, 
                                                              @showValidated INT      = 1 -- 1=all,2=validated,3=unvalidated

AS
    BEGIN
        DECLARE @tblnav TABLE
        (Date            DATETIME, 
         Amount          DECIMAL(18, 6), 
         TypeOfOperation VARCHAR(100), 
         DocStatus       INT
        );
        INSERT INTO @tblnav
               SELECT NavDate Date, 
                      dbo.[F_GetAdjustedNav_V1](NULL, @objectID, @moduleID, @FundID, NULL, @date, @showValidated), 
                      'Last NAV' TypeOfOperation,
                      CASE
                          WHEN ccal.TotalValidationReq = 0
                          THEN 1
                          ELSE ccal.DocStatus
                      END DocStatus
               FROM tbl_VehicleNavLimitedPartner aaa
                    JOIN tbl_VehicleNav ccal ON aaa.VehicleNavID = ccal.VehicleNavID
                    JOIN tbl_LimitedPartner ccal2 ON aaa.LimitedPartnerID = ccal2.LimitedPartnerID
               WHERE ccal.VehicleID = ISNULL(@FundID, ccal.VehicleID)
                     AND ccal2.ObjectID = ISNULL(@objectID, ccal2.ObjectID)
                     AND aaa.ShareID = ISNULL(@shareID, aaa.ShareID)
                     AND ccal.NavDate <= @date
                     AND ccal2.moduleid = @moduleID
                     AND 1 = CASE
                                 WHEN @showValidated = 1
                                 THEN 1
                                 WHEN @showValidated = 2
                                      AND (CASE
                                               WHEN ccal.TotalValidationReq = 0
                                               THEN 1
                                               WHEN ccal.DocStatus IS NOT NULL
                                               THEN 1
                                               ELSE 0
                                           END) = 1
                                 THEN 1
                                 WHEN @showValidated = 3
                                      AND (CASE
                                               WHEN ccal.TotalValidationReq = 0
                                               THEN 1
                                               WHEN ccal.DocStatus IS NOT NULL
                                               THEN 1
                                               ELSE 0
                                           END) = 0
                                 THEN 1
                                 ELSE 0
                             END
                     AND NavDate =
               (
                   SELECT MAX(NavDate)
                   FROM tbl_VehicleNav ccal
                        JOIN tbl_LimitedPartner ccal2 ON aaa.LimitedPartnerID = ccal2.LimitedPartnerID
                   WHERE ccal.VehicleID = ISNULL(@FundID, ccal.VehicleID)
                         AND ccal2.ObjectID = ISNULL(@objectID, ccal2.ObjectID)
                         AND ccal2.moduleid = @moduleID
                         AND ccal.NavDate <= @date
                         AND 1 = CASE
                                     WHEN @showValidated = 1
                                     THEN 1
                                     WHEN @showValidated = 2
                                          AND (CASE
                                                   WHEN ccal.TotalValidationReq = 0
                                                   THEN 1
                                                   WHEN ccal.DocStatus IS NOT NULL
                                                   THEN 1
                                                   ELSE 0
                                               END) = 1
                                     THEN 1
                                     WHEN @showValidated = 3
                                          AND (CASE
                                                   WHEN ccal.TotalValidationReq = 0
                                                   THEN 1
                                                   WHEN ccal.DocStatus IS NOT NULL
                                                   THEN 1
                                                   ELSE 0
                                               END) = 0
                                     THEN 1
                                     ELSE 0
                                 END
               )
               GROUP BY NavDate,
                        CASE
                            WHEN ccal.TotalValidationReq = 0
                            THEN 1
                            ELSE ccal.DocStatus
                        END;
        IF
        (
            SELECT COUNT(1)
            FROM @tblnav
        ) = 0
            BEGIN
                INSERT INTO @tblnav
                       SELECT @date, 
                              dbo.[F_GetAdjustedNav_V1](NULL, @objectID, @moduleID, @FundID, NULL, @date, @showValidated), 
                              'Last NAV', 
                              1;
        END;
        SELECT P.Date, 
               P.Amount, 
               P.TypeOfOperation, 
               P.DocStatus
        FROM
        (
            SELECT ccal.DueDate AS 'Date', 
                   -CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
                   'Capital Call' AS TypeOfOperation,
                   CASE
                       WHEN ccal.TotalValidationReq = 0
                       THEN 1
                       ELSE ccal.DocStatus
                   END DocStatus
            FROM tbl_CapitalCallLimitedPartner cc
                 JOIN tbl_capitalcall ccal ON cc.CapitalCallID = ccal.CapitalCallID
                 JOIN tbl_LimitedPartner ccal2 ON cc.LimitedPartnerID = ccal2.LimitedPartnerID
            WHERE ccal2.ObjectID = @objectID
                  AND ccal2.moduleid = @moduleID
                  AND cc.ShareID = ISNULL(@shareID, cc.ShareID)
                  AND ccal.CallDate <= @date
                  AND ccal.FundID = ISNULL(@FundID, ccal.FundID)
                  AND 1 = CASE
                              WHEN @showValidated = 1
                              THEN 1
                              WHEN @showValidated = 2
                                   AND (CASE
                                            WHEN ccal.TotalValidationReq = 0
                                            THEN 1
                                            WHEN ccal.DocStatus IS NOT NULL
                                            THEN 1
                                            ELSE 0
                                        END) = 1
                              THEN 1
                              WHEN @showValidated = 3
                                   AND (CASE
                                            WHEN ccal.TotalValidationReq = 0
                                            THEN 1
                                            WHEN ccal.DocStatus IS NOT NULL
                                            THEN 1
                                            ELSE 0
                                        END) = 0
                              THEN 1
                              ELSE 0
                          END
            GROUP BY ccal2.ObjectID, 
                     ccal.FundID, 
                     ccal.DueDate,
                     CASE
                         WHEN ccal.TotalValidationReq = 0
                         THEN 1
                         ELSE ccal.DocStatus
                     END
            UNION
            SELECT ccal.Date AS 'Date', 
                   CAST(SUM(ISNULL(cc.Amount, 0)) AS DECIMAL(18, 2)) AS Amount, 
                   'Distribution' TypeOfOperation,
                   CASE
                       WHEN ccal.TotalValidationReq = 0
                       THEN 1
                       ELSE ccal.DocStatus
                   END DocStatus
            FROM tbl_DistributionLimitedPartner cc
                 JOIN tbl_Distribution ccal ON cc.DistributionID = ccal.DistributionID
                 JOIN tbl_LimitedPartner ccal2 ON cc.LimitedPartnerID = ccal2.LimitedPartnerID
            WHERE ccal2.ObjectID = ISNULL(@objectID, ccal2.ObjectID)
                  AND ccal2.moduleid = @moduleID
                  AND cc.ShareID = ISNULL(@shareID, cc.ShareID)
                  AND ccal.FundID = ISNULL(@FundID, ccal.FundID)
                  AND ccal.Date <= @date
                  AND 1 = CASE
                              WHEN @showValidated = 1
                              THEN 1
                              WHEN @showValidated = 2
                                   AND (CASE
                                            WHEN ccal.TotalValidationReq = 0
                                            THEN 1
                                            WHEN ccal.DocStatus IS NOT NULL
                                            THEN 1
                                            ELSE 0
                                        END) = 1
                              THEN 1
                              WHEN @showValidated = 3
                                   AND (CASE
                                            WHEN ccal.TotalValidationReq = 0
                                            THEN 1
                                            WHEN ccal.DocStatus IS NOT NULL
                                            THEN 1
                                            ELSE 0
                                        END) = 0
                              THEN 1
                              ELSE 0
                          END
            GROUP BY ccal2.ObjectID, 
                     ccal.FundID, 
                     ccal.Date,
                     CASE
                         WHEN ccal.TotalValidationReq = 0
                         THEN 1
                         ELSE ccal.DocStatus
                     END
            UNION ALL
            SELECT *
            FROM @tblnav
        ) P
        WHERE 1 = CASE
                      WHEN TypeOfOperation = 'Last NAV'
                      THEN 1
                      WHEN p.amount <> 0
                      THEN 1
                      ELSE 0
                  END
        ORDER BY P.Date ASC;
    END;
