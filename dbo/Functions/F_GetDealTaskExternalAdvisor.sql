CREATE FUNCTION [dbo].[F_GetDealTaskExternalAdvisor]
(@DealID INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @VouvherNo VARCHAR(MAX);
         SELECT @VouvherNo = COALESCE(@VouvherNo + ' , ', '') + CC.CompanyName
         FROM tbl_TaskLinked TL
              JOIN tbl_Tasks AS T ON TL.Taskid = T.TaskID
                                     AND TL.ModuleID = 6
              JOIN tbl_CompanyContact AS CC ON T.ExternalAdvisorsID = CC.CompanyContactID
         WHERE TL.ObjectID = @DealID;
         RETURN @VouvherNo;
     END;
