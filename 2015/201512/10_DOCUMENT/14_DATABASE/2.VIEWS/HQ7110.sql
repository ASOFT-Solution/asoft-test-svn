IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HQ7110]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HQ7110]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by: Dang Le Bao Quynh; Date: 07/08/09
---- Edit by: Huynh Tan Phu, Date 04/07/2007 Bo cac clolumn HV1400.WorkDate, HV1400.LeaveDate, HV1400.CountryName
---- Purpose: Viet chet in bao cao luong theo thiet lap
---- Modifile by Thanh Thịnh: Date 10/8/2015 Lý Do Nghĩ Việc, Ngày Cấp CMND, Nơi Cấp CMND, ngày cấp BHXH
---- Modifile by Thanh Thịnh: Date 02/11/2015 Thêm cột chiều cao

CREATE VIEW HQ7110
AS

SELECT H10.*, H00.InsuranceSalary, H00.Salary01, H00.Salary02, H00.Salary03, H40.EmployeeStatus,
	 LRS.QuitJobName , h40.IdentifyPlace, h40.IdentifyDate, H42.SoInsurBeginDate, H42.Hobby
FROM HT7110 H10
LEFT JOIN HT1400 H40 ON H40.DivisionID = H10.DivisionID AND H40.EmployeeID = H10.EmployeeID
LEFT JOIN HT1403 h43 ON h43.DivisionID = H10.DivisionID AND h43.EmployeeID = H10.EmployeeID
LEFT JOIN HT1107 LRS ON LRS.DivisionID = H10.DivisionID AND LRS.QuitJobID = h43.QuitJobID
LEFT JOIN HT2400 H00 ON H00.DivisionID = H10.DivisionID AND H00.EmployeeID = H10.EmployeeID AND H00.TranMonth = H10.TranMonth AND H00.TranYear = H10.TranYear
LEFT JOIN HT1402 H42 ON H42.DivisionID = H10.DivisionID AND H42.EmployeeID = H10.EmployeeID



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
