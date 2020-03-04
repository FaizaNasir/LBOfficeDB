CREATE PROCEDURE [dbo].[proc_tbl_DistributionOperation_GET_By_DistributionID] @DistributionID INT = NULL
AS
    BEGIN
        SELECT s.DistributionOperationID, 
               s.FundID, 
               s.Date, 
               s.Type, 
               s.ShareID, 
               vs.VehicleShareID, 
               vs.ShareName, 
               CAST(InvestmentAmount AS DECIMAL(18, 2)) AS InvestmentAmount, 
               CAST(ManagementFees AS DECIMAL(18, 2)) AS ManagementFees, 
               CAST(OtherFees AS DECIMAL(18, 2)) AS OtherFees, 
               CAST(ReturnOfCapital AS DECIMAL(18, 2)) AS ReturnOfCapital, 
               CAST(Profit AS DECIMAL(18, 2)) AS Profit, 
               CAST(TotalDistribution AS DECIMAL(18, 2)) AS TotalDistribution, 
               CAST(DistributionByShare AS DECIMAL(18, 2)) AS DistributionByShare, 
               S.Active, 
               S.CreatedDateTime, 
               S.ModifiedDateTime, 
               S.CreatedBy, 
               S.ModifiedBy, 
               Undrawn, 
               Recallable
        FROM tbl_DistributionOperation S
             JOIN tbl_vehicleshare vs ON S.ShareID = vs.VehicleShareID
        WHERE S.DistributionID = @DistributionID;
    END;
