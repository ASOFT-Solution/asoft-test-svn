IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0314]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0314]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 09/10/2013
--- Purpose: Tính mức lương được hưởng chế độ thai sản
--- Modify on 16/04/2014 by Bảo Anh: Tính số tháng đóng BHXH dựa vào ngày bắt đầu đóng bhxh
--- EXEC HP0314 'UN','AG001',1,2014,0

CREATE PROCEDURE [dbo].[HP0314] 
				@DivisionID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@ConditionTypeID nvarchar(50)
AS

Declare @InsuranceSalary decimal(28,8),
		@CountInsurance int,
		@InsMonth int,
		@SBeginDate datetime,
		@SQL varchar(max)

SELECT TOP 1 @SBeginDate = SBeginDate FROM HT2460 WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID ORDER BY SBeginDate
SELECT @InsMonth = DateDiff(month,@SBeginDate,convert(datetime,ltrim(DAY(@SBeginDate)) + '/' + ltrim(@TranMonth) + '/' + ltrim(@TranYear),101))

IF Isnull(@ConditionTypeID,'') = ''
	SET @InsuranceSalary = 0
ELSE
	BEGIN
		
		SET @CountInsurance = (select count(*) FROM (Select Top 6 InsuranceSalary From HT2400 Where DivisionID = @DivisionID
								And EmployeeID = @EmployeeID AND ISNULL(InsuranceSalary,0) <> 0
								And TranMonth + TranYear * 100 <= @TranMonth + @TranYear * 100
								Order by TranYear DESC, TranMonth DESC) B)
										
		If @ConditionTypeID = 2	--- trường hợp sinh con, nuôi con nuôi
		Begin
			If @InsMonth < 6
				SET @SQL = 'SELECT 0 as InsuranceSalary'
			Else				
				SET @SQL = 'SELECT (Select sum(Isnull(InsuranceSalary,0)) FROM (Select Top ' + ltrim(@CountInsurance) + ' InsuranceSalary From HT2400
										Where DivisionID = ''' + @DivisionID + ''' And EmployeeID = ''' + @EmployeeID + ''' AND ISNULL(InsuranceSalary,0) <> 0
										And TranMonth + TranYear * 100 <= ' + ltrim(@TranMonth + @TranYear * 100) + ' Order by TranYear DESC, TranMonth DESC) A)/' + ltrim(@CountInsurance) + ' as InsuranceSalary'
		End
		Else --- các trường hợp khác
		Begin
			SET @SQL = 'SELECT (Select sum(Isnull(InsuranceSalary,0)) FROM (Select Top ' + ltrim(@CountInsurance) + ' InsuranceSalary From HT2400
									Where DivisionID = ''' + @DivisionID + ''' And EmployeeID = ''' + @EmployeeID + ''' AND ISNULL(InsuranceSalary,0) <> 0
									And TranMonth + TranYear * 100 <= ' + ltrim(@TranMonth + @TranYear * 100) + ' Order by TranYear DESC, TranMonth DESC) A)/' + ltrim(@CountInsurance) + ' as InsuranceSalary'
		End
	END
	
EXEC(@SQL)