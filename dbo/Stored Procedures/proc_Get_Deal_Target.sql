-- [proc_Get_Deal_Target] 3550 
-- created by : Syed Zain ALi      

CREATE PROCEDURE [dbo].[proc_Get_Deal_Target] @DealID INT = NULL
AS
    BEGIN
        SELECT DeallTargetID, 
               [DealID], 
               ModuleObjectID, 
               dtc.[CreatedDateTime], 
               [Description], 
               [Strengths], 
               [Weaknesses], 
               [Opportunities], 
               [Threats], 
               cc.companyName TargetName, 
               CompanyBusinessDesc TargetBusinessDesc, 
        (
            SELECT Countryname
            FROM tbl_country c
            WHERE c.countryid = co.CountryID
        ) CountryName, 
               ISNULL(dtc.IsMain, 0) IsMain, 
        (
            SELECT BusinessAreaTitle
            FROM tbl_BusinessArea b
            WHERE b.BusinessAreaID = cc.CompanyBusinessAreaID
                  AND b.Active = 1
        ) TargetTypeDesc
        FROM tbl_DealTarget dtc
             JOIN tbl_companycontact cc ON cc.CompanyContactID = dtc.ModuleObjectID
             LEFT JOIN tbl_companyoffice co ON co.CompanyContactID = cc.CompanyContactID
                                               AND co.ismain = 1
        WHERE DealID = ISNULL(@DealID, DealID);
    END;
