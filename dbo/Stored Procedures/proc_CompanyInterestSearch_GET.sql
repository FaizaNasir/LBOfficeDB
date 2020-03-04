CREATE PROCEDURE [dbo].[proc_CompanyInterestSearch_GET]
(@RoleID                 VARCHAR(MAX), 
 @Gernal                 VARCHAR(1000) = NULL, 
 @CompanyTypeIDs         VARCHAR(1000) = NULL, 
 @ExternalAdvisorTypeIDs VARCHAR(1000) = NULL, 
 @CompanyCountryID       VARCHAR(1000) = NULL, 
 @CompanyIndustryID      VARCHAR(1000) = NULL, 
 @CompanyCityID          VARCHAR(1000) = NULL, 
 @CompanySectorID        VARCHAR(1000) = NULL, 
 @CompanyInvestorTypeID  VARCHAR(1000) = NULL, 
 @Character              VARCHAR(10)   = NULL, 
 @interestSector         VARCHAR(1000) = NULL, 
 @interestAsset          VARCHAR(1000) = NULL, 
 @interestRegion         VARCHAR(1000) = NULL, 
 @interestCountry        VARCHAR(1000) = NULL, 
 @interestDealSizeFrom   INT           = NULL, 
 @interestDealSizeTo     INT           = NULL
)
AS
     IF @interestSector = ''
         SET @interestSector = NULL;
     IF @interestAsset = ''
         SET @interestAsset = NULL;
     IF @interestRegion = ''
         SET @interestRegion = NULL;
     IF @interestCountry = ''
         SET @interestCountry = NULL;
     IF @interestDealSizeFrom = ''
         SET @interestDealSizeFrom = NULL;
     IF @interestDealSizeTo = ''
         SET @interestDealSizeTo = NULL;
     DECLARE @temp TABLE
     (CompanyContactID                INT, 
      CompanyLogo                     VARCHAR(MAX), 
      ExternalAdvisorTypeID           INT, 
      CompanyCountryID                INT, 
      CompanyCityID                   INT, 
      CompanyStatus                   VARCHAR(100), 
      CompanyIndustryID               INT, 
      CompanyBusinessAreaID           INT, 
      CompanyBusinessDesc             VARCHAR(5000), 
      CompanyName                     VARCHAR(100), 
      CompanyWebSite                  VARCHAR(100), 
      CompanyAddress                  VARCHAR(100), 
      CompanyZip                      VARCHAR(100), 
      CompanyPOBox                    VARCHAR(100), 
      CompanyPhone                    VARCHAR(100), 
      CompanyFax                      VARCHAR(100), 
      CompanyCreationDate             DATETIME, 
      CompanyCreatedDate              DATETIME, 
      CompanyStartCollaborationDate   DATETIME, 
      CompanyActivity                 VARCHAR(100), 
      CompanyLinkedIn                 VARCHAR(100), 
      CompanyFacebook                 VARCHAR(100), 
      CompanyTwitter                  VARCHAR(100), 
      CompanyComments                 VARCHAR(5000), 
      StateId                         INT, 
      StateTitle                      VARCHAR(100), 
      CompanyType                     VARCHAR(1000), 
      CompanyMainContact              VARCHAR(50), 
      CompanyMainIndividualID         INT, 
      CompanyMainContactPosition      VARCHAR(50), 
      CompanyMainContactBusinessEmail VARCHAR(100), 
      CountryCode                     VARCHAR(100), 
      canEdit                         BIT
     );
     INSERT INTO @temp
     EXEC dbo.[proc_CompanySearch_GET] 
          @RoleID, 
          @Gernal, 
          @CompanyTypeIDs, 
          @ExternalAdvisorTypeIDs, 
          @CompanyCountryID, 
          @CompanyIndustryID, 
          @CompanyCityID, 
          @CompanySectorID, 
          @CompanyInvestorTypeID, 
          @Character;             
     --    return         
     SELECT DISTINCT 
            C.*
     FROM @temp C
          LEFT JOIN tbl_InterestAppetiteAssetTypePreference iaatp ON iaatp.ObjectID = C.CompanyContactID
                                                                     AND iaatp.IsCompany = 0
          LEFT JOIN tbl_InterestAppetiteAssetTypePerferenceDetails iaatpd ON iaatpd.InterestAppetiteAssetTypePreferenceID = iaatp.InterestAppetiteAssetTypePreferenceID
          LEFT JOIN tbl_InterestAppetiteGeographyCountry iaagp ON iaagp.ObjectID = C.CompanyContactID
                                                                  AND iaagp.IsCompany = 0
          LEFT JOIN tbl_InterestGeoghraphyCountryDetail iaagpd ON iaagpd.InterestAppetiteGeoghraphyCountryID = iaagp.InterestAppetiteGeoghraphyCountryID
          LEFT JOIN tbl_InterestAppetiteGeographyRegion iaagr ON iaagr.ObjectID = C.CompanyContactID
                                                                 AND iaagr.IsCompany = 0
          LEFT JOIN tbl_InterestGeoghraphyRegionDetail iaagrd ON iaagrd.InterestAppetiteGeoghraphyCountryID = iaagr.InterestAppetiteGeoghraphyRegionID
          LEFT JOIN tbl_InterestAppetiteSectorPreference iaasp ON iaasp.ObjectID = C.CompanyContactID
                                                                  AND iaasp.IsCompany = 0
          LEFT JOIN tbl_SectorPerferenceDetails iaaspd ON iaaspd.AppetiteSectorPerferenceID = iaasp.InterestAppetiteSectorPreferenceID
          LEFT JOIN tbl_InterestAppetiteSizePreference iaads ON iaads.ObjectID = C.CompanyContactID
                                                                AND iaads.IsCompany = 0
     WHERE ISNULL(MinimumInvestmentSize, 0) >= ISNULL(@interestDealSizeFrom, ISNULL(MinimumInvestmentSize, 0))
           AND ISNULL(MaximumInvestmentSize, 0) <= ISNULL(@interestDealSizeTo, ISNULL(MaximumInvestmentSize, 0))            
           --and iaasp.objectid = 254             
           AND 1 = CASE
                       WHEN @interestSector IS NULL
                       THEN 1
                       WHEN iaaspd.SectorPerferenceID IN
     (
         SELECT *
         FROM dbo.[SplitCSV](@interestSector, ',')
     )
                       THEN 1
                   END
          AND 1 = CASE
                      WHEN @interestRegion IS NULL
                      THEN 1
                      WHEN iaagrd.RegionID IN
     (
         SELECT *
         FROM dbo.[SplitCSV](@interestRegion, ',')
     )
                      THEN 1
                  END
     AND 1 = CASE
                 WHEN @interestCountry IS NULL
                 THEN 1
                 WHEN iaagpd.CountryID IN
     (
         SELECT *
         FROM dbo.[SplitCSV](@interestCountry, ',')
     )
                 THEN 1
             END
     AND 1 = CASE
                 WHEN @interestAsset IS NULL
                 THEN 1
                 WHEN iaatpd.AssetTypePerferenceID IN
     (
         SELECT *
         FROM dbo.[SplitCSV](@interestAsset, ',')
     )
                 THEN 1
             END
     ORDER BY c.CompanyName;
