CREATE TABLE [dbo].[tbl_PortfolioShareholdingTypeofOperation] (
    [ShareholdingTypeofOperationID] INT            IDENTITY (1, 1) NOT NULL,
    [TypeofOperationName]           VARCHAR (1000) NULL,
    [Active]                        BIT            NULL,
    [CreatedDateTime]               DATETIME       NULL,
    [ModifiedDateTime]              DATETIME       NULL,
    [CreatedBy]                     VARCHAR (100)  NULL,
    [ModifiedBy]                    VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_PortfolioShareholdingTypeofOperation] PRIMARY KEY CLUSTERED ([ShareholdingTypeofOperationID] ASC)
);

