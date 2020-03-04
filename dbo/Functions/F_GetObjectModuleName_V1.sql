
--  select dbo.[F_GetObjectModuleName](null,0)    

CREATE FUNCTION [dbo].[F_GetObjectModuleName_V1]
(@id       INT, 
 @moduleID INT, 
 @isFrom   BIT = 1
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @result VARCHAR(MAX);
         IF(@moduleID = 3)
             BEGIN
                 SET @result =
                 (
                     SELECT name
                     FROM tbl_Vehicle
                     WHERE VehicleID = @id
                 );
         END;
             ELSE
             IF(@moduleID = 4)
                 BEGIN
                     SET @result =
                     (
                         SELECT IndividualFullName
                         FROM tbl_ContactIndividual
                         WHERE IndividualID = @id
                     );
             END;
                 ELSE
                 IF(@moduleID = 5)
                     BEGIN
                         SET @result =
                         (
                             SELECT CompanyName
                             FROM tbl_CompanyContact
                             WHERE CompanyContactID = @id
                         );
                 END;
         IF(@moduleID = 7)
             BEGIN
                 SET @result =
                 (
                     SELECT CompanyName
                     FROM tbl_CompanyContact cc
                          JOIN tbl_portfolio p ON p.TargetPortfolioID = cc.CompanyContactID
                     WHERE PortfolioID = @id
                 );
         END;
             ELSE
             IF(@moduleID = 6)
                 BEGIN
                     SET @result =
                     (
                         SELECT DealName
                         FROM tbl_Deals
                         WHERE DealID = @id
                     );
             END;
                 ELSE
                 IF @moduleID = 0
                    AND @isFrom = 1
                     BEGIN
                         SET @result = 'Creation';
                 END;
                     ELSE
                     IF @moduleID = 0
                        AND @isFrom = 0
                         BEGIN
                             SET @result = 'Delete';
                     END;
         RETURN ISNULL(@result, '');
     END;
