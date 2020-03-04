CREATE TABLE [dbo].[tbl_DealTarget] (
    [DeallTargetID]   INT            IDENTITY (1, 1) NOT NULL,
    [DealID]          INT            NULL,
    [ModuleObjectID]  INT            NULL,
    [Active]          BIT            NULL,
    [CreatedDateTime] DATETIME       NULL,
    [Description]     NVARCHAR (MAX) NULL,
    [Strengths]       NVARCHAR (MAX) NULL,
    [Weaknesses]      NVARCHAR (MAX) NULL,
    [Opportunities]   NVARCHAR (MAX) NULL,
    [Threats]         NVARCHAR (MAX) NULL,
    [IsMain]          BIT            NULL,
    [DescriptionFr]   VARCHAR (MAX)  NULL,
    CONSTRAINT [PK_tbl_DealTargetCompany] PRIMARY KEY CLUSTERED ([DeallTargetID] ASC),
    CONSTRAINT [DealTargetDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealTarget] NOCHECK CONSTRAINT [DealTargetDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealTarget]
    ON [dbo].[tbl_DealTarget]([DealID] ASC);

