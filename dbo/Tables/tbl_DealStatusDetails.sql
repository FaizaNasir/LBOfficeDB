CREATE TABLE [dbo].[tbl_DealStatusDetails] (
    [DealStatusDetailsID] INT           IDENTITY (1, 1) NOT NULL,
    [DealID]              INT           NULL,
    [DealStatusID]        INT           NULL,
    [DealStatusDateTime]  DATETIME      NULL,
    [DealStatusComments]  VARCHAR (MAX) NULL,
    [Active]              BIT           NULL,
    [CreateDateTime]      DATETIME      NULL,
    [UserID]              VARCHAR (MAX) NULL,
    [Validation]          VARCHAR (200) NULL,
    CONSTRAINT [PK_tbl_DealStatusDetails] PRIMARY KEY CLUSTERED ([DealStatusDetailsID] ASC),
    CONSTRAINT [DealStatusDetailsDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealStatusDetails] NOCHECK CONSTRAINT [DealStatusDetailsDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealStatusDetails]
    ON [dbo].[tbl_DealStatusDetails]([DealID] ASC);

