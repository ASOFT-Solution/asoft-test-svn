IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP6013]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP6013]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Bảo Anh	Date: 18/05/2015 
---- In báo cáo tổng hợp theo MPT (AR6013)
---- AP6013 @DivisionID=N'BBL',@FromMonth=5,@FromYear=2015,@ToMonth=5,@ToYear=2015,@FromDate='2015-05-19 00:00:00',@ToDate='2015-05-19 00:00:00',@IsDate=0,@IsDebit=0,@FromDebitAccountID=N'',@ToDebitAccountID=N'',@IsCredit=0,@FromCreditAccountID=N'',@ToCreditAccountID=N'',@AnaTypeID=N'A01',@FromAnaID=N'[]',@ToAnaID=N'E07',@StrDivisionID=N'BBL',@UserID='ASOFTADMIN'

CREATE PROCEDURE [dbo].[AP6013]  
				@DivisionID nvarchar(50), 
				@FromMonth AS int, 
				@FromYear AS int,
				@ToMonth AS int,
				@ToYear AS int,
				@FromDate AS Datetime, @ToDate AS Datetime,
				@IsDate AS tinyint,
				@IsDebit AS int,
				@FromDebitAccountID AS nvarchar(50),
				@ToDebitAccountID AS nvarchar(50),
				@IsCredit AS int,
				@FromCreditAccountID AS nvarchar(50),
				@ToCreditAccountID AS nvarchar(50),
				@AnaTypeID AS nvarchar(50),
				@FromAnaID AS nvarchar(50),
				@ToAnaID AS nvarchar(50),
				@StrDivisionID AS NVARCHAR(4000) = '',
				@UserID AS VARCHAR(50) = ''
			
AS
Declare @FieldName AS  nvarchar(MAX),
		@sql1 AS nvarchar(max),
		@sql2 AS nvarchar(max),
		@sql3 AS nvarchar(max),
   		@sql4 AS nvarchar(max),
		@StrDivisionID_New AS NVARCHAR(max)

----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = AT9000.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = AT9000.CreateUserID '
		SET @sWHEREPer = ' AND (AT9000.CreateUserID = AT0010.UserID
								OR  AT9000.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	

SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + replace(@StrDivisionID, ',',''',''') + ''')' END

If @AnaTypeID like 'A%'  --- Ma phan tich but toan
	Set @FieldName = 'AT9000.Ana'+right(@AnaTypeID,2)+'ID'
If @AnaTypeID like 'I%'  --- Ma phan tich mat hang
	Set @FieldName = 'T02.I'+right(@AnaTypeID,2)+'ID'
If @AnaTypeID like 'O%'  --- Ma phan tich doi tuong
	Set @FieldName = 'AT1202.O'+right(@AnaTypeID,2)+'ID'
If @AnaTypeID like 'CI%'  --- Ma phan loai mat hang
	Set @FieldName = 'T02.S'+right(@AnaTypeID,1)+' '
If @AnaTypeID like 'CO%'  --- Ma phan loai doi tuong
	Set @FieldName = 'AT1202.S'+right(@AnaTypeID,1)+' '
If @AnaTypeID = ''
	Set @FieldName = ''''''
	
if @FromAnaID ='[]' 
	 set @FromAnaID =''

if @ToAnaID ='[]' 
	 set @ToAnaID =''


If Upper(Right(@FromDebitAccountID,1)) ='Z' 
	Set @FromDebitAccountID = Left(@FromDebitAccountID,len(@FromDebitAccountID) -1) + '%'

--- Nhóm chi phí mua hàng
Set @sql1 = N'
SELECT ''G01'' As GroupID, AT9000.DivisionID, '+@FieldName+N' AS AnaID,	AV6666.SelectionName AS AnaName,
	AT9000.VoucherDate, AT9000.VoucherNo, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName As [Type],
	AT9000.CreditBankAccountID, AT9000.DebitBankAccountID,
	AT9000.Ana01ID, AT01.AnaName AS AnaName01, AT9000.Ana02ID, AT02.AnaName AS AnaName02, AT9000.Ana03ID, AT03.AnaName AS AnaName03,
	AT9000.Ana04ID, AT04.AnaName AS AnaName04, AT9000.Ana05ID, AT05.AnaName AS AnaName05, AT9000.Ana06ID, AT06.AnaName AS AnaName06,
	AT9000.Ana07ID, AT07.AnaName AS AnaName07, AT9000.Ana08ID, AT08.AnaName AS AnaName08, AT9000.Ana09ID, AT09.AnaName AS AnaName09, AT9000.Ana10ID, AT10.AnaName AS AnaName10,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.TDescription,
	Sum(Isnull(OriginalAmount,0)) as OriginalAmount, Sum(Isnull(ConvertedAmount,0)) as ConvertedAmount
'
set @sql1 = @sql1 + N'
FROM	AT9000
Left join AT1302 T02 on T02.DivisionID = At9000.DivisionID and T02.InventoryID = At9000.InventoryID
Left join AT1202 on AT1202.DivisionID = At9000.DivisionID and AT1202.ObjectID = At9000.ObjectID
Left Join AT1015 on AT1202.DivisionID = AT1015.DivisionID And AT1202.O01ID = AT1015.AnaID And AT1015.AnaTypeID = ''O01''
Left join AT1011 AS AT01 on AT01.AnaID = AT9000.Ana01ID and AT01.DivisionID = AT9000.DivisionID and AT01.AnaTypeID = ''A01''
Left join AT1011 AS AT02 on AT02.AnaID = AT9000.Ana02ID and AT02.DivisionID = AT9000.DivisionID and AT02.AnaTypeID = ''A02''
Left join AT1011 AS AT03 on AT03.AnaID = AT9000.Ana03ID and AT03.DivisionID = AT9000.DivisionID and AT03.AnaTypeID = ''A03''
Left join AT1011 AS AT04 on AT04.AnaID = AT9000.Ana04ID and AT04.DivisionID = AT9000.DivisionID and AT04.AnaTypeID = ''A04''
Left join AT1011 AS AT05 on AT05.AnaID = AT9000.Ana05ID and AT05.DivisionID = AT9000.DivisionID and AT05.AnaTypeID = ''A05''
Left join AT1011 AS AT06 on AT06.AnaID = AT9000.Ana06ID and AT06.DivisionID = AT9000.DivisionID and AT06.AnaTypeID = ''A06''
Left join AT1011 AS AT07 on AT07.AnaID = AT9000.Ana07ID and AT07.DivisionID = AT9000.DivisionID and AT07.AnaTypeID = ''A07''
Left join AT1011 AS AT08 on AT08.AnaID = AT9000.Ana08ID and AT08.DivisionID = AT9000.DivisionID and AT08.AnaTypeID = ''A08''
Left join AT1011 AS AT09 on AT09.AnaID = AT9000.Ana09ID and AT09.DivisionID = AT9000.DivisionID and AT09.AnaTypeID = ''A09''
Left join AT1011 AS AT10 on AT10.AnaID = AT9000.Ana10ID and AT10.DivisionID = AT9000.DivisionID and AT10.AnaTypeID = ''A10''
Left join AV6666 on AV6666.DivisionID = AT9000.DivisionID and AV6666.SelectionID = '+@FieldName+'  and AV6666.SelectionType = '''+@AnaTypeID+N'''
'+@sSQLPer +'
WHERE	AT9000.DivisionID '+@StrDivisionID_New+' 
		'+@sWHEREPer+' and TransactionTypeID = ''T03''
		and	( isnull('+@FieldName+N','''')  between N'''+@FromAnaID+N''' and N'''+@ToAnaID+N''' ) and '

If @IsDate =0  --- Theo ky
	Set @sql1 = @sql1 + '(TranMonth + 100*TranYear between '+str(@FromMonth) +' + 100*'+str(@FromYear)+' and  '+str(@ToMonth) +' + 100*'+str(@ToYear)+')  '
else
	Set @sql1 = @sql1 + '(CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101)  Between '''+convert(varchar(10), @FromDate,101)+'''  and '''+convert(varchar(10), @ToDate, 101)+''')'

If @IsDebit <>0  and isnull(@FromDebitAccountID,'') <> '' and isnull(@ToDebitAccountID,'') =''
	Set @sql1 = @sql1 + N' and (DebitAccountID like  N'''+ @FromDebitAccountID +N''' or  CreditAccountID like N'''+@FromDebitAccountID+N''' ) '
else If @IsDebit <>0  
	Set @sql1 = @sql1 + N' and (DebitAccountID between N'''+@FromDebitAccountID+N''' and N'''+@ToDebitAccountID+N''' ) '

If @IsCredit <>0 
	Set @sql1 = @sql1 + N' and (CreditAccountID between N'''+@FromCreditAccountID+N''' and N'''+@ToCreditAccountID+N''' ) '

Set @sql1 = @sql1 + N'GROUP BY AT9000.DivisionID, '+@FieldName+N',	AV6666.SelectionName,
	AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName, AT9000.VoucherDate, AT9000.VoucherNo, 
	AT9000.CreditBankAccountID, AT9000.DebitBankAccountID,
	AT9000.Ana01ID, AT01.AnaName, AT9000.Ana02ID, AT02.AnaName , AT9000.Ana03ID, AT03.AnaName,
	AT9000.Ana04ID, AT04.AnaName, AT9000.Ana05ID, AT05.AnaName, AT9000.Ana06ID, AT06.AnaName,
	AT9000.Ana07ID, AT07.AnaName, AT9000.Ana08ID, AT08.AnaName, AT9000.Ana09ID, AT09.AnaName, AT9000.Ana10ID, AT10.AnaName,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.TDescription'

--- Nhóm doanh số bán hàng
Set  @sql2 =   + N' Union ALL
	SELECT ''G02'' As GroupID, AT9000.DivisionID, '+@FieldName+N' AS AnaID,	AV6666.SelectionName AS AnaName,
	AT9000.VoucherDate, AT9000.VoucherNo, AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName As [Type],
	AT9000.CreditBankAccountID, AT9000.DebitBankAccountID,
	AT9000.Ana01ID, AT01.AnaName AS AnaName01, AT9000.Ana02ID, AT02.AnaName AS AnaName02, AT9000.Ana03ID, AT03.AnaName AS AnaName03,
	AT9000.Ana04ID, AT04.AnaName AS AnaName04, AT9000.Ana05ID, AT05.AnaName AS AnaName05, AT9000.Ana06ID, AT06.AnaName AS AnaName06,
	AT9000.Ana07ID, AT07.AnaName AS AnaName07, AT9000.Ana08ID, AT08.AnaName AS AnaName08, AT9000.Ana09ID, AT09.AnaName AS AnaName09, AT9000.Ana10ID, AT10.AnaName AS AnaName10,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.TDescription,
	Sum(OriginalAmount) as OriginalAmount, Sum(ConvertedAmount) as ConvertedAmount
'
set @sql2 = @sql2 + N'
FROM	AT9000
Left join AT1302 T02 on T02.DivisionID = At9000.DivisionID and T02.InventoryID = At9000.InventoryID
Left join AT1202 on AT1202.DivisionID = At9000.DivisionID and AT1202.ObjectID = At9000.ObjectID
Left Join AT1015 on AT1202.DivisionID = AT1015.DivisionID And AT1202.O01ID = AT1015.AnaID And AT1015.AnaTypeID = ''O01''
Left join AT1011 AS AT01 on AT01.AnaID = AT9000.Ana01ID and AT01.DivisionID = AT9000.DivisionID and AT01.AnaTypeID = ''A01''
Left join AT1011 AS AT02 on AT02.AnaID = AT9000.Ana02ID and AT02.DivisionID = AT9000.DivisionID and AT02.AnaTypeID = ''A02''
Left join AT1011 AS AT03 on AT03.AnaID = AT9000.Ana03ID and AT03.DivisionID = AT9000.DivisionID and AT03.AnaTypeID = ''A03''
Left join AT1011 AS AT04 on AT04.AnaID = AT9000.Ana04ID and AT04.DivisionID = AT9000.DivisionID and AT04.AnaTypeID = ''A04''
Left join AT1011 AS AT05 on AT05.AnaID = AT9000.Ana05ID and AT05.DivisionID = AT9000.DivisionID and AT05.AnaTypeID = ''A05''
Left join AT1011 AS AT06 on AT06.AnaID = AT9000.Ana06ID and AT06.DivisionID = AT9000.DivisionID and AT06.AnaTypeID = ''A06''
Left join AT1011 AS AT07 on AT07.AnaID = AT9000.Ana07ID and AT07.DivisionID = AT9000.DivisionID and AT07.AnaTypeID = ''A07''
Left join AT1011 AS AT08 on AT08.AnaID = AT9000.Ana08ID and AT08.DivisionID = AT9000.DivisionID and AT08.AnaTypeID = ''A08''
Left join AT1011 AS AT09 on AT09.AnaID = AT9000.Ana09ID and AT09.DivisionID = AT9000.DivisionID and AT09.AnaTypeID = ''A09''
Left join AT1011 AS AT10 on AT10.AnaID = AT9000.Ana10ID and AT10.DivisionID = AT9000.DivisionID and AT10.AnaTypeID = ''A10''
Left join AV6666 on AV6666.DivisionID = AT9000.DivisionID and AV6666.SelectionID = '+@FieldName+'  and AV6666.SelectionType = '''+@AnaTypeID+N'''
'+@sSQLPer +'
WHERE	AT9000.DivisionID '+@StrDivisionID_New+' 
		'+@sWHEREPer+' and TransactionTypeID = ''T04''
		and	( isnull('+@FieldName+N','''')  between N'''+@FromAnaID+N''' and N'''+@ToAnaID+N''' ) and '

If @IsDate =0  --- Theo ky
	Set @sql2 = @sql2 + '(TranMonth + 100*TranYear between '+str(@FromMonth) +' + 100*'+str(@FromYear)+' and  '+str(@ToMonth) +' + 100*'+str(@ToYear)+')  '
else
	Set @sql2 = @sql2 + '(CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101)  Between '''+convert(varchar(10), @FromDate,101)+'''  and '''+convert(varchar(10), @ToDate, 101)+''')'

If @IsDebit <>0  and isnull(@FromDebitAccountID,'') <> '' and isnull(@ToDebitAccountID,'') =''
	Set @sql2 = @sql2 + N' and (DebitAccountID like  N'''+ @FromDebitAccountID +N''' or  CreditAccountID like N'''+@FromDebitAccountID+N''' ) '
else If @IsDebit <>0  
	Set @sql2 = @sql2 + N' and (DebitAccountID between N'''+@FromDebitAccountID+N''' and N'''+@ToDebitAccountID+N''' ) '

If @IsCredit <>0 
	Set @sql2 = @sql2 + N' and (CreditAccountID between N'''+@FromCreditAccountID+N''' and N'''+@ToCreditAccountID+N''' ) '

Set @sql2 = @sql2 + N'GROUP BY AT9000.DivisionID, '+@FieldName+N',	AV6666.SelectionName,
	AT9000.ObjectID, AT1202.ObjectName, AT1015.AnaName, AT9000.VoucherDate, AT9000.VoucherNo,
	AT9000.CreditBankAccountID, AT9000.DebitBankAccountID,
	AT9000.Ana01ID, AT01.AnaName, AT9000.Ana02ID, AT02.AnaName , AT9000.Ana03ID, AT03.AnaName,
	AT9000.Ana04ID, AT04.AnaName, AT9000.Ana05ID, AT05.AnaName, AT9000.Ana06ID, AT06.AnaName,
	AT9000.Ana07ID, AT07.AnaName, AT9000.Ana08ID, AT08.AnaName, AT9000.Ana09ID, AT09.AnaName, AT9000.Ana10ID, AT10.AnaName,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.TDescription'

--- Nhóm phân bổ chi phí
Set  @sql3 =   + N' Union ALL
	SELECT ''G03'' As GroupID, AT9000.DivisionID, '+@FieldName+N' AS AnaID,	AV6666.SelectionName AS AnaName,
	AT9000.VoucherDate, AT9000.VoucherNo, AT9000.ObjectID, AT1202.ObjectName,
	(Case When AT9000.DebitAccountID like ''6%'' Then DAcc.AccountName Else CAcc.AccountName End) As [Type],
	NULL as CreditBankAccountID, NULL as DebitBankAccountID,
	AT9000.Ana01ID, AT01.AnaName AS AnaName01, AT9000.Ana02ID, AT02.AnaName AS AnaName02, AT9000.Ana03ID, AT03.AnaName AS AnaName03,
	AT9000.Ana04ID, AT04.AnaName AS AnaName04, AT9000.Ana05ID, AT05.AnaName AS AnaName05, AT9000.Ana06ID, AT06.AnaName AS AnaName06,
	AT9000.Ana07ID, AT07.AnaName AS AnaName07, AT9000.Ana08ID, AT08.AnaName AS AnaName08, AT9000.Ana09ID, AT09.AnaName AS AnaName09, AT9000.Ana10ID, AT10.AnaName AS AnaName10,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.Description as TDescription,
	Sum(isnull((Case When AT9000.DebitAccountID like ''6%'' Then AT9000.OriginalAmount Else -AT9000.OriginalAmount End),0)) As OriginalAmount, 
	Sum(isnull((Case When AT9000.DebitAccountID like ''6%'' Then AT9000.ConvertedAmount Else -AT9000.ConvertedAmount End),0)) As ConvertedAmount
'
set @sql3 = @sql3 + N'
FROM	AT9001 AT9000
Left join AT1302 T02 on T02.DivisionID = At9000.DivisionID and T02.InventoryID = At9000.InventoryID
Left join AT1202 on AT1202.DivisionID = At9000.DivisionID and AT1202.ObjectID = At9000.ObjectID
Left Join AT1005 DAcc On AT9000.DivisionID = DAcc.DivisionID And AT9000.DebitAccountID = DAcc.AccountID
Left Join AT1005 CAcc On AT9000.DivisionID = CAcc.DivisionID And AT9000.CreditAccountID = CAcc.AccountID
Left join AT1011 AS AT01 on AT01.AnaID = AT9000.Ana01ID and AT01.DivisionID = AT9000.DivisionID and AT01.AnaTypeID = ''A01''
Left join AT1011 AS AT02 on AT02.AnaID = AT9000.Ana02ID and AT02.DivisionID = AT9000.DivisionID and AT02.AnaTypeID = ''A02''
Left join AT1011 AS AT03 on AT03.AnaID = AT9000.Ana03ID and AT03.DivisionID = AT9000.DivisionID and AT03.AnaTypeID = ''A03''
Left join AT1011 AS AT04 on AT04.AnaID = AT9000.Ana04ID and AT04.DivisionID = AT9000.DivisionID and AT04.AnaTypeID = ''A04''
Left join AT1011 AS AT05 on AT05.AnaID = AT9000.Ana05ID and AT05.DivisionID = AT9000.DivisionID and AT05.AnaTypeID = ''A05''
Left join AT1011 AS AT06 on AT06.AnaID = AT9000.Ana06ID and AT06.DivisionID = AT9000.DivisionID and AT06.AnaTypeID = ''A06''
Left join AT1011 AS AT07 on AT07.AnaID = AT9000.Ana07ID and AT07.DivisionID = AT9000.DivisionID and AT07.AnaTypeID = ''A07''
Left join AT1011 AS AT08 on AT08.AnaID = AT9000.Ana08ID and AT08.DivisionID = AT9000.DivisionID and AT08.AnaTypeID = ''A08''
Left join AT1011 AS AT09 on AT09.AnaID = AT9000.Ana09ID and AT09.DivisionID = AT9000.DivisionID and AT09.AnaTypeID = ''A09''
Left join AT1011 AS AT10 on AT10.AnaID = AT9000.Ana10ID and AT10.DivisionID = AT9000.DivisionID and AT10.AnaTypeID = ''A10''
Left join AV6666 on AV6666.DivisionID = AT9000.DivisionID and AV6666.SelectionID = '+@FieldName+'  and AV6666.SelectionType = '''+@AnaTypeID+N'''
'+@sSQLPer +'
WHERE	AT9000.DivisionID '+@StrDivisionID_New+' 
		'+@sWHEREPer+'
		and (AT9000.DebitAccountID like ''6%'' Or AT9000.CreditAccountID like ''6%'')
		and	( isnull('+@FieldName+N','''')  between N'''+@FromAnaID+N''' and N'''+@ToAnaID+N''' ) and '

If @IsDate =0  --- Theo ky
	Set @sql3 = @sql3 + '(TranMonth + 100*TranYear between '+str(@FromMonth) +' + 100*'+str(@FromYear)+' and  '+str(@ToMonth) +' + 100*'+str(@ToYear)+')  '
else
	Set @sql3 = @sql3 + '(CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101)  Between '''+convert(varchar(10), @FromDate,101)+'''  and '''+convert(varchar(10), @ToDate, 101)+''')'

If @IsDebit <>0  and isnull(@FromDebitAccountID,'') <> '' and isnull(@ToDebitAccountID,'') =''
	Set @sql3 = @sql3 + N' and (DebitAccountID like  N'''+ @FromDebitAccountID +N''' or  CreditAccountID like N'''+@FromDebitAccountID+N''' ) '
else If @IsDebit <>0  
	Set @sql3 = @sql3 + N' and (DebitAccountID between N'''+@FromDebitAccountID+N''' and N'''+@ToDebitAccountID+N''' ) '

If @IsCredit <>0 
	Set @sql3 = @sql3 + N' and (CreditAccountID between N'''+@FromCreditAccountID+N''' and N'''+@ToCreditAccountID+N''' ) '

Set @sql3 = @sql3 + N'GROUP BY AT9000.DivisionID, '+@FieldName+N',	AV6666.SelectionName,
	AT9000.ObjectID, AT1202.ObjectName, AT9000.VoucherDate, AT9000.VoucherNo, 
	(Case When AT9000.DebitAccountID like ''6%'' Then DAcc.AccountName Else CAcc.AccountName End),
	AT9000.Ana01ID, AT01.AnaName, AT9000.Ana02ID, AT02.AnaName , AT9000.Ana03ID, AT03.AnaName,
	AT9000.Ana04ID, AT04.AnaName, AT9000.Ana05ID, AT05.AnaName, AT9000.Ana06ID, AT06.AnaName,
	AT9000.Ana07ID, AT07.AnaName, AT9000.Ana08ID, AT08.AnaName, AT9000.Ana09ID, AT09.AnaName, AT9000.Ana10ID, AT10.AnaName,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.Description'

--- Nhóm chi phí bán hàng
Set  @sql4 =   + N' Union ALL
	SELECT ''G04'' As GroupID, AT9000.DivisionID, '+@FieldName+N' AS AnaID,	AV6666.SelectionName AS AnaName,
	AT9000.VoucherDate, AT9000.VoucherNo, AT9000.ObjectID, AT1202.ObjectName,
	(Case When AT9000.DebitAccountID like ''641%'' Then DAcc.AccountName Else CAcc.AccountName End) As [Type],
	AT9000.CreditBankAccountID, AT9000.DebitBankAccountID,
	AT9000.Ana01ID, AT01.AnaName AS AnaName01, AT9000.Ana02ID, AT02.AnaName AS AnaName02, AT9000.Ana03ID, AT03.AnaName AS AnaName03,
	AT9000.Ana04ID, AT04.AnaName AS AnaName04, AT9000.Ana05ID, AT05.AnaName AS AnaName05, AT9000.Ana06ID, AT06.AnaName AS AnaName06,
	AT9000.Ana07ID, AT07.AnaName AS AnaName07, AT9000.Ana08ID, AT08.AnaName AS AnaName08, AT9000.Ana09ID, AT09.AnaName AS AnaName09, AT9000.Ana10ID, AT10.AnaName AS AnaName10,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.TDescription,
	Sum(isnull((Case When DebitAccountID Like ''641%'' Then AT9000.OriginalAmount Else -AT9000.OriginalAmount End),0)) As OriginalAmount, 
	Sum(isnull((Case When DebitAccountID Like ''641%'' Then AT9000.ConvertedAmount Else -AT9000.ConvertedAmount End),0)) As ConvertedAmount
'
set @sql4 = @sql4 + N'
FROM	AT9000
Left join AT1302 T02 on T02.DivisionID = At9000.DivisionID and T02.InventoryID = At9000.InventoryID
Left join AT1202 on AT1202.DivisionID = At9000.DivisionID and AT1202.ObjectID = At9000.ObjectID
Left Join AT1005 DAcc On AT9000.DivisionID = DAcc.DivisionID And AT9000.DebitAccountID = DAcc.AccountID
Left Join AT1005 CAcc On AT9000.DivisionID = CAcc.DivisionID And AT9000.CreditAccountID = CAcc.AccountID
Left join AT1011 AS AT01 on AT01.AnaID = AT9000.Ana01ID and AT01.DivisionID = AT9000.DivisionID and AT01.AnaTypeID = ''A01''
Left join AT1011 AS AT02 on AT02.AnaID = AT9000.Ana02ID and AT02.DivisionID = AT9000.DivisionID and AT02.AnaTypeID = ''A02''
Left join AT1011 AS AT03 on AT03.AnaID = AT9000.Ana03ID and AT03.DivisionID = AT9000.DivisionID and AT03.AnaTypeID = ''A03''
Left join AT1011 AS AT04 on AT04.AnaID = AT9000.Ana04ID and AT04.DivisionID = AT9000.DivisionID and AT04.AnaTypeID = ''A04''
Left join AT1011 AS AT05 on AT05.AnaID = AT9000.Ana05ID and AT05.DivisionID = AT9000.DivisionID and AT05.AnaTypeID = ''A05''
Left join AT1011 AS AT06 on AT06.AnaID = AT9000.Ana06ID and AT06.DivisionID = AT9000.DivisionID and AT06.AnaTypeID = ''A06''
Left join AT1011 AS AT07 on AT07.AnaID = AT9000.Ana07ID and AT07.DivisionID = AT9000.DivisionID and AT07.AnaTypeID = ''A07''
Left join AT1011 AS AT08 on AT08.AnaID = AT9000.Ana08ID and AT08.DivisionID = AT9000.DivisionID and AT08.AnaTypeID = ''A08''
Left join AT1011 AS AT09 on AT09.AnaID = AT9000.Ana09ID and AT09.DivisionID = AT9000.DivisionID and AT09.AnaTypeID = ''A09''
Left join AT1011 AS AT10 on AT10.AnaID = AT9000.Ana10ID and AT10.DivisionID = AT9000.DivisionID and AT10.AnaTypeID = ''A10''
Left join AV6666 on AV6666.DivisionID = AT9000.DivisionID and AV6666.SelectionID = '+@FieldName+'  and AV6666.SelectionType = '''+@AnaTypeID+N'''
'+@sSQLPer +'
WHERE	AT9000.DivisionID '+@StrDivisionID_New+' 
		'+@sWHEREPer+'
		and (AT9000.DebitAccountID Like ''641%'' Or AT9000.CreditAccountID Like ''641%'')
		and	( isnull('+@FieldName+N','''')  between N'''+@FromAnaID+N''' and N'''+@ToAnaID+N''' ) and '

If @IsDate =0  --- Theo ky
	Set @sql4 = @sql4 + '(TranMonth + 100*TranYear between '+str(@FromMonth) +' + 100*'+str(@FromYear)+' and  '+str(@ToMonth) +' + 100*'+str(@ToYear)+')  '
else
	Set @sql4 = @sql4 + '(CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.VoucherDate,101),101)  Between '''+convert(varchar(10), @FromDate,101)+'''  and '''+convert(varchar(10), @ToDate, 101)+''')'

If @IsDebit <>0  and isnull(@FromDebitAccountID,'') <> '' and isnull(@ToDebitAccountID,'') =''
	Set @sql4 = @sql4 + N' and (DebitAccountID like  N'''+ @FromDebitAccountID +N''' or  CreditAccountID like N'''+@FromDebitAccountID+N''' ) '
else If @IsDebit <>0  
	Set @sql4 = @sql4 + N' and (DebitAccountID between N'''+@FromDebitAccountID+N''' and N'''+@ToDebitAccountID+N''' ) '

If @IsCredit <>0 
	Set @sql4 = @sql4 + N' and (CreditAccountID between N'''+@FromCreditAccountID+N''' and N'''+@ToCreditAccountID+N''' ) '

Set @sql4 = @sql4 + N'GROUP BY AT9000.DivisionID, '+@FieldName+N',	AV6666.SelectionName,
	AT9000.ObjectID, AT1202.ObjectName, AT9000.VoucherDate, AT9000.VoucherNo,
	(Case When AT9000.DebitAccountID like ''641%'' Then DAcc.AccountName Else CAcc.AccountName End),
	AT9000.CreditBankAccountID, AT9000.DebitBankAccountID,
	AT9000.Ana01ID, AT01.AnaName, AT9000.Ana02ID, AT02.AnaName , AT9000.Ana03ID, AT03.AnaName,
	AT9000.Ana04ID, AT04.AnaName, AT9000.Ana05ID, AT05.AnaName, AT9000.Ana06ID, AT06.AnaName,
	AT9000.Ana07ID, AT07.AnaName, AT9000.Ana08ID, AT08.AnaName, AT9000.Ana09ID, AT09.AnaName, AT9000.Ana10ID, AT10.AnaName,
	AT9000.DebitAccountID, AT9000.CreditAccountID, AT9000.TDescription'

--print @sql1
--print @sql2
--print @sql3
--print @sql4

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV6003' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV6003 AS ' +  @sql1 + @sql2 + @sql3 + @sql4)
ELSE
	EXEC ('ALTER VIEW AV6003 AS ' +   @sql1 + @sql2 + @sql3 + @sql4)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

