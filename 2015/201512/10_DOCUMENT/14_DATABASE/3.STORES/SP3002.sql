/****** Object:  StoredProcedure [dbo].[SP3002]    Script Date: 12/07/2011 13:27:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP3002]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP3002]
GO

/****** Object:  StoredProcedure [dbo].[SP3002]    Script Date: 12/07/2011 13:27:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SP3002]
		@DivisionID nvarchar(50),
		@FromObjectID nvarchar(50),
		@ToObjectID nvarchar(50),
		@CurrencyID nvarchar(50),
		@FromAccountID nvarchar(50),
		@ToAccountID nvarchar(50),
		@IsPeriod bit, @FromPeriodIntType int, @ToPeriodIntType int, 
		@FromDate datetime, @ToDate datetime,
		@Filter nvarchar(4000) = ''
	
As

Declare 	@CNWhere1 as nvarchar(1000),
		@CNWhere2 as nvarchar(1000),
		@CNWhere3 as nvarchar(1000),
		@CNWhere4 as nvarchar(1000),
		@SQL1 nvarchar(4000),
		@SQL2 nvarchar(2000),
		@SQL3 nvarchar(2000),
		@SQL4 nvarchar(2000),
		@SQL5 nvarchar(2000),
		@SQL6 nvarchar(2000)
		
Set @CNWhere1 = ' And (CN.ObjectID Between ''' + @FromObjectID + ''' And ''' + @ToObjectID + ''') 
				 And (CN.AccountID Between ''' + @FromAccountID + ''' And ''' + @ToAccountID + ''') '
				 
Set @CNWhere2 = ' And (O1.ObjectID Between ''' + @FromObjectID + ''' And ''' + @ToObjectID + ''') 
				 And (T9.DebitAccountID Between ''' + @FromAccountID + ''' And ''' + @ToAccountID + ''') '

Set @CNWhere3 = ' And (Case When T9.TransactionTypeID = ''T99'' Then T9.CreditObjectID Else T9.ObjectID End Between ''' + @FromObjectID + ''' And ''' + @ToObjectID + ''') 
				 And (T9.CreditAccountID Between ''' + @FromAccountID + ''' And ''' + @ToAccountID + ''') '
				 
Set @CNWhere4 = ' And (T9.ObjectID Between ''' + @FromObjectID + ''' And ''' + @ToObjectID + ''') 
				 And (T9.DebitAccountID Between ''' + @FromAccountID + ''' And ''' + @ToAccountID + ''') '				 
				 
If isnull(@CurrencyID,'') <> '%' 
	Begin
		Set @CNWhere1 = @CNWhere1 + ' And (CN.CurrencyIDCN = ''' + @CurrencyID + ''') '
		Set @CNWhere2 = @CNWhere2 + ' And T9.CurrencyIDCN = ''' + @CurrencyID + ''' '
		Set @CNWhere3 = @CNWhere3 + ' And T9.CurrencyIDCN = ''' + @CurrencyID + ''' '
		Set @CNWhere4 = @CNWhere4 + ' And T9.CurrencyIDCN = ''' + @CurrencyID + ''' '
	End	
If @IsPeriod = 1
	Begin
		Set @CNWhere1 = @CNWhere1 + ' And (CN.TranMonth + CN.TranYear*12 < ' + LTRIM(@FromPeriodIntType) + ' Or CN.TransactionTypeID = ''T00'') '
		Set @CNWhere2 = @CNWhere2 + ' And (O1.TranMonth + O1.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ' ) '
		Set @CNWhere3 = @CNWhere3 + ' And (T9.TranMonth + T9.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ' ) '
		Set @CNWhere4 = @CNWhere4 + ' And (T9.TranMonth + T9.TranYear*12 Between ' + LTRIM(@FromPeriodIntType) + ' And ' + LTRIM(@ToPeriodIntType) + ' ) '
	End
Else
	Begin
		Set @CNWhere1 = @CNWhere1 + ' And (CN.VoucherDate < ''' + LTRIM(@FromDate) + ''' Or CN.TransactionTypeID = ''T00'') '
		Set @CNWhere2 = @CNWhere2 + ' And (O1.OrderDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') '
		Set @CNWhere3 = @CNWhere3 + ' And (T9.VoucherDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') '
		Set @CNWhere4 = @CNWhere4 + ' And (T9.VoucherDate Between ''' + LTRIM(@FromDate) + ''' And ''' + LTRIM(@ToDate) + ''') '
	End	
	
Set @SQL1 = 
'(Select OB.ObjectID, OB.ObjectName, 
			OB.S1, OB.S2, OB.S3, 
			OB.S1Name, OB.S2Name, OB.S3Name, 
			OB.O01ID, OB.O02ID, OB.O03ID, OB.O04ID, OB.O05ID,
			OB.O01Name, OB.O02Name, OB.O03Name, OB.O04Name, OB.O05Name,
SUM((Case When D_C = ''D'' Then isnull(CN.OriginalAmountCN,0) Else -isnull(CN.OriginalAmountCN,0) End)) As OpenOriginalAmount,
SUM((Case When D_C = ''D'' Then isnull(CN.ConvertedAmount,0) Else -isnull(CN.ConvertedAmount,0) End)) As OpenConvertedAmount
From 
(Select * From AV4301 CN
	Where CN.DivisionID = ''' + @DivisionID + ''' And (CN.BudgetID  = ''AA'') ' + @CNWhere1 + ' 
 ) CN Right Join 
(
	Select 
			O.DivisionID, O.ObjectID, O.ObjectName, 
			O.S1, O.S2, O.S3, 
			OS1.SName As S1Name, OS2.SName As S2Name, OS3.SName As S3Name, 
			O.O01ID, O.O02ID, O.O03ID, O.O04ID, O.O05ID,
			O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name
	From AT1202 O
			Left join AT1015 O1 on O1.AnaID = O.O01ID and O1.DivisionID = O.DivisionID and O1.AnaTypeID = ''O01''
			Left join AT1015 O2 on O2.AnaID = O.O02ID and O2.DivisionID = O.DivisionID and O2.AnaTypeID = ''O02''
			Left join AT1015 O3 on O3.AnaID = O.O03ID and O3.DivisionID = O.DivisionID and O3.AnaTypeID = ''O03''
			Left join AT1015 O4 on O4.AnaID = O.O04ID and O4.DivisionID = O.DivisionID and O4.AnaTypeID = ''O04''
			Left join AT1015 O5 on O5.AnaID = O.O05ID and O5.DivisionID = O.DivisionID and O5.AnaTypeID = ''O05''
			Left join AT1207 OS1 on OS1.S = O.S1 and OS1.DivisionID = O.DivisionID and OS1.STypeID = ''O01''
			Left join AT1207 OS2 on OS2.S = O.S2 and OS2.DivisionID = O.DivisionID and OS2.STypeID = ''O02''
			Left join AT1207 OS3 on OS3.S = O.S3 and OS3.DivisionID = O.DivisionID and OS3.STypeID = ''O03''
	Where O.ObjectID Between ''' + @FromObjectID + ''' And ''' + @ToObjectID + ''' 
) OB
On CN.DivisionID = OB.DivisionID And CN.ObjectID = OB.ObjectID
Group By OB.ObjectID, OB.ObjectName, 
			OB.S1, OB.S2, OB.S3, 
			OB.S1Name, OB.S2Name, OB.S3Name, 
			OB.O01ID, OB.O02ID, OB.O03ID, OB.O04ID, OB.O05ID,
			OB.O01Name, OB.O02Name, OB.O03Name, OB.O04Name, OB.O05Name) '
			
--Don hang da xuat hoa don
Set @SQL2 = '
Select ''G01'' As GroupID, 1 As Orders, O1.SOrderID, T9.ObjectID, O1.OrderDate As VoucherDate, O1.VoucherNo,
	T9.InventoryID, T2.InventoryName, T2.UnitID, T9.Quantity, T9.UnitPrice, T9.OriginalAmount, (T9.ConvertedAmount + Isnull(T9.DiscountAmount,0)) As ConvertedAmount,
	T9.OriginalAmount As SignOriginalAmount, (T9.ConvertedAmount + Isnull(T9.DiscountAmount,0)) As SignConvertedAmount
From AT9000 T9
Left Join AT1302 T2
	On T9.InventoryID = T2.InventoryID And T9.DivisionID = T2.DivisionID 
Inner Join OT2002 O2
	On T9.DivisionID = O2.DivisionID And T9.OrderID = O2.SOrderID 
Inner Join OT2001 O1 
	On O1.DivisionID = O2.DivisionID And O1.SOrderID = O2.SOrderID And T9.OTransactionID = O2.TransactionID 
Where O1.DivisionID = ''' + @DivisionID + ''' And T9.TransactionTypeID = ''T04''' + @CNWhere2 + ' '

--Giam gia
Set @SQL3 = '
Select ''G01'' As GroupID, 2 As Orders, O1.SOrderID, O1.ObjectID, O1.OrderDate, O1.VoucherNo,
	T9.InventoryID, T2.InventoryName, T2.UnitID, T9.Quantity, T9.UnitPrice, 
	-- T9.Quantity/O2.OrderQuantity*(isnull(O2.DiscountOriginalAmount,0) + isnull(O2.CommissionOAmount,0)) As OriginalAmount, 
	-- T9.Quantity/O2.OrderQuantity*(isnull(O2.DiscountConvertedAmount,0) + isnull(O2.CommissionCAmount,0)) As ConvertedAmount,
	-- -T9.Quantity/O2.OrderQuantity*(isnull(O2.DiscountOriginalAmount,0) + isnull(O2.CommissionOAmount,0)) As SignOriginalAmount, 
	-- -T9.Quantity/O2.OrderQuantity*(isnull(O2.DiscountConvertedAmount,0) + isnull(O2.CommissionCAmount,0)) As SignConvertedAmount
	Isnull(T9.DiscountAmount,0) As OriginalAmount, 
	Isnull(T9.DiscountAmount,0) As ConvertedAmount,
	-Isnull(T9.DiscountAmount,0) As SignOriginalAmount, 
	-Isnull(T9.DiscountAmount,0) As SignConvertedAmount
From AT9000 T9
Left Join AT1302 T2
	On T9.InventoryID = T2.InventoryID And T9.DivisionID = T2.DivisionID 
Inner Join OT2002 O2
	On T9.DivisionID = O2.DivisionID And T9.OrderID = O2.SOrderID 
Inner Join OT2001 O1 
	On O1.DivisionID = O2.DivisionID And O1.SOrderID = O2.SOrderID And T9.OTransactionID = O2.TransactionID 
Where O1.DivisionID = ''' + @DivisionID + ''' And T9.TransactionTypeID = ''T04'' 
And Isnull(T9.DiscountAmount,0) <> 0 ' + @CNWhere2 + ' '


--Hang ban tra lai: T24
Set @SQL4 = '
Select ''G02'' As GroupID, 3 As Orders, T9.OrderID As SOrderID, T9.ObjectID, T9.VoucherDate, T9.VoucherNo, 
	T9.InventoryID, T2.InventoryName, T2.UnitID, T9.Quantity, T9.UnitPrice, T9.OriginalAmount, T9.ConvertedAmount, 
	-T9.OriginalAmount As SignOriginalAmount, -T9.ConvertedAmount As SignConvertedAmount 
From AT9000 T9
Left Join AT1302 T2
	On T9.InventoryID = T2.InventoryID And T9.DivisionID = T2.DivisionID 
Where T9.DivisionID = ''' + @DivisionID + ''' And T9.TransactionTypeID = ''T24'' ' + @CNWhere3 + ' '

--Phieu thu
Set @SQL5 = '
Select ''G03'' As GroupID, 4 As Orders, '''' As SOrderID, T9.ObjectID, T9.VoucherDate, T9.VoucherNo, 
	'''' As InventoryID, '''' As InventoryName, '''' As UnitID, 0 As Quantity, 0 As UnitPrice, 
	Sum(isnull(T9.OriginalAmount,0)) As OriginalAmount, Sum(isnull(T9.ConvertedAmount,0)) As ConvertedAmount,
	-Sum(isnull(T9.OriginalAmount,0)) As SignOriginalAmount, -Sum(isnull(T9.ConvertedAmount,0)) As SignConvertedAmount  
From AT9000 T9
Where T9.DivisionID = ''' + @DivisionID + ''' And T9.TransactionTypeID In (''T01'',''T21'') ' + @CNWhere3 + '  
Group By T9.ObjectID, T9.VoucherDate, T9.VoucherNo
'
--Phieu phat sinh cong no
Set @SQL6 = '
Select ''G04'' As GroupID, 5 As Orders, '''' As SOrderID, T9.ObjectID, T9.VoucherDate, T9.VoucherNo, 
	'''' As InventoryID, '''' As InventoryName, '''' As UnitID, 0 As Quantity, 0 As UnitPrice, 
	Sum(isnull(T9.OriginalAmount,0)) As OriginalAmount, Sum(isnull(T9.ConvertedAmount,0)) As ConvertedAmount, 
	Sum(isnull(T9.OriginalAmount,0)) As SignOriginalAmount, Sum(isnull(T9.ConvertedAmount,0)) As SignConvertedAmount  
From AT9000 T9
Where T9.DivisionID = ''' + @DivisionID + ''' And T9.TransactionTypeID <> ''T00'' And Isnull(T9.OrderID,'''')='''' ' + @CNWhere4 + '  
Group By T9.ObjectID, T9.VoucherDate, T9.VoucherNo
'

If isnull(@Filter,'')<>''
	EXEC ('Select * From 
			(Select A.*,
			B.GroupID, B.Orders, B.SOrderID, 
			B.VoucherDate, B.VoucherNo, 
			B.InventoryID, B.InventoryName, B.UnitID, B.Quantity, B.UnitPrice, 
			B.OriginalAmount, B.ConvertedAmount,
			B.SignOriginalAmount, B.SignConvertedAmount  
			From ' + @SQL1 + ' A 
			Left Join ' + '(' + @SQL2 + ' Union All ' + @SQL3 + ' Union All ' + @SQL4 + ' Union All ' + @SQL5 + ' Union All ' + @SQL6 + ') B
			On A.ObjectID = B.ObjectID) SV3002 Where ' + @Filter )
Else
	EXEC ('Select * From 
			(Select A.*,
			B.GroupID, B.Orders, B.SOrderID, 
			B.VoucherDate, B.VoucherNo, 
			B.InventoryID, B.InventoryName, B.UnitID, B.Quantity, B.UnitPrice, 
			B.OriginalAmount, B.ConvertedAmount,
			B.SignOriginalAmount, B.SignConvertedAmount  
			From ' + @SQL1 + ' A 
			Left Join ' + '(' + @SQL2 + ' Union All ' + @SQL3 + ' Union All ' + @SQL4 + ' Union All ' + @SQL5 + ' Union All ' + @SQL6 + ') B
			On A.ObjectID = B.ObjectID) SV3002 ')

GO


