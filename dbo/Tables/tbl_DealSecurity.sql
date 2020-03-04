CREATE TABLE [dbo].[tbl_DealSecurity] (
    [DealSecurityID]  INT          IDENTITY (1, 1) NOT NULL,
    [DealID]          INT          NULL,
    [AllocationRatio] NUMERIC (18) NULL,
    [SecurityTypeID]  INT          NULL,
    [IsActive]        BIT          NULL,
    [CreateOn]        DATETIME     NULL,
    [CreateBy]        VARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_dealSecurity] PRIMARY KEY CLUSTERED ([DealSecurityID] ASC),
    CONSTRAINT [DealSecurityDealID] FOREIGN KEY ([DealID]) REFERENCES [dbo].[tbl_Deals] ([DealID])
);


GO
ALTER TABLE [dbo].[tbl_DealSecurity] NOCHECK CONSTRAINT [DealSecurityDealID];


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DealSecurity]
    ON [dbo].[tbl_DealSecurity]([DealID] ASC);

