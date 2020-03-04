CREATE TABLE [dbo].[tbl_PortfolioSecurityType] (
    [PortfolioSecurityTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [SecurityGroupID]           INT            NULL,
    [PortfolioSecurityTypeName] VARCHAR (1000) NULL,
    [Active]                    BIT            CONSTRAINT [DF_tbl_PortfolioSecurityType_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]           DATETIME       NULL,
    [ModifiedDateTime]          DATETIME       NULL,
    [CreatedBy]                 VARCHAR (100)  NULL,
    [ModifiedBy]                VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_PortfolioSecurityType] PRIMARY KEY CLUSTERED ([PortfolioSecurityTypeID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_PortfolioSecurityType]
    ON [dbo].[tbl_PortfolioSecurityType]([SecurityGroupID] ASC);

