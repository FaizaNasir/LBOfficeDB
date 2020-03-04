
--[proc_getDealSimulations]             

CREATE PROC [dbo].[proc_getDealSimulations]
AS
    BEGIN

        --select  EligibleFunds,           

        DECLARE @sql VARCHAR(MAX);
        SET @sql = 'select DealSimulationID,ds.DealID,          

  ds.TransectionTypeID,          

  dbo.f_GetEligibileFund(ds.DealID,null) [Fonds éligible],          

  d.DealName + '' ('' + dt.DealTransectionTypeName + '') '' [Deal name]';
        DECLARE @count INT;
        DECLARE @current INT;
        DECLARE @tblFund TABLE
        (ID       INT, 
         FundID   INT, 
         FundName VARCHAR(200)
        );
        INSERT INTO @tblFund
               SELECT ROW_NUMBER() OVER(
                      ORDER BY ConstitutionDate DESC), 
                      a.VehicleID, 
                      Name
               FROM tbl_vehicle a
                    LEFT JOIN tbl_vehicleEligibility b ON a.vehicleID = b.vehicleID
               WHERE a.Active = 1
               ORDER BY ConstitutionDate DESC;
        SET @count =
        (
            SELECT COUNT(1)
            FROM @tblFund
        );
        SET @current = 1;
        WHILE @current <= @count
            BEGIN
                SET @sql+=
                (
                    SELECT ','''' [' + FundName + ']'
                    FROM @tblFund
                    WHERE id = @current
                );
                SET @current = @current + 1;
            END;
        SET @sql+=' from tbl_dealsimulation ds            

  join tbl_deals d on d.DealID = ds.DealID          

  join tbl_DealTransectionType dt          

  on dt.DealTransectionTypeID = ds.TransectionTypeID';
        PRINT(@sql);
        EXECUTE (@sql);
    END;
