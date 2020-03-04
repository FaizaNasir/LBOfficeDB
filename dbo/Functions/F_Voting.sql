CREATE FUNCTION [dbo].[F_Voting]
(@id          INT, 
 @moduleID    INT, 
 @date        DATETIME, 
 @portfolioid INT
)
RETURNS DECIMAL(18, 2)
AS
     BEGIN
         DECLARE @add DECIMAL(18, 2);
         DECLARE @sub DECIMAL(18, 2);
         SELECT @add = SUM(Number * VotingRatio)
         FROM
         (
             SELECT CASE
                        WHEN st.PortfolioSecurityTypeID = 2
                        THEN
             (
                 SELECT(VotingRatio * pso.Number)
                 FROM tbl_PortfolioSecurity ss
                 WHERE ss.PortfolioSecurityID = BasedOn
             )
                        ELSE pso.Number
                    END Number, 
                    ISNULL(VotingRatio, 1) VotingRatio
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = pso.SecurityID
                  JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                       AND SecurityGroupID = 1
             WHERE ToID = @id
                   AND ToTypeID = @moduleID
                   AND pso.Date <= @date
                   AND pso.PortfolioID = @portfolioid
         ) t;
         SELECT @sub = SUM(Number * VotingRatio)
         FROM
         (
             SELECT CASE
                        WHEN st.PortfolioSecurityTypeID = 2
                        THEN
             (
                 SELECT(VotingRatio * pso.Number)
                 FROM tbl_PortfolioSecurity ss
                 WHERE ss.PortfolioSecurityID = BasedOn
             )
                        ELSE pso.Number
                    END Number, 
                    ISNULL(VotingRatio, 1) VotingRatio
             FROM tbl_PortfolioShareholdingOperations pso
                  JOIN tbl_PortfolioSecurity ps ON ps.PortfolioSecurityID = pso.SecurityID
                  JOIN tbl_PortfolioSecurityType st ON st.PortfolioSecurityTypeID = ps.PortfolioSecurityTypeID
                                                       AND SecurityGroupID = 1
             WHERE FromID = @id
                   AND FromTypeID = @moduleID
                   AND pso.Date <= @date
                   AND pso.PortfolioID = @portfolioid
         ) t;
         RETURN ISNULL(@add, 0) - ISNULL(@sub, 0);
     END;
