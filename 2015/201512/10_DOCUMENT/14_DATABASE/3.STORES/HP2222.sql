IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2222]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2222]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by: Nguyen Quoc Huy
-- Created date: 12/2/2004
-- Purpose:  Employee statistics
--- Edited by B.Anh	Date: 04/10/2010	Purpose: Phan quyen phong ban
---- Modified on 20/12/2012 by Lê Thị Thu Hiền : Kiểm tra @ConditionDE = ''

CREATE PROCEDURE [dbo].[HP2222]  
				@DivisionID nvarchar(50),
				@TablesName nvarchar(50),
				@FieldID nvarchar(100),
				@Type tinyint,
				@ConditionDE nvarchar(4000),
				@Description nvarchar (50)

 AS

Declare  @strSQL as nvarchar(4000),
	@TypeID as nvarchar(50)

Set @TablesName = Ltrim(Rtrim(@TablesName))
Set @FieldID = Ltrim(Rtrim(@FieldID))

If @Type = 0
	
	if @TablesName<>'AT1102'
		Begin	
			Set @strSQL = '
				Select ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set @strSQL = @strSQL + ' Count(*) As EmployeeAmount'
	
			Set @strSQL = @strSQL + ' 
				From   ' + @TablesName + ', HV1400  Where ' + @TablesName + '.' + @FieldID + ' = HV1400.' + @FieldID +' 
				and ' + @TablesName + '.DivisionID = HV1400.DivisionID And HV1400.EmployeeStatus=1'
			Set @strSQL = @strSQL + '  And HV1400.DivisionID = ''' + @DivisionID + ''' 
				Group by  '  + @TablesName + '.' + @FieldID + ',' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name'
			Set @strSQL = @strSQL + ' 
				Union
				Select '  + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name, ' 
			Set @strSQL = @strSQL + ' 0  As EmployeeAmount'
			Set @strSQL = @strSQL + ' 
				 From   ' + @TablesName + ', HV1400  Where ' + @TablesName + '.' + @FieldID + ' Not in'
			Set @strSQL = @strSQL + ' 
				(Select '  + @FieldID + ' From HV1400 Where ' + @FieldID + ' is not Null And HV1400.DivisionID = '''+ @DivisionID +''') 
				And ' + @TablesName + '.DivisionID = HV1400.DivisionID And HV1400.DivisionID = ''' + @DivisionID + ''' And HV1400.EmployeeStatus=1' 

		
		End 
		
	if  @TablesName='AT1102'

		Begin	
			Set @strSQL = '
				Select ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set @strSQL = @strSQL + ' Count(*) As EmployeeAmount'
			Set @strSQL = @strSQL + ' 
				From   HV1400 Left Join  AT1102 on HV1400.DivisionID = AT1102.DivisionID
				Where ' + @TablesName + '.' + @FieldID + ' = HV1400.' + @FieldID
			Set @strSQL = @strSQL + '  
				And HV1400.DivisionID = ''' + @DivisionID + ''' 
				And HV1400.EmployeeStatus=1 
				'+CASE WHEN ISNULL(@ConditionDE,'') <> '' THEN 'And Isnull(' + @TablesName + '.' +  @FieldID + ',''#'') in (' + @ConditionDE +')' ELSE '' END +'
				Group by  '  + @TablesName + '.' + @FieldID + ',' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name'
			Set @strSQL = @strSQL + ' 
				Union
				Select ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name, ' 
			Set @strSQL = @strSQL + ' 0  As EmployeeAmount'
			Set @strSQL = @strSQL + ' 
				 From   HV1400 Left Join  AT1102 on HV1400.DivisionID = AT1102.DivisionID 
				 Where ' + @TablesName + '.' + @FieldID + ' Not in'
			Set @strSQL = @strSQL + ' 
				(Select '  + @FieldID + ' From HV1400 Where ' + @FieldID + ' is not Null And HV1400.DivisionID = '''+ @DivisionID +''')  And HV1400.DivisionID = ''' + @DivisionID + ''' 
				And HV1400.EmployeeStatus=1
				'+CASE WHEN ISNULL(@ConditionDE,'') <> '' THEN 'And Isnull(' + @TablesName + '.' +  @FieldID + ',''#'') in (' + @ConditionDE +')' ELSE '' END +'
				'
		End 
		
		print @strSQL
	
If @Type <>0 and @Type<99
	Begin
		Set @TablesName = 'HV3333'
		Set @strSQL = '
		Select HV3333.Value as ' + @FieldID + ',  HV3333.' + @Description + ' as Description , Count(*) As EmployeeAmount 
		From  HT2222, HV3333, HV1400
		Where HV3333.Description = HV1400.'+ @FieldID +'Name
		And HV1400.DivisionID = HT2222.DivisionID
		and HV3333.FieldID = HT2222.FieldID
		And HV1400.DivisionID = ''' + @DivisionID + ''' and HV1400.EmployeeStatus=1

		Group by HV3333.Value,HV3333.'+ @Description + '
		Union 
		Select HV3333.Value as ' + @FieldID +', HV3333.' + @Description + ' , 0 As EmployeeAmount 
		From  HT2222 inner Join HV3333 on HT2222.FieldID = HV3333.FieldID
		Where HV3333.Description not in	(Select ' + @FieldID + 'Name From HV1400  where HV1400.EmployeeStatus=1 And HV1400.DivisionID = ''' + @DivisionID + ''' )

		--And HV1400.DivisionID = ''' + @DivisionID + ''' 
		and HT2222.FieldID =''' + @FieldID+ '''
		and HT2222.DivisionID =''' + @DivisionID+ ''' '

	End


If @Type =99
Begin
	Set @TypeID ='T'+ltrim(Rtrim(substring(@FieldID,7,2)))	
		Set @strSQL = '
				Select ' + @TablesName + '.TargetID as '+@FieldID+ ',  ' +  @TablesName + '.TargetName as ' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set @strSQL = @strSQL + ' Count(*) As EmployeeAmount'
			Set @strSQL = @strSQL + ' 
				From   ' + @TablesName + ', HV1400  Where ' + @TablesName + '.TargetID = HV1400.' + @FieldID+' 
				and TargetTypeID ='''+@TypeID+''' 
				and ' + @TablesName + '.DivisionID = HV1400.DivisionID'  
			Set @strSQL = @strSQL + '  And HV1400.DivisionID = ''' + @DivisionID + ''' and HV1400.EmployeeStatus=1 
				Group by ' + @TablesName + '.TargetID ,' +  @TablesName + '.TargetName  '
			
			Set @strSQL = @strSQL + ' 
				Union
				Select ' + @TablesName + '.TargetID as '+@FieldID+  ',  ' +  @TablesName + '.TargetName as ' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set @strSQL = @strSQL + ' 0  As EmployeeAmount'
			Set @strSQL = @strSQL + ' 
				 From   ' + @TablesName + ', HV1400  Where  TargetTypeID ='''+@TypeID+''' and ' + @TablesName + '.DivisionID = HV1400.DivisionID and  ' + @TablesName + '.TargetID  Not in '
			Set @strSQL = @strSQL + ' 
				(Select '  + @FieldID + ' From HV1400 Where ' + @FieldID + ' is not Null And HV1400.DivisionID = ''' + @DivisionID + ''' )  And HV1400.DivisionID = ''' + @DivisionID + ''' and HV1400.EmployeeStatus=1' 
			

	
End

--Print @strSQL


If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[HV2222]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View HV2222 as ' + @strSQL)
Else
	Exec (' Alter  View HV2222 as ' + @strSQL)



Exec HP1404 DivisionID,@TablesName,	 @FieldID, @Type

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

