
-- select dbo.F_GetStageBeforeLastStage(419)  

CREATE FUNCTION [dbo].[F_GetStageBeforeLastStage]
(@deal INT
)
RETURNS VARCHAR(1000)
AS
     BEGIN
         DECLARE @result VARCHAR(1000);
         SET @result =
         (
             SELECT TOP 1 ProjectStatusTitle
             FROM tbl_DealStatusDetails dd
                  JOIN tbl_DealStatus d ON d.ProjectStatusID = dd.DealStatusID
             WHERE DealID = @deal
                   AND DealStatusDetailsID <
             (
                 SELECT TOP 1 DealStatusDetailsID
                 FROM tbl_DealStatusDetails
                 WHERE DealID = @deal
                 ORDER BY DealStatusDetailsID DESC
             )
             ORDER BY DealStatusDetailsID DESC
         );
         RETURN @result;
     END;
