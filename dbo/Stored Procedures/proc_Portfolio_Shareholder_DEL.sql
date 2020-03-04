
--[proc_Portfolio_Shareholder_DEL] 370,true  
CREATE PROCEDURE [dbo].[proc_Portfolio_Shareholder_DEL] @TargetPortfolioID INT, 
                                                        @IsUpdate          BIT = 0
AS
     IF(@IsUpdate = 1)
         BEGIN
             DELETE FROM [tbl_Shareholders]
             WHERE TargetPortfolioID = @TargetPortfolioID
                   AND ModuleID IN(4, 5);
     END;
         ELSE
         BEGIN
             DELETE FROM [tbl_Shareholders]
             WHERE TargetPortfolioID = @TargetPortfolioID;
     END;
     SELECT 1 AS 'Column1';
