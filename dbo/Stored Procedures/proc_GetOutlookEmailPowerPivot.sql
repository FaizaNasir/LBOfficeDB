CREATE PROC [dbo].[proc_GetOutlookEmailPowerPivot]
AS
     SELECT Subject, 
            Body, 
            HTMLBody, 
            ind.individualFullName, 
            Attachments, 
            ReceivedTime, 
            ISNULL(CC, '') CC, 
            ISNULL(BCC, '') BCC, 
            ISNULL(
     (
         SELECT SUBSTRING(
         (
             SELECT ',' + i.IndividualFullName
             FROM tbl_outlookemailLinkedTo s
                  JOIN tbl_contactindividual i ON i.individualid = s.objectid
             WHERE s.emailid = e.emailid
                   AND s.moduleid = 4
                   AND IsEmailTo = 1
             ORDER BY i.IndividualFullName FOR XML PATH('')
         ), 2, 200000)
     ), '') AS [To], 
            ISNULL(
     (
         SELECT SUBSTRING(
         (
             SELECT ',' + i.IndividualFullName
             FROM tbl_outlookemailLinkedTo s
                  JOIN tbl_contactindividual i ON i.individualid = s.objectid
             WHERE s.emailid = e.emailid
                   AND s.moduleid = 4
                   AND IsEmailTo = 0
             ORDER BY i.IndividualFullName FOR XML PATH('')
         ), 2, 200000)
     ), '') AS Individuals, 
            ISNULL(
     (
         SELECT SUBSTRING(
         (
             SELECT ',' + i.CompanyName
             FROM tbl_outlookemailLinkedTo s
                  JOIN tbl_companycontact i ON i.CompanyContactID = s.objectid
             WHERE s.emailid = e.emailid
                   AND s.moduleid = 5
                   AND IsEmailTo = 0
             ORDER BY i.CompanyName FOR XML PATH('')
         ), 2, 200000)
     ), '') AS Companies, 
            ISNULL(
     (
         SELECT SUBSTRING(
         (
             SELECT ',' + i.DealName
             FROM tbl_outlookemailLinkedTo s
                  JOIN tbl_deals i ON i.dealid = s.objectid
             WHERE s.emailid = e.emailid
                   AND s.moduleid = 6
                   AND IsEmailTo = 0
             ORDER BY i.DealName FOR XML PATH('')
         ), 2, 200000)
     ), '') AS Deals
     FROM tbl_outlookemail e
          JOIN tbl_contactindividual ind ON ind.individualid = e.fromid;
