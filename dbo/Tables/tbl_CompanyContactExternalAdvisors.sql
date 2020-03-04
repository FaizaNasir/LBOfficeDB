CREATE TABLE [dbo].[tbl_CompanyContactExternalAdvisors] (
    [CompanyEATypeID]         INT           IDENTITY (1, 1) NOT NULL,
    [CompanyID]               INT           NULL,
    [ExternalAdvisorTypeID]   INT           NULL,
    [Active]                  BIT           CONSTRAINT [DF_tbl_CompanyContactExternalAdvisors_Active] DEFAULT ((1)) NULL,
    [ExternalAdvisorCost]     FLOAT (53)    NULL,
    [ExternalAdvisorCostType] NCHAR (10)    NULL,
    [ExternalAdvisorCurrency] NVARCHAR (50) NULL,
    CONSTRAINT [PK_tbl_CompanyContactExternalAdvisors] PRIMARY KEY CLUSTERED ([CompanyEATypeID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CompanyContactExternalAdvisors]
    ON [dbo].[tbl_CompanyContactExternalAdvisors]([CompanyID] ASC);

