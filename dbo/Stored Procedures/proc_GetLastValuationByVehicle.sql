CREATE PROC [dbo].[proc_GetLastValuationByVehicle]
(@vehicleID INT, 
 @date      DATETIME
)
AS
    BEGIN
        SELECT SUM(Value) Value
        FROM
        (
            SELECT
            (
                SELECT TOP 1 FinalValuation
                FROM tbl_portfoliovaluation p
                WHERE p.portfolioid = pv.portfolioid
                      AND p.Date <= ISNULL(@date, p.Date)
                      AND p.vehicleID = pv.vehicleID
                ORDER BY Date DESC
            ) Value
            FROM tbl_portfoliovehicle pv
            WHERE vehicleID = @vehicleID
        ) t;
    END;
