CREATE TABLE [dbo].[tbl_InvestmentType] (
    [InvestmentTypeID] INT           IDENTITY (1, 1) NOT NULL,
    [Title]            VARCHAR (50)  NULL,
    [Description]      VARCHAR (100) NULL,
    [IsActive]         BIT           NULL,
    CONSTRAINT [PK_tbl_InvestmentType] PRIMARY KEY CLUSTERED ([InvestmentTypeID] ASC)
);

