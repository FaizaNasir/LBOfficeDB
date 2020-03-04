CREATE TABLE [dbo].[tbl_DealSecurityType] (
    [DealSecurityTypeID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealSecurityTypeName] VARCHAR (1000) NULL,
    [CreatedDateTime]      DATETIME       NULL,
    [ModifiedDateTeime]    DATETIME       NULL,
    CONSTRAINT [PK_tbl_DealSecurityType] PRIMARY KEY CLUSTERED ([DealSecurityTypeID] ASC)
);

