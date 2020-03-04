CREATE TABLE [dbo].[tbl_ShareholdersOwnedTotal] (
    [ShareholderTotalID]     INT             IDENTITY (1, 1) NOT NULL,
    [TargetPortfolioID]      INT             NULL,
    [Active]                 BIT             NULL,
    [CreatedDateTime]        DATETIME        NULL,
    [ModifiedDateTime]       DATETIME        NULL,
    [CreatedBy]              VARCHAR (100)   NULL,
    [ModifiedBy]             VARCHAR (100)   NULL,
    [TypeName]               VARCHAR (100)   NULL,
    [ShareholderOwnedDateId] INT             NULL,
    [NumberofShares]         DECIMAL (18, 6) NULL,
    [ConvertibleBonds]       DECIMAL (18, 6) NULL,
    [NumberofOthers]         DECIMAL (18, 6) NULL,
    CONSTRAINT [PK_tbl_ShareholdersOwnedTotal] PRIMARY KEY CLUSTERED ([ShareholderTotalID] ASC)
);

