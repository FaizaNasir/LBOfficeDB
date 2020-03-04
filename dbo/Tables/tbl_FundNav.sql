CREATE TABLE [dbo].[tbl_FundNav] (
    [FundNavID]        INT           IDENTITY (1, 1) NOT NULL,
    [FundID]           INT           NULL,
    [Date]             DATETIME      NULL,
    [TypeID]           INT           NULL,
    [ValuationLevel]   BIT           NULL,
    [NAV]              DECIMAL (18)  NULL,
    [WorkingCapital]   DECIMAL (18)  NULL,
    [Cash]             DECIMAL (18)  NULL,
    [AdjustedNAV]      DECIMAL (18)  NULL,
    [Notes]            VARCHAR (MAX) NULL,
    [Active]           BIT           CONSTRAINT [DF_tbl_FundNav_Active] DEFAULT ((1)) NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_FundNav] PRIMARY KEY CLUSTERED ([FundNavID] ASC)
);

