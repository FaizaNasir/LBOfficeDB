CREATE TABLE [dbo].[tbl_CompanyExternalAdvisorTypes] (
    [CompanyExternalAdvisorID]    INT           NOT NULL,
    [CompanyExternalAdvisorTitle] VARCHAR (100) NULL,
    [CompanyExternalAdvisorDesc]  VARCHAR (100) NULL,
    [Active]                      BIT           CONSTRAINT [DF_tbl_CompanyExternalAdvisorTypes_Active] DEFAULT ((1)) NULL,
    [CreateDateTime]              DATETIME      NULL,
    CONSTRAINT [PK_tbl_CompanyExternalAdvisorTypes] PRIMARY KEY CLUSTERED ([CompanyExternalAdvisorID] ASC)
);

