CREATE PROCEDURE [dbo].[proc_Vehicle_Strategy_Investment_Criteria_GET] --1
@VehicleID INT          = NULL, 
@RoleName  VARCHAR(100) = NULL
AS
    BEGIN
        SELECT [CriteriaID], 
               tbl_Vehicle_Strategy_Investment_Criteria.VehicleID, 
               [IsAndOr], 
               [ConditionSign], 
               tbl_Vehicle_Strategy_Investment_Criteria.InvestmentTypeID, 
               tbl_Vehicle_Strategy_Investment_Criteria.CurrencyID, 
               [Amount], 
               tbl_Currency.CurrencyCode, 
               tbl_InvestmentType.Title, 
               'Type' = CASE tbl_Vehicle_Strategy_Investment_Criteria.InvestmentTypeID
                            WHEN '3'
                            THEN 'employees'
                            ELSE tbl_Currency.CurrencyCode
                        END, 
               tbl_Vehicle_Strategy_Investment_Criteria.CreatedDateTime, 
               tbl_Vehicle_Strategy_Investment_Criteria.ModifiedDateTime, 
               tbl_Vehicle_Strategy_Investment_Criteria.CreatedBy, 
               tbl_Vehicle_Strategy_Investment_Criteria.ModifiedBy, 
               tbl_Vehicle_Strategy_Investment_Criteria.Active
        FROM tbl_Vehicle_Strategy_Investment_Criteria
             LEFT OUTER JOIN tbl_Currency ON tbl_Vehicle_Strategy_Investment_Criteria.CurrencyID = tbl_Currency.CurrencyID
             LEFT OUTER JOIN tbl_InvestmentType ON tbl_Vehicle_Strategy_Investment_Criteria.InvestmentTypeID = tbl_InvestmentType.InvestmentTypeID
        WHERE VehicleID = ISNULL(@VehicleID, VehicleID);
    END;
