CREATE PROCEDURE [dbo].[proc_Get_Target_Details] @DealID         INT, 
                                                 @ModuleObjectID INT
AS
    BEGIN
        SELECT [DeallTargetID], 
               [DealID], 
               ModuleObjectID, 
               [Active], 
               [CreatedDateTime], 
               [Description], 
               DescriptionFr, 
               [Strengths], 
               [Weaknesses], 
               [Opportunities], 
               [Threats], 
               IsMain
        FROM [tbl_DealTarget]
        WHERE ModuleObjectID = @ModuleObjectID;
    END;
