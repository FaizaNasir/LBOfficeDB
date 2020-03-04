
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--  [GETFundExcelCashFlowByFundID] 72,1,1,'2/2/2017'

CREATE PROCEDURE [dbo].[GETFundExcelCashFlowByFundIDandShareID]

-- Add the parameters for the stored procedure here

@FundID          INT  = NULL, 
@IsNew           INT  = NULL, 
@NAVDistribution INT  = NULL, 
@Date            DATE = NULL, 
@ShareID         INT  = NULL
AS
    BEGIN

        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.

        SET NOCOUNT ON;
        DECLARE @returnDate TABLE
        (Amount    DECIMAL(18, 2), 
         Date      DATE, 
         ShareName VARCHAR(100)
        );
        INSERT INTO @returnDate
               SELECT SUM(ISNULL(c.InvestmentAmount, 0)) + SUM(ISNULL(c.ManagementFees, 0)) + SUM(ISNULL(c.OtherFees, 0)) AS Amount, 
                      a.DueDate AS Date, 
                      d.ShareName
               FROM tbl_CapitalCall a
                    JOIN tbl_CapitalCallOperation c ON a.CapitalCallID = c.CapitalCallID
                    JOIN tbl_vehicleshare d ON c.ShareID = d.VehicleShareID
               WHERE a.DueDate < @Date
                     AND a.FundID = @FundID
                     AND d.VehicleShareID = @ShareID
                     AND d.Hurdle = 1
               GROUP BY a.DueDate, 
                        d.ShareName;
        INSERT INTO @returnDate
               SELECT -(SUM(ISNULL(c.TotalDistribution, 0))) AS Amount, 
                     a.date AS Date,
                     d.ShareName
               FROM tbl_Distribution a
                    JOIN tbl_DistributionOperation c ON a.DistributionID = c.DistributionID
                    JOIN tbl_vehicleshare d ON c.ShareID = d.VehicleShareID
               WHERE a.Date < @Date
                     AND a.FundID = @FundID
                     AND d.VehicleShareID = @ShareID
                     AND d.Hurdle = 1
               GROUP BY a.date, 
                        d.ShareName;
        SELECT *
        FROM @returnDate
        --WHERE Amount > 0
        ORDER BY ShareName, 
                 Date;
    END;

