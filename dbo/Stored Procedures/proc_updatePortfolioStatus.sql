
-- proc_updatePortfolioStatus 1,12  

CREATE PROC [dbo].[proc_updatePortfolioStatus]
(@portfolioID INT, 
 @fundiD      INT
)
AS
     DECLARE @PortfolioVehicleID INT;
    BEGIN
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioShareholdingOperations
            WHERE FromTypeID = 3
                  AND FromID = @fundiD
                  AND PortfolioID = @portfolioID
        )
           AND (ISNULL(
        (
            SELECT ISNULL(SUM(Number), 0)
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.ToTypeID = 3
                  AND ToID = @fundiD
                  AND PortfolioID = @portfolioID
            GROUP BY PortfolioID
        ), 0) - ISNULL(
        (
            SELECT ISNULL(SUM(Number), 0) AS 'Seling'
            FROM tbl_PortfolioShareholdingOperations sho
            WHERE sho.FromTypeID = 3
                  AND FromID = @fundiD
                  AND PortfolioID = @portfolioID
            GROUP BY PortfolioID
        ), 0)) = 0
            BEGIN
                UPDATE tbl_PortfolioVehicle
                  SET 
                      STATUS = 4
                WHERE PortfolioID = @portfolioID
                      AND VehicleID = @fundiD;
        END;
            ELSE
            BEGIN
                UPDATE tbl_PortfolioVehicle
                  SET 
                      STATUS = 1
                WHERE PortfolioID = @portfolioID
                      AND VehicleID = @fundiD;
        END;

        --if not exists (select top 1 1 from  
        -- tbl_PortfolioShareholdingOperations  
        -- where FromTypeID = 3 and FromID = @fundiD  
        -- )  
        -- update tbl_PortfolioVehicle  
        -- set Status = 1  
        -- where PortfolioID = @portfolioID  
        -- and VehicleID = @fundiD  
        --else if exists (select top 1 1 from  
        --tbl_PortfolioShareholdingOperations  
        --where FromTypeID = 3 and FromID = @fundiD  
        --)  
        --update tbl_PortfolioVehicle  
        --set Status = 2  
        --where PortfolioID = @portfolioID  
        --and VehicleID = @fundiD  
        --else if exists (select top 1 1 from  
        -- tbl_PortfolioShareholdingOperations  
        -- where FromTypeID = 3 and FromID = @fundiD  
        -- )  
        -- and   
        -- ( (Select sum(number)  
        --   from tbl_PortfolioShareholdingOperations pso  
        --   where pso.FromTypeID in (3,4,5))  
        --     -      
        --   (Select sum(number)  
        --   from tbl_PortfolioShareholdingOperations pso  
        --   where pso.ToTypeID in (3,4,5))   
        --) = 0  
        -- update tbl_PortfolioVehicle  
        -- set Status = 3  
        -- where PortfolioID = @portfolioID  
        -- and VehicleID = @fundiD  

        SET @PortfolioVehicleID = @@IDENTITY;
        SELECT 'Success' AS Result, 
               @PortfolioVehicleID AS 'PortfolioVehicleID';
    END;
