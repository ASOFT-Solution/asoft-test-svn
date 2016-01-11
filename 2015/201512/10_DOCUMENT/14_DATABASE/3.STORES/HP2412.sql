/****** Object:  StoredProcedure [dbo].[HP2412]    Script Date: 07/30/2010 17:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Kiem tra dieu kien khi ket chuyen cham cong ngay sang cham cong thang
---- Created by Nguyen Thi Ngoc Minh, Date 05/05/2004

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE 	[dbo].[HP2412]	 @DivisionID as nvarchar(50), 
				@DepartmentID as nvarchar(50), 
				@TeamID as nvarchar(50), 
				@EmployeeID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@AbsentTypeID as nvarchar(50),
				@PeriodID nvarchar(50) = Null


 AS

Declare @sSQL as nvarchar(4000),
	@HV2412Cursor as cursor,
	@FullName as nvarchar(250),
	@DepartmentName as nvarchar(250),
	@Status as tinyint,
	@VietMess as nvarchar(1000),
	@EngMess as nvarchar(1000),
	@BeginDate as datetime,
	@EndDate as datetime,
	@TempMonth as nvarchar(2)

Set @Status =0
Set @VietMess =''
Set @EngMess =''

/*
if @PeriodID is Null
	Set @sSQL = '
	Select H02.EmployeeID, H02.DepartmentID, H00.FullName, A02.DepartmentName
	From HT2402 as H02 inner join HV1400 as H00 on H02.EmployeeID = H00.EmployeeID
				inner join AT1102 as A02 on H02.DepartmentID = A02.DepartmentID and H02.DivisionID = A02.DivisionID
	Where H02.DivisionID like ''' + @DivisionID + ''' and
		H02.DepartmentID like ''' + @DepartmentID + ''' and
		isnull(H02.TeamID,'''') like ''' + @TeamID + ''' and
		H02.EmployeeID like ''' + @EmployeeID + ''' and
		H02.AbsentTypeID like ''' + @AbsentTypeID + ''' and
		H02.TranMonth = ' +  ltrim(@TranMonth) +' and
		H02.TranYear = ' + ltrim(@TranYear) 

Else
	Set @sSQL = '
	Select H02.EmployeeID, H02.DepartmentID, H00.FullName, A02.DepartmentName
	From HT2402 as H02 inner join HV1400 as H00 on H02.EmployeeID = H00.EmployeeID
				inner join AT1102 as A02 on H02.DepartmentID = A02.DepartmentID and H02.DivisionID = A02.DivisionID
	Where H02.DivisionID like ''' + @DivisionID + ''' and
		H02.DepartmentID like ''' + @DepartmentID + ''' and
		isnull(H02.TeamID,'''') like ''' + @TeamID + ''' and
		H02.EmployeeID like ''' + @EmployeeID + ''' and
		H02.AbsentTypeID like ''' + @AbsentTypeID + ''' and
		H02.TranMonth = ' +  ltrim(@TranMonth) +' and
		H02.TranYear = ' + ltrim(@TranYear) + ' and 
		H02.PeriodID = ''' + @PeriodID + ''''


If  Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='HV2412')
	Drop view HV2412
	Exec(' Create view HV2412 as '+@sSQL)

SET @HV2412Cursor = CURSOR SCROLL KEYSET FOR
		SELECT *
		FROM HV2412
If Exists (Select EmployeeID From HV2412)
  Begin
	Set @Status = 1
	Set @VietMess = @VietMess + 'Baïn khoâng theå chaám coâng 1 loaïi chaám coâng ' + char(13) + 'cho cuøng 1 nhaân vieân trong cuøng 1 thaùng:'
	Set @EngMess = @EngMess + 'You cannot choose the same absent type ' + char(13) + 'for a same employee in a same month: '
  End

OPEN @HV2412Cursor
FETCH NEXT FROM @HV2412Cursor INTO @EmployeeID, @DepartmentID, @FullName, @DepartmentName

WHILE @@FETCH_STATUS = 0
  BEGIN
	Set @VietMess = @VietMess + char(13) + @FullName + ' - ' + @DepartmentName + ', '
	Set @EngMess = @EngMess + char(13) + @FullName + ' - ' + @DepartmentName + ', '
	FETCH NEXT FROM @HV2412Cursor INTO @EmployeeID, @DepartmentID, @FullName, @DepartmentName
  END
CLOSE @HV2412Cursor
DEALLOCATE @HV2412Cursor 	

If Exists (Select EmployeeID From HV2412)
  Begin
	Set @VietMess = left(ltrim(rtrim(@VietMess)),len(ltrim(rtrim(@VietMess)))-1) + '.'
	Set @EngMess = left(ltrim(rtrim(@EngMess)),len(ltrim(rtrim(@EngMess)))-1) + '.'
  End
Goto EndMess

EndMess:
*/
	Select @Status as Status, @VietMess as Vietmess, @EngMess as EngMess
