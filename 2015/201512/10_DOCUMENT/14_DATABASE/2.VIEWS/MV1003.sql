/****** Object:  View [dbo].[MV1003]    Script Date: 12/16/2010 15:24:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date: 02/12/2005
---purpose: View chet, loc ra cac lenh san xuat cho combo 
ALTER VIEW [dbo].[MV1003] as 
Select T00.DivisionID, TranMonth, TranYear, PlanID, VoucherTypeID, VoucherDate, VoucherNo, SOderID,  Description, PlanStatus, 
	T00.EmployeeID, FullName
From MT2001 T00 --left join AT1102  T01 on T00.DepartmentID = T01.DepartmentID
	left join AT1103 T02 on T02.EmployeeID = T00.EmployeeID

GO


