CREATE TABLE [dbo].[tbl_DealInvestorType] (
    [DealInvestorTypeID]   INT           IDENTITY (1, 1) NOT NULL,
    [DealInvestorTypeName] VARCHAR (100) NULL,
    [CreatedDateTime]      DATETIME      NULL,
    [ModifiedDateTime]     DATETIME      NULL,
    CONSTRAINT [PK_tbl_DealInvestorType] PRIMARY KEY CLUSTERED ([DealInvestorTypeID] ASC)
);

