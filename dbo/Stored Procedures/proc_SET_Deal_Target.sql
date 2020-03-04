CREATE PROCEDURE [dbo].[proc_SET_Deal_Target] @DeallTargetID      INT, 
                                              @DealID             INT, 
                                              @moduleobjectID     INT          = NULL, 
                                              @TargetBusinessDesc VARCHAR(MAX), 
                                              @TargetTypeID       INT, 
                                              @countryID          INT, 
                                              @activityID         INT, 
                                              @isMain             BIT
AS
     IF NOT EXISTS
     (
         SELECT 1
         FROM tbl_DealTarget
         WHERE DealID = @DealID
               AND moduleobjectID = @moduleobjectID
     )
         BEGIN
             INSERT INTO [tbl_DealTarget]
             ([DealID], 
              [moduleobjectID], 
              [Active], 
              [CreatedDateTime]
             )
             VALUES
             (@DealID, 
              @moduleobjectID, 
              1, 
              GETDATE()
             );
     END;
         ELSE
         BEGIN
             UPDATE [tbl_DealTarget]
               SET 
                   moduleobjectID = @moduleobjectID
             WHERE DeallTargetID = ISNULL(@DeallTargetID, DeallTargetID)
                   AND DealID = @DealID
                   AND moduleobjectID = @moduleobjectID;
     END;
     SET @DeallTargetID = SCOPE_IDENTITY();
     UPDATE [dbo].[tbl_CompanyContact]
       SET 
           CompanyBusinessDesc = @targetBusinessDesc, 
           CompanyBusinessAreaID = ISNULL(@TargetTypeID, CompanyBusinessAreaID)
     WHERE CompanyContactID = @moduleobjectID;
     IF @countryID IS NOT NULL
         BEGIN
             UPDATE tbl_companyoffice
               SET 
                   ismain = 0
             WHERE companycontactid = @moduleobjectID;
             IF EXISTS
             (
                 SELECT TOP 1 1
                 FROM tbl_companyoffice
                 WHERE companycontactid = @moduleobjectID
                       AND countryid = @countryID
             )
                 BEGIN
                     UPDATE tbl_companyoffice
                       SET 
                           ismain = 1
                     WHERE OfficeID =
                     (
                         SELECT TOP 1 OfficeID
                         FROM tbl_companyoffice
                         WHERE companycontactid = @moduleobjectID
                               AND countryid = @countryID
                     );
             END;
                 ELSE
                 BEGIN
                     INSERT INTO tbl_companyoffice
                     (CompanyContactID, 
                      CountryID, 
                      IsMain
                     )
                            SELECT @moduleobjectID, 
                                   @countryID, 
                                   1;
             END;
     END;
     SELECT 'Success' AS Result, 
            @DeallTargetID DeallTargetID;
