
----  select dbo.[F_KeyFigures_HeaderDate](13,'12-31-2012')              

CREATE FUNCTION [dbo].[F_KeyFigures_HeaderDate]
(@portfolioid INT, 
 @date        DATETIME
)
RETURNS VARCHAR(300)
AS
     BEGIN
         DECLARE @start VARCHAR(300);
         DECLARE @end VARCHAR(300);
         DECLARE @result VARCHAR(300);                                           
         -- CONVERT(varchar(10),year,101)        
         SELECT @start =
         (
             SELECT TOP 1 amount
             FROM tbl_PortfolioKeyFigure b
                  JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
             WHERE b.portfolioid = @portfolioid
                   AND year = @date
                   AND name = 'Start date'
                   AND b.subtab = 1
         );
         SELECT @end =
         (
             SELECT TOP 1 amount
             FROM tbl_PortfolioKeyFigure b
                  JOIN tbl_KeyfigureConfig c ON b.KeyFigureConfigID = c.KeyFigureConfigID
             WHERE b.portfolioid = @portfolioid
                   AND year = @date
                   AND name = 'End date'
                   AND b.subtab = 1
         );

         --SELECT CONVERT(VARCHAR(5), cast(@start as datetime), 101)                                      
         --SELECT CONVERT(VARCHAR(5), cast(@end as datetime), 101)                                      
         --select @result =     month(  @start) + '-' + day(@start)                           
         -- Select @result =                            
         -- (                                      
         --substring(@start,4,2) + '/' +  substring(@start,0,3)                                       
         --    + ' - ' +                                 
         --   substring(@end,4,2) + '/' +  substring(@end,0,3)                                    
         --    )                                      

         SELECT @result = (SUBSTRING(@start, 0, 3) + '/' + SUBSTRING(@start, 4, 2) + ' - ' + SUBSTRING(@end, 0, 3) + '/' + SUBSTRING(@end, 4, 2));
         RETURN @result;
     END;
