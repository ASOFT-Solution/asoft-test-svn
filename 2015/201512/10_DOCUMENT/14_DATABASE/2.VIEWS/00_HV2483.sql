IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV2483]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV2483]
GO
--Tạo view HV2483 
CREATE VIEW [dbo].[HV2483]  
AS  
-- Create by: Dang Le Thanh Tra; Date: 26/04/2011  
-- Purpose: View chet load che do om dau  
  
 Select 'I' Type, N'Bản thân ốm ngắn ngày' TypeDescription, '' TypeDescriptionE   
 union   
 Select 'II' Type, N'Bản thân ốm dài ngày' TypeDescription, '' TypeDescriptionE  
 union   
 Select 'III' Type, N'Con ốm' TypeDescription, '' TypeDescriptionE 