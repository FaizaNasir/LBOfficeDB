CREATE TABLE [dbo].[tbl_Deals] (
    [DealID]                 INT             IDENTITY (1, 1) NOT NULL,
    [DealName]               VARCHAR (100)   NULL,
    [DealCode]               VARCHAR (100)   NULL,
    [ReceivedDate]           DATETIME        NULL,
    [DealTypeID]             INT             NULL,
    [DealSize]               DECIMAL (38, 6) NULL,
    [DealCurrencyCode]       VARCHAR (10)    NULL,
    [Valuation]              DECIMAL (38, 6) NULL,
    [Notes]                  VARCHAR (MAX)   NULL,
    [ReceiverId]             INT             NULL,
    [DealSourceCompanyID]    INT             NULL,
    [DealSourceIndividualID] INT             NULL,
    [DealCurrentTargetID]    INT             NULL,
    [ActivityID]             INT             NULL,
    [DealStageID]            INT             NULL,
    [DealStatusID]           INT             NULL,
    [OfficeID]               INT             NULL,
    [AssignmentFeeDebt]      INT             NULL,
    [AssignmentFeeEquity]    INT             NULL,
    [CreatedDateTime]        DATETIME        NULL,
    [ModifiedDateTime]       DATETIME        NULL,
    [LinkedTo]               INT             NULL,
    [Active]                 BIT             CONSTRAINT [DF_tbl_Deals_Active] DEFAULT ((1)) NULL,
    [Sale]                   DECIMAL (38, 6) NULL,
    CONSTRAINT [PK_tbl_Project] PRIMARY KEY CLUSTERED ([DealID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Deals]
    ON [dbo].[tbl_Deals]([DealName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Deals_1]
    ON [dbo].[tbl_Deals]([ReceivedDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Deals_3]
    ON [dbo].[tbl_Deals]([DealStageID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Deals_4]
    ON [dbo].[tbl_Deals]([DealStatusID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Deals_5]
    ON [dbo].[tbl_Deals]([DealTypeID] ASC);

