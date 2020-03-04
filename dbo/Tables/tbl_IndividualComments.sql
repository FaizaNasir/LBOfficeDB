CREATE TABLE [dbo].[tbl_IndividualComments] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Comments]     VARCHAR (MAX) NULL,
    [CreatedTime]  DATETIME      NULL,
    [CreatedBy]    INT           NULL,
    [IndividualID] INT           NULL,
    CONSTRAINT [PK_tbl_IndividualComments] PRIMARY KEY CLUSTERED ([ID] ASC)
);

