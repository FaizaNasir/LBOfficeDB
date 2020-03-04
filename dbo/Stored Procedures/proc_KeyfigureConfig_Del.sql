CREATE PROCEDURE [dbo].[proc_KeyfigureConfig_Del] @ID INT
AS
     DELETE FROM tbl_KeyfigureConfig
     WHERE KeyFigureConfigID = @ID;
     DELETE FROM tbl_PortfolioKeyFigure
     WHERE KeyFigureConfigID = @ID;
     SELECT 1;
