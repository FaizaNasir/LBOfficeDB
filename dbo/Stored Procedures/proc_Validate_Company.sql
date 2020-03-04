CREATE PROCEDURE [dbo].[proc_Validate_Company] --'Alpen Capital','abc,street and  road'

@CompanyName VARCHAR(100), 
@Address     VARCHAR(100) = NULL
AS
    BEGIN

        --select * from tbl_CompanyContact
        --SELECT 'Success' as Result,'NA' as ResultDescription
        --Return
        --	DECLARE @FullName varchar(100)
        --	SET @FullName = ISNULL(@CompanyName,'#') + ',' + ISNULL(@Address,'#') 
        --IF Exists(Select 1 FROM tbl_CompanyContact WHERE  ISNULL(CompanyName,'#') + ',' + ISNULL(CompanyAddress,'#') = @FullName)
        --BEGIN
        --	DECLARE @CompanyID int=NULL,@CompanyAddress varchar(100)=NULL
        --	SELECT @CompanyID =CompanyContactID,@CompanyAddress=CompanyAddress 
        --	FROM tbl_CompanyContact 
        --	WHERE  ISNULL(CompanyName,'#') + ',' + ISNULL(CompanyAddress,'#') = @FullName
        --	IF(@CompanyAddress  IS NULL AND @Address IS NULL)
        --	BEGIN
        --		SELECT 'Fail' as Result,'Please provide address as company with out address already exists' as ResultDescription
        --		RETURN
        --	END
        --	IF(@CompanyAddress  IS NOT NULL AND @Address IS NOT NULL)
        --	BEGIN
        --		IF EXISTS(Select 1 from tbl_CompanyContact WHERE  CompanyContactID=@CompanyID AND CompanyAddress = @Address)
        --		BEGIN
        --			SELECT 'Fail' as Result,'company with same  address already exists' as ResultDescription
        --		RETURN
        --		END
        --	END
        --	SELECT 'Success' as Result,'NA' as ResultDescription	
        --END

        IF EXISTS
        (
            SELECT 1
            FROM tbl_CompanyContact
            WHERE CompanyName = @CompanyName
        )
            BEGIN
                SELECT 'Fail' AS Result, 
                       'Sorry, a company contact already exists under the same name' AS ResultDescription;
        END;
            ELSE
            SELECT 'Success' AS Result, 
                   'NA' AS ResultDescription;
    END;
