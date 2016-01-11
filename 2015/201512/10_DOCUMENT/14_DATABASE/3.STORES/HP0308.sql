IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0308]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0308]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 09/10/2013
--- Purpose: Load dữ liệu form DS đề nghị hưởng chế độ ốm đau
--- EXEC HP0308 'AS','%','%','%',3,2012,'01/2012',0

CREATE PROCEDURE [dbo].[HP0308] 
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@Quarter nvarchar(7),
				@IsQuarter tinyint,
				@TransactionID nvarchar(50) = ''
AS
	
IF @TransactionID = ''	--- load form HF0308
	BEGIN
		IF @IsQuarter = 1	--- hiển thị dữ liệu quý
			BEGIN
				SELECT	HT0308.*,
						Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
						A03.DepartmentName, T01.TeamName, V03.ConditionTypeName,
						(Select Top 1 SBeginDate From HT2460 Where DivisionID = @DivisionID And EmployeeID = HT0308.EmployeeID And TranMonth + TranYear * 100 <= @TranMonth + @TranYear * 100
						 Order by SBeginDate DESC) as SBeginDate
												
				FROM	HT0308
				INNER JOIN HT1400 HT00 On HT0308.DivisionID = HT00.DivisionID And HT0308.EmployeeID = HT00.EmployeeID
				Left join AT1102 A03 on HT0308.DivisionID = A03.DivisionID and HT0308.DepartmentID = A03.DepartmentID
				Left Join HT1101 As T01 On HT0308.DivisionID = T01.DivisionID And HT0308.TeamID = T01.TeamID and HT0308.DepartmentID =T01.DepartmentID
				Left Join HV0300 As V03 On HT0308.DivisionID = V03.DivisionID And HT0308.ConditionTypeID = V03.ConditionTypeID and V03.TypeID = 'H04'
				
				WHERE 	HT0308.DivisionID = @DivisionID And  
						HT0308.DepartmentID Like @DepartmentID And 
						isnull(HT0308.TeamID,'') Like @TeamID And 
						HT0308.EmployeeID Like @EmployeeID And
						HT0308.TranYear = @TranYear	And
						HT0308.TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = @DivisionID And [Quarter] = @Quarter)	
				ORDER BY HT0308.EmployeeID
			END
		ELSE	--- hiển thị dữ liệu tháng
			BEGIN
				SELECT	HT0308.*,
						Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
						A03.DepartmentName, T01.TeamName, V03.ConditionTypeName,
						(Select Top 1 SBeginDate From HT2460 Where DivisionID = @DivisionID And EmployeeID = HT0308.EmployeeID And TranMonth + TranYear * 100 <= @TranMonth + @TranYear * 100
						Order by SBeginDate DESC) as SBeginDate
				
				FROM	HT0308
				INNER JOIN HT1400 HT00 On HT0308.DivisionID = HT00.DivisionID And HT0308.EmployeeID = HT00.EmployeeID
				Left join AT1102 A03 on HT0308.DivisionID = A03.DivisionID and HT0308.DepartmentID = A03.DepartmentID
				Left Join HT1101 As T01 On HT0308.DivisionID = T01.DivisionID And HT0308.TeamID = T01.TeamID and HT0308.DepartmentID =T01.DepartmentID
				Left Join HV0300 As V03 On HT0308.DivisionID = V03.DivisionID And HT0308.ConditionTypeID = V03.ConditionTypeID and V03.TypeID = 'H04'
				
				WHERE 	HT0308.DivisionID = @DivisionID And  
						HT0308.DepartmentID Like @DepartmentID And 
						isnull(HT0308.TeamID,'') Like @TeamID And 
						HT0308.EmployeeID Like @EmployeeID And
						HT0308.TranMonth = @TranMonth And
						HT0308.TranYear = @TranYear	
				ORDER BY HT0308.EmployeeID
			END
	END
ELSE	--- load form HF0309
	SELECT	HT0308.*,
			Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
			A03.DepartmentName, T01.TeamName,
			(Select Top 1 SBeginDate From HT2460 Where DivisionID = @DivisionID And EmployeeID = HT0308.EmployeeID And TranMonth + TranYear * 100 <= @TranMonth + @TranYear * 100
			Order by SBeginDate DESC) as SBeginDate
	FROM	HT0308
	INNER JOIN HT1400 HT00 On HT0308.DivisionID = HT00.DivisionID And HT0308.EmployeeID = HT00.EmployeeID
	Left join AT1102 A03 on HT0308.DivisionID = A03.DivisionID and HT0308.DepartmentID = A03.DepartmentID
	Left Join HT1101 As T01 On HT0308.DivisionID = T01.DivisionID And HT0308.TeamID = T01.TeamID and HT0308.DepartmentID =T01.DepartmentID
	WHERE 	HT0308.DivisionID = @DivisionID And HT0308.TransactionID = @TransactionID