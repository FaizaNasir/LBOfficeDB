CREATE TABLE [dbo].[tbl_Portfolio] (
    [PortfolioID]               INT            IDENTITY (1, 1) NOT NULL,
    [TargetPortfolioID]         INT            NULL,
    [ModuleID]                  INT            NULL,
    [ManagementIncentiveScheme] VARCHAR (MAX)  NULL,
    [StageID]                   INT            NULL,
    [Active]                    BIT            NULL,
    [CreatedDateTime]           DATETIME       NULL,
    [ModifiedDateTime]          DATETIME       NULL,
    [CreatedBy]                 VARCHAR (100)  NULL,
    [ModifiedBy]                VARCHAR (100)  NULL,
    [KeyFigureComments]         VARCHAR (4000) NULL,
    [KeyFigureCommentsFR]       VARCHAR (4000) NULL,
    CONSTRAINT [PK_tbl_Portfolio] PRIMARY KEY CLUSTERED ([PortfolioID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Portfolio]
    ON [dbo].[tbl_Portfolio]([TargetPortfolioID] ASC);

