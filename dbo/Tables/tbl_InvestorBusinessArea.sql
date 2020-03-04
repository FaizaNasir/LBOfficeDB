CREATE TABLE [dbo].[tbl_InvestorBusinessArea] (
    [BusinessAreaPrefrenceID]    INT           IDENTITY (1, 1) NOT NULL,
    [BusinessAreaPrefrenceTitle] VARCHAR (100) NULL,
    [BusinessAreaPrefrenceDesc]  VARCHAR (100) NULL,
    [Active]                     BIT           CONSTRAINT [DF_tbl_InvestorBusinessArea_Active] DEFAULT ((1)) NULL,
    [CreateDateTime]             DATETIME      CONSTRAINT [DF_tbl_InvestorBusinessArea_CreateDateTime] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tbl_BusinessAreaPrefrence] PRIMARY KEY CLUSTERED ([BusinessAreaPrefrenceID] ASC)
);

