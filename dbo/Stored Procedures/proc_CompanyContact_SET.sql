-- [proc_CompanyContact_SET] null,'testfaisal',null    

CREATE PROCEDURE [dbo].[proc_CompanyContact_SET] -- 1,'company'    

(@CompanyID                     INT            = NULL, 
 @CompanyName                   VARCHAR(100)   = NULL, 
 @StateID                       INT            = NULL, 
 @CompanyLogo                   VARCHAR(100)   = NULL, 
 @CompanyContactTypes           VARCHAR(100)   = NULL, 
 @ExternalAdvisorTypesID        VARCHAR(1000)  = NULL, 
 @CompanyAddress                VARCHAR(100)   = NULL, 
 @CompanyOfficeGUID             NVARCHAR(225)  = NULL, 
 @CompanyZip                    VARCHAR(100)   = NULL, 
 @CompanyPOBox                  VARCHAR(100)   = NULL, 
 @CompanyCountryID              INT            = NULL, 
 @CompanyCityID                 INT            = NULL, 
 @CompanyCityName               VARCHAR(100)   = NULL, 
 @CompanyPhone                  VARCHAR(100)   = NULL, 
 @CompanyFax                    VARCHAR(100)   = NULL, 
 @CompanyWebSite                VARCHAR(100)   = NULL, 
 @CompanyCreationDate           DATETIME       = NULL, 
 @CompanyStartCollaborationDate DATETIME       = NULL, 
 @CompanyLinkedIn               VARCHAR(100)   = NULL, 
 @CompanyFacebook               VARCHAR(100)   = NULL, 
 @CompanyTwitter                VARCHAR(100)   = NULL, 
 @CompanyStatus                 VARCHAR(100)   = NULL, 
 @CompanyIndustryID             INT            = NULL, 
 @CompanyBusinessAreaID         INT            = NULL, 
 @CompanyBusinessDesc           VARCHAR(5000)  = NULL, 
 @CompanyComments               VARCHAR(5000)  = NULL, 
 @CompanyGeography              VARCHAR(5000)  = NULL, 
 @CompanyAssetsUnderManagement  VARCHAR(5000)  = NULL, 
 @CompanyNbActiveFunds          VARCHAR(5000)  = NULL, 
 @CompanyNbClosedFunds          VARCHAR(5000)  = NULL, 
 @CompanyCurrencies             INT            = NULL, 
 @CompanyNbPortfolioCompanies   VARCHAR(5000)  = NULL, 
 @LPTypeID                      INT, 
 @AccountName                   NVARCHAR(1000)
)
AS
    BEGIN
        DECLARE @NewIDCompnay INT;
        IF(@CompanyID IS NULL)
            BEGIN
                INSERT INTO [tbl_CompanyContact]
                ([CompanyName], 
                 [CompanyLogo], 
                 [CompanyAddress], 
                 [CompanyZip], 
                 [CompanyPOBox], 
                 [CompanyCountryID], 
                 [CompanyCityID], 
                 [CompanyPhone], 
                 [CompanyFax], 
                 [CompanyWebSite], 
                 [CompanyCreationDate], 
                 [CompanyStartCollaborationDate], 
                 [CompanyLinkedIn], 
                 [CompanyFacebook], 
                 [CompanyTwitter], 
                 [CompanyStatus], 
                 [CompanyIndustryID], 
                 [CompanyBusinessAreaID], 
                 [CompanyBusinessDesc], 
                 [CompanyComments], 
                 [stateid], 
                 [CompanyGeography], 
                 [CompanyAssetsUnderManagement], 
                 [CompanyNbActiveFunds], 
                 [CompanyNbClosedFunds], 
                 [CompanyNbPortfolioCompanies], 
                 [CompanyCurrencies], 
                 LPTypeID, 
                 AccountName
                )
                VALUES
                (@CompanyName, 
                 @CompanyLogo, 
                 @CompanyAddress, 
                 @CompanyZip, 
                 @CompanyPOBox, 
                 @CompanyCountryID, 
                 @CompanyCityID, 
                 @CompanyPhone, 
                 @CompanyFax, 
                 @CompanyWebSite, 
                 @CompanyCreationDate, 
                 @CompanyStartCollaborationDate, 
                 @CompanyLinkedIn, 
                 @CompanyFacebook, 
                 @CompanyTwitter, 
                 @CompanyStatus, 
                 @CompanyIndustryID, 
                 @CompanyBusinessAreaID, 
                 @CompanyBusinessDesc, 
                 @CompanyComments, 
                 @StateID, 
                 @CompanyGeography, 
                 @CompanyAssetsUnderManagement, 
                 @CompanyNbActiveFunds, 
                 @CompanyNbClosedFunds, 
                 @CompanyNbPortfolioCompanies, 
                 @CompanyCurrencies, 
                 @LPTypeID, 
                 @AccountName
                );
                SET @NewIDCompnay = @@IDENTITY;
                UPDATE tbl_CompanyOffice
                  SET 
                      CompanyContactID = @NewIDCompnay
                WHERE OfficeNewGuid = @CompanyOfficeGUID;
        END;
            ELSE
            BEGIN
                UPDATE [tbl_CompanyContact]
                  SET 
                      [CompanyName] = @CompanyName, 
                      [CompanyLogo] = @CompanyLogo, 
                      [CompanyAddress] = @CompanyAddress, 
                      [CompanyZip] = @CompanyZip, 
                      [CompanyPOBox] = @CompanyPOBox, 
                      [CompanyCountryID] = @CompanyCountryID, 
                      [CompanyCityID] = @CompanyCityID, 
                      [CompanyPhone] = @CompanyPhone, 
                      [CompanyFax] = @CompanyFax, 
                      [CompanyWebSite] = @CompanyWebSite, 
                      [CompanyCreationDate] = @CompanyCreationDate, 
                      [CompanyStartCollaborationDate] = @CompanyStartCollaborationDate, 
                      [CompanyLinkedIn] = @CompanyLinkedIn, 
                      [CompanyFacebook] = @CompanyFacebook, 
                      [CompanyTwitter] = @CompanyTwitter, 
                      [CompanyStatus] = @CompanyStatus, 
                      [CompanyIndustryID] = @CompanyIndustryID, 
                      [CompanyBusinessAreaID] = @CompanyBusinessAreaID, 
                      [CompanyBusinessDesc] = @CompanyBusinessDesc, 
                      [CompanyComments] = @CompanyComments, 
                      [stateid] = @StateID, 
                      [CompanyGeography] = @CompanyGeography, 
                      [CompanyAssetsUnderManagement] = @CompanyAssetsUnderManagement, 
                      [CompanyNbActiveFunds] = @CompanyNbActiveFunds, 
                      [CompanyNbClosedFunds] = @CompanyNbClosedFunds, 
                      [CompanyNbPortfolioCompanies] = @CompanyNbPortfolioCompanies, 
                      [CompanyCurrencies] = @CompanyCurrencies, 
                      [LPTypeID] = @LPTypeID, 
                      [AccountName] = @AccountName
                WHERE CompanyContactID = @CompanyID;
                SELECT @NewIDCompnay = @CompanyID;
        END;
        IF(@CompanyContactTypes IS NOT NULL)
            BEGIN
                EXEC proc_CompanyContactTypes_SET 
                     @NewIDCompnay, 
                     @CompanyContactTypes;
        END;
        IF(@ExternalAdvisorTypesID IS NOT NULL)
            BEGIN
                EXEC proc_CompanyExternalAdvisorTypes_SET 
                     @NewIDCompnay, 
                     @ExternalAdvisorTypesID, 
                     NULL, 
                     NULL, 
                     NULL;
        END;
        SELECT 'Success' AS Success, 
               @NewIDCompnay AS NewCompanyID;
        RETURN;
    END;
