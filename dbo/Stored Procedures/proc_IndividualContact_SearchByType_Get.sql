CREATE PROCEDURE [dbo].[proc_IndividualContact_SearchByType_Get] @key  NVARCHAR(50), 
                                                                 @type NVARCHAR(50)
AS
     IF(@type = 'GroupName')
         BEGIN
             SELECT DISTINCT 
                    GroupName AS Result
             FROM
             (
              (
                  SELECT GroupName
                  FROM [tbl_ContactIndividualOptional]
                  WHERE GroupName LIKE '%' + @key + '%'
              )
              UNION
              (
                  SELECT GroupName
                  FROM [tbl_companyOptionalBis]
                  WHERE GroupName LIKE '%' + @key + '%'
              )
             ) AS tbl;
     END;
     IF(@type = 'Greetings1')
         BEGIN
             SELECT DISTINCT 
                    greeting AS Result
             FROM
             (
              (
                  SELECT DISTINCT 
                         Greetings1 AS greeting
                  FROM [tbl_ContactIndividualOptional]
                  WHERE Greetings1 LIKE '%' + @key + '%'
              )
              UNION
(
    SELECT DISTINCT 
           Greetings2 AS greeting
    FROM [tbl_ContactIndividualOptional]
    WHERE Greetings2 LIKE '%' + @key + '%'
)
UNION
(
    SELECT DISTINCT 
           Greetings1 AS greeting
    FROM [tbl_companyOptionalBis]
    WHERE Greetings1 LIKE '%' + @key + '%'
)
UNION
(
    SELECT DISTINCT 
           Greetings2 AS greeting
    FROM [tbl_companyOptionalBis]
    WHERE Greetings2 LIKE '%' + @key + '%'
)
             ) AS tbl;
     END;
     IF(@type = 'Greetings2')
         BEGIN
             SELECT DISTINCT 
                    greeting AS Result
             FROM
             (
              (
                  SELECT DISTINCT 
                         Greetings1 AS greeting
                  FROM [tbl_ContactIndividualOptional]
                  WHERE Greetings1 LIKE '%' + @key + '%'
              )
              UNION
(
    SELECT DISTINCT 
           Greetings2 AS greeting
    FROM [tbl_ContactIndividualOptional]
    WHERE Greetings2 LIKE '%' + @key + '%'
)
UNION
(
    SELECT DISTINCT 
           Greetings1 AS greeting
    FROM [tbl_companyOptionalBis]
    WHERE Greetings1 LIKE '%' + @key + '%'
)
UNION
(
    SELECT DISTINCT 
           Greetings2 AS greeting
    FROM [tbl_companyOptionalBis]
    WHERE Greetings2 LIKE '%' + @key + '%'
)
             ) AS tbl;
     END;
     IF(@type = 'Bank')
         BEGIN
             SELECT DISTINCT 
                    Bank AS Result
             FROM
             (
              (
                  SELECT Bank
                  FROM [tbl_ContactIndividualOptional]
                  WHERE Bank LIKE '%' + @key + '%'
              )
              UNION
              (
                  SELECT Bank
                  FROM [tbl_companyOptionalBis]
                  WHERE Bank LIKE '%' + @key + '%'
              )
             ) AS tbl;
     END;
     IF(@type = 'SWIFT')
         BEGIN
             SELECT DISTINCT 
                    SWIFT AS Result
             FROM
             (
              (
                  SELECT SWIFT
                  FROM [tbl_ContactIndividualOptional]
                  WHERE SWIFT LIKE '%' + @key + '%'
              )
              UNION
              (
                  SELECT SWIFT
                  FROM [tbl_companyOptionalBis]
                  WHERE SWIFT LIKE '%' + @key + '%'
              )
             ) AS tbl;
     END;
     IF(@type = 'IBAN')
         BEGIN
             SELECT DISTINCT 
                    IBAN AS Result
             FROM
             (
              (
                  SELECT IBAN
                  FROM [tbl_ContactIndividualOptional]
                  WHERE IBAN LIKE '%' + @key + '%'
              )
              UNION
              (
                  SELECT IBAN
                  FROM [tbl_companyOptionalBis]
                  WHERE IBAN LIKE '%' + @key + '%'
              )
             ) AS tbl;
     END;
     RETURN 0;
