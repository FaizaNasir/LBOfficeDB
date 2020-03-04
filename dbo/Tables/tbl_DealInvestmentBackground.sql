CREATE TABLE [dbo].[tbl_DealInvestmentBackground] (
    [DealInvestmentBackgroundID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealInvestmentBackgroundName] VARCHAR (1000) NULL,
    [CreatedDateTime]              DATETIME       NULL,
    [ModifiedDateTime]             DATETIME       NULL,
    CONSTRAINT [PK_tbl_DealInvestmentBackground] PRIMARY KEY CLUSTERED ([DealInvestmentBackgroundID] ASC)
);

