﻿CREATE TABLE [dbo].[tbl_LPReport] (
    [LPReportID]     INT            IDENTITY (1, 1) NOT NULL,
    [VehicleID]      INT            NULL,
    [DocumentTypeID] INT            NULL,
    [ModuleID]       INT            NULL,
    [ObjectID]       INT            NULL,
    [Date]           DATETIME       NULL,
    [Name]           VARCHAR (1000) NULL,
    [ReportLocation] VARCHAR (3000) NULL,
    [PdfLocation]    VARCHAR (3000) NULL,
    [EmailLocation]  VARCHAR (3000) NULL,
    [Active]         BIT            NULL,
    [CreatedDate]    DATETIME       NULL,
    [ModifiedDate]   DATETIME       NULL,
    [CreatedBy]      VARCHAR (100)  NULL,
    [ModifiedBy]     VARCHAR (100)  NULL,
    [ContextID]      INT            NULL,
    [PublishedDate]  DATETIME       NULL,
    [Attempt]        INT            NULL,
    [MailStatus]     VARCHAR (1000) NULL,
    [SentBy]         VARCHAR (1000) NULL,
    [SentDate]       DATETIME       NULL,
    [ShareID]        INT            NULL,
    [DownloadedDate] DATETIME       NULL,
    [DownloadedBy]   VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_LPReport] PRIMARY KEY CLUSTERED ([LPReportID] ASC)
);

