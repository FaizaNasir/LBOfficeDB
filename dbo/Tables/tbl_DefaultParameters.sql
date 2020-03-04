CREATE TABLE [dbo].[tbl_DefaultParameters] (
    [ParameterID]    INT           IDENTITY (1, 1) NOT NULL,
    [ParameterName]  VARCHAR (100) NULL,
    [ParameterValue] VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_DefaultParameters] PRIMARY KEY CLUSTERED ([ParameterID] ASC)
);

