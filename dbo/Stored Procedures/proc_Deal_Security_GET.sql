
-- created by	:	Syed Zain ALi

CREATE PROCEDURE [dbo].[proc_Deal_Security_GET] @DealID INT = NULL
AS
    BEGIN
        SELECT [DealSecurityID], 
               [DealID], 
               AllocationRatio, 
               ds.[SecurityTypeID], 
               [IsActive], 
               [CreateOn], 
               [CreateBy], 
               st.DealSecurityTypeName
        FROM tbl_DealSecurity ds
             LEFT JOIN tbl_DealSecurityType st ON ds.[SecurityTypeID] = st.DealSecurityTypeID
        WHERE DealID = ISNULL(@DealID, DealID);
    END;
