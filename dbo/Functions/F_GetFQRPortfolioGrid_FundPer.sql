  
CREATE FUNCTION [dbo].[F_GetFQRPortfolioGrid_FundPer](@vehicleid        INT,   
                                                     @companycontactid INT,   
                                                     @portfolioid      INT,   
                                                     @date             DATETIME)  
RETURNS DECIMAL(18, 2)  
AS  
     BEGIN  
         DECLARE @isSold BIT;  
         SET @isSold = CASE  
                           WHEN EXISTS  
         (  
             SELECT TOP 1 1  
             FROM tbl_PortfolioVehicle pv  
             WHERE pv.PortfolioID = @portfolioid  
                   AND pv.VehicleID = @vehicleid  
                   AND pv.STATUS = 4  
         )  
                           THEN 1  
                           ELSE 0  
                       END;  
         IF @isSold = 1  
             BEGIN  
                 SET @date = dbo.F_ClosingDate(@vehicleID, @portfolioid, @date);  
                 IF MONTH(@date) <= 3  
                     BEGIN  
                         SET @date = '03-31-' + CAST(YEAR(@date) AS VARCHAR(100));  
                 END;  
                     ELSE  
                     IF MONTH(@date) <= 6  
                         BEGIN  
                             SET @date = '06-30-' + CAST(YEAR(@date) AS VARCHAR(100));  
                     END;  
                         ELSE  
                         IF MONTH(@date) <= 9  
                             BEGIN  
                                 SET @date = '09-30-' + CAST(YEAR(@date) AS VARCHAR(100));  
                         END;  
                             ELSE  
                             IF MONTH(@date) <= 12  
                                 BEGIN  
                                     SET @date = '12-31-' + CAST(YEAR(@date) AS VARCHAR(100));  
                             END;  
         END;  
         DECLARE @result DECIMAL(18, 2);  
         DECLARE @sum DECIMAL(18, 6);  
         SET @sum =  
         (  
             SELECT SUM(dbo.[F_NonDiluted](SH.ObjectID, SH.ModuleID, @date, @portfolioid))  
             FROM tbl_Shareholders SH  
             WHERE TargetPortfolioID = @companycontactid  
         );  
         SET @result = ISNULL(  
         (  
             SELECT dbo.[F_NonDiluted](@vehicleid, 3, @date, @portfolioid)  
         ), 0);  
         IF @sum <> 0  
             SET @result = 100 * @result / @sum;  
         RETURN @result;  
     END;