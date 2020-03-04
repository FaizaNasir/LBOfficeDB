CREATE PROC [dbo].[proc_getPortfolioFundKeyFigureSimulations](@PortfolioFundUnderlyingInvestmentsID INT)
AS
    BEGIN
        DECLARE @tblKeyFigure TABLE
        (PortfolioFundUnderlyingInvestmentsID INT, 
         Year                                 INT, 
         Name                                 VARCHAR(1000), 
         Amount                               VARCHAR(1000), 
         Date                                 DATETIME
        );
        INSERT INTO @tblKeyFigure
               SELECT PortfolioFundUnderlyingInvestmentsID, 
                      YEAR(year), 
               (
                   SELECT Name
                   FROM tbl_PortfolioFundKeyfigureConfig con
                   WHERE con.PortfolioFundKeyfigureConfigID = b.PortfolioFundKeyfigureConfigID
                         AND con.VehicleID = b.VehicleID
               ) Name, 
                      ISNULL(Amount, ''), 
                      date
               FROM tbl_PortfolioFundKeyFigure b
               WHERE b.PortfolioFundUnderlyingInvestmentsID = @PortfolioFundUnderlyingInvestmentsID;
        DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX);
        SELECT @cols = STUFF(
        (
            SELECT ',' + QUOTENAME(Year)
            FROM @tblKeyFigure
            GROUP BY Year
            ORDER BY Year FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
        SET @query = '

declare @tblKeyFigure     

table(PortfolioFundUnderlyingInvestmentsID int,Year int,Name varchar(1000),Amount varchar(1000),Seq Int,Date datetime)  

insert into @tblKeyFigure    

   select PortfolioFundUnderlyingInvestmentsID,year(year),

   (select Name from tbl_PortfolioFundKeyfigureConfig con where 

   con.PortfolioFundKeyfigureConfigID = b.PortfolioFundKeyfigureConfigID  

  and con.PortfolioFundUnderlyingInvestmentsID = b.PortfolioFundUnderlyingInvestmentsID)Name,ISNULL(Amount,''''),   

  (select Seq from tbl_PortfolioFundKeyfigureConfig con where  

  con.PortfolioFundKeyfigureConfigID = b.PortfolioFundKeyfigureConfigID    

  and con.PortfolioFundUnderlyingInvestmentsID = b.PortfolioFundUnderlyingInvestmentsID)Seq   ,Date

   from tbl_PortfolioFundKeyFIgure b       

   where b.PortfolioFundUnderlyingInvestmentsID = ' + CAST(@PortfolioFundUnderlyingInvestmentsID AS VARCHAR(10)) + '   


SELECT ' + @cols + ', Name as Millions from

            (

                select PortfolioFundUnderlyingInvestmentsID,Seq, Name, Year, ISNULL(Amount,0) Amount  ,Date

                from @tblKeyFigure

            ) x 

            pivot

            ( 

                MAX(Amount) 

                for Year in (' + @cols + ')

            ) p   

            order by Seq ';
        PRINT(@query);
        EXECUTE (@query);
    END;
