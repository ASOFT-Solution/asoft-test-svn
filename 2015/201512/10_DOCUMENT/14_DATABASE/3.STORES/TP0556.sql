IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TP0556]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TP0556]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by Quoc Hoai
--Date 07/04/2004
--Purpose: So sanh tinh dong nhat 2 table danh muc giua 2 database
--Edit by Quoc Huy

CREATE PROCEDURE [dbo].[TP0556] @Dataname1 as nvarchar(4000),
				 @Dataname2 nvarchar(4000),
				 @Tablename as nvarchar(4000),
				 @IDTable as nvarchar(4000)  AS

Declare @cur0 cursor
Declare @sqlstr as nvarchar(4000),
		@column as nvarchar(4000),
		@WHERE as nvarchar(4000)
set @WHERE  = ''
Set @cur0 = cursor static for
		SELECT data FROM dbo.Split(@IDTable,',')
	Open @cur0
Fetch Next From @cur0 Into @column
While @@Fetch_Status = 0
Begin

	SET @WHERE = @WHERE + ' AND A.'+@COLUMN + ' = B.' + @COLUMN;
	Fetch Next From @cur0 Into @column
End
DEALLOCATE @cur0

Set @sqlstr  = 'Select  ' +@IDTable + '  As TableName  From [' +@Dataname1+'].[dbo].['+@Tablename+'] A 
				Where (Select COUNT(*) From  [' +@Dataname2+'].[dbo].['+@Tablename+'] B
				WHERE A.DivisionID = B.DivisionID
				 '+ISNULL(@WHERE,'')+') =0'      

print @sqlstr
	if not exists(Select 1 from sysobjects where Xtype='V' and 'TV0557'=name)
		exec('create view TV0557 As '+@sqlstr)
	else
		exec('Alter view TV0557 As '+@sqlstr)
	
	--print @sqlstr

/*
	--Xac dinh xem co neu co ben @Dataname1 ma khong co ben @Dataname2 thi tra ve null
             Set @sqlstr='Select A.* From [' +@Dataname1+'].[dbo].['+@Tablename+'] As A 
		Full Join [' +@Dataname2+'].[dbo].['+@Tablename+']  As B on A.'+@IDTable+'=B.'+@IDTable
	--print @sqlstr

	if not exists(Select 1 from sysobjects where Xtype='V' and 'TV0556'=name)
		exec('create view TV0556 As '+@sqlstr)
	else
		exec('Alter view TV0556 As '+@sqlstr)
	--Xax dinh co bao nhieu records co ben @Dataname1 ma khong co ben @Dataname2 	
	Set @sqlstr='Select ' +@IDTable+ ' From TV0556 Where ' +@IDTable+' is Null'
	if not exists(Select 1 from sysobjects where Xtype='V' and 'TV0557'=name)
		exec('create view TV0557 As '+@sqlstr)
	else
		exec('Alter view TV0557 As '+@sqlstr)


	If exists(Select 1 from TV0557)
	        Begin
		Set @sqlstr='Select '''+@Tablename+ ''' As TABLENAME,'''+@IDTable+''' As IDTable'

		if not exists(Select 1 from sysobjects where Xtype='V' and name ='TV0557')
			exec('CREATE View TV0557 as ' +@sqlstr) 
		Else
			exec('Alter View TV0557 as ' +@sqlstr) 
	        End
	
	Else
		Begin

			--Xac dinh xem co neu co ben @Dataname2 ma khong co ben @Dataname1 thi tra ve null
			Set @sqlstr='Select A.* From [' +@Dataname2+'].[dbo].['+@Tablename+'] As A 
				Full Join [' +@Dataname1+'].[dbo].['+@Tablename+']  as B on A.'+@IDTable+'=B.'+@IDTable

			if not exists(Select 1 from sysobjects where Xtype='V' and 'TV0556'=name)
				exec('create view TV0556 As '+@sqlstr)
			else
				exec('Alter view TV0556 As '+@sqlstr)
	
			Set @sqlstr='Select ' +@IDTable+ ' from TV0556 where ' +@IDTable+' is Null'
			if not exists(Select 1 from sysobjects where Xtype='V' and 'TV0557'=name)
				exec('create view TV0557 As '+@sqlstr)
			else
				exec('Alter view TV0557 As '+@sqlstr)

			Set @sqlstr='Select ' +@IDTable+ ' from TV0556 where ' +@IDTable+' is Null'
			if not exists(Select 1 from sysobjects where Xtype='V' and 'TV0557'=name)
				exec('create view TV0557 As '+@sqlstr)
			else
				exec('Alter view TV0557 As '+@sqlstr)
			if exists(Select 1 from TV0557)
				Begin
					Set @sqlstr='Select '''+@Tablename+ ''' as TABLENAME,'''+@IDTable+''' as IDTable'

					if not exists(Select 1 from sysobjects where  Xtype='V' and name ='TV0557')
						exec('CREATE View TV0557 as ' +@sqlstr) 
					Else
						exec('Alter View TV0557 as ' +@sqlstr) 
				End
		End



*/
GO


