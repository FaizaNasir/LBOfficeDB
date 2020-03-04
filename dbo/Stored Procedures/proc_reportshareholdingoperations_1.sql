--tbl_vehicle            
--tbl_companycontact  where companyname like '%budget%'            
--tbl_portfoliosecurity where portfolioid = 32            
-- [proc_reportshareholdingoperations_1] '8','32','78','1','01/01/2011','01/01/2200','3,1,2'            
-- tbl_vehicle                

CREATE PROC [dbo].[proc_reportshareholdingoperations_1]
(@Vehiclecvs       VARCHAR(1000), 
 @PortfolioCompany VARCHAR(MAX), 
 @SecurityID       VARCHAR(MAX), 
 @SecurityTypeID   VARCHAR(MAX), 
 @FromDate         DATETIME, 
 @ToDate           DATETIME, 
 @Operationtype    VARCHAR(MAX)
)
AS
     DECLARE @temp TABLE
     (ID                   INT, 
      VehicleID            INT, 
      VehicleName          VARCHAR(1000), 
      Date                 DATETIME, 
      securityname         VARCHAR(MAX), 
      Number               DECIMAL(18, 2), 
      Amount               DECIMAL(18, 2), 
      Notes                VARCHAR(MAX), 
      portfoliocompanyname VARCHAR(MAX), 
      NatureType           VARCHAR(MAX), 
      NatureTypeName       VARCHAR(MAX)
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
     DECLARE @portfolioID INT;
     DECLARE @vehicleID INT;
     DECLARE @ID INT;
     DECLARE @Count INT;
     DECLARE @Current INT;
     SET @Current = 1;
     SET @Count =
     (
         SELECT COUNT(1)
         FROM @vehicles
     );                  
     --select * from @vehicles                  
     WHILE @current <= @count
         BEGIN
             SET @vehicleID =
             (
                 SELECT VehicleID
                 FROM @vehicles
                 WHERE ID = @current
             );
             DECLARE @tmp TABLE
             (ID                   INT, 
              VehicleID            INT, 
              VehicleName          VARCHAR(1000), 
              Date                 DATETIME, 
              securityname         VARCHAR(MAX), 
              number               DECIMAL(18, 4), 
              amount               DECIMAL(18, 4), 
              note                 VARCHAR(MAX), 
              portfoliocompanyname VARCHAR(MAX), 
              operationtype        VARCHAR(100)
             );
             INSERT INTO @tmp

                    --  Select Distinct                
                    --  @vehicleID ,v.Name, sho.Date,ps.Name 'securityname',sho.Number,sho.Amount,sho.Notes,              
                    --  cc.CompanyName 'portfoliocompanyname',              
                    --  case when FromTypeID = 0 and ToTypeID = 3  then '1'                        
                    --  when FromTypeID <> 0 and FromTypeID = 3 then '2'                        
                    --  when FromTypeID = 3 and ToTypeID <> 0 then 'Transfert de titres'                        
                    --  else '3' end 'NatureType'              
                    --from  tbl_PortfolioShareholdingOperations sho               
                    --   inner join tbl_PortfolioSecurity ps ON                 
                    --   ps.PortfolioID = sho.PortfolioID                 
                    --   and sho.SecurityID = ps.PortfolioSecurityID              
                    --   inner join tbl_Portfolio p ON              
                    --   p.PortfolioID = sho.PortfolioID              
                    --   inner join tbl_CompanyContact cc ON              
                    --   cc.CompanyContactID = p.TargetPortfolioID             
                    --   join tbl_Vehicle v            
                    --   on v.VehicleID = @vehicleID             
                    --WHERE            
                    ----sho.PortfolioID in (select * from dbo.[F_CheckEligibility](@VehicleID)) and           
                    --sho.PortfolioID in (Select * from dbo.[SplitCSV](@PortfolioCompany,','))              
                    --and ps.PortfolioSecurityID in (Select * from dbo.[SplitCSV](@SecurityID,','))              
                    --and ps.PortfolioSecurityTypeID in (Select * from dbo.[SplitCSV](@SecurityTypeID,','))                
                    --and sho.Date between @FromDate and @ToDate               
                    --and sho.ToTypeID = 3 and sho.ToID = @VehicleID              
                    --UNION All              

                    SELECT DISTINCT 
                           ShareholdingOperationID, 
                           @vehicleID, 
                           v.name, 
                           sho.Date, 
                           ps.Name 'securityname', 
                           sho.Number, 
                           sho.Amount, 
                           sho.Notes, 
                           cc.CompanyName 'portfoliocompanyname',
                           CASE
                               WHEN FromTypeID = 0
                                    AND ToTypeID = 3
                               THEN '1'
                               WHEN FromTypeID <> 0
                                    AND FromTypeID = 3
                               THEN '2'                        
                                          --when FromTypeID = 3 and ToTypeID <> 0 then 'Transfert de titres'                        
                               ELSE '3'
                           END 'NatureType'
                    FROM tbl_PortfolioShareholdingOperations sho
                         INNER JOIN tbl_PortfolioSecurity ps ON ps.PortfolioID = sho.PortfolioID
                                                                AND sho.SecurityID = ps.PortfolioSecurityID
                         INNER JOIN tbl_Portfolio p ON p.PortfolioID = sho.PortfolioID
                         INNER JOIN tbl_CompanyContact cc ON cc.CompanyContactID = p.TargetPortfolioID
                         JOIN tbl_Vehicle v ON v.VehicleID = @vehicleID
                    WHERE            
                    --sho.PortfolioID in (select * from dbo.[F_CheckEligibility](@VehicleID)) and           
                    sho.PortfolioID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@PortfolioCompany, ',')
                    )
                         AND ps.PortfolioSecurityID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@SecurityID, ',')
                    )
                    AND ps.PortfolioSecurityTypeID IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@SecurityTypeID, ',')
                    )
             AND sho.Date BETWEEN @FromDate AND @ToDate
             AND ((sho.FromTypeID = 3
                   AND sho.FromID = @VehicleID)
                  OR (sho.ToTypeID = 3
                      AND sho.ToID = @VehicleID))
                    ORDER BY sho.Date;
             INSERT INTO @temp
                    SELECT *,
                           CASE
                               WHEN operationtype = '1'
                               THEN 'AK'
                               WHEN operationtype = '2'
                               THEN 'Cession'
                               WHEN operationtype = '3'
                               THEN 'Transfert de titres'
                           END
                    FROM @tmp
                    WHERE operationtype IN
                    (
                        SELECT *
                        FROM dbo.[SplitCSV](@Operationtype, ',')
                    );
             SET @current = @current + 1;
         END;

     --select * from @temp                 

     SELECT DISTINCT 
            *
     FROM @temp
     ORDER BY VehicleID, 
              date, 
              securityname, 
              Number, 
              Amount, 
              portfoliocompanyname, 
              NatureType;
