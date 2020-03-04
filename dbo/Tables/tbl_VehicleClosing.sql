CREATE TABLE [dbo].[tbl_VehicleClosing] (
    [VehicleClosingID] INT           IDENTITY (1, 1) NOT NULL,
    [StartDate]        DATETIME      NULL,
    [EndDate]          DATETIME      NULL,
    [VehicleID]        INT           NULL,
    [Number]           INT           NULL,
    [Notes]            VARCHAR (MAX) NULL,
    [Active]           BIT           NULL,
    [CreatedDate]      DATETIME      NULL,
    [ModifiedDate]     DATETIME      NULL,
    [CreatedBy]        VARCHAR (100) NULL,
    [ModifiedBy]       VARCHAR (100) NULL,
    CONSTRAINT [PK_tbl_VehicleClosing] PRIMARY KEY CLUSTERED ([VehicleClosingID] ASC)
);

