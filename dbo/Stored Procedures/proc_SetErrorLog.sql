
-- proc_GetPortfolioInfoByIsin ''      

CREATE PROC [dbo].[proc_SetErrorLog]
(@msg       VARCHAR(MAX), 
 @CreatedBy VARCHAR(100)
)
AS
    BEGIN
        INSERT INTO tbl_errorlog
        (Message, 
         CreatedBy, 
         CreatedDateTime
        )
               SELECT @msg, 
                      @CreatedBy, 
                      GETDATE();
        SELECT 1;
    END;
