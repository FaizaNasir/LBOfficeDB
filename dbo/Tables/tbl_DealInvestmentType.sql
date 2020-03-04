CREATE TABLE [dbo].[tbl_DealInvestmentType] (
    [ProjectInvestmentTypeID]    INT           IDENTITY (1, 1) NOT NULL,
    [ProjectInvestmentTypeDesc]  VARCHAR (100) NULL,
    [ProjectInvestmentTypeTitle] VARCHAR (100) NULL,
    [Active]                     BIT           NULL,
    [CreatedDateTim]             DATETIME      NULL,
    CONSTRAINT [PK_tbl_ProjectInvestmentType] PRIMARY KEY CLUSTERED ([ProjectInvestmentTypeID] ASC)
);

