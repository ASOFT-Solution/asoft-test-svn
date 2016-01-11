
/****** Object:  StoredProcedure [dbo].[HP2413]    Script Date: 11/21/2011 09:06:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2413]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2413]
GO


/****** Object:  StoredProcedure [dbo].[HP2413]    Script Date: 11/21/2011 09:06:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----- Created by Vo Thanh Huong, Date 27/08/2004
---- Purpose: Cho phep xoa, s?a cham cong theo san pham
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2413] @TimesID  nvarchar(50),
				@DivisionID  nvarchar(50),
				@DepartmentID  nvarchar(50),
				@TeamID  nvarchar(50),
				@EmployeeID  nvarchar(50),
				@TranMonth int,
				@TranYear int
AS

Declare @sSQL as nvarchar(4000),
	@cur as cursor,
	@FullName as nvarchar(250),
	@DepartmentName as nvarchar(250),
	@Status as tinyint,
	@VietMess as nvarchar(1000),
	@EngMess as nvarchar(1000)

Select @Status =0, @VietMess ='',  @EngMess =''
Set @sSQL = 'Select H00.DivisionID, H00.EmployeeID, H00.DepartmentID, FullName
			From HT2403 H00  inner join HV1400 HV on H00.EmployeeID=HV.EmployeeID and H00.DivisionID=HV.DivisionID			
		 Where H00.DivisionID=N''' + @DivisionID + ''' and 
			H00.DepartmentID like N''' + @DepartmentID + '''and 
			Isnull(H00.TeamID,'''') like N''' + @TeamID + ''' and
			H00.EmployeeID like N''' + @EmployeeID + ''' and
			H00.TranMonth =' + str(@TranMonth) +  ' and
			H00.TranYear =' + str(@TranYear) + ' and			
			H00.TimesID = N''' + @TimesID + ''' and H00.EmployeeID in (Select distinct EmployeeID 
					From HT3401 inner join HT5012  on HT3401.PayrollMethodID = HT5012.PayrollMethodID and HT3401.DivisionID = HT5012.DivisionID 
						Where HT3401.DivisionID = N''' + @DivisionID + ''' and 
							DepartmentID like N''' + @DepartmentID + ''' and
							isnull(TeamID, ''' + ''') like isnull(N''' + @TeamID + ''', ''' + ''') and 
							TranMonth = ' + str(@TranMonth)  + ' and 
						TranYear = ' + str(@TranYear) + ' and TimesID = N''' + @TimesID+ ''')'
--Print @sSQL
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='HV2413')
	Exec(' Create view HV2413   ---Tao boi HP2413
			as '+@sSQL)
else
	Exec(' Alter view HV2413   ---Tao boi HP2413
			as '+@sSQL)

If exists (select 1 From HV2413 Where DivisionID = @DivisionID)
Begin
	Set @Status = 1
	Set @VietMess = N'HFML000056'--@VietMess + N'Baïn khoâng theå söûa vì ñaõ tính löông cho nhöõng nhaân vieân naøy:'
	Set @EngMess = N'HFML000056'--@EngMess + N'You cannot edit because they were caculated salary '

Set @VietMess = left(ltrim(rtrim(@VietMess)),len(ltrim(rtrim(@VietMess)))-1) + '.'
Set @EngMess = left(ltrim(rtrim(@EngMess)),len(ltrim(rtrim(@EngMess)))-1) + '.'
End
Goto EndMess

EndMess:
	Select @Status as Status, @VietMess as VieMessage, @EngMess as EngMessage

GO


