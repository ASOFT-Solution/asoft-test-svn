IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4720]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4720]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-------- 	Created by Nguyen Van Nhan
-------- 	Created date 07/06/2004
-------- 	Purpose: Truy van quan tri.
---- 	Last update by Van Nhan, 15/03/2005
---Last edit by Thien Huynh, 30/11/2011: Cat va noi chuoi qua dai
---- Modified on 19/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified by on 12/10/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID

CREATE PROCEDURE 	[dbo].[AP4720]
			@DivisionID nvarchar(50), 
			@FromMonth int, 
			@FromYear as int, 
			@ToMonth as int, 
			@ToYear as int,
			@FromAccountID nvarchar(50), 
			@ToAccountID as nvarchar(50),
			@FromCorAccountID nvarchar(50), 
			@ToCorAccountID nvarchar(50),
			@D_C as tinyint, ---0 Phat sinh No, 1 Phat sinh Co, 2 So du
			@ColumnTypeID as nvarchar(50), ---- Loai tieu thuc du lieu lay o cot
			@Col01ID as nvarchar(50), 
			@Col02ID as nvarchar(50), 
			@Col03ID as nvarchar(50), 
			@Col04ID as nvarchar(50), 
			@Col05ID as nvarchar(50), 
			@Col06ID as nvarchar(50), 
			@Col07ID as nvarchar(50), 
			@Col08ID as nvarchar(50), 
			@Col09ID as nvarchar(50), 
			@Col10ID as nvarchar(50), 
			@Col11ID as nvarchar(50), 
			@Col12ID as nvarchar(50), 
			@Col13ID as nvarchar(50), 
			@Col14ID as nvarchar(50), 
			@Col15ID as nvarchar(50), 
			@Col16ID as nvarchar(50), 
			@Col17ID as nvarchar(50), 
			@Col18ID as nvarchar(50), 
			@Col19ID as nvarchar(50), 
			@Col20ID as nvarchar(50), 
			@Col21ID as nvarchar(50), 
			@Col22ID as nvarchar(50), 
			@Col23ID as nvarchar(50), 
			@Col24ID as nvarchar(50), 
			@Col25ID as nvarchar(50), 
			@Col26ID as nvarchar(50), 
			@Col27ID as nvarchar(50), 
			@Col28ID as nvarchar(50), 
			@Col29ID as nvarchar(50), 
			@Col30ID as nvarchar(50), 
			@RowTypeID as nvarchar(50),
			@IsQuantity as tinyint,			
			@IsDate as tinyint,
			@FromDate as Datetime, 
			@ToDate as DATETIME,
			@StrDivisionID AS NVARCHAR(4000) = ''
			
 AS


Declare 	@sSQL as nvarchar(4000),
			@sSQLunion as nvarchar(4000),
			@sSQLunion1 as nvarchar(4000),			
			@ListOfColumn as varchar(2000),   --- Max = 30 Column
			@RowField as nvarchar(30),
			@ColField as nvarchar(20),
			@AmountField as nvarchar(30),
			@strTime as nvarchar(4000),
			@sSQL1 as nvarchar(4000),
			@StrDivisionID_New AS NVARCHAR(max)
			
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END					

If @IsDate = 0
	set @strTime = ' (V43.TranMonth + 100*V43.TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and  '+str(@ToMonth)+' + 100*'+str(@ToYear)+' ) And '
