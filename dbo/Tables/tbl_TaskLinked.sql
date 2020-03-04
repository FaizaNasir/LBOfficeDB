CREATE TABLE [dbo].[tbl_TaskLinked] (
    [TaskLinkedID]      INT IDENTITY (1, 1) NOT NULL,
    [TaskID]            INT NULL,
    [ModuleID]          INT NULL,
    [ObjectID]          INT NULL,
    [IsExternalAdvisor] BIT CONSTRAINT [DF_tbl_TaskLinked_IsExternalAdvisor] DEFAULT ((0)) NULL,
    [IsMCUser]          BIT CONSTRAINT [DF_tbl_TaskLinked_IsMCUser] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tbl_TaskLinked] PRIMARY KEY CLUSTERED ([TaskLinkedID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_TaskLinked]
    ON [dbo].[tbl_TaskLinked]([TaskID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_TaskLinked_1]
    ON [dbo].[tbl_TaskLinked]([ModuleID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_TaskLinked_2]
    ON [dbo].[tbl_TaskLinked]([IsMCUser] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_TaskLinked_3]
    ON [dbo].[tbl_TaskLinked]([IsExternalAdvisor] ASC);

