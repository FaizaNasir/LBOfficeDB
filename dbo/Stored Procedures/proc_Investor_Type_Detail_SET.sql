CREATE PROCEDURE [dbo].[proc_Investor_Type_Detail_SET] --1,1,false,false  

@InvestorTypeID INT = NULL, 
@ObjectTypeID   INT = NULL, 
@IsCompany      BIT = NULL, 
@IsIndividual   BIT = NULL
AS
     DECLARE @InvestorTypeDetailID INT;
    BEGIN  
        --DELETE FROM tbl_InvestorTypeDetail WHERE ObjectTypeID=@ObjectTypeID  
        INSERT INTO tbl_InvestorTypeDetail
        (InvestorTypeID, 
         ObjectTypeID, 
         IsCompany, 
         IsIndividual
        )
        VALUES
        (@InvestorTypeID, 
         @ObjectTypeID, 
         @IsCompany, 
         @IsIndividual
        );
        SET @InvestorTypeDetailID = @@IDENTITY;
        SELECT 'Success' AS Result, 
               @InvestorTypeDetailID AS 'InvestorTypeDetailID';
    END;  
