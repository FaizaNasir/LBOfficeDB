CREATE TABLE [dbo].[tbl_FundShare] (
    [FundShareID]      INT             NOT NULL,
    [FundID]           INT             NULL,
    [ShareName]        VARCHAR (50)    NULL,
    [NominalValue]     DECIMAL (18, 2) NULL,
    [Ratio]            DECIMAL (18, 2) NULL,
    [Active]           BIT             NULL,
    [CreatedBy]        VARCHAR (50)    NULL,
    [CreatedDateTime]  DATETIME        NULL,
    [ModifiedBy]       VARCHAR (50)    NULL,
    [ModifiedDateTime] DATETIME        NULL,
    [ISIN]             VARCHAR (1000)  NULL
);

