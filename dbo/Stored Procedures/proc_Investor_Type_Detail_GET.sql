CREATE PROCEDURE [dbo].[proc_Investor_Type_Detail_GET] --257,true,false

@ObjectTypeID INT = NULL, 
@IsCompany    BIT = NULL, 
@IsIndividual BIT = NULL
AS
     DECLARE @InvestorTypeDetailID INT= NULL;
    BEGIN
        SELECT [InvestorTypeDetailID], 
               [InvestorTypeID], 
               [ObjectTypeID], 
               [IsCompany], 
               [IsIndividual]
        FROM tbl_InvestorTypeDetail
        WHERE ObjectTypeID = ISNULL(@ObjectTypeID, ObjectTypeID)
              AND IsIndividual = ISNULL(@IsIndividual, IsIndividual)
              AND IsCompany = ISNULL(@IsCompany, IsCompany);
    END;
