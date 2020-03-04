CREATE PROC [dbo].[gcn]
AS
     SELECT ParameterValue
     FROM tbl_DefaultParameters
     WHERE ParameterName LIKE 'Client';
