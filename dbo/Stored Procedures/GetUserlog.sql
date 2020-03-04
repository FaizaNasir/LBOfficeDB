CREATE PROC [dbo].[GetUserlog]
(@dateFrom DATETIME, 
 @datTo    DATETIME, 
 @user     VARCHAR(1000)
)
AS
    BEGIN
        IF @user = '0'
            SET @user = NULL;
        SET @dateFrom = CONVERT(VARCHAR(12), @dateFrom, 107) + ' 00:00:00';
        SET @datTo = CONVERT(VARCHAR(12), @datTo, 107) + ' 23:59:59';
        SELECT UserLogID, 
               UserName, 
               Login, 
               Logout
        FROM tbl_userlog
        WHERE login BETWEEN @dateFrom AND @datTo
              AND username = ISNULL(@user, username);
    END;
