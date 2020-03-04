
-- created by : Syed Zain ALi      
-- =============================================              
-- Author:  <Author,,Zain Ali>              
-- Create date: <Created Date,,02 Oct, 2013>              
-- Description: <Description,,This funtion will return the info of individual/company based on input values.             
--         if the value does not exists then it ill create and return them as well>              
-- =============================================              
-- [proc_Vehicle_SETBulk] 'DAVIGOLD MANAGEMENT,DAVIGOLD MANAGEMENT Testing'    

CREATE PROCEDURE [dbo].[proc_Vehicle_SETBulk] @name VARCHAR(MAX)
AS
    BEGIN

        --INSERT INTO dbo.tbl_vehicle            
        --   (            
        -- Name           
        --   )            
        --   SELECT i.items          
        --   FROM             
        --dbo.tbl_vehicle ci            
        --RIGHT JOIN (SELECT * FROM dbo.SplitCSV(@name,',')) i            
        --ON i.items = Name            
        --WHERE ci.VehicleID IS NULL             

        SELECT ci.VehicleID AS ObjectID, 
               ci.Name AS ObjectName
        FROM dbo.tbl_Vehicle ci
        WHERE Name IN
        (
            SELECT *
            FROM dbo.SplitCSV(@name, ',')
        );
    END;
