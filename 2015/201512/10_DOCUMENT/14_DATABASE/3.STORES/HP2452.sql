IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2452]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2452]
GO
-----Create by: Dang Le Bao Quynh; Date 23/12/2006  
-----Purpose: Tao view phuc vu In bao cao luong san pham cho Van Hung  
  
CREATE PROCEDURE [HP2452]   
 @sSQL nvarchar(4000)  
AS  
  
If not exists (Select id From Sysobjects Where ID = Object_ID('HV2452') And XType = 'V')  
 Exec ('Create View HV2452 As ' + @sSQL)  
Else  
 Exec ('Alter View HV2452 As ' + @sSQL)