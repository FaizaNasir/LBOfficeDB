CREATE PROCEDURE [dbo].[proc_Investor_Type_GET] @IsCompany    BIT = NULL, 
                                                @IsIndividual BIT = NULL
AS
    BEGIN
        SELECT [InvestorTypeID], 
               [InvestorDesc], 
               [IsCompany], 
               [IsIndividual]
        FROM tbl_InvestorType
        WHERE IsCompany = ISNULL(@IsCompany, IsCompany)
              AND IsIndividual = ISNULL(@IsIndividual, IsIndividual);
    END;
