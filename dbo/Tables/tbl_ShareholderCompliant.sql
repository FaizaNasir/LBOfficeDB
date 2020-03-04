﻿CREATE TABLE [dbo].[tbl_ShareholderCompliant] (
    [CompliantID]      INT           IDENTITY (1, 1) NOT NULL,
    [ShareholderID]    INT           NULL,
    [Compliant1]       INT           NULL,
    [Compliant2]       INT           NULL,
    [Compliant3]       INT           NULL,
    [Compliant4]       INT           NULL,
    [Compliant5]       INT           NULL,
    [Compliant6]       INT           NULL,
    [Compliant7]       INT           NULL,
    [Compliant8]       INT           NULL,
    [Compliant9]       INT           NULL,
    [Compliant10]      INT           NULL,
    [Compliant11]      INT           NULL,
    [Compliant12]      INT           NULL,
    [Compliant13]      INT           NULL,
    [Compliant14]      INT           NULL,
    [Compliant15]      INT           NULL,
    [Compliant16]      INT           NULL,
    [Compliant17]      INT           NULL,
    [Compliant18]      INT           NULL,
    [Compliant19]      INT           NULL,
    [Compliant20]      INT           NULL,
    [Compliant21]      INT           NULL,
    [Compliant22]      INT           NULL,
    [Compliant23]      INT           NULL,
    [Compliant24]      INT           NULL,
    [Active]           BIT           NULL,
    [CreatedDateTime]  DATETIME      NULL,
    [ModifiedDateTime] DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    [Compliant25]      INT           NULL,
    CONSTRAINT [PK_tbl_ShareholderCompliant] PRIMARY KEY CLUSTERED ([CompliantID] ASC)
);

