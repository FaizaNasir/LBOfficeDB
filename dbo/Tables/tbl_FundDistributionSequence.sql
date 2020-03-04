CREATE TABLE [dbo].[tbl_FundDistributionSequence] (
    [FundDistributionSequenceID] INT             NOT NULL,
    [FundID]                     INT             NULL,
    [Hurdle]                     DECIMAL (18, 2) NULL,
    [Catchup]                    DECIMAL (18, 2) NULL,
    [CarriedIntrest]             DECIMAL (18, 2) NULL,
    [Active]                     BIT             NULL,
    [CreatedBy]                  VARCHAR (50)    NULL,
    [CreatedDateTime]            DATETIME        NULL,
    [ModifiedBy]                 VARCHAR (50)    NULL,
    [ModifiedDateTime]           DATETIME        NULL
);

