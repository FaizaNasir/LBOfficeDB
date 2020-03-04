
-- created date : 18-Dec, 2013    
-- created by : Syed Zain Ali    
-- [proc_get_DealFundNegativeInvestor] 49    

CREATE PROC [dbo].[proc_get_DealFundNegativeInvestor](@dealID INT)
AS
    BEGIN
        SELECT c.CompanyContactID, 
               c.CompanyName
        FROM tbl_DealFundNegativeInvestor di
             JOIN tbl_companycontact c ON c.companycontactid = di.CompanyContactID
        WHERE di.DealID = @dealID;
    END;
