/****** Object:  View [dbo].[HV1012]    Script Date: 11/18/2011 16:44:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[HV1012]'))
DROP VIEW [dbo].[HV1012]
GO

/****** Object:  View [dbo].[HV1012]    Script Date: 11/18/2011 16:44:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


--View chet xac dinh tinh trang nhan vien

CREATE VIEW [dbo].[HV1012] as 
Select '0' as EmployeeStatus, N'Tuyển dụng' as Description,  'Recruitment' as EDescription,  0 as Disabled
Union 
Select '1' as EmployeeStatus, N'Đang làm' as Description, 'Working' as EDescription,   0 as Disabled
Union 
Select '2' as EmployeeStatus, N'Thử việc' as Description, 'Trial Period' as EDescription, 0 as Disabled
Union 
Select '3' as EmployeeStatus, N'Tạm nghỉ' as Description, 'Paused' as EDescription, 0 as Disabled
Union
Select '9' as EmployeeStatus, N'Nghỉ việc' as 'Description', 'Stop Working' as EDescription, 0 as Disabled


GO


