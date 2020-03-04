CREATE PROCEDURE [dbo].[proc_ContactInvestor_GET] --1,198,'Companies'
@RoleID       INT, 
@InvestorID   INT          = NULL, 
@InvestorType VARCHAR(100)
AS
    BEGIN
        SELECT I.*, 
               IL.InvestorBankIntrestStatus AS InvestorStatus, 
               IL.InvectorBankIntrestDate AS InvestorBankIntrestDate, 
               InvestorBankComments
        FROM tbl_InvestorBankAppetite I
             LEFT JOIN tbl_InvestorBankIntrestLogs IL ON I.InvestorBankIndividualID = IL.InvestorID
        WHERE I.InvestorBankIndividualID = @InvestorID
              AND I.InvestorType = @InvestorType;
    END;
