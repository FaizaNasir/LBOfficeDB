CREATE TABLE [dbo].[tbl_DistributionLimitedPartner] (
    [DistributionLimitedPartnerID] INT             IDENTITY (1, 1) NOT NULL,
    [LimitedPartnerID]             INT             NULL,
    [ShareID]                      INT             NULL,
    [Amount]                       DECIMAL (18, 6) NULL,
    [Active]                       BIT             NULL,
    [CreatedDateTime]              DATETIME        NULL,
    [ModifiedDateTime]             DATETIME        NULL,
    [CreatedBy]                    VARCHAR (100)   NULL,
    [ModifiedBy]                   VARCHAR (100)   NULL,
    [DistributionID]               INT             NULL,
    [TransferID]                   INT             NULL,
    CONSTRAINT [PK_tbl_DistributionLimitedPartner] PRIMARY KEY CLUSTERED ([DistributionLimitedPartnerID] ASC)
);

