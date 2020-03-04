CREATE PROC [dbo].[DeleteDeals](@dealID INT)
AS
    BEGIN
        DELETE FROM tbl_DealOptionalDetails
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealSecurity
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealStatusDetails
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealFee
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealCompany
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealFundInvestors
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealTarget
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealBusiness
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealBusinessClients
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealBusinessCompetitors
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealFundNegativeInvestor
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealVehicle
        WHERE dealid = @dealID;
        DELETE FROM tbl_DealTeam
        WHERE dealid = @dealID;
        DELETE FROM tbl_MeetingLinkedTo
        WHERE objectid = @dealID
              AND moduleid = 6;
        DELETE FROM tbl_Deals
        WHERE dealid = @dealID;
        SELECT 1 Result, 
               '' Msg;
    END;
