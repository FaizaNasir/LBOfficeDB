CREATE PROCEDURE [dbo].[proc_FundTeamMemberRole_Get] @key VARCHAR(100)
AS
    BEGIN
        SELECT DISTINCT 
               [Role]
        FROM tbl_FundTeamMembers
        WHERE [Role] LIKE '%' + @key + '%';
    END;
