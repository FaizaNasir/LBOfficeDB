CREATE TABLE [dbo].[tbl_CommitteeAttendies] (
    [CommitteeAttendyID] INT NOT NULL,
    [CommitteeID]        INT NULL,
    [CompanyID]          INT NULL,
    [IndividualID]       INT NULL,
    CONSTRAINT [PK_tbl_CommitteeAttendies] PRIMARY KEY CLUSTERED ([CommitteeAttendyID] ASC)
);

