CREATE TABLE [dbo].[tbl_DealStatusBU] (
    [ProjectStatusID]    INT           NOT NULL,
    [ProjectStatusTitle] VARCHAR (100) NULL,
    [ProjectStatusDesc]  VARCHAR (100) NULL,
    [Active]             BIT           NULL,
    [CreatedDateTime]    DATETIME      NULL,
    [DealStageID]        INT           NULL,
    [DefaultStatusID]    BIT           NULL,
    [Seq]                INT           NULL
);

