if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OP3051]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[OP3051]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO



--Create by: Dang Le Bao Quynh; Date : 02/04/2008
--Purpose: Tao view in bao cao bang ke hai quan

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [10/09/2010]
'********************************************/

CREATE PROCEDURE OP3051 @AppendixNo As int
AS
Declare @RemainRows as int,
	@For as int,
	@FieldCount as int,
	@NullRowInsert as nvarchar(1000),
	@sSQL as nvarchar(4000)

If @AppendixNo > 1 
	Insert Into OT3050 (TransactionID) Select Top 9 TransactionID From OV3002 Where TransactionID Not In (Select TransactionID From OT3050) Order by Orders

If Not Exists (Select 1 From sysObjects Where Name ='OV3051' and xType = 'V')
	Exec ('Create view OV3051  ---tao boi OP3051
		as 
		Select Top 9 * from OV3002 Where TransactionID Not In (Select TransactionID From OT3050) Order by Orders')
Else
	Exec( 'Alter view OV3051  ---tao boi OP3051
		as 
		Select Top 9 * from OV3002 Where TransactionID Not In (Select TransactionID From OT3050) Order by Orders')
/*
Set @sSQL = ''
Set @FieldCount = (select count(name) From syscolumns where id = object_id('OV3002'))
Set @NullRowInsert = REPLICATE('Null,',@FieldCount)
Set @NullRowInsert = LEFT(@NullRowInsert,LEN(@NullRowInsert)-1)

Select @RemainRows = 9 - Count(*) From OV3051

If @RemainRows>0 And @RemainRows<9
Begin
	Set @For = 1
	While @For <=@RemainRows
	Begin
		Set @sSQL = @sSQL +  ' Union All 
					Select ' + @NullRowInsert + ' 
					'		
		Set @For = @For + 1
	End
End

If Not Exists (Select 1 From sysObjects Where Name ='OV3051' and xType = 'V')
	Exec ('Create view OV3051  ---tao boi OP3051
		as 
		Select * From (Select Top 9 * from OV3002 Where TransactionID Not In (Select TransactionID From OT3050) Order by Orders) as OV02 ' + @sSQL)
Else
	Exec( 'Alter view OV3051  ---tao boi OP3051
		as 
		Select * From (Select Top 9 * from OV3002 Where TransactionID Not In (Select TransactionID From OT3050) Order by Orders) as OV02 ' + @sSQL)
*/
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

