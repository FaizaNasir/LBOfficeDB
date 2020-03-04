CREATE FUNCTION [dbo].[F_LPEmailConfigDetail]
(@id   INT, 
 @isCC BIT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @return_value VARCHAR(MAX);
         SET @return_value =
         (
             SELECT SUBSTRING(
             (
                 SELECT ';' + Email
                 FROM
                 (
                     SELECT DISTINCT 
                            ISNULL(ContactEmailAddressInCompany, i.IndividualEmail) Email
                     FROM tbl_LPEmailConfigDetail config
                          JOIN tbl_ContactIndividual i ON i.individualID = config.contactID
                          LEFT JOIN tbl_companyindividuals ci ON ci.ContactIndividualID = i.IndividualID
                                                                 AND ci.isMainCompany = 1
                     WHERE LPEmailConfigID = @id
                           AND IsCC = @isCC
                 ) t FOR XML PATH('')
             ), 2, 200000)
         );
         RETURN @return_value;
     END;
