CREATE TABLE [dbo].[tbl_TypeDeDeal] (
    [TypeDeDealID]   INT            IDENTITY (1, 1) NOT NULL,
    [TypeDeDealName] VARCHAR (1000) NULL,
    CONSTRAINT [PK_tbl_TypeDeDeal] PRIMARY KEY CLUSTERED ([TypeDeDealID] ASC)
);

