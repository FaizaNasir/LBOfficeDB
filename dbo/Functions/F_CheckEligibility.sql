
--  select * from dbo.[F_CheckEligibility](7)      

CREATE FUNCTION [dbo].[F_CheckEligibility]
(@vehicleID INT
)
RETURNS @result TABLE(ID INT)
AS
     BEGIN
         DECLARE @tmp TABLE
         (ID          INT, 
          PortfolioID INT
         );
         DECLARE @portfolioID INT;
         DECLARE @count INT;
         DECLARE @current INT;
         DECLARE @isEligibile BIT;
         DECLARE @EmpNumber INT;
         DECLARE @MinEmp INT;
         DECLARE @MaxEmp INT;
         DECLARE @eligibilityID INT;
         DECLARE @VehicleEligibilityTypeID INT;
         INSERT INTO @tmp
                SELECT ROW_NUMBER() OVER(
                       ORDER BY ObjectModuleID DESC), 
                       ObjectModuleID
                FROM tbl_Eligibility
                WHERE VehicleID = @VehicleID;  
         --and ObjectModuleID = 47  
         SET @count =
         (
             SELECT COUNT(1)
             FROM @tmp
         );
         SET @current = 1;
         WHILE @current <= @count
             BEGIN
                 SET @VehicleEligibilityTypeID =
                 (
                     SELECT VehicleEligibilityTypeID
                     FROM tbl_VehicleEligibility
                     WHERE VehicleID = @vehicleID
                 );
                 SET @isEligibile = 1;
                 SET @eligibilityID =
                 (
                     SELECT EligibilityID
                     FROM tbl_Eligibility
                     WHERE ObjectModuleID =
                     (
                         SELECT TOP 1 PortfolioID
                         FROM @tmp
                         WHERE ID = @current
                     )
                           AND ModuleID = 7
                           AND vehicleID = @vehicleID
                           AND IsTargetPayTax = 1
                 );
                 IF @eligibilityID IS NULL
                     SET @isEligibile = 0;
                 IF @eligibilityID IS NULL
                     IF @isEligibile = 1
                        AND NOT EXISTS
                     (
                         SELECT TOP 1 1
                         FROM tbl_EligibilityInnovativeCriteria
                         WHERE EligibilityID = @eligibilityID
                               AND InnovateCriteriaID = 1
                     )
                         SET @isEligibile = 0;

                 --if @isEligibile = 1 and @VehicleEligibilityTypeID <> 1     
                 -- set @isEligibile = 0    

                 IF @isEligibile = 1
                    AND @VehicleEligibilityTypeID = 2
                    AND EXISTS
                 (
                     SELECT TOP 1 1
                     FROM tbl_EligibilityInnovativeCriteria
                     WHERE EligibilityID = @eligibilityID
                           AND InnovateCriteriaID NOT IN(2, 3)
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
                 INSERT INTO @result
                        SELECT ObjectModuleID
                        FROM tbl_eligibility
                        WHERE EligibilityID = @eligibilityID;
                 SET @current = @current + 1;
             END;
         RETURN;
     END;
