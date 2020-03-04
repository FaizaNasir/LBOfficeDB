CREATE PROC [dbo].[proc_LPDetail_Get](@LPID INT)
AS
    BEGIN
        SELECT LimitedPartnerDetailID, 
               lpd.ShareID VehicleShareID, 
               ShareName, 
               lpd.Amount, 
               lpd.Active, 
               lpd.CreatedDateTime, 
               lpd.ModifiedDateTime, 
               lpd.CreatedBy, 
               lpd.ModifiedBy
        FROM tbl_LimitedPartnerDetail lpd
             JOIN tbl_VehicleShare vs ON lpd.ShareID = vs.VehicleShareID
        WHERE LimitedPartnerID = @LPID;
    END;
