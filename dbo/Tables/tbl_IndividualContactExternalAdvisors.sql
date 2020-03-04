CREATE TABLE [dbo].[tbl_IndividualContactExternalAdvisors] (
    [IndividualEATypeID]    INT IDENTITY (1, 1) NOT NULL,
    [IndividualID]          INT NULL,
    [ExternalAdvisorTypeID] INT NULL,
    [Active]                BIT CONSTRAINT [DF_tbl_IndividualContactExternalAdvisors_Active] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tbl_IndividualContactExternalAdvisors] PRIMARY KEY CLUSTERED ([IndividualEATypeID] ASC)
);

