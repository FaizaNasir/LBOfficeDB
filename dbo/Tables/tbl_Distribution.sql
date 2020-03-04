﻿CREATE TABLE [dbo].[tbl_Distribution] (
    [DistributionID]               INT             IDENTITY (1, 1) NOT NULL,
    [Name]                         VARCHAR (50)    NULL,
    [Date]                         DATETIME        NULL,
    [TotalAmount]                  DECIMAL (18, 5) NULL,
    [PaidCarriedInterest]          DECIMAL (18, 5) NULL,
    [PendingCarriedInterest]       DECIMAL (18, 5) NULL,
    [Active]                       BIT             NULL,
    [CreatedBy]                    VARCHAR (50)    NULL,
    [CreatedDateTime]              DATETIME        NULL,
    [ModifiedBy]                   VARCHAR (50)    NULL,
    [ModifiedDateTime]             DATETIME        NULL,
    [FundID]                       INT             NULL,
    [IsApproved1]                  BIT             NULL,
    [Log1]                         VARCHAR (1000)  NULL,
    [IsApproved2]                  BIT             NULL,
    [Log2]                         VARCHAR (1000)  NULL,
    [RecallableDistributionAmount] DECIMAL (18, 5) NULL,
    [TotalValidationReq]           INT             NULL,
    [UserRole1]                    VARCHAR (1000)  NULL,
    [UserRole2]                    VARCHAR (1000)  NULL,
    [NameFr]                       VARCHAR (50)    NULL,
    [DocStatus]                    INT             NULL,
    [Notes]                        VARBINARY (MAX) NULL,
    [NotesFR]                      VARBINARY (MAX) NULL,
    CONSTRAINT [PK_tbl_Distribution] PRIMARY KEY CLUSTERED ([DistributionID] ASC)
);
