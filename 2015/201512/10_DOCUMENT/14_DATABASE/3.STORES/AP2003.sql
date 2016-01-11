
/****** Object:  StoredProcedure [dbo].[AP2003]    Script Date: 07/29/2010 14:33:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP2003]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP2003]
GO

/****** Object:  StoredProcedure [dbo].[AP2003]    Script Date: 07/29/2010 14:33:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


------- Created by Nguyen Van Nhan. Date 17/05/2003
------ Purpose: Xu ly danh sach cac lÞch lµm viÖc ®Ó ®­a lªn Fom AF2003

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP2003] 	@DivisionID as nvarchar(50),
				@TimeType as tinyint, --(1 Tuan, 2 He thong, 3 Ngay, 4 Thang)
					@BeginDate as Datetime,
					@EndDate as  Datetime,
					@CurrentDate as Datetime,
					@TranMonth as int,
					@TranYear as int,
				@UseType as tinyint,
					@UserID as nvarchar(50),
					@DepartmentID as nvarchar(50)
		
				
 AS
Declare @sSQL as nvarchar(4000),
	@SqlWhere1 as nvarchar(500),
	@SqlWhere2 as nvarchar(500),
	@FromDate as Datetime,
	@ToDate as Datetime,
	@ScheduleDays as int
	

------ Xu ly tho gian
	If @TimeType =1 or @TimeType =3	--- theo tuan, theo ngay
		Begin
			Set @FromDate = @BeginDate
			Set @ToDate = @EndDate
			Set @SqlWhere1 = ' and (ScheduleDate Between '''+convert(nvarchar(50), @BeginDate,101)+''' and '''+convert(nvarchar(50),@EndDate,101)+''' )'
		End	
	else
	
	If @TimeType =2 ---- Lay theo ngay he thong
		Begin
			Set @ScheduleDays = (Select top 1 ScheduleDays From AT0000)
			Set @ScheduleDays = isnull(@ScheduleDays,0)
			Set @FromDate =DateAdd(Day, -@ScheduleDays, @CurrentDate)
			Set @ToDate =DateAdd(Day, @ScheduleDays, @CurrentDate)
			Set @SqlWhere1 = ' and (ScheduleDate Between '''+ convert(nvarchar(50),@FromDate,101)+''' and '''+convert(nvarchar(50),@ToDate,101)+''')'
		End
	else	
	If @TimeType =4
		Set @SqlWhere1 = ' and (TranMonth + TranYear*100 = '+str(@TranMonth)+'  + 100* '+str(@TranYear)+')'
	else
		Set @sqlWhere1=''

If @UseType =1
	Set @sqlWhere2 =' and AT2003.EmployeeID = '''+@UserID+''' '
else
If @UseType =2
	Set @sqlWhere2 =' and AT1103.DepartmentID like  '''+@DepartmentID+''' '
else
	Set @sqlWhere2=''

Set @sSQL ='
Select 	ScheduleID,
	AT2003.EmployeeID,
	AT1103.DepartmentID,
	AT1103.FullName as FullName,
	ScheduleDate,
	StartHour,
	StartMinute,
(Case DateName(weekDay, ScheduleDate)  when ''Monday'' then ''Thø hai''
					   When ''Tuesday'' then ''Thø ba''
					   When ''Wednesday'' then ''Thø t­''
					   When ''Thursday'' then ''Thø n¨m''
					   When ''Friday'' then ''Thø s¸u''
					   When ''Saturday'' then ''Thø b¶y''
					   When ''Sunday'' then ''Chñ nhËt''
             End)+'' ''+
	( right(''0''+ltrim(rtrim(StartHour)),2)+'':''+right(''0''+ltrim(rtrim(StartMinute)),2) +'' - '' +right(''0''+ltrim(rtrim(ToHour)),2)+'':''+right(''0''+ltrim(rtrim(ToMinute)),2) ) as StartEndHour,
	ToHour,
	ToMinute,
	Description , 
	Notes,
	TranMonth,
	TranYear,
	AT2003.DivisionID,
	AT2003.CreateDate,
	AT2003.CreateUserID,
	AT2003.LastModifyDate,
	 AT2003.LastModifyUserID     
From AT2003 inner join AT1103 on AT1103.EmployeeID = AT2003.EmployeeID and AT1103.DivisionID = AT2003.DivisionID

Where AT2003.DivisionID ='''+@DivisionID+''' ' +@sqlWhere1+' '+@sqlWhere2


If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV2003')

	Exec ('Create View AV2003 as '+@sSQL)
Else
	Exec('  Alter View  AV2003 as '+ @sSQL)



GO

