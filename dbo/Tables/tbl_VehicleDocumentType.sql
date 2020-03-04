CREATE TABLE [dbo].[tbl_VehicleDocumentType] (
    [VehicleDocumentTypeID] INT            IDENTITY (1, 1) NOT NULL,
    [VehicleID]             INT            NULL,
    [DocumentTypeID]        INT            NULL,
    [RequireApproval1]      BIT            NULL,
    [RoleName1]             VARCHAR (1000) NULL,
    [RequireApproval2]      BIT            NULL,
    [RoleName2]             VARCHAR (1000) NULL,
    [Active]                BIT            NULL,
    [CreatedDate]           DATETIME       NULL,
    [ModifiedDate]          DATETIME       NULL,
    [CreatedBy]             VARCHAR (100)  NULL,
    [ModifiedBy]            VARCHAR (100)  NULL,
    CONSTRAINT [PK_tbl_VehicleDocumentType] PRIMARY KEY CLUSTERED ([VehicleDocumentTypeID] ASC)
);

