CREATE TABLE [dbo].[tbl_VehicleManagement] (
    [VehicleGeneralFeesID]       INT           IDENTITY (1, 1) NOT NULL,
    [VehicleID]                  INT           NULL,
    [NotesManagementFees]        VARCHAR (50)  NULL,
    [NotesHurdle]                VARCHAR (50)  NULL,
    [NotesCatchup]               VARCHAR (50)  NULL,
    [NotesCarriedInterest]       VARCHAR (50)  NULL,
    [FrequencyManagementFeesID]  INT           NULL,
    [IsFundBasedCarriedIntreset] BIT           NULL,
    [CreatedDateTime]            DATETIME      NULL,
    [CreatedBy]                  VARCHAR (100) NULL,
    [ModifiedDateTime]           DATETIME      NULL,
    [ModifiedBy]                 VARCHAR (100) NULL,
    [Active]                     BIT           NULL,
    [IsHurdleCapitalized]        BIT           NULL,
    [IsCatchupCapitalized]       BIT           NULL,
    [HurdleRatepercentage]       INT           NULL,
    [Catchuppercentage]          DECIMAL (18)  NULL,
    [CarriedInterestTypeID]      INT           NULL,
    [IsRatioBasedOnCommitments]  BIT           NULL,
    CONSTRAINT [PK_tbl_FundGeneralFees] PRIMARY KEY CLUSTERED ([VehicleGeneralFeesID] ASC)
);

