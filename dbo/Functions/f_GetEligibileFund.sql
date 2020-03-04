
--  select dbo.[f_GetEligibileFund](388,-1)                      

CREATE FUNCTION [dbo].[f_GetEligibileFund]
(@dealID    INT, 
 @vehicleID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @result VARCHAR(MAX);
         DECLARE @tmp TABLE
         (ID          INT, 
          VehicleID   INT, 
          VehicleName VARCHAR(200), 
          IsEligible  BIT
         );
         DECLARE @count INT;
         DECLARE @current INT;
         DECLARE @isEligibile BIT;
         DECLARE @EmpNumber INT;
         DECLARE @MinEmp INT;
         DECLARE @MaxEmp INT;
         DECLARE @eligibilityID INT;
         DECLARE @VehicleEligibilityTypeID INT;

         --                    
         SET @isEligibile = 1;
         SET @eligibilityID =
         (
             SELECT a.eligibilityID
             FROM tbl_Eligibility a
                  JOIN tbl_EligibilityInnovativeCriteria b ON a.EligibilityID = b.EligibilityID
             WHERE ModuleID = 6
                   AND ObjectModuleID = @dealID
                   AND IsTargetPayTax = 1
                   AND HeadquarterID <> 2
                   AND InnovateCriteriaID = 3
         );
         IF @eligibilityID IS NULL
             SET @isEligibile = 0;
         INSERT INTO @tmp
                SELECT ROW_NUMBER() OVER(
                       ORDER BY VehicleID DESC), 
                       VehicleID, 
                       Name, 
                       0
                FROM tbl_vehicle
                WHERE VehicleID = ISNULL(@vehicleID, VehicleID);
         SET @count =
         (
             SELECT COUNT(1)
             FROM @tmp
         );
         SET @current = 1;
         WHILE @current <= @count
               AND @eligibilityID IS NOT NULL
             BEGIN
                 SET @isEligibile = 1;
                 SET @vehicleID =
                 (
                     SELECT vehicleID
                     FROM @tmp
                     WHERE ID = @current
                 );
                 SET @VehicleEligibilityTypeID =
                 (
                     SELECT VehicleEligibilityTypeID
                     FROM tbl_VehicleEligibility
                     WHERE VehicleID = @vehicleID
                 );
                 IF @VehicleEligibilityTypeID IS NULL
                     SET @isEligibile = 0;
                 IF @isEligibile = 1
                    AND @VehicleEligibilityTypeID = 1
                    AND EXISTS
                 (
                     SELECT TOP 1 1
                     FROM tbl_EligibilityInnovativeCriteria
                     WHERE EligibilityID = @eligibilityID
                           AND InnovateCriteriaID NOT IN(2, 1, 3)
                 )
                     SET @isEligibile = 0;
                 SET @EmpNumber =
                 (
                     SELECT EmpNumber
                     FROM tbl_Eligibility
                     WHERE EligibilityID = @EligibilityID
                 );
                 SELECT @MinEmp = MinEmp, 
                        @MaxEmp = MaxEmp
                 FROM tbl_VehicleEligibility
                 WHERE vehicleID = @vehicleID;
                 IF @isEligibile = 1
                    AND @EmpNumber NOT BETWEEN @MinEmp AND @MaxEmp
                     SET @isEligibile = 0;
                 IF EXISTS
                 (
                     SELECT TOP 1 1
                     FROM tbl_eligibilityRegion x
                          JOIN tbl_eligibility y ON x.EligibilityID = y.EligibilityID
                                                    AND x.EligibilityID = @eligibilityID
                                                    AND x.RegionID NOT IN(SELECT b.RegionID
                                                                          FROM tbl_VehicleEligibility A
                                                                               JOIN tbl_VehicleEligibilityRegion b ON a.VehicleEligibilityID = b.VehicleEligibilityID
                                                                                                                      AND a.VehicleID = @VehicleID)
                 )
                     SET @isEligibile = 0;
                 IF @isEligibile = 1
                     BEGIN
                         UPDATE @tmp
                           SET 
                               IsEligible = 1
                         WHERE ID = @current;
                 END;
                 SET @current = @current + 1;
             END;
         SET @result =
         (
             SELECT SUBSTRING(
             (
                 SELECT ',' + s.VehicleName
                 FROM @tmp s
                 WHERE IsEligible = 1
                 ORDER BY s.VehicleName FOR XML PATH('')
             ), 2, 200000)
         );
         RETURN ISNULL(@result, '');
     END; 
