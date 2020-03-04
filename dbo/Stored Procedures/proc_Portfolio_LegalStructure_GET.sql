
/********************************************************************
** Name			    :	[proc_Portfolio_LegalStructure_GET]
** Author			    :	Naveed Bashani
** Create Date		    :	22 Dec, 2013
** 
** Description / Page   :	Portfolio - Legal structure get
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_LegalStructure_GET] @Active BIT
AS
    BEGIN
        SELECT [LegalStructureID], 
               [LegalStructureName], 
               [Active], 
               [OrderBy]
        FROM tbl_PortfolioLegalStructure
        WHERE Active = ISNULL(@Active, Active)
        ORDER BY OrderBy ASC;
    END;
