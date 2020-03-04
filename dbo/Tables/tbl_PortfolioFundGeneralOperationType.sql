CREATE TABLE [dbo].[tbl_PortfolioFundGeneralOperationType] (
    [TypeID]           INT            NOT NULL,
    [TypeName]         VARCHAR (1000) NULL,
    [Active]           BIT            DEFAULT ((1)) NOT NULL,
    [CreatedDateTime]  DATETIME       NULL,
    [ModifiedDateTime] DATETIME       NULL,
    [CreatedBy]        VARCHAR (100)  NULL,
    [ModifiedBy]       VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_PortfolioFundGeneralOperationType] PRIMARY KEY CLUSTERED ([TypeID] ASC)
);

