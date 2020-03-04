
-- created by	:	Syed Zain Ali  

CREATE PROC [dbo].[proc_get_all_link_to_companies_task]
AS
     SELECT DISTINCT 
            ci.CompanyContactID, 
            ci.CompanyName
     FROM tbl_TaskLinked tl
          JOIN tbl_CompanyContact ci ON tl.ObjectID = ci.CompanyContactID
     ORDER BY ci.CompanyName;
