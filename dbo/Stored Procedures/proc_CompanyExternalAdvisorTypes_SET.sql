CREATE PROCEDURE [dbo].[proc_CompanyExternalAdvisorTypes_SET] @CompanyID               INT, 
                                                              @ExternalAdvisorTypesID  VARCHAR(1000), 
                                                              @ExternalAdvisorCost     FLOAT, 
                                                              @ExternalAdvisorCostType NCHAR(10), 
                                                              @ExternalAdvisorCurrency NVARCHAR(50)
AS
    BEGIN
        DELETE FROM tbl_CompanyContactExternalAdvisors
        WHERE CompanyID = @CompanyID;
        INSERT INTO tbl_CompanyContactExternalAdvisors
        (CompanyID, 
         ExternalAdvisorCost, 
         ExternalAdvisorCostType, 
         ExternalAdvisorCurrency, 
         ExternalAdvisorTypeID
        )
               SELECT @CompanyID, 
                      @ExternalAdvisorCost, 
                      @ExternalAdvisorCostType, 
                      @ExternalAdvisorCurrency, 
                      items
               FROM SplitCSV(@ExternalAdvisorTypesID, ',');
    END;
