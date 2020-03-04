CREATE FUNCTION [dbo].[F_GetObjectName]
(@ModuleID INT, 
 @ObjectID INT
)
RETURNS VARCHAR(500)
AS
     BEGIN
         DECLARE @name VARCHAR(MAX);
         IF @ModuleID = 5
             SELECT @name = companyName
             FROM tbl_companycontact
             WHERE CompanyContactID = @ObjectID;
             ELSE
             IF @ModuleID = 3
                 SELECT @name = name
                 FROM tbl_vehicle
                 WHERE vehicleID = @ObjectID;
                 ELSE
                 IF @ModuleID = 6
                     SELECT @name = Dealname
                     FROM tbl_deals
                     WHERE dealid = @ObjectID;
                     ELSE
                     IF @ModuleID = 4
                         SELECT @name = individualfullname
                         FROM tbl_contactindividual
                         WHERE IndividualID = @ObjectID;
         RETURN @name;
     END;
