CREATE FUNCTION [dbo].[F_Sho_GetCostOfSoldInvs_Updated_SecurityWise]
(@_securityID INT, 
 @sho         SHOTYPE READONLY, 
 @portfolioID INT, 
 @NatureID    INT, 
 @typeID      INT, 
 @VehicleID   INT
)
RETURNS DECIMAL(18, 6)
AS
     BEGIN
         DECLARE @result DECIMAL(18, 6);
         SET @result = 0;
         DECLARE @securities TABLE
         (ID         INT, 
          SecurityID INT
         );
         INSERT INTO @securities
                SELECT ROW_NUMBER() OVER(
                       ORDER BY SecurityID DESC), 
                       securityID
                FROM
                (
                    SELECT DISTINCT 
                           SecurityID
                    FROM @sho
                    WHERE securityID = @_securityID
                ) t;
         DECLARE @current INT;
         DECLARE @count INT;
         DECLARE @securityID INT;
         SET @current = 1;
         SET @count =
         (
             SELECT COUNT(1)
             FROM @securities
         );
         DECLARE @shoResult TABLE
         (ID                      INT, 
          ShareholdingOperationID INT, 
          PortfolioID             INT, 
          Date                    DATETIME, 
          Amount                  DECIMAL(18, 6), 
          SecurityID              INT, 
          Number                  DECIMAL(18, 6), 
          FromID                  INT, 
          ToID                    INT, 
          FromTypeID              INT, 
          ToTypeID                INT, 
          NatureID                INT, 
          Val                     DECIMAL(18, 6)
         );
         DECLARE @shoSecurity TABLE
         (ID                      INT, 
          ShareholdingOperationID INT, 
          PortfolioID             INT, 
          Date                    DATETIME, 
          Amount                  DECIMAL(18, 6), 
          SecurityID              INT, 
          Number                  DECIMAL(18, 6), 
          FromID                  INT, 
          ToID                    INT, 
          FromTypeID              INT, 
          ToTypeID                INT, 
          NatureID                INT, 
          Val                     DECIMAL(18, 6)
         );
         INSERT INTO @shoResult
                SELECT ROW_NUMBER() OVER(
                       ORDER BY Val DESC), 
                       *
                FROM
                (
                    SELECT ShareholdingOperationID, 
                           PortfolioID, 
                           Date, 
                           Amount, 
                           SecurityID, 
                           Number, 
                           FromID, 
                           ToID, 
                           FromTypeID, 
                           ToTypeID, 
                           NatureID, 
                           0 Val
                    FROM @sho
                    WHERE Date < DATEADD(year, -2, GETDATE())
                          AND securityID = @_securityID
                ) t
                ORDER BY t.date;
         DECLARE @CostOfSold DECIMAL(18, 6);
         DECLARE @unitValue DECIMAL(18, 6);
         DECLARE @sumOfNumbers DECIMAL(18, 6);
         DECLARE @break BIT;
         DECLARE @SCRT DECIMAL(18, 6);
         DECLARE @SCSN DECIMAL(18, 6);
         DECLARE @ECRT DECIMAL(18, 6);
         DECLARE @ECSN DECIMAL(18, 6);
         DECLARE @a DECIMAL(18, 6);
         DECLARE @b DECIMAL(18, 6);

         --select * from @shoResult                
         --return              

         WHILE @current <= @count
             BEGIN
                 SET @securityID =
                 (
                     SELECT securityID
                     FROM @securities
                     WHERE ID = @current
                 );
                 DELETE FROM @shoSecurity;
                 SET @SCRT = 0;
                 SET @SCSN = 0;
                 SET @ECRT = 0;
                 SET @ECSN = 0;
                 SET @break = 1;
                 INSERT INTO @shoSecurity
                        SELECT ROW_NUMBER() OVER(
                               ORDER BY SecurityID DESC), 
                               ShareholdingOperationID, 
                               PortfolioID, 
                               Date, 
                               Amount, 
                               SecurityID, 
                               Number, 
                               FromID, 
                               ToID, 
                               FromTypeID, 
                               ToTypeID, 
                               NatureID, 
                               0 Val
                        FROM @shoResult
                        WHERE SecurityID = @securityID
                        ORDER BY date;

                 --select 'asd',* from @shoSecurity        

                 WHILE @break = 1
                     BEGIN
                         SET @SCRT =
                         (
                             SELECT TOP 1 ID
                             FROM @shoSecurity
                             WHERE FromTypeID <> 3
                                   AND ID > @ECRT
                         );
                         SET @SCSN =
                         (
                             SELECT TOP 1 ID
                             FROM @shoSecurity
                             WHERE FromTypeID = 3
                                   AND ID > @ECSN
                         );
                         SET @ECRT =
                         (
                             SELECT TOP 1 ID
                             FROM @shoSecurity
                             WHERE ID < @SCSN
                             ORDER BY ID DESC
                         );
                         SET @ECSN =
                         (
                             SELECT TOP 1 ID
                             FROM @shoSecurity
                             WHERE ID <
                             (
                                 SELECT TOP 1 ID
                                 FROM @shoSecurity
                                 WHERE FromTypeID <> 3
                                       AND ID > @SCSN
                             )
                             ORDER BY ID DESC
                         );

                         --select  @SCRT                
                         --    ,@SCSN                
                         --    ,@ECRT                
                         --    ,@ECSN                

                         IF @SCRT IS NULL
                            OR @SCSN IS NULL
                            OR @ECRT IS NULL
                            OR @ECSN IS NULL
                             BEGIN
                                 SET @break = 0;
                                 IF @ECSN IS NULL
                                     BEGIN
                                         SET @ECSN =
                                         (
                                             SELECT TOP 1 ID
                                             FROM @shoSecurity
                                             ORDER BY 1 DESC
                                         );
                                 END;
                         END;
                         IF(@SCRT =
                         (
                             SELECT TOP 1 ID
                             FROM @shoSecurity
                         ))
                             BEGIN
                                 SET @unitValue =
                                 (
                                     SELECT SUM(Amount) / SUM(CASE
                                                                  WHEN Number = 0
                                                                  THEN 1
                                                                  ELSE Number
                                                              END)
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCRT AND @ECRT
                                           AND 1 = CASE
                                                       WHEN @typeID = 1
                                                       THEN 1
                                                       WHEN @typeID = 2
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(NULL, ObjectModuleID)
                                               AND IsCapital = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 3
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan5Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 4
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan8Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 5
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 6
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 7
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 1
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 8
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 9
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 10
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 4
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                   END
                                 );
                                 SET @sumOfNumbers = (
                                 (
                                     SELECT SUM(ISNULL(Number, 0))
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCRT AND @ECRT
                                           AND Date < DATEADD(year, -2, GETDATE())
                                           AND 1 = CASE
                                                       WHEN @typeID = 1
                                                       THEN 1
                                                       WHEN @typeID = 2
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(NULL, ObjectModuleID)
                                               AND IsCapital = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 3
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan5Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 4
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan8Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 5
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 6
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 7
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 1
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 8
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 9
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 10
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 4
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                   END
                                 ) -
                                 (
                                     SELECT SUM(ISNULL(Number, 0))
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCSN AND @ECSN
                                 ));
                                 UPDATE @shoSecurity
                                   SET 
                                       Val = @unitValue * Number
                                 WHERE ID BETWEEN @SCSN AND @ECSN;

                                 --select @securityID,@unitValue,@sumOfNumbers,@a,@b,@SCRT,@SCSN,@ECRT,@ECSN                

                         END;
                             ELSE
                             BEGIN
                                 SET @a =
                                 (
                                     SELECT SUM(amount) + (@sumOfNumbers * @unitValue)
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCRT AND @ECRT
                                           AND Date < DATEADD(year, -2, GETDATE())
                                           AND 1 = CASE
                                                       WHEN @typeID = 1
                                                       THEN 1
                                                       WHEN @typeID = 2
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(NULL, ObjectModuleID)
                                               AND IsCapital = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 3
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan5Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 4
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan8Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 5
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 6
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 7
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 1
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 8
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 9
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 10
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 4
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                   END
                                 );
                                 SET @unitValue =
                                 (
                                     SELECT SUM(Amount) / SUM(CASE
                                                                  WHEN Number = 0
                                                                  THEN 1
                                                                  ELSE Number
                                                              END)
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCRT AND @ECRT
                                           AND Date < DATEADD(year, -2, GETDATE())
                                           AND 1 = CASE
                                                       WHEN @typeID = 1
                                                       THEN 1
                                                       WHEN @typeID = 2
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(NULL, ObjectModuleID)
                                               AND IsCapital = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 3
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan5Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 4
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan8Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 5
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 6
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 7
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 1
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 8
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 9
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 10
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 4
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                   END
                                 );
                                 SET @b =
                                 (
                                     SELECT SUM(number) + (@sumOfNumbers)
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCRT AND @ECRT
                                           AND Date < DATEADD(year, -2, GETDATE())
                                           AND 1 = CASE
                                                       WHEN @typeID = 1
                                                       THEN 1
                                                       WHEN @typeID = 2
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(NULL, ObjectModuleID)
                                               AND IsCapital = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 3
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan5Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 4
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan8Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 5
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 6
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 7
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 1
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 8
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 9
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 10
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 4
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                   END
                                 );
                                 SET @unitValue = @a / @b;
                                 UPDATE @shoSecurity
                                   SET 
                                       Val = @unitValue * Number
                                 WHERE ID BETWEEN @SCSN AND @ECSN;

                                 --select @unitValue,@sumOfNumbers,@a,@b,@SCRT,@SCSN,@ECRT,@ECSN                

                                 SET @sumOfNumbers = (
                                 (
                                     SELECT SUM(ISNULL(Number, 0))
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCRT AND @ECRT
                                           AND Date < DATEADD(year, -2, GETDATE())
                                           AND 1 = CASE
                                                       WHEN @typeID = 1
                                                       THEN 1
                                                       WHEN @typeID = 2
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(NULL, ObjectModuleID)
                                               AND IsCapital = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 3
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan5Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 4
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND IsCompanylessthan8Years = 1
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 5
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 6
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND QuotationID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 7
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 1
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 8
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 2
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 9
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 3
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                       WHEN @typeID = 10
                                                            AND PortfolioID IN
                                     (
                                         SELECT ObjectModuleID
                                         FROM tbl_eligibility
                                         WHERE moduleID = 7
                                               AND ObjectModuleID = ISNULL(@portfolioID, ObjectModuleID)
                                               AND NatureID = 4
                                               AND vehicleID = @VehicleID
                                     )
                                                       THEN 1
                                                   END
                                 ) -
                                 (
                                     SELECT SUM(ISNULL(Number, 0))
                                     FROM @shoSecurity
                                     WHERE ID BETWEEN @SCSN AND @ECSN
                                 ));
                         END;
                     END;
                 SET @result = @result +
                 (
                     SELECT ISNULL(SUM(val), 0)
                     FROM @shoSecurity
                 );

                 --select ISNULL(SUM(val),0) from @shoSecurity              

                 SET @current = @current + 1;
             END;
         RETURN @result;
     END;
