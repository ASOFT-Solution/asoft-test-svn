IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2405]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2405]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



----Created by: Dang Le Bao Quynh
----Created date: 16/08/2006
----purpose: Luu tam ung

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/
---- Modified on 24/07/2013 by Lê Thị Thu Hiền : Không lấy AP0000 mà lấy AP0002

CREATE PROCEDURE [dbo].[HP2405]  
				@IsEdit tinyint,
				@AdvanceID nvarchar(50),
				@DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),	
				@TeamID nvarchar(50),
				@EmployeeID nvarchar(50),
				@AdvanceDate datetime,
				@TranMonth as int,
				@TranYear as int,
				@Description nvarchar(250),
				@IsRate tinyint,
				@AdvanceAmount decimal(28,8),
				@AdvanceRate decimal(28,8),
				@SalaryField nvarchar(20),
				@CreateUserID nvarchar(50)
			
AS

DECLARE 	@sSQL nvarchar(4000),
	    	@AdvanceCalculate decimal(28,8),
			@cur cursor,
			@DepartmentInsertID nvarchar(50),
			@TeamInsertID nvarchar(50),
			@EmployeeInsertID nvarchar(50),
			@CustomerName NVARCHAR (50)
			
CREATE TABLE #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

SET NOCOUNT ON

CREATE TABLE #AdvanceCalculate ( DivisionID nvarchar(50) ,DepartmentID nvarchar(50),TeamID nvarchar(50),EmployeeID nvarchar(50),Advance decimal(28,8))		

If @IsEdit = 1 
	Begin
		If @IsRate=1
			Begin
				SET @sSQL=	'INSERT INTO #AdvanceCalculate SELECT DivisionID, DepartmentID,TeamID,EmployeeID,' + @SalaryField + ' FROM ' +
						'HT2400 WHERE ' +
						' DivisionID =  ''' + @DivisionID + ''' AND ' +
						'EmployeeID=''' + @EmployeeID + ''' AND ' +
						'Tranmonth = ' + ltrim(@TranMonth) + ' AND ' +
						'TranYear = ' + ltrim(@TranYear)
				EXEC  (@sSQL) 
				

				
				SET @AdvanceCalculate = (SELECT Advance FROM #AdvanceCalculate Where DivisionID = @DivisionID)	
				
				Update HT2500 Set AdvanceAmount = @AdvanceCalculate*@AdvanceRate/100, Description = @Description, 
							  AdvanceDate = @AdvanceDate, LastModifyUserID = @CreateUserID, LastModifyDate = getdate()			
				Where AdvanceID = @AdvanceID and DivisionID = @DivisionID
			End
		Else
			Begin
				Update HT2500 Set AdvanceAmount = @AdvanceAmount, Description = @Description, 
						AdvanceDate = @AdvanceDate, LastModifyUserID = @CreateUserID, LastModifyDate = getdate()			
				Where AdvanceID = @AdvanceID and DivisionID = @DivisionID
			End			

	End 
Else 
	Begin							
		If @IsRate=1
			Begin
				SET @sSQL=	'INSERT INTO #AdvanceCalculate SELECT DivisionID, DepartmentID,TeamID,EmployeeID,' + @SalaryField + ' FROM ' +
						'HT2400 WHERE ' + 
						'DivisionID = ''' + @DivisionID + ''' AND ' +
						'isnull(DepartmentID,''%'') like ''' + @DepartmentID + ''' AND ' +
						'isnull(TeamID,''%'') like ''' + @TeamID + ''' AND ' +
						'EmployeeID like ''' + @EmployeeID + ''' AND ' +
						'Tranmonth = ' + ltrim(@TranMonth) + ' AND ' +
						'TranYear = ' + ltrim(@TranYear)
				EXEC  (@sSQL) 

				SET @cur = cursor static for
				SELECT DepartmentID,TeamID,EmployeeID,Advance From #AdvanceCalculate

				Open @cur
				
				Fetch Next From @cur Into @DepartmentInsertID,@TeamInsertID,@EmployeeInsertID,@AdvanceCalculate
				
				While @@FETCH_STATUS=0
				Begin
					Exec AP0002  @DivisionID, @AdvanceID  OUTPUT, 'HT2500', 'AT', @TranYear, '', 15, 3, 0, ''
					INSERT INTO HT2500 (
								AdvanceID, DivisionID, 
								DepartmentID, TeamID, 
								EmployeeID, TranMonth, TranYear, 
								AdvanceDate, AdvanceAmount, 
								[Description], CreateUserID, CreateDate
								)
					VALUES 	(
							@AdvanceID, @DivisionID,
							@DepartmentInsertID, @TeamInsertID,
							@EmployeeInsertID, @TranMonth, @TranYear,
							@AdvanceDate,@AdvanceCalculate*@AdvanceRate/100,
							@Description,@CreateUserID,getdate()
							)
					Fetch Next From @cur Into @DepartmentInsertID,@TeamInsertID,@EmployeeInsertID,@AdvanceCalculate
				End

				Close @cur
			End
		Else
			Begin
				SET @sSQL=	'INSERT INTO #AdvanceCalculate SELECT DivisionID, DepartmentID,TeamID,EmployeeID,0 FROM ' +
						'HT2400 WHERE ' + 
						'DivisionID = ''' + @DivisionID + ''' AND ' +
						'isnull(DepartmentID,''%'') like ''' + @DepartmentID + ''' AND ' +
						'isnull(TeamID,''%'') like ''' + @TeamID + ''' AND ' +
						'EmployeeID like ''' + @EmployeeID + ''' AND ' +
						'Tranmonth = ' + ltrim(@TranMonth) + ' AND ' +
						'TranYear = ' + ltrim(@TranYear)
				EXEC  (@sSQL) 

				SET @cur = cursor static for
				SELECT DepartmentID,TeamID,EmployeeID From #AdvanceCalculate

				Open @cur
				
				Fetch Next From @cur Into @DepartmentInsertID,@TeamInsertID,@EmployeeInsertID
				
				While @@FETCH_STATUS=0
				Begin
					Exec AP0002  @DivisionID, @AdvanceID  OUTPUT, 'HT2500', 'AT', @TranYear, '', 15, 3, 0, ''
					INSERT INTO HT2500 (
								AdvanceID, DivisionID, 
								DepartmentID, TeamID, 
								EmployeeID, TranMonth, TranYear, 
								AdvanceDate, AdvanceAmount, 
								[Description], CreateUserID, CreateDate
								 )
					SELECT 	
							@AdvanceID, @DivisionID,
							@DepartmentInsertID, @TeamInsertID,
							@EmployeeInsertID, @TranMonth, @TranYear,
							@AdvanceDate,(CASE WHEN @CustomerName = '19' THEN Salary03 * [C02] ELSE @AdvanceAmount END) ,@Description,@CreateUserID,getdate()				
					FROM HT1403 WHERE EmployeeID = @EmployeeInsertID
					Fetch Next From @cur Into @DepartmentInsertID,@TeamInsertID,@EmployeeInsertID
				End

				Close @cur
			End
	End
DROP TABLE #AdvanceCalculate
SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

