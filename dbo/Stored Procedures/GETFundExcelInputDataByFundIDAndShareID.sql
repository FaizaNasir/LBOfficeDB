
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--  [GETFundExcelInputDataByFundIDAndShareID] 80,12,1,'08/17/2015'

CREATE PROCEDURE [dbo].[GETFundExcelInputDataByFundIDAndShareID] 
-- Add the parameters for the stored procedure here
@FundID          INT  = NULL, 
@ShareID         INT  = NULL, 
@NAVDistribution INT  = NULL, 
@Date            DATE = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Commitments DECIMAL(18, 8);
        DECLARE @Calls DECIMAL(18, 8);
        DECLARE @IncludingFees DECIMAL(18, 8);
        DECLARE @Distributions DECIMAL(18, 8);
        DECLARE @ReturnOfCapital DECIMAL(18, 8);
        DECLARE @ShareNominalValue NUMERIC(25, 12);
        DECLARE @NumberOfShares DECIMAL(18, 8);
        SELECT @Commitments = SUM(ISNULL(b.Amount, 0))
        FROM tbl_LimitedPartner a
             JOIN tbl_LimitedPartnerDetail b ON a.LimitedPartnerID = b.LimitedPartnerID
        WHERE a.Date <= ISNULL(@Date, a.Date)
              AND a.VehicleID = @FundID
              AND b.ShareID = @ShareID;
        SET @ShareNominalValue =
        (
            SELECT TOP 1 a.NominalValue
            FROM tbl_vehicleshareDetail a
            WHERE a.ShareID = @ShareID
                  AND a.ShareDate <= @date
            ORDER BY a.ShareDate DESC
        );
        PRINT @ShareNominalValue;
        SET @NumberOfShares = @Commitments / @ShareNominalValue;
        SELECT @Calls = SUM(ISNULL(c.InvestmentAmount, 0)) + SUM(ISNULL(c.ManagementFees, 0)) + SUM(ISNULL(c.OtherFees, 0)), 
               @IncludingFees = SUM(ISNULL(c.ManagementFees, 0))
        FROM tbl_CapitalCall a
             JOIN tbl_CapitalCallOperation c ON a.CapitalCallID = c.CapitalCallID
        WHERE a.DueDate <= @Date
              AND a.FundID = @FundID
              AND c.ShareID = @ShareID;
        IF(@NAVDistribution = 1)
            BEGIN
                SELECT @Distributions = SUM(ISNULL(c.TotalDistribution, 0)), 
                       @ReturnOfCapital = SUM(ISNULL(c.ReturnOfCapital, 0))
                FROM tbl_Distribution a
                     JOIN tbl_DistributionOperation c ON a.DistributionID = c.DistributionID
                WHERE a.Date <= @Date
                      AND a.FundID = @FundID
                      AND c.ShareID = @ShareID;
        END;
            ELSE
            BEGIN
                SELECT @Distributions = SUM(ISNULL(c.TotalDistribution, 0)), 
                       @ReturnOfCapital = SUM(ISNULL(c.ReturnOfCapital, 0))
                FROM tbl_Distribution a
                     JOIN tbl_DistributionOperation c ON a.DistributionID = c.DistributionID
                WHERE a.Date < @Date
                      AND a.FundID = @FundID
                      AND c.ShareID = @ShareID;
        END;
        SELECT ISNULL(@Commitments, 0) AS Commitments, 
               ISNULL(@Calls, 0) AS Calls, 
               ISNULL(@IncludingFees, 0) AS IncludingFees, 
               ISNULL(@Distributions, 0) AS Distributions, 
               ISNULL(@ReturnOfCapital, 0) AS ReturnOfCapital, 
               ISNULL(@NumberOfShares, 0) AS NumberOfShares;
    END;
