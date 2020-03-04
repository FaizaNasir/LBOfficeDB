-- Batch submitted through debugger: SQLQuery33.sql|7|0|C:\Users\Administrator\AppData\Local\Temp\~vs4FA3.sql        
--  select  dbo.[F_NonDiluted] (10,3,'1 Apr,2012')        

CREATE FUNCTION [dbo].[F_NonDiluted_Report]
(@id           INT, 
 @moduleID     INT, 
 @date         DATETIME, 
 @portfolioid  INT, 
 @securityType VARCHAR(100)
)
RETURNS decimal(18,6)
AS
     BEGIN
         DECLARE @add decimal(18,6);
         DECLARE @sub decimal(18,6);
         SELECT @add = SUM(Number * ConversionRatio)
         FROM
         (
             SELECT CASE
                        WHEN st.PortfolioSecurityTypeID = 2
                        THEN
             (
                 SELECT(ConversionRatio * pso.Number)
                 FROM tbl_PortfolioSecurity ss
                 WHERE ss.PortfolioSecurityID = BasedOn
             )
                        ELSE pso.Number
                    END Number, 
                    ISNULL(ConversionRatio, 1) ConversionRatio
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = pso.SecurityID
                  JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                       AND st.PortfolioSecurityTypeID IN(SELECT *
                                                                                         FROM dbo.SplitCSV(@securityType, ','))
             WHERE ToID = ISNULL(@id, ToID)        
                   --and FromID = -1        
                   AND ToTypeID = @moduleID
                   AND pso.Date <= @date
                   AND pso.PortfolioID = @portfolioid
         ) t;
         SELECT @sub = SUM(Number * ConversionRatio)
         FROM
         (
             SELECT CASE
                        WHEN st.PortfolioSecurityTypeID = 2
                        THEN
             (
                 SELECT(ConversionRatio * pso.Number)
                 FROM tbl_PortfolioSecurity ss
                 WHERE ss.PortfolioSecurityID = BasedOn
             )
                        ELSE pso.Number
                    END Number, 
                    ISNULL(ConversionRatio, 1) ConversionRatio
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = pso.SecurityID
                  JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                       AND st.PortfolioSecurityTypeID IN(SELECT *
                                                                                         FROM dbo.SplitCSV(@securityType, ','))
             WHERE FromID = ISNULL(@id, FromID)
                   AND FromTypeID = @moduleID
                   AND pso.Date <= @date
                   AND pso.PortfolioID = @portfolioid
         ) t;
         RETURN ISNULL(@add, 0) - ISNULL(@sub, 0);
     END;
