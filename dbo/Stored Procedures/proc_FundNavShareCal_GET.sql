
-- [proc_PortfolioValuationSecurity_GET] 20,1        

CREATE PROCEDURE [dbo].[proc_FundNavShareCal_GET] -- 28                     

(@vehicleID INT
)
AS
    BEGIN
        DECLARE @tmp TABLE
        (amount   DECIMAL(18, 2), 
         shareid  INT, 
         moduleid INT, 
         objectid INT
        );
        INSERT INTO @tmp
               SELECT SUM(shareamount), 
                      cs.FundShareID, 
                      c.ModuleID, 
                      c.ObjectID
               FROM tbl_Commitment c
                    INNER JOIN tbl_CommitmentFundShare cs ON c.CommitmentID = cs.CommitmentID
               WHERE FundID = @vehicleID
               GROUP BY cs.FundShareID, 
                        c.ModuleID, 
                        c.ObjectID;
        SELECT CAST(((SUM(t.amount)) / fs.NominalValue) AS INT) AS 'Stock', 
               t.shareid, 
               fs.ShareName, 
               '' AS 'Value'
        FROM @tmp t
             INNER JOIN tbl_FundShare fs ON fs.FundShareID = shareid
        GROUP BY t.shareid, 
                 fs.NominalValue, 
                 fs.ShareName;
    END; 
