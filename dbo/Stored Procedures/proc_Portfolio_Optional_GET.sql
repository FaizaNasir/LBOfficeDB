
/********************************************************************
** Name			    :	[proc_Portfolio_Optional_GET]
** Author			    :	Faisal Ashraf
** Create Date		    :	12 Dec, 2015
** 
** Description / Page   :	Portfolio - Get optional info 
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_Optional_GET] @PortfolioID INT
AS
    BEGIN
        SELECT PortfolioOptionalID, 
               PortfolioID, 
               DealTypeID, 
               InvestmentBackgroundID, 
               InvestmentBackgroundNotes, 
               DealThesis, 
               ExitExpectations, 
               IsCommunicated, 
               EnviornmentalRisks, 
               SoicalRisks, 
               GovernanceRisks, 
               MeasureTaken, 
               InvestmentRiskAssessment, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_PortfolioOptional;
    END;
