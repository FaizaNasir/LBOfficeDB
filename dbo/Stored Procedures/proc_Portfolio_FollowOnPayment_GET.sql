
/********************************************************************

** Name			    :	[proc_Portfolio_FollowOnPayment_GET]

** Author			    :	Zain Ali

** Create Date		    :	22 Jun, 2014

** 

** Description / Page   :	Portfolio - Get Security follow on payments

**

**

********************************************************************

** Change History

**

**      Date		    Author		Description	

** --   --------	    ------		------------------------------------

** 01   4 July, 2014    Zain Ali		Add Created Date Column

********************************************************************/

CREATE PROCEDURE [dbo].[proc_Portfolio_FollowOnPayment_GET] @ShareholdingOperationID INT = NULL
AS
    BEGIN
        SELECT FollowOnPaymentID, 
               ShareholdingOperationID, 
               Date, 
               AmountDue, 
               Active, 
               CreatedDateTime, 
               ModifiedDateTime, 
               CreatedBy, 
               ModifiedBy, 
               AmountDueFx
        FROM tbl_PortfolioFollowOnPayment
        WHERE ShareholdingOperationID = ISNULL(@ShareholdingOperationID, ShareholdingOperationID);
    END;
