CREATE TABLE [dbo].[tbl_DealStageApproval] (
    [DealApprovalID]   INT      IDENTITY (1, 1) NOT NULL,
    [DealID]           INT      NULL,
    [ApprovedByID]     INT      NULL,
    [IsActive]         BIT      NULL,
    [CreatedDateTime]  DATETIME NULL,
    [ModifiedDateTime] DATETIME NULL,
    [RequestedStage]   INT      NULL,
    [CurrentStage]     INT      NULL,
    [IsApproved]       BIT      NULL,
    CONSTRAINT [PK_tbl_DealApproval] PRIMARY KEY CLUSTERED ([DealApprovalID] ASC)
);

