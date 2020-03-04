CREATE TABLE [dbo].[tbl_DealStages] (
    [DealStageID]     INT          NOT NULL,
    [DealStageTitle]  VARCHAR (50) NULL,
    [DealStageDecs]   VARCHAR (50) NULL,
    [Active]          BIT          NULL,
    [CreatedDateTime] DATETIME     NULL,
    CONSTRAINT [PK_tbl_DealStages] PRIMARY KEY CLUSTERED ([DealStageID] ASC)
);

