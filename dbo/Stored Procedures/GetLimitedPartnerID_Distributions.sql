
-- GetLimitedPartnerID_Calls 4,1185,1

CREATE PROC [dbo].[GetLimitedPartnerID_Distributions]
(@limitedPartnerID INT, 
 @distributionid   INT, 
 @shareID          INT
)
AS
     SELECT t.*, 
            ObjectID, 
            ModuleID
     FROM
     (
         SELECT DISTINCT 
                SUM(Amount) Amount, 
                a.LimitedPartnerID
         FROM tbl_distributionLimitedPartner a
         WHERE limitedpartnerid IN
         (
             SELECT limitedpartnerid
             FROM tbl_limitedpartner lp
                  JOIN
             (
                 SELECT moduleid, 
                        objectid
                 FROM tbl_limitedpartner
                 WHERE limitedpartnerid = @limitedPartnerID
             ) t ON lp.ObjectID = t.objectid
                    AND lp.ModuleID = t.ModuleID
         )
             AND a.Distributionid = @distributionid
             AND a.ShareID = @shareID
         GROUP BY a.LimitedPartnerID
     ) t
     JOIN tbl_limitedpartner lp ON lp.LimitedPartnerID = t.LimitedPartnerID;
