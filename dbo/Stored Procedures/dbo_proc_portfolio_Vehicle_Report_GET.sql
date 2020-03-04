CREATE PROCEDURE [dbo].[dbo_proc_portfolio_Vehicle_Report_GET]
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @tblFund AS TABLE
        (RowNum    INT IDENTITY(1, 1), 
         VehicleID INT
        );
        DECLARE @Cnt AS INT= 1, @TotCnt AS INT;
        INSERT INTO @tblFund
               SELECT VehicleID
               FROM Tbl_Vehicle;
        SELECT @TotCnt = COUNT(VehicleID)
        FROM @tblFund;
        CREATE TABLE #PFDetails
        (
        --VehicleID INT NULL,
        PortfolioID      INT, 
        CompanyContactID INT, 
        CompanyName      VARCHAR(600)
        );
        CREATE TABLE #FundDetails
        (VehicleID        INT NULL, 
         PortfolioID      INT, 
         CompanyContactID INT, 
         CompanyName      VARCHAR(600)
        );
        WHILE @Cnt <= @TotCnt
            BEGIN
                DECLARE @locVehicleID AS INT;
                SELECT @locVehicleID = VehicleID
                FROM @tblFund
                WHERE RowNum = @Cnt;
                INSERT INTO #PFDetails
                EXEC dbo.Proc_portfolio_list_report_get 
                     @locVehicleID;
                SELECT @Cnt = @Cnt + 1;
                INSERT INTO #FundDetails
                       SELECT @locVehicleID, 
                              PortfolioID, 
                              CompanyContactID, 
                              CompanyName
                       FROM #PFDetails;
            END;
        SELECT FD.VehicleID, 
               Name, 
               PortfolioID, 
               CompanyContactID, 
               CompanyName
        FROM #FundDetails FD
             LEFT JOIN tbl_Vehicle tv ON FD.VehicleID = tv.VehicleID;
        DROP TABLE #PFDetails;
        DROP TABLE #FundDetails;
        SET NOCOUNT OFF;
    END;
