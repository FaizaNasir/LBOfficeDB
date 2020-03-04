CREATE PROCEDURE [dbo].[proc_ProtfolioFund_SET] @VehicleID       INT, 
                                                @ProtfolioFundID INT
AS
     INSERT INTO [tbl_VehiclePortfolioFund]
     (VehicleID, 
      PortfolioFundID
     )
     VALUES
     (@VehicleID, 
      @ProtfolioFundID
     );
     RETURN;
