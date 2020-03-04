
/********************************************************************
** Name			    :	[proc_Activities_ByTargetPortfolioType_GET]
** Author			    :	Naveed Bashani
** Create Date		    :	22 Dec, 2013
** 
** Description / Page   :	Portfolio - Get activities by portfolio type
**
**
********************************************************************
** Change History
**
**      Date		    Author		Description	
** --   --------	    ------		------------------------------------
********************************************************************/

CREATE PROCEDURE [dbo].[proc_Activities_ByTargetPortfolioType_GET] @TargetPortfolioTypeID INT          = NULL, 
                                                                   @RoleName              VARCHAR(100) = NULL
AS
    BEGIN
        SELECT A.[ActiviteID], 
               A.[ActiviteName], 
               A.[Active], 
               A.[PortfolioTargetTypeID]
        FROM tbl_Activities A
        WHERE A.PortfolioTargetTypeID = ISNULL(@TargetPortfolioTypeID, A.PortfolioTargetTypeID)
        ORDER BY [ActiviteName];
    END;
