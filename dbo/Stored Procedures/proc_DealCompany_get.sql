CREATE PROC [dbo].[proc_DealCompany_get](@dealID INT)
AS
    BEGIN
        SELECT DealCompanyID, 
               DealID, 
               CompanyID, 
               CompanyName
        FROM tbl_dealcompany dc
             JOIN tbl_companycontact c ON dc.companyid = c.companycontactid
                                          AND dc.DealID = @dealID;
    END;
