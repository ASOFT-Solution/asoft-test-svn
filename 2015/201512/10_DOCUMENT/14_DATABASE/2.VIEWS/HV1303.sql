IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV1303]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV1303]
GO
CREATE VIEW HV1303 AS SELECT HT.EmployeeID, HV.FullName, HV.DivisionID,HV.DepartmentID, HV.TeamID,  
 HT.TranMonth, HT.TranYear, HT.FromDate, HT.NumberOfDays,HT.AbsentAmount, HT.ToPlace, HT.Price, HT13.AbsentName, HT.IsTimeKeeping  
FROM HT1303 HT inner join HV1400 HV on HT.EmployeeID = HV.EmployeeID   and HT.DivisionID = HV.DivisionID   
inner join HT1013 HT13 on HT.AbsentTypeID = HT13.AbsentTypeID and HT.DivisionID = HT13.DivisionID