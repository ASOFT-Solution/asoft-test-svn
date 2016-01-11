/****** Object:  StoredProcedure [dbo].[CP2222]    Script Date: 07/30/2010 10:08:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--- Created by: Nguyen Thi Thuy Tuyen
-- Created date: 15/11/2006
-- Purpose:  thong ke
--Edit By Nguyen Quoc Huy, Date 18/07/2008

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP2222]  @DivisionID nvarchar(50),
				 @TablesName nvarchar(50),
				 @FieldID nvarchar(100),
				 @Type tinyint,
				 @FromMonth int,
				 @FromYear int,
				 @ToMonth int,
				 @ToYear int,
				@FromDate datetime,
				@ToDate datetime,
				@Isdate tinyint

 AS

Declare  @strSQL as nvarchar(4000),
	@TypeID as nvarchar(50),
	@sPeriod as varchar (500)
 If @Type = 0
	Begin
		If @TablesName <> 'AT1302'
			Set @sPeriod = case when @IsDate = 1 then ' and  CT4000.WMFileDate  between''' + convert(nvarchar(50), @FromDate,101) + '''  and  ''' + 
				convert(nvarchar(50),  @ToDate, 101) + ''''   else 
				' and CT4000.TranMonth + CT4000.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +
				cast(@ToMonth + @ToYear*100 as nvarchar(50))  end
			
		Else
			Set @sPeriod =	' and CT4001.TranMonth + CT4001.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +
				cast(@ToMonth + @ToYear*100 as nvarchar(50))  
			

	End
Else
	Begin
	Set @sPeriod = case when @IsDate = 1 then ' and  CT4002.FixDate  between''' + convert(nvarchar(50), @FromDate,101) + '''  and  ''' + 
		convert(nvarchar(50),  @ToDate, 101) + ''''   else 
		' and CT4002.TranMonth + CT4002.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +
		cast(@ToMonth + @ToYear*100 as nvarchar(50))  end
	End	

Set @TablesName = Ltrim(Rtrim(@TablesName))
Set @FieldID = Ltrim(Rtrim(@FieldID))
 If @Type = 0
	Begin	

		If @FieldID ='Serial'
		Begin
			Set @strSQL =  ' Select  CT4001.DivisionID, CT4001.Serial, CT4001.Serial as SerialName ,  Count(*) As  Amount  '
	
			Set @strSQL = @strSQL + ' 
				From   CT4001, CT4000  Where CT4001.WMFileID = CT4000.WMFileID and CT4001.DivisionID = CT4000.DivisionID '
			Set @strSQL = @strSQL + @sPeriod
			Set @strSQL = @strSQL + '  And CT4000.DivisionID = ''' + @DivisionID + ''' 
				Group by  CT4001.DivisionID, CT4001.Serial'  
		End
		
		If @TablesName <> 'AT1302' and @FieldID <> 'Serial'
		Begin
			Set @strSQL = '
				Select CT4000.DivisionID, ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set @strSQL = @strSQL + ' Count(*) As  Amount'
	
			Set @strSQL = @strSQL + ' 
				From   ' + @TablesName + ', CT4000  Where ' + @TablesName + '.' + @FieldID + ' = CT4000.' + @FieldID 
			
			Set @strSQL = @strSQL + @sPeriod
			
			Set @strSQL = @strSQL + '  And CT4000.DivisionID = ''' + @DivisionID + ''' 
					
				Group by  CT4000.DivisionID, '  + @TablesName + '.' + @FieldID + ',' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name'
			Set   @strSQL = @strSQL + ' 
				Union 
				
				Select CT4000.DivisionID, ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set  @strSQL = @strSQL+ '0  as Amount'
			
			Set  @strSQL = @strSQL+ '
				From ' +@TablesName+ ', CT4000 Where ' + @TablesName + '.' + @FieldID + ' Not in'
			Set @strSQL = @strSQL +'
				(select CT4000.'  + @FieldID + ' From CT4000)'
		End
		Else if  @FieldID <> 'Serial'
		Begin
			Set @strSQL = '
				Select CT4001.DivisionID, ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set @strSQL = @strSQL + ' Count(*) As  Amount'
	
			Set @strSQL = @strSQL + ' 
				From   ' + @TablesName + ', CT4001  Where ' + @TablesName + '.' + @FieldID + ' = CT4001.' + @FieldID 
			
			Set @strSQL = @strSQL + @sPeriod
			
			Set @strSQL = @strSQL + '  And CT4001.DivisionID = ''' + @DivisionID + ''' 
					
				Group by  CT4001.DivisionID, '  + @TablesName + '.' + @FieldID + ',' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name'
			Set   @strSQL = @strSQL + ' 
				Union 
				
				Select CT4001.DivisionID, ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set  @strSQL = @strSQL+ '0  as Amount'
			
			Set  @strSQL = @strSQL+ '
				From ' +@TablesName+ ', CT4001 Where ' + @TablesName + '.' + @FieldID + ' Not in'
			Set @strSQL = @strSQL +'
				(select CT4001.'  + @FieldID + ' From CT4001)'
		End

	End

Else
	Begin
			Set @strSQL = '
				Select CT4002.DivisionID, ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set @strSQL = @strSQL + ' Count(*) As  Amount'
	
			Set @strSQL = @strSQL + ' 
				From   ' + @TablesName + ', CT4002  Where ' + @TablesName + '.' + @FieldID + ' = CT4002.' + @FieldID 

			Set @strSQL = @strSQL + @sPeriod
			

			Set @strSQL = @strSQL + '  And CT4002.DivisionID = ''' + @DivisionID + ''' 
				Group by  CT4002.DivisionID, '  + @TablesName + '.' + @FieldID + ',' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name'

			Set   @strSQL = @strSQL + ' 
				Union 
				
				Select CT4002.DivisionID, ' + @TablesName + '.' + @FieldID + ', ' +  @TablesName + '.' + Left(@FieldID,Len(@FieldID)-2) + 'Name , '
			Set  @strSQL = @strSQL+ '0  as Amount'
			
			Set  @strSQL = @strSQL+ '
				From ' +@TablesName+ ', CT4002 Where ' + @TablesName + '.' + @FieldID + ' Not in'
			Set @strSQL = @strSQL +'
				(select CT4002.'  + @FieldID + ' From CT4002)'


	End

Print @strSQL

If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[CV2222]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View CV2222 as ' + @strSQL)
Else
	Exec (' Alter  View CV2222 as ' + @strSQL)



Exec CP4014 @DivisionID,@TablesName, @FieldID, @Type,  @FromMonth , @FromYear , @ToMonth , @ToYear ,@FromDate ,@ToDate ,@Isdate