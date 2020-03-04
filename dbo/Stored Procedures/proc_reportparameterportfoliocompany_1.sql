
-- [proc_reportparameterportfoliocompany_1] '1,2,3,4,5,6,7,8'  

CREATE PROCEDURE [dbo].[proc_reportparameterportfoliocompany_1](@Vehiclecvs VARCHAR(1000))
AS
    BEGIN
        DECLARE @result TABLE
        (PortfolioID       INT, 
         TargetPortfolioID INT, 
         CompanyName       VARCHAR(1000)
        );
        DECLARE @vehicles TABLE
        (ID        INT, 
         VehicleID INT
        );
        INSERT INTO @vehicles
               SELECT ROW_NUMBER() OVER(
                      ORDER BY VehicleID DESC), 
                      VehicleID
               FROM tbl_Vehicle
               WHERE VehicleID IN
               (
                   SELECT *
                   FROM dbo.SplitCSV(@Vehiclecvs, ',')
               );
        DECLARE @ID INT;
        DECLARE @Count INT;
        DECLARE @Current INT;
        DECLARE @vehicleID INT;
        SET @Current = 1;
        SET @Count =
        (
            SELECT COUNT(1)
            FROM @vehicles
        );
        WHILE(@current <= @count)
            BEGIN
                SET @vehicleID =
                (
                    SELECT VehicleID
                    FROM @vehicles
                    WHERE ID = @current
                );
                INSERT INTO @result
                       SELECT p.PortfolioID, 
                              p.TargetPortfolioID, 
                              cc.CompanyName
                       FROM tbl_Portfolio p
                            INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID;
                SET @current = @current + 1;
            END;
    END;
        SELECT DISTINCT 
               *
        FROM @result
        ORDER BY companyname;

--tbl_Vehicle 

