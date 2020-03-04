CREATE PROCEDURE [dbo].[proc_TaskLinked_SET]
(@TaskID            INT, 
 @ModuleID          INT, 
 @ObjectID          INT, 
 @isExternalAdvisor BIT, 
 @IsMCUser          BIT
)
AS          
    --BEGIN          
    --IF(@TaskID is null)          
    BEGIN
        INSERT INTO [dbo].[tbl_TaskLinked]
        (TaskID, 
         ModuleID, 
         ObjectID, 
         IsExternalAdvisor, 
         ismcuser
        )
        VALUES
        (@TaskID, 
         @ModuleID, 
         @ObjectID, 
         @isExternalAdvisor, 
         @IsMCUser
        );
        SET @TaskID =
        (
            SELECT SCOPE_IDENTITY()
        );

        --END          
        --ELSE          
        --BEGIN          
        --  UPDATE  [dbo].[tbl_TaskLinked]          
        --     SET            
        --  TaskID = @TaskID, ModuleID = @ModuleID, ObjectID = @ObjectID,        
        --  IsExternalAdvisor = @IsExternalAdvisor          
        --  WHERE TaskID = @TaskID       
        --  and ModuleID = isnull(@ModuleID,ModuleID)      
        --  and ObjectID = isnull(@ObjectID,ObjectID)      
        --  and IsExternalAdvisor = isnull(@IsExternalAdvisor,IsExternalAdvisor)    
        --  and IsMCUser = isnull(@IsMCUser,IsMCUser)      
        --END          
        SELECT 'Success' AS Success, 
               @TaskID AS TaskID;
    END;
