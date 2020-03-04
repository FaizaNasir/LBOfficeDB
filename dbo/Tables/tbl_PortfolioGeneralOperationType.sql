CREATE TABLE [dbo].[tbl_PortfolioGeneralOperationType] (
    [TypeID]           INT            IDENTITY (1, 1) NOT NULL,
    [TypeName]         VARCHAR (1000) NULL,
    [Active]           BIT            CONSTRAINT [DF_tbl_PortfolioGeneralOperationType_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]  DATETIME       NULL,
    [ModifiedDateTime] DATETIME       NULL,
    [CreatedBy]        VARCHAR (100)  NULL,
    [ModifiedBy]       VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_PortfolioGeneralOperationType] PRIMARY KEY CLUSTERED ([TypeID] ASC)
);

