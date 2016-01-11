IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0301]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0301]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 05/09/2013
--- Purpose: Load dữ liệu form DS đề nghị hưởng trợ cấp nghỉ DSPHSK
--- EXEC HP0301 'AS','%','%','%',1,2012,1

CREATE PROCEDURE [dbo].[HP0301] 
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@IsQuarter tinyint,
				@TransactionID nvarchar(50) = ''
AS

IF @TransactionID = ''	--- load form HF0301
	BEGIN
		IF @IsQuarter = 1	--- hiển thị dữ liệu quý
			BEGIN
				Declare @Quarter nvarchar(7)
				SELECT @Quarter = [Quarter] FROM HV9999 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear
				--- Trả ra dữ liệu
				SELECT	HT0301.*,
						Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
						A03.DepartmentName, T01.TeamName
				FROM	HT0301
				INNER JOIN HT1400 HT00 On HT0301.DivisionID = HT00.DivisionID And HT0301.EmployeeID = HT00.EmployeeID
				Left join AT1102 A03 on A03.DivisionID = HT0301.DivisionID and A03.DepartmentID = HT0301.DepartmentID
				Left Join HT1101 As T01 On HT0301.DivisionID = T01.DivisionID And HT0301.TeamID = T01.TeamID and HT0301.DepartmentID =T01.DepartmentID
				WHERE 	HT0301.DivisionID = @DivisionID And  
						HT0301.DepartmentID Like @DepartmentID And 
						isnull(HT0301.TeamID,'') Like @TeamID And 
						HT0301.EmployeeID Like @EmployeeID And 
						HT0301.TranYear = @TranYear And
						HT0301.TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = @DivisionID And [Quarter] = @Quarter)		 		
				ORDER BY HT0301.TranMonth, HT0301.EmployeeID
			END
		ELSE	--- hiển thị dữ liệu tháng
			BEGIN
				SELECT	HT0301.*,
						Ltrim(RTrim(isnull(HT00.LastName,'')))+ ' ' + LTrim(RTrim(isnull(HT00.MiddleName,''))) + ' ' + LTrim(RTrim(Isnull(HT00.FirstName,''))) As FullName,
						A03.DepartmentName, T01.TeamName
				FROM	HT0301
				INNER JOIN HT1400 HT00 On HT0301.DivisionID = HT00.DivisionID And HT0301.EmployeeID = HT00.EmployeeID
				Left join AT1102 A03 on A03.DivisionID = HT0301.DivisionID and A03.DepartmentID = HT0301.DepartmentID
				Left Join HT1101 As T01 On HT0301.DivisionID = T01.DivisionID And HT0301.TeamID = T01.TeamID and HT0301.DepartmentID =T01.DepartmentID
				WHERE 	HT0301.DivisionID = @DivisionID And  
						HT0301.DepartmentID Like @DepartmentID And 
						isnull(HT0301.TeamID,'') Like @TeamID And 
						HT0301.EmployeeID Like @EmployeeID And 
						HT0301.TranMonth = @TranMonth And
						HT0301.TranYear = @TranYear			
				ORDER BY HT0301.TranMonth, HT0301.EmployeeID
			END
	END

ELSE	--- load form HF0302
	SELECT	*
	FROM	HT0301
	WHERE 	DivisionID = @DivisionID And TransactionID = @TransactionID