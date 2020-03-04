
/********************************************************************
** Name			    :	[proc_Portfolio_LegalEvent_GET]
** Author			    :	Naveed Bashani
** Create Date		    :	12 Dec, 2013
** 
** Description / Page   :	Portfolio - Legal event get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
** 01   22 Dec, 2013    Zain Ali		Add created date column
** 02   4 Mar, 2014	    Faisal ashraf	Add new parameters for portfolio id
********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_LegalEvent_GET] @PortfolioID INT = NULL
AS
    BEGIN
        SELECT PortfolioLegalEventID, 
               Date, 
               DateTime, 
               Username,
               CASE
                   WHEN TypeID = 1
                   THEN 'Board meeting'
                   WHEN TypeID = 2
                   THEN 'Breach of covenants'
                   WHEN TypeID = 3
                   THEN 'Court case'
                   WHEN TypeID = 4
                   THEN 'General assembly'
                   ELSE ''
               END AS 'EventType', 
               Comments, 
               PortfolioID, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy
        FROM tbl_PortfolioLegalEvent
        WHERE PortfolioID = ISNULL(@PortfolioID, PortfolioID);
    END;
