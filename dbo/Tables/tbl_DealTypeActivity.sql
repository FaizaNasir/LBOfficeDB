CREATE TABLE [dbo].[tbl_DealTypeActivity] (
    [DealTypeActivityID] INT      IDENTITY (1, 1) NOT NULL,
    [DealTypeID]         INT      NULL,
    [ActivityID]         INT      NULL,
    [Active]             BIT      NULL,
    [CreatedDateTime]    DATETIME NULL,
    CONSTRAINT [PK_tbl_DealTypeActivity] PRIMARY KEY CLUSTERED ([DealTypeActivityID] ASC)
);

