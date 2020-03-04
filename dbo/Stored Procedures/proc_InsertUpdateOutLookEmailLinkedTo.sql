CREATE PROC [dbo].[proc_InsertUpdateOutLookEmailLinkedTo]
(@EmailID   INT, 
 @ObjectID  INT, 
 @ModuleID  INT, 
 @IsEmailTo BIT
)
AS
    BEGIN
        INSERT INTO tbl_OutlookEmailLinkedTo
        (EmailID, 
         ObjectID, 
         ModuleID, 
         IsEmailTo
        )
               SELECT @EmailID, 
                      @ObjectID, 
                      @ModuleID, 
                      @IsEmailTo;
        SELECT SCOPE_IDENTITY() Result;
    END;
