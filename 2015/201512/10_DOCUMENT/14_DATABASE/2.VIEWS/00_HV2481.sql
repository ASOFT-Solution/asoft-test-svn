IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV2481]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV2481]
GO
--///////////////////Tạo view///////////////////////
--Tạo view HV2481
CREATE VIEW [dbo].[HV2481]  
AS  
-- Create by: Dang Le Thanh Tra; Date: 26/04/2011    
-- Purpose: View chet load che do thai san    
    
 Select 'I' Type, N'Khám thai' TypeDescription, '' TypeDescriptionE  
 union     
 Select 'II' Type, N'Sảy thai, nạo hút thai, thai chết lưu' TypeDescription, '' TypeDescriptionE     
 union     
 Select 'III' Type, N'Sinh con, nuôi con nuôi' TypeDescription, '' TypeDescriptionE         
 union     
 Select 'IV' Type, N'Thực hiện các biện pháp tránh thai' TypeDescription, '' TypeDescriptionE    


 
   

 
 

