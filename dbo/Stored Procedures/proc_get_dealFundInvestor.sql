
-- created date : 18-Dec, 2013        
-- created by : Syed Zain Ali        
-- proc_get_dealFundInvestor 114        

CREATE PROC [dbo].[proc_get_dealFundInvestor]
(@dealID         INT, 
 @InvestorTypeID INT
)
AS
    BEGIN
        SELECT di.DealFundInvestorID, 
               di.DealID, 
               di.CompanyContactID, 
               di.InvestorTypeID, 
               di.DealCompanyMainContactID, 
               di.ForecastedAmount, 
               di.ClosedAmount, 
               di.DealFundInvestorStatusID, 
               di.DealFundInvestorNotes, 
               dit.DealInvestorTypeName, 
               di.IsIndividual, 
               di.FundID, 
               c.CompanyName, 
               i.IndividualFullName, 
               i.IndividualFirstName, 
               i.IndividualLastName, 
               i.IndividualID, 
               DealFundInvestorStatusName, 
               mainInd.IndividualID AS MainRMID, 
               mainInd.IndividualFullName AS MainRMName, 
               CreatedBy, 
               ModifiedBy, 
               di.CreatedDateTime, 
               di.ModifiedDateTime
        FROM tbl_DealFundInvestors di
             LEFT JOIN tbl_companycontact c ON c.companycontactid = di.CompanyContactID
             LEFT JOIN tbl_contactindividual i ON di.DealCompanyMainContactID = i.IndividualID
             LEFT JOIN tbl_dealinvestortype dit ON dit.DealInvestorTypeID = di.InvestorTypeID
             LEFT JOIN tbl_dealfundinvestorstatus dfis ON dfis.DealFundInvestorStatusID = di.DealFundInvestorStatusID
             LEFT JOIN tbl_ContactIndividualRM dt ON dt.IndividualID = i.IndividualID
                                                     AND dt.IsMain = 1
             LEFT JOIN tbl_contactindividual mainInd ON mainInd.IndividualID = dt.ManagementCompanyIndividualID
        WHERE di.dealid = @dealid
              AND di.InvestorTypeID = @InvestorTypeID;
    END;
