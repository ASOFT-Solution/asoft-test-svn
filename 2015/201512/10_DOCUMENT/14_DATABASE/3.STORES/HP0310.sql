IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0310]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0310]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 09/10/2013
--- Purpose: Load dữ liệu form DS đề nghị hưởng trợ cấp nghỉ DSPHSK sau thai sản
--- EXEC HP0310 'AS','%','%','%',3,2012,1

CREATE PROCEDURE [dbo].[HP0310] 
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@IsQuarter tinyint,
				@TransactionID nvarchar(50) = ''
AS

IF @TransactionID = ''	--- load form HF0310
	BEGIN
		IF @IsQuarter = 1	--- hiển thị dữ liệu quý
			BEGIN
				Declare @Quarter nvarchar(7)
				SELECT @Quarter = [Quarter] FROM HV9999 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear
				--- Trả ra dữ liệu
				SELECT	HT0310.*,
						Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
						A03.DepartmentName, T01.TeamName, V03.ConditionTypeName
				FROM	HT0310
				INNER JOIN HT1400 HT00 On HT0310.DivisionID = HT00.DivisionID And HT0310.EmployeeID = HT00.EmployeeID
				Left join AT1102 A03 on HT0310.DivisionID = A03.DivisionID and HT0310.DepartmentID = A03.DepartmentID
				Left Join HT1101 As T01 On HT0310.DivisionID = T01.DivisionID And HT0310.TeamID = T01.TeamID and HT0310.DepartmentID =T01.DepartmentID
				Left Join HV0300 As V03 On HT0310.DivisionID = V03.DivisionID And HT0310.ConditionTypeID = V03.ConditionTypeID and V03.TypeID = 'H01'
				WHERE 	HT0310.DivisionID = @DivisionID And  
						HT0310.DepartmentID Like @DepartmentID And 
						isnull(HT0310.TeamID,'') Like @TeamID And 
						HT0310.EmployeeID Like @EmployeeID And
						HT0310.TranYear = @TranYear	And
						HT0310.TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = @DivisionID And [Quarter] = @Quarter)	
				ORDER BY HT0310.EmployeeID
			END
		ELSE	--- hiển thị dữ liệu tháng
			BEGIN
				SELECT	HT0310.*,
						Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
						A03.DepartmentName, T01.TeamName, V03.ConditionTypeName
				FROM	HT0310
				INNER JOIN HT1400 HT00 On HT0310.DivisionID = HT00.DivisionID And HT0310.EmployeeID = HT00.EmployeeID
				Left join AT1102 A03 on HT0310.DivisionID = A03.DivisionID and HT0310.DepartmentID = A03.DepartmentID
				Left Join HT1101 As T01 On HT0310.DivisionID = T01.DivisionID And HT0310.TeamID = T01.TeamID and HT0310.DepartmentID =T01.DepartmentID
				Left Join HV0300 As V03 On HT0310.DivisionID = V03.DivisionID And HT0310.ConditionTypeID = V03.ConditionTypeID and V03.TypeID = 'H01'
				WHERE 	HT0310.DivisionID = @DivisionID And  
						HT0310.DepartmentID Like @DepartmentID And 
						isnull(HT0310.TeamID,'') Like @TeamID And 
						HT0310.EmployeeID Like @EmployeeID And 
						HT0310.TranMonth = @TranMonth And
						HT0310.TranYear = @TranYear	
				ORDER BY HT0310.EmployeeID
			END
	END
ELSE	--- load form HF0311
	SELECT	*
	FROM	HT0310
	WHERE 	DivisionID = @DivisionID And TransactionID = @TransactionID