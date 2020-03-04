CREATE TABLE [dbo].[tbl_LPPerformance] (
    [LPPerformanceID] INT             NULL,
    [VehicleID]       INT             NULL,
    [ModuleID]        INT             NULL,
    [ObjectID]        INT             NULL,
    [IRRGross]        DECIMAL (18, 6) NULL,
    [IRRNet]          DECIMAL (18, 6) NULL,
    [MultipleGross]   DECIMAL (18, 6) NULL,
    [MultipleNet]     DECIMAL (18, 6) NULL,
    [IRRGrossFX]      DECIMAL (18, 6) NULL,
    [MultipleGrossFX] DECIMAL (18, 6) NULL,
    [IRRNetFX]        DECIMAL (18, 6) NULL,
    [MultipleNetFX]   DECIMAL (18, 6) NULL,
    [CreatedDate]     DATETIME        CONSTRAINT [DF_tbl_LPPerformance_CreatedDate] DEFAULT (getdate()) NULL
);

