CREATE PROC [dbo].[DeleteFund](@VehicleID INT)
AS
    BEGIN
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioVehicle
            WHERE VehicleID = @VehicleID
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, first you have to delete the portfolio companies of that fund' Msg;
                RETURN;
        END;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioShareholdingOperations
            WHERE((ToID = @VehicleID
                   AND ToTypeID = 3)
                  OR (FromID = @VehicleID
                      AND FromTypeID = 3))
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, this fund is involved in some operations. First delete those operations before deleting the fund itself' Msg;
                RETURN;
        END;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfoliogeneralOperation
            WHERE((ToID = @VehicleID
                   AND ToModuleID = 3)
                  OR (FromID = @VehicleID
                      AND FromModuleID = 3))
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, this fund is involved in some operations. First delete those operations before deleting the fund itself' Msg;
                RETURN;
        END;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_PortfolioFundGeneralOperation
            WHERE((ToID = @VehicleID
                   AND ToModuleID = 3)
                  OR (FromID = @VehicleID
                      AND FromModuleID = 3))
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, this fund is involved in some operations. First delete those operations before deleting the fund itself' Msg;
                RETURN;
        END;
        IF EXISTS
        (
            SELECT TOP 1 1
            FROM tbl_VehiclePortfolioFund
            WHERE VehicleID = @VehicleID
        )
            BEGIN
                SELECT 0 Result, 
                       'Sorry, this fund have one or more portfolio fund. First delete those portfolio fund before deleting the fund itself' Msg;
                RETURN;
        END;
        DELETE FROM tbl_FundBusinessAreaAllocation
        WHERE FundID = @vehicleID;
        DELETE FROM tbl_portfoliofundnav
        WHERE VehicleID = @vehicleID;
        DELETE FROM tbl_CommitmentFundShare
        WHERE FundShareID IN
        (
            SELECT FundShareID
            FROM tbl_FundShare
            WHERE FundID = @vehicleID
        );
        DELETE FROM tbl_CommitmentTransferFundShare
        WHERE FundShareID IN
        (
            SELECT FundShareID
            FROM tbl_FundShare
            WHERE FundID = @vehicleID
        );
        DELETE FROM tbl_CommitmentTransferFundShare
        WHERE ToShareID IN
        (
            SELECT FundShareID
            FROM tbl_FundShare
            WHERE FundID = @vehicleID
        );
        DELETE FROM tbl_PortfolioVehicle
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_DealVehicle
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_FundNavDetails
        WHERE ShareID IN
        (
            SELECT FundShareID
            FROM tbl_FundShare
            WHERE FundID = @vehicleID
        );
        DELETE FROM tbl_FundShare
        WHERE FundID = @vehicleID;
        DELETE FROM tbl_FundNav
        WHERE FundID = @vehicleID;
        DELETE FROM tbl_FundDistributionSequence
        WHERE FundID = @vehicleID;
        DELETE FROM tbl_VehicleCarriedIntreset
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleBankDetails
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleActivity
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_Vehicle_Strategy_Investment_Criteria
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_SubVehicles
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleQuarterlyUpdates
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleManagement
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleLegal
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleHurdleRate
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleCatchUp
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_PortfolioShareholdingOperations
        WHERE((FromID = @vehicleID
               AND FromTypeID = 3)
              OR (ToID = @vehicleID
                  AND ToTypeID = 3));
        DELETE FROM tbl_PortfolioGeneralOperation
        WHERE((FromID = @vehicleID
               AND FromModuleID = 3)
              OR (ToID = @vehicleID
                  AND ToModuleID = 3));
        DELETE FROM tbl_Shareholders
        WHERE ModuleID = 3
              AND ObjectID = @vehicleID;
        DELETE FROM tbl_VehicleStrategyRegion
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleStrategyPortfolioSize
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleStrategyDealType
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleStrategyFinancialInstrument
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleStrategyCountry
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleStrategyAssetType
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleShareDetail
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleShare
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleTeam
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehicleStrategySector
        WHERE vehicleID = @vehicleID;
        DELETE FROM tbl_VehiclePortfolioFund
        WHERE PortfolioFundID = @vehicleID;
        DELETE FROM tbl_Vehicle
        WHERE vehicleID = @vehicleID;
        SELECT 1 Result, 
               '' Msg;
    END;
