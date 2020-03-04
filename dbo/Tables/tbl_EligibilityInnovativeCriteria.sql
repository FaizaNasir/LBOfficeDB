CREATE TABLE [dbo].[tbl_EligibilityInnovativeCriteria] (
    [EligibilityInnovativeCriteriaID] INT           IDENTITY (1, 1) NOT NULL,
    [EligibilityID]                   INT           NULL,
    [InnovateCriteriaID]              INT           NULL,
    [Active]                          BIT           NULL,
    [CreatedDateTime]                 DATETIME      NULL,
    [ModifiedDateTime]                DATETIME      NULL,
    [CreatedBy]                       VARCHAR (100) NULL,
    [ModifiedBy]                      VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_EligibilityInnovativeCriteria] PRIMARY KEY CLUSTERED ([EligibilityInnovativeCriteriaID] ASC)
);

