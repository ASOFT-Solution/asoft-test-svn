IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2417]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2417]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 19/08/2013
--- Purpose: Chuyển dữ liệu lương của data thuế sang tạm ứng của dữ liệu nội bộ (Thuận Lợi)

CREATE PROCEDURE [dbo].[HP2417]  
				@DivisionID nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@FromDepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@PayrollMethodID nvarchar(50),
				@Description nvarchar(250),
				@CreateUserID nvarchar(50)
AS

DECLARE 	@sSQL nvarchar(4000),
	    	@AdvanceID nvarchar(50),
	    	@TargetData nvarchar(50),
	    	@Cur cursor,
	    	@DepartmentInsertID nvarchar(50),
			@TeamInsertID nvarchar(50),
			@EmployeeInsertID nvarchar(50),
			@AdvanceAmount decimal(28,8)	

--- Lấy tên dữ liệu thuế theo thiết lập
SELECT @TargetData = TargetData FROM HT0000 WHERE DivisionID = @DivisionID

--- Xóa dữ liệu tạm ứng trên data nội bộ trước khi insert
DELETE HT2500 WHERE DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear
And (DepartmentID Between @FromDepartmentID And @ToDepartmentID) And ISNULL(IsFromOtherData,0) = 1

--- Tạo bảng tạm chứa bảng lương của dữ liệu thuế
CREATE TABLE #Advance (DivisionID nvarchar(50), DepartmentID nvarchar(50),TeamID nvarchar(50),EmployeeID nvarchar(50),AdvanceAmount decimal(28,8))		

SET @sSQL = 'INSERT INTO #Advance (DivisionID, DepartmentID, TeamID, EmployeeID, AdvanceAmount)
SELECT DivisionID, DepartmentID, TeamID, EmployeeID, SalaryAmount
FROM ' + @TargetData + '.dbo.HV3400
Where DivisionID = ''' + @DivisionID + ''' And TranMonth = ' + str(@TranMonth) + ' and TranYear = ' + str(@TranYear) + '
and (DepartmentID between ''' + @FromDepartmentID + ''' And ''' + @ToDepartmentID + ''')
And PayrollMethodID like ''' + @PayrollMethodID + '''
Order by DepartmentID, EmployeeID'
EXEC(@sSQL)

SET NOCOUNT ON

SET @Cur = cursor static for
SELECT DepartmentID,TeamID,EmployeeID,AdvanceAmount From #Advance

Open @Cur

Fetch Next From @Cur Into @DepartmentInsertID,@TeamInsertID,@EmployeeInsertID,@AdvanceAmount

While @@FETCH_STATUS=0
Begin
	Exec AP0002  @DivisionID, @AdvanceID  OUTPUT, 'HT2500', 'AT', @TranYear, '', 15, 3, 0, ''

	INSERT INTO HT2500 (DivisionID, AdvanceID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AdvanceDate, AdvanceAmount, 
				[Description], CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, IsFromOtherData)
	
	VALUES(@DivisionID, @AdvanceID, @DepartmentInsertID, @TeamInsertID, @EmployeeInsertID,	@TranMonth, @TranYear,
		(Select EndDate From HT9999 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear = @TranYear),
		@AdvanceAmount, @Description, @CreateUserID, GETDATE(), @CreateUserID, GETDATE(), 1)
	
	Fetch Next From @Cur Into @DepartmentInsertID,@TeamInsertID,@EmployeeInsertID,@AdvanceAmount
End

Close @Cur

SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
