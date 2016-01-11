IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0298]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0298]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 05/09/2013
--- Purpose: Load dữ liệu bảng theo dõi thi đua
--- Modify on 06/11/2013 by Bảo Anh: Số ngày nghỉ lấy từ loại cong phép và giảm
--- EXEC HP0298 'AS','%','%','%',1,2012

CREATE PROCEDURE [dbo].[HP0298] 
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int

AS

SELECT	HT24.DivisionID, HT98.TransactionID, HT24.EmployeeID, HV14.FullName,
		Isnull(HT98.AbsentDays, HT02.AbsentAmount) as AbsentDays,
		HT98.HavePermission, HT98.NoPermission, HT98.NoScanning, HT98.InLate, 
		HT98.Moving, HT98.Uniform, HT98.NameTable, HT98.LabourSafety, HT98.InOut, HT98.Notes

FROM	HT2400 HT24
Left Join HV1400 HV14 On HT24.DivisionID = HV14.DivisionID And HT24.EmployeeID = HV14.EmployeeID
Left join (Select * From HT0298   
			Where DivisionID = @DivisionID And  
				EmployeeID Like @EmployeeID And				
				TranMonth = @TranMonth And 
				TranYear = @TranYear) HT98
	on HT24.DivisionID = HT98.DivisionID And HT24.EmployeeID = HT98.EmployeeID And HT24.TranMonth = HT98.TranMonth And HT24.TranYear = HT98.TranYear
Left join (Select DivisionID,EmployeeID,TranMonth,TranYear,AbsentTypeID,SUM(AbsentAmount) as AbsentAmount From HT2402
			Where DivisionID = @DivisionID And  
				EmployeeID Like @EmployeeID And				
				TranMonth = @TranMonth And 
				TranYear = @TranYear And
				AbsentTypeID in (Select AbsentTypeID from HT1013 Where TypeID in ('P','G'))
			Group by DivisionID,EmployeeID,TranMonth,TranYear,AbsentTypeID) HT02
	on HT24.DivisionID = HT02.DivisionID And HT24.EmployeeID = HT02.EmployeeID And HT24.TranMonth = HT02.TranMonth And HT24.TranYear = HT02.TranYear
	
Where 	HT24.DivisionID = @DivisionID And  
		HT24.DepartmentID Like @DepartmentID And 
		isnull(HT24.TeamID,'') Like @TeamID And 
		HT24.EmployeeID Like @EmployeeID And 
		HT24.TranMonth = @TranMonth And
		HT24.TranYear = @TranYear