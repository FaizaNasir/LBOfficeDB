CREATE TABLE [dbo].[tbl_Shareholders] (
    [ShareholderID]     INT             IDENTITY (1, 1) NOT NULL,
    [ModuleID]          INT             NULL,
    [ObjectID]          INT             NULL,
    [TargetPortfolioID] INT             NULL,
    [Active]            BIT             NULL,
    [CreatedDateTime]   DATETIME        NULL,
    [ModifiedDateTime]  DATETIME        NULL,
    [CreatedBy]         VARCHAR (100)   NULL,
    [ModifiedBy]        VARCHAR (100)   NULL,
    [NonDiluted]        DECIMAL (18, 6) NULL,
    [Diluted]           DECIMAL (18, 6) NULL,
    [Voting]            DECIMAL (18, 6) NULL,
    [Type]              INT             NULL,
    CONSTRAINT [PK_tbl_Shareholders] PRIMARY KEY CLUSTERED ([ShareholderID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Shareholders]
    ON [dbo].[tbl_Shareholders]([ModuleID] ASC, [ObjectID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Shareholders_1]
    ON [dbo].[tbl_Shareholders]([TargetPortfolioID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Shareholders_2]
    ON [dbo].[tbl_Shareholders]([ShareholderID] ASC);