Else  
	set @strTime =  ' ( CONVERT(DATETIME,CONVERT(VARCHAR(10),V43.VoucherDate,101),101)  Between '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''') and  '

Set @ListOfColumn ='( '''+@Col01ID+''', '''+@Col02ID+''', '''+@Col03ID+''', '''+@Col04ID+''', '''+ @Col05ID+''', '''+@Col06ID+''', '''+@Col07ID+''', '''+@Col08ID+''', '''+@Col09ID+''', '''+ @Col10ID+''', '''
Set @ListOfColumn =@ListOfColumn+@Col11ID+''', '''+@Col12ID+''', '''+@Col13ID+''', '''+@Col14ID+''', '''+ @Col15ID+''', '''+@Col16ID+''', '''+@Col17ID+''', '''+@Col18ID+''', '''+@Col19ID+''', '''+ @Col20ID+''', '''
Set @ListOfColumn = @ListOfColumn+@Col21ID+''', '''+@Col22ID+''', '''+@Col23ID+''', '''+@Col24ID+''', '''+ @Col25ID+''', '''+@Col26ID+''', '''+@Col27ID+''', '''+@Col28ID+''', '''+@Col29ID+''', '''+ @Col30ID+''')'

EXEC AP4700 @RowTypeID,  @RowField  OUTPUT
EXEC AP4700 @ColumnTypeID,  @ColField  OUTPUT


if @IsQuantity =0  --- theo Thanh tien
begin
If @D_C =0
	Set @AmountField ='ConvertedAmount'
Else
	If @D_C =1  
		Set  @AmountField ='ConvertedAmount'
		Else
			If @D_C =2
				Set   @AmountField ='SignAmount'
End
Else
Begin
If @D_C =0
	Set @AmountField =' Quantity '
Else
	If @D_C =1  
		Set  @AmountField =' Quantity'
		Else
			If @D_C =2
				Set   @AmountField ='SignQuantity'

End  


Set @sSQL ='
Select		V43.'+@RowField+' as  RowID, 
		V66.SelectionName as RowDescription,
		Sum( '+@AmountField+ ') as TotalAmount,
		Sum( Case when V43.'+@ColField+' = '''+@Col01ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount01,
		Sum( Case when V43.'+@ColField+' = '''+@Col02ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount02,
		Sum( Case when V43.'+@ColField+' = '''+@Col03ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount03,
		Sum( Case when V43.'+@ColField+' = '''+@Col04ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount04,
		Sum( Case when V43.'+@ColField+' = '''+@Col05ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount05,
		Sum( Case when V43.'+@ColField+' = '''+@Col06ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount06,
		Sum( Case when V43.'+@ColField+' = '''+@Col07ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount07,
		Sum( Case when V43.'+@ColField+' = '''+@Col08ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount08,
		Sum( Case when V43.'+@ColField+' = '''+@Col09ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount09,
		Sum( Case when V43.'+@ColField+' = '''+@Col10ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount10,

		Sum( Case when V43.'+@ColField+' = '''+@Col11ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount11,
		Sum( Case when V43.'+@ColField+' = '''+@Col12ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount12,
		Sum( Case when V43.'+@ColField+' = '''+@Col13ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount13,
		Sum( Case when V43.'+@ColField+' = '''+@Col14ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount14,
		Sum( Case when V43.'+@ColField+' = '''+@Col15ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount15,
		Sum( Case when V43.'+@ColField+' = '''+@Col16ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount16,
		Sum( Case when V43.'+@ColField+' = '''+@Col17ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount17,
		Sum( Case when V43.'+@ColField+' = '''+@Col18ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount18,
		Sum( Case when V43.'+@ColField+' = '''+@Col19ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount19,
		Sum( Case when V43.'+@ColField+' = '''+@Col20ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount20,

		Sum( Case when V43.'+@ColField+' = '''+@Col21ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount21,
		Sum( Case when V43.'+@ColField+' = '''+@Col22ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount22,
		Sum( Case when V43.'+@ColField+' = '''+@Col23ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount23,
		Sum( Case when V43.'+@ColField+' = '''+@Col24ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount24,
		Sum( Case when V43.'+@ColField+' = '''+@Col25ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount25,
		Sum( Case when V43.'+@ColField+' = '''+@Col26ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount26,
		Sum( Case when V43.'+@ColField+' = '''+@Col27ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount27,
		Sum( Case when V43.'+@ColField+' = '''+@Col28ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount28,
		Sum( Case when V43.'+@ColField+' = '''+@Col29ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount29,
		Sum( Case when V43.'+@ColField+' = '''+@Col30ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount30,
        V43.DivisionID '
Set @sSQL1 = '

From 		AV4301  V43 inner join AV6666 V66 on 	V66.SelectionID= V43.'+@RowField+' and
							V66.SelectionType  ='''+@RowTypeID+''' and V66.DivisionID = V43.DivisionID

Where 		V43.'+@ColField+'  in '+@ListOfColumn+'  and '+@strTime+ '		
		( (V43.D_C  = ''D'' and '+str(@D_C)+' =0 ) or 
		(V43.D_C  = ''C'' and '+str(@D_C)+' =1 ) or 
		( '+str(@D_C)+' =2 ) ) and
		(V43.AccountID Between '''+@FromAccountID+''' and '''+@ToAccountID+''') '

If isnull(@FromCorAccountID,'') <>'' and @FromCorAccountID <>'%'
	Set @sSQL1 = @sSQL1 + ' and (V43.CorAccountID Between '''+@FromCorAccountID+''' and '''+@ToCorAccountID+''') '

If @D_C <> 2 ---- Chi lay so phat sinh
	Set @sSQL1 = @sSQL1 + ' and ( V43.TransactionTypeID <>''T00'' ) '

Set @sSQL1 = @sSQL1 + ' Group by V43.'+@RowField+' , V66.SelectionName, V43.DivisionID

---add by Nguyen Quoc Huy
Union All'

Set @sSQLunion ='
Select		V43.'+@RowField+' as  RowID, 
		V66.SelectionName as RowDescription,
		Sum( '+@AmountField+ ') as TotalAmount,
		Sum( Case when V43.'+@ColField+' = '''+@Col01ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount01,
		Sum( Case when V43.'+@ColField+' = '''+@Col02ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount02,
		Sum( Case when V43.'+@ColField+' = '''+@Col03ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount03,
		Sum( Case when V43.'+@ColField+' = '''+@Col04ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount04,
		Sum( Case when V43.'+@ColField+' = '''+@Col05ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount05,
		Sum( Case when V43.'+@ColField+' = '''+@Col06ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount06,
		Sum( Case when V43.'+@ColField+' = '''+@Col07ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount07,
		Sum( Case when V43.'+@ColField+' = '''+@Col08ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount08,
		Sum( Case when V43.'+@ColField+' = '''+@Col09ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount09,
		Sum( Case when V43.'+@ColField+' = '''+@Col10ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount10,

		Sum( Case when V43.'+@ColField+' = '''+@Col11ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount11,
		Sum( Case when V43.'+@ColField+' = '''+@Col12ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount12,
		Sum( Case when V43.'+@ColField+' = '''+@Col13ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount13,
		Sum( Case when V43.'+@ColField+' = '''+@Col14ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount14,
		Sum( Case when V43.'+@ColField+' = '''+@Col15ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount15,
		Sum( Case when V43.'+@ColField+' = '''+@Col16ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount16,
		Sum( Case when V43.'+@ColField+' = '''+@Col17ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount17,
		Sum( Case when V43.'+@ColField+' = '''+@Col18ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount18,
		Sum( Case when V43.'+@ColField+' = '''+@Col19ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount19,
		Sum( Case when V43.'+@ColField+' = '''+@Col20ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount20,

		Sum( Case when V43.'+@ColField+' = '''+@Col21ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount21,
		Sum( Case when V43.'+@ColField+' = '''+@Col22ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount22,
		Sum( Case when V43.'+@ColField+' = '''+@Col23ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount23,
		Sum( Case when V43.'+@ColField+' = '''+@Col24ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount24,
		Sum( Case when V43.'+@ColField+' = '''+@Col25ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount25,
		Sum( Case when V43.'+@ColField+' = '''+@Col26ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount26,
		Sum( Case when V43.'+@ColField+' = '''+@Col27ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount27,
		Sum( Case when V43.'+@ColField+' = '''+@Col28ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount28,
		Sum( Case when V43.'+@ColField+' = '''+@Col29ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount29,
		Sum( Case when V43.'+@ColField+' = '''+@Col30ID+ ''' then '+@AmountField+ ' Else 0 End ) as Amount30,
        V43.DivisionID '

Set @sSQLunion1 = '
From 		AV4311  V43 inner join AV6666 V66 on 	V66.SelectionID= V43.'+@RowField+' and
							V66.SelectionType  ='''+@RowTypeID+'''  and V66.DivisionID = V43.DivisionID

Where 		V43.'+@ColField+'  in '+@ListOfColumn+'  and '+@strTime+ '		
		( (V43.D_C  = ''D'' and '+str(@D_C)+' =0 ) or 
		(V43.D_C  = ''C'' and '+str(@D_C)+' =1 ) or 
		( '+str(@D_C)+' =2 ) ) and
		(V43.AccountID Between '''+@FromAccountID+''' and '''+@ToAccountID+''') '
		

If isnull(@FromCorAccountID,'') <>'' and @FromCorAccountID <>'%'
	Set @sSQLunion1 = @sSQLunion1 + ' and (V43.CorAccountID Between '''+@FromCorAccountID+''' and '''+@ToCorAccountID+''') '

If @D_C <> 2 ---- Chi lay so phat sinh
	Set @sSQLunion1 = @sSQLunion1 +  ' and ( V43.TransactionTypeID <>''T00'' ) '

Set @sSQLunion1 = @sSQLunion1 + ' Group by V43.'+@RowField+' , V66.SelectionName, V43.DivisionID  '

--print @sSQL + @sSQL1 + @sSQLunion + @sSQLunion1

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV4720' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV4720 AS ' + @sSQL + @sSQL1 + @sSQLunion + @sSQLunion1)
ELSE
	EXEC ('ALTER VIEW AV4720 AS ' + @sSQL + @sSQL1 + @sSQLunion + @sSQLunion1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

