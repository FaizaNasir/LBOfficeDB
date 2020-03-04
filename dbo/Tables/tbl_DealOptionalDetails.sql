CREATE TABLE [dbo].[tbl_DealOptionalDetails] (
    [DealOptionalDetailsID]  INT             IDENTITY (1, 1) NOT NULL,
    [DealID]                 INT             NULL,
    [DealPriority]           INT             NULL,
    [SignedOn]               DATETIME        NULL,
    [TenorOfEngagement]      INT             NULL,
    [InvestmentBackgroundID] INT             NULL,
    [OwnershipID]            INT             NULL,
    [ShareholdingTypeID]     INT             NULL,
    [SourceTypeID]           INT             NULL,
    [InvestmentReason]       VARCHAR (MAX)   NULL,
    [IntroducedWithID]       INT             NULL,
    [ExpectedExit]           VARCHAR (1000)  NULL,
    [IsCommunicated]         BIT             NULL,
    [CloseDate]              DATETIME        NULL,
    [NDATypeID]              BIT             NULL,
    [DernierCA]              DECIMAL (18, 2) NULL,
    [EBIT]                   DECIMAL (18, 2) NULL,
    [EBITDA]                 DECIMAL (18, 2) NULL,
    [ResultatNet]            DECIMAL (18, 2) NULL,
    [Commentaires]           VARCHAR (1000)  NULL,
    [TypeDeDealID]           INT             NULL,
    CONSTRAINT [PK_tbl_DealOptionalDetails] PRIMARY KEY CLUSTERED ([DealOptionalDetailsID] ASC),
    CONSTRAINT [DealOptionalDetailsDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealOptionalDetails] NOCHECK CONSTRAINT [DealOptionalDetailsDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealOptionalDetails]
    ON [dbo].[tbl_DealOptionalDetails]([DealID] ASC);

