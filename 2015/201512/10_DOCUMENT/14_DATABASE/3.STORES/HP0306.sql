IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0306]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0306]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 09/10/2013
--- Purpose: Load dữ liệu form cập nhật thông tin xét duyệt đề nghị hưởng trợ cấp
--- EXEC HP0306 'AS','%','%','%',3,2012,'01/2012',0,1,'HF0308'

CREATE PROCEDURE [dbo].[HP0306] 
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@Quarter nvarchar(7),
				@IsQuarter tinyint,
				@TimesNo int,
				@FormID nvarchar(10)
AS
	
Declare @SQL nvarchar(max),
		@TableID nvarchar(10),
		@WhereTime nvarchar(max),
		@Join nvarchar(max),
		@Select nvarchar(max)
	
IF @FormID = 'HF0302'
	BEGIN
		SET @TableID = 'HT0301'
		SET @Join = ''
		SET @Select = 'SELECT HT03.EmployeeID, HT03.SNo, HT03.TransactionID, NULL as ConditionTypeName, HT03.LeaveFromDate as VoucherDateFrom, HT03.LeaveToDate as VoucherDateTo,
						(Isnull(HT03.HomeDays,0) + Isnull(HT03.HealthCenterDays,0)) as InLeaveDays, Amounts, HT03.IsExamined, HT03.EndInLeaveDays,
						HT03.EndAmounts, HT03.Reason'
	END
IF @FormID = 'HF0310'
	BEGIN
		SET @TableID = 'HT0310'
		SET @Join = 'LEFT JOIN HV0300 On HT03.DivisionID = HV0300.DivisionID And HT03.ConditionTypeID = HV0300.ConditionTypeID And HV0300.TypeID = ''H01'''
		SET @Select = 'SELECT HT03.EmployeeID, HT03.SNo, HT03.TransactionID, HV0300.ConditionTypeName, HT03.LeaveFromDate as VoucherDateFrom, HT03.LeaveToDate as VoucherDateTo,
						(Isnull(HT03.HomeDays,0) + Isnull(HT03.HealthCenterDays,0)) as InLeaveDays, Amounts, HT03.IsExamined, HT03.EndInLeaveDays,
						HT03.EndAmounts, HT03.Reason'
	END
IF @FormID = 'HF0312'
	BEGIN
		SET @TableID = 'HT0312'
		SET @Join = 'LEFT JOIN HV0300 On HT03.DivisionID = HV0300.DivisionID And HT03.ConditionTypeID = HV0300.ConditionTypeID And HV0300.TypeID = ''H03'''
		SET @Select = 'SELECT HT03.EmployeeID, HT03.SNo, HT03.TransactionID, HV0300.ConditionTypeName, HT03.LeaveFromDate as VoucherDateFrom, HT03.LeaveToDate as VoucherDateTo,
						(Isnull(HT03.HomeDays,0) + Isnull(HT03.HealthCenterDays,0)) as InLeaveDays, Amounts, HT03.IsExamined, HT03.EndInLeaveDays,
						HT03.EndAmounts, HT03.Reason'
	END
IF @FormID = 'HF0315'
	BEGIN
		SET @TableID = 'HT0315'
		SET @Join = 'LEFT JOIN HV0300 On HT03.DivisionID = HV0300.DivisionID And HT03.ConditionTypeID = HV0300.ConditionTypeID And HV0300.TypeID = ''H02'''
		SET @Select = 'SELECT HT03.EmployeeID, HT03.SNo, HT03.TransactionID, HV0300.ConditionTypeName, HT03.VoucherDate as VoucherDateFrom, NULL as VoucherDateTo,
						HT03.InLeaveDays, HT03.Amounts, HT03.IsExamined, HT03.EndInLeaveDays, HT03.EndAmounts, HT03.Reason'
	END
IF @FormID = 'HF0308'
	BEGIN
		SET @TableID = 'HT0308'
		SET @Join = 'LEFT JOIN HV0300 On HT03.DivisionID = HV0300.DivisionID And HT03.ConditionTypeID = HV0300.ConditionTypeID And HV0300.TypeID = ''H04'''
		SET @Select = 'SELECT HT03.EmployeeID, HT03.SNo, HT03.TransactionID, HV0300.ConditionTypeName, HT03.VoucherDateFrom, HT03.VoucherDateTo,
						HT03.InLeaveDays, HT03.Amounts, HT03.IsExamined, HT03.EndInLeaveDays, HT03.EndAmounts, HT03.Reason'
	END

IF @IsQuarter = 1	--- hiển thị dữ liệu quý
	SET @WhereTime = ' And HT03.TranYear = ' + str(@TranYear) + '
						And	HT03.TranMonth in (Select TranMonth FROM HV9999 Where DivisionID = ''' + @DivisionID + ''' And Quarter = ''' + @Quarter + ''')'	
					
ELSE	--- hiển thị dữ liệu tháng
	SET @WhereTime = ' And HT03.TranMonth = ' + str(@TranMonth) + ' AND HT03.TranYear = ' + str(@TranYear)
	
SET @SQL = @Select + ', Ltrim(RTrim(isnull(HT00.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT00.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.FirstName,''''))) As FullName,
					A03.DepartmentName, T01.TeamName
			
					FROM ' + @TableID + ' HT03
					INNER JOIN HT1400 HT00 On HT03.DivisionID = HT00.DivisionID And HT03.EmployeeID = HT00.EmployeeID
					LEFT JOIN AT1102 A03 on HT03.DivisionID = A03.DivisionID and HT03.DepartmentID = A03.DepartmentID
					LEFT JOIN HT1101 As T01 On HT03.DivisionID = T01.DivisionID And HT03.TeamID = T01.TeamID and HT03.DepartmentID =T01.DepartmentID ' + @Join + '			
					
					WHERE HT03.DivisionID = ''' + @DivisionID + ''' And HT03.DepartmentID like ''' + @DepartmentID + '''
					AND Isnull(HT03.TeamID,'''') like ''' + @TeamID + ''' AND HT03.EmployeeID like ''' + @EmployeeID + '''
					AND HT03.TimesNo = ' + STR(@TimesNo) + @WhereTime + '
					
					ORDER BY HT03.IsExamined, HT03.EmployeeID'
	
EXEC(@SQL)