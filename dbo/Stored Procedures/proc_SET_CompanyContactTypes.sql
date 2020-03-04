
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  

CREATE PROCEDURE [dbo].[proc_SET_CompanyContactTypes] @CompanyContactID INT = NULL, 
                                                      @ContactTypeID    INT = NULL
AS
    BEGIN
        INSERT INTO tbl_CompanyContactType
        (CompanyContactID, 
         ContactTypeID
        )
        VALUES
        (@CompanyContactID, 
         @ContactTypeID
        );
        SELECT 'Success' AS Result, 
               @ContactTypeID AS ContactTypeID, 
               @CompanyContactID AS 'CompanyContactID';
    END;
