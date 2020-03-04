CREATE PROC [dbo].[GetLPReport]
(@moduleID        INT, 
 @objectID        INT, 
 @vehicleID       INT, 
 @DocumentTypeID  INT, 
 @sentBy          VARCHAR(1000), 
 @mailStatus      VARCHAR(1000), 
 @publishDateFrom DATETIME, 
 @publishDateTo   DATETIME, 
 @sentDateFrom    DATETIME, 
 @sentDateTo      DATETIME, 
 @shareID         INT
)
AS
     IF @sentBy = '0'
         SET @sentBy = NULL;
     IF @shareID = 0
         SET @shareID = NULL;
     IF @publishDateFrom IS NULL
         SET @publishDateFrom = '01/01/1900';
     IF @sentDateFrom IS NULL
         SET @sentDateFrom = '01/01/1900';
     IF @publishDateTo IS NULL
         SET @publishDateTo = '01/01/2500';
     IF @sentDateTo IS NULL
         SET @sentDateTo = '01/01/2500';
     IF @moduleID = 12
         BEGIN
             SET @moduleID = NULL;
             SET @objectID = NULL;
     END;
    BEGIN
        SELECT *
        FROM
        (
            SELECT LPReportID, 
                   lp.VehicleID, 
                   DocumentTypeID, 
                   ModuleID, 
                   ObjectID, 
                   Date, 
                   Name,
                   CASE
                       WHEN documenttypeid = 1
                       THEN
            (
                SELECT CallNameFR
                FROM tbl_capitalcall c
                WHERE c.capitalcallid = contextid
            )
                       WHEN documenttypeid = 2
                       THEN
            (
                SELECT NameFR
                FROM tbl_distribution c
                WHERE c.distributionid = contextid
            )
                   END NameFr, 
                   ReportLocation, 
            (
                SELECT replace(ParameterValue, '\', '\\')
                FROM tbl_DefaultParameters
                WHERE ParameterName = 'PdfDirectory'
            ) + PdfLocation PdfLocation, 
                   EmailLocation, 
                   lp.Active, 
                   CreatedDate, 
                   ModifiedDate, 
                   lp.CreatedBy, 
                   lp.ModifiedBy, 
                   ContextID, 
                   PublishedDate, 
                   Attempt, 
                   MailStatus, 
                   SentBy, 
                   SentDate, 
                   dbo.F_GetObjectModuleName(objectID, moduleID) LPName, 
                   ShareID, 
                   ShareName, 
                   ShareNameFr, 
                   DownloadedDate, 
                   DownloadedBy
            FROM tbl_LPReport lp
                 LEFT JOIN tbl_vehicleshare s ON s.vehicleShareID = lp.shareID
            WHERE moduleID = ISNULL(@moduleID, moduleID)
                  AND ISNULL(lp.active, 1) = 1
                  AND objectid = ISNULL(@objectID, objectid)
                  AND lp.vehicleID = @vehicleID
                  AND DocumentTypeID = @DocumentTypeID
                  AND ISNULL(SentBy, 0) = ISNULL(@SentBy, ISNULL(SentBy, 0))
                  AND ShareID = ISNULL(@shareID, ShareID)
                  AND ISNULL(mailStatus, 0) = ISNULL(@mailStatus, ISNULL(mailStatus, 0))
                  AND PublishedDate BETWEEN @publishDateFrom AND @publishDateTo
                  AND ISNULL(SentDate, GETDATE()) BETWEEN @sentDateFrom AND @sentDateTo
        ) t
        WHERE LPName <> ''
        ORDER BY t.Date DESC;
    END;
