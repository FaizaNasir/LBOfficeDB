CREATE PROC [dbo].[proc_get_dealType](@activityID INT)
AS
    BEGIN
        SELECT DISTINCT 
               ProjectTypeID, 
               ProjectTypeTitle, 
               ProjectTypeDesc, 
               ProjectTypeTitleFr
        FROM tbl_dealtype dt
             JOIN tbl_DealTypeActivity dta ON dta.dealtypeid = dt.projecttypeid
        WHERE dta.activityid = ISNULL(@activityID, dta.activityid)
              AND dta.Active = 1
        ORDER BY ProjectTypeTitle;
    END;
