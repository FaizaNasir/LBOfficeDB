CREATE TABLE [dbo].[tbl_Tasks] (
    [TaskID]             INT             IDENTITY (1, 1) NOT NULL,
    [TaskName]           VARCHAR (100)   NULL,
    [TaskDescription]    VARCHAR (MAX)   NULL,
    [StartingDateTime]   DATETIME        NULL,
    [EndDateTime]        DATETIME        NULL,
    [TaskStatus]         VARCHAR (100)   NULL,
    [TaskCost]           INT             NULL,
    [AlertIntervalID]    INT             NULL,
    [CurrencyID]         INT             NULL,
    [OperationID]        INT             NULL,
    [AlertComments]      VARCHAR (2000)  NULL,
    [EstimatedDuration]  INT             NULL,
    [FinalDuration]      INT             NULL,
    [IsPrivacy]          BIT             NULL,
    [RecurringType]      VARCHAR (50)    NULL,
    [Duration]           INT             NULL,
    [ExternalAdvisorsID] INT             NULL,
    [TaskComments]       VARCHAR (MAX)   NULL,
    [RecurringGroupID]   INT             NULL,
    [ParentTaskID]       INT             NULL,
    [IsDocAttach]        BIT             NULL,
    [Budget]             DECIMAL (18, 2) NULL,
    [Dismissed]          BIT             NULL,
    [WorkDuration]       INT             NULL,
    CONSTRAINT [PK_tbl_Task] PRIMARY KEY CLUSTERED ([TaskID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Tasks]
    ON [dbo].[tbl_Tasks]([StartingDateTime] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Tasks_1]
    ON [dbo].[tbl_Tasks]([ParentTaskID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Tasks_2]
    ON [dbo].[tbl_Tasks]([TaskStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Tasks_3]
    ON [dbo].[tbl_Tasks]([EndDateTime] ASC);

