
-- created by : syed zain ali  
-- created date : 10-Dec-2013  
-- [proc_Get_DealExternalTask]  

CREATE PROC [dbo].[proc_Get_DealExternalTask](@dealID INT)
AS
    BEGIN
        SELECT t.TaskID, 
               TaskName, 
               TaskComments, 
               StartingDateTime, 
               EndDateTime, 
               ExternalAdvisorsID, 
               0 PortfolioTargetTypeID, 
               DealCurrentTargetID, 
               CompanyName
        FROM tbl_tasks t
             JOIN tbl_tasklinked tl ON t.taskid = tl.taskid
             JOIN tbl_deals d ON d.dealid = tl.objectid
             JOIN tbl_companycontact c ON c.CompanyContactID = t.ExternalAdvisorsID
        WHERE moduleid = 6
              AND objectid = @dealID
              AND t.ExternalAdvisorsID IS NOT NULL;
    END;
