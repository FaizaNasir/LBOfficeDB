CREATE FUNCTION [dbo].[F_DealSearchOperator]
(@ID                 INT, 
 @dealStatusCriteria VARCHAR(1000), 
 @dealStatusOccured  VARCHAR(500)
)
RETURNS BIT
AS
     BEGIN

         --DECLARE @ID INT;
         --DECLARE @dealStatusCriteria VARCHAR(1000);
         --DECLARE @dealStatusOccured VARCHAR(500);
         --SET @ID = 4884;
         --SET @dealStatusCriteria = 'or';
         --SET @dealStatusOccured = '1,11';

         DECLARE @result BIT;
         DECLARE @tbl TABLE
         (ID   INT IDENTITY(1, 1), 
          Item VARCHAR(100)
         );
         DECLARE @found INT;
         DECLARE @count INT;
         INSERT INTO @tbl
                SELECT *
                FROM dbo.[SplitCSV](@dealStatusOccured, ',');
         SET @count =
         (
             SELECT COUNT(1)
             FROM @tbl
         );
         SET @found =
         (
             SELECT COUNT(DISTINCT DealStatusID)
             FROM tbl_DealStatusDetails ds
                  JOIN @tbl t ON ds.DealStatusID = t.Item
             WHERE ds.dealid = @ID
         );
         IF @dealStatusCriteria = ''
             SET @result = 1;
             ELSE
             IF @dealStatusCriteria = 'and'
                AND @found = @count
                 SET @result = 1;
                 ELSE
                 IF @dealStatusCriteria = 'or'
                    AND @found > 0
                     SET @result = 1;
         RETURN ISNULL(@result, 0);
     END;
