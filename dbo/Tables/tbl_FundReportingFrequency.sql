CREATE TABLE [dbo].[tbl_FundReportingFrequency] (
    [FundReportingFrequencyID]    INT           NOT NULL,
    [FundReportingFrequencyTitle] VARCHAR (100) NULL,
    [FundReportingFrequencyDesc]  VARCHAR (100) NULL,
    [Active]                      BIT           NULL,
    [CreatedDateTim]              DATETIME      NULL,
    CONSTRAINT [PK_tbl_FundFrequency] PRIMARY KEY CLUSTERED ([FundReportingFrequencyID] ASC)
);

