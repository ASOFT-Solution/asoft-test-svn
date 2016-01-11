IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV8888]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV8888]
GO
---Created by : Vo Thanh Huong,   date : 03/02/2005  
---purpose:  Quan ly bao cao (view chet )  
 
Create VIEW [dbo].[HV8888] as  
Select 'G01' as GroupId, N'Danh sách nhân viên' as GroupName , N'' as GroupNameE
Union  
Select 'G02' as GroupId, N'Quản lý nhân sự' as GroupName , N'' as GroupNameE
Union  
Select 'G03' as GroupId, N'Bảo hiểm xã hội' as GroupName ,  N'' as GroupNameE  
Union  
Select 'G04' as GroupId, N'Tạm ứng' as GroupName , N'' as GroupNameE  
Union  
Select 'G05' as GroupId, N'Lương' as GroupName , N'' as GroupNameE   
Union  
Select 'G06' as GroupId, N'Chấm công' as GroupName , N'' as GroupNameE  
Union  
Select 'G07' as GroupId, N'Báo cáo lương' as GroupName , N'' as GroupNameE  
Union  
Select 'G08' as GroupId, N'Thu nhập cá nhân' as GroupName , N'' as GroupNameE  
Union  
Select 'G09' as GroupId, N'Khác' as GroupName , N'' as GroupNameE
Union  
Select 'G19' as GroupId, N'Báo cáo biến động lương' as GroupName , N'' as GroupNameE