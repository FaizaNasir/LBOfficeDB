
-- created by : Syed Zain ALi    
-- =============================================            
-- Author:  <Author,,Zain Ali>            
-- Create date: <Created Date,,02 Oct, 2013>            
-- Description: <Description,,This funtion will return the info of individual/company based on input values.           
--         if the value does not exists then it ill create and return them as well>            
-- =============================================            
-- [proc_Deal_SETBulk] 'DAVIGOLD MANAGEMENT,DAVIGOLD MANAGEMENT Testing','Company'          

CREATE PROCEDURE [dbo].[proc_Deal_SETBulk] @name VARCHAR(MAX)
AS
    BEGIN
        INSERT INTO dbo.tbl_Deals
        (DealName, 
         DealStatusID
        )
               SELECT i.items, 
                      1
               FROM dbo.tbl_Deals ci
                    RIGHT JOIN
               (
                   SELECT *
                   FROM dbo.SplitCSV(@name, ',')
               ) i ON i.items = DealName
               WHERE ci.DealID IS NULL;
        SELECT ci.DealID AS ObjectID, 
               ci.DealName AS ObjectName
        FROM dbo.tbl_Deals ci
        WHERE DealName IN
        (
            SELECT *
            FROM dbo.SplitCSV(@name, ',')
        );
    END;
