CREATE TABLE [dbo].[tbl_FundNavDetails] (
    [FundNavDetailID]  INT           IDENTITY (1, 1) NOT NULL,
    [FundNavID]        INT           NULL,
    [ShareID]          INT           NULL,
    [Value]            DECIMAL (18)  NULL,
    [Stock]            DECIMAL (18)  NULL,
    [Active]           BIT           CONSTRAINT [DF_tbl_FundNavDetails_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_FundNavDetails] PRIMARY KEY CLUSTERED ([FundNavDetailID] ASC)
);

