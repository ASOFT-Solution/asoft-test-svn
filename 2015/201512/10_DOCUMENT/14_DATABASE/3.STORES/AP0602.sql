IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0602]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0602]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--created by Hoang Thi Lan
--Date 17/10/2003
--Purpose: Dung cho Report Doanh so hang mua theo mat hang(tong hop)
--Edit by: Dang Le Bao Quynh; Date: 21/05/2008
--Purpose: Them he so quy doi cho mat hang
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
--- Edited by: Bao Anh	Date: 17/07/2012
--- Purpose: Lay them truong MPT doi tuong, dien giai, dieu khoan thanh toan
---- Modified on 26/10/2012 by Lê Thị Thu Hiền : Bổ sung JOIN DivisionID
---- Modified on 22/11/2013 by Thanh Sơn: Bổ sung lấy thêm 5 trường mã phân tích mặt hàng (Mã + Tên)
---- Modified on 08/01/2016 by Tiểu Mai: Bổ sung thông tin quy cách khi có thiết lập quản lý mặt hàng theo quy cách.

CREATE PROCEDURE [dbo].[AP0602] @DivisionID AS nvarchar(50), 
				@sSQLWhere AS nvarchar(4000), 
				@Group1ID as tinyint,	---- = 0 la theo loai mat hang.
								---  = 1 la theo tai khoan doanh so
								---  = 2 la theo doi tuong
				@Group2ID as tinyint
AS

Declare @sSQL as nvarchar(4000)
Declare @sSQL1 as nvarchar(4000)

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	Set @sSQL=N'
			Select 	
				' + (Case when @Group1ID = 0 then 'AT9000.InventoryID'
					when @Group1ID = 1 then 'AT9000.DebitAccountID'
					else 'AT9000.ObjectID' end) + ' as Group1ID,
				' + (Case when @Group1ID = 0 then 'AT1302.InventoryName'
					when @Group1ID = 1 then 'AT1005.AccountName'
					else 'AT1202.ObjectName' end) + ' as Group1Name,
				' + (Case when @Group2ID = 0 then 'AT9000.InventoryID'
					when @Group2ID = 1 then 'AT9000.DebitAccountID'
					else 'AT9000.ObjectID' end) + ' as Group2ID,
				' + (Case when @Group2ID = 0 then 'AT1302.InventoryName'
					when @Group2ID = 1 then 'AT1005.AccountName'
					else 'AT1202.ObjectName' end) + ' as Group2Name,
				AT9000.ObjectID,
				AT1202.ObjectName,
				AT9000.InventoryID,
				AT1302.InventoryName,
				AT1302.UnitID,
				AT1309.UnitID As ConversionUnitID,
				AT1309.ConversionFactor,
				AT1309.Operator,	
				DebitAccountID, AccountName as DebitAccountName,
				sum(isnull(Quantity,0)) as Quantity,
				sum(isnull(OriginalAmount,0)) as OriginalAmount,
				sum(isnull(ConvertedAmount,0)) as ConvertedAmount,

				sum(ImTaxOriginalAmount) as ImTaxOriginalAmount,
				sum(ImTaxConvertedAmount) as ImTaxConvertedAmount,
				sum(ExpenseOriginalAmount) as ExpenseOriginalAmount,	
				sum(ExpenseConvertedAmount) as ExpenseConvertedAmount,
				AT9000.DivisionID,
				AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
				O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name,
				BDescription, TDescription, AT9000.PaymentTermID, AT1208.PaymentTermName,
				AT1302.[I01ID], AT1302.[I02ID], AT1302.[I03ID], AT1302.[I04ID], AT1302.[I05ID],
				I1.AnaName AS I01Name,I2.AnaName AS I02Name,I3.AnaName AS I03Name,I4.AnaName AS I04Name,I5.AnaName AS I05Name,
				O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
				O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	From AT9000 left join AT1302 on AT9000.InventoryID = AT1302.InventoryID and  AT9000.DivisionID = AT1302.DivisionID
			Left join (Select DivisionID, InventoryID,Min(UnitID) As UnitID,Min(ConversionFactor) As ConversionFactor, Min(Operator) As Operator From AT1309 Group By DivisionID, InventoryID) AT1309 On AT9000.InventoryID = AT1309.InventoryID and  AT9000.DivisionID = AT1309.DivisionID
			left join AT1202 on AT9000.ObjectID = AT1202.ObjectID and  AT9000.DivisionID = AT1202.DivisionID
			left join AT1005 on AT9000.DebitAccountID = AT1005.AccountID and  AT9000.DivisionID = AT1005.DivisionID
			Left join AT1015 O1 on AT1202.O01ID = O1.AnaID And O1.AnaTypeID = ''O01'' and O1.DivisionID = AT9000.DivisionID
			Left join AT1015 O2 on AT1202.O02ID = O2.AnaID And O2.AnaTypeID = ''O02'' and O2.DivisionID = AT9000.DivisionID
			Left join AT1015 O3 on AT1202.O03ID = O3.AnaID And O3.AnaTypeID = ''O03'' and O3.DivisionID = AT9000.DivisionID
			Left join AT1015 O4 on AT1202.O04ID = O4.AnaID And O4.AnaTypeID = ''O04'' and O4.DivisionID = AT9000.DivisionID
			Left join AT1015 O5 on AT1202.O05ID = O5.AnaID And O5.AnaTypeID = ''O05'' and O5.DivisionID = AT9000.DivisionID
			Left join AT1015 I1 on AT1302.I01ID = I1.AnaID And I1.AnaTypeID = ''I01'' and I1.DivisionID = AT9000.DivisionID
			Left join AT1015 I2 on AT1302.I02ID = I2.AnaID And I2.AnaTypeID = ''I02'' and I2.DivisionID = AT9000.DivisionID
			Left join AT1015 I3 on AT1302.I03ID = I3.AnaID And I3.AnaTypeID = ''I03'' and I3.DivisionID = AT9000.DivisionID
			Left join AT1015 I4 on AT1302.I04ID = I4.AnaID And I4.AnaTypeID = ''I04'' and I4.DivisionID = AT9000.DivisionID
			Left join AT1015 I5 on AT1302.I05ID = I5.AnaID And I5.AnaTypeID = ''I05'' and I5.DivisionID = AT9000.DivisionID
			Left Join AT1208 on AT9000.PaymentTermID = AT1208.PaymentTermID AND AT1208.DivisionID = AT9000.DivisionID
			LEFT JOIN AT8899 O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID
	'
	set @sSQL1 = 'Where AT9000.DivisionID=N'''+@DivisionID+''' and AT9000.TransactionTypeID in (N''T03'',N''T30'')
		and '+@sSQLWhere+'
	Group by AT9000.ObjectID, AT1202.ObjectName, AT9000.InventoryID, AT1302.InventoryName, DebitAccountID,
				AT1005.AccountName,
				AT1302.UnitID,
				AT1309.UnitID,
				AT1309.ConversionFactor,
				AT1309.Operator,
				AT9000.DivisionID,
				AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
				O1.AnaName, O2.AnaName, O3.AnaName, O4.AnaName, O5.AnaName,
				BDescription, TDescription, AT9000.PaymentTermID, AT1208.PaymentTermName,
				AT1302.[I01ID], AT1302.[I02ID], AT1302.[I03ID], AT1302.[I04ID], AT1302.[I05ID],
				I1.AnaName, I2.AnaName, I3.AnaName, I4.AnaName, I5.AnaName,
				O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
				O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID   '
	
END
ELSE
BEGIN
	Set @sSQL=N'
			Select 	
				' + (Case when @Group1ID = 0 then 'AT9000.InventoryID'
					when @Group1ID = 1 then 'AT9000.DebitAccountID'
					else 'AT9000.ObjectID' end) + ' as Group1ID,
				' + (Case when @Group1ID = 0 then 'AT1302.InventoryName'
					when @Group1ID = 1 then 'AT1005.AccountName'
					else 'AT1202.ObjectName' end) + ' as Group1Name,
				' + (Case when @Group2ID = 0 then 'AT9000.InventoryID'
					when @Group2ID = 1 then 'AT9000.DebitAccountID'
					else 'AT9000.ObjectID' end) + ' as Group2ID,
				' + (Case when @Group2ID = 0 then 'AT1302.InventoryName'
					when @Group2ID = 1 then 'AT1005.AccountName'
					else 'AT1202.ObjectName' end) + ' as Group2Name,
				AT9000.ObjectID,
				AT1202.ObjectName,
				AT9000.InventoryID,
				AT1302.InventoryName,
				AT1302.UnitID,
				AT1309.UnitID As ConversionUnitID,
				AT1309.ConversionFactor,
				AT1309.Operator,	
				DebitAccountID, AccountName as DebitAccountName,
				sum(isnull(Quantity,0)) as Quantity,
				sum(isnull(OriginalAmount,0)) as OriginalAmount,
				sum(isnull(ConvertedAmount,0)) as ConvertedAmount,

				sum(ImTaxOriginalAmount) as ImTaxOriginalAmount,
				sum(ImTaxConvertedAmount) as ImTaxConvertedAmount,
				sum(ExpenseOriginalAmount) as ExpenseOriginalAmount,	
				sum(ExpenseConvertedAmount) as ExpenseConvertedAmount,
				AT9000.DivisionID,
				AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
				O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name,
				BDescription, TDescription, AT9000.PaymentTermID, AT1208.PaymentTermName,
				AT1302.[I01ID], AT1302.[I02ID], AT1302.[I03ID], AT1302.[I04ID], AT1302.[I05ID],
				I1.AnaName AS I01Name,I2.AnaName AS I02Name,I3.AnaName AS I03Name,I4.AnaName AS I04Name,I5.AnaName AS I05Name
	From AT9000 left join AT1302 on AT9000.InventoryID = AT1302.InventoryID and  AT9000.DivisionID = AT1302.DivisionID
			Left join (Select DivisionID, InventoryID,Min(UnitID) As UnitID,Min(ConversionFactor) As ConversionFactor, Min(Operator) As Operator From AT1309 Group By DivisionID, InventoryID) AT1309 On AT9000.InventoryID = AT1309.InventoryID and  AT9000.DivisionID = AT1309.DivisionID
			left join AT1202 on AT9000.ObjectID = AT1202.ObjectID and  AT9000.DivisionID = AT1202.DivisionID
			left join AT1005 on AT9000.DebitAccountID = AT1005.AccountID and  AT9000.DivisionID = AT1005.DivisionID
			Left join AT1015 O1 on AT1202.O01ID = O1.AnaID And O1.AnaTypeID = ''O01'' and O1.DivisionID = AT9000.DivisionID
			Left join AT1015 O2 on AT1202.O02ID = O2.AnaID And O2.AnaTypeID = ''O02'' and O2.DivisionID = AT9000.DivisionID
			Left join AT1015 O3 on AT1202.O03ID = O3.AnaID And O3.AnaTypeID = ''O03'' and O3.DivisionID = AT9000.DivisionID
			Left join AT1015 O4 on AT1202.O04ID = O4.AnaID And O4.AnaTypeID = ''O04'' and O4.DivisionID = AT9000.DivisionID
			Left join AT1015 O5 on AT1202.O05ID = O5.AnaID And O5.AnaTypeID = ''O05'' and O5.DivisionID = AT9000.DivisionID
			Left join AT1015 I1 on AT1302.I01ID = I1.AnaID And I1.AnaTypeID = ''I01'' and I1.DivisionID = AT9000.DivisionID
			Left join AT1015 I2 on AT1302.I02ID = I2.AnaID And I2.AnaTypeID = ''I02'' and I2.DivisionID = AT9000.DivisionID
			Left join AT1015 I3 on AT1302.I03ID = I3.AnaID And I3.AnaTypeID = ''I03'' and I3.DivisionID = AT9000.DivisionID
			Left join AT1015 I4 on AT1302.I04ID = I4.AnaID And I4.AnaTypeID = ''I04'' and I4.DivisionID = AT9000.DivisionID
			Left join AT1015 I5 on AT1302.I05ID = I5.AnaID And I5.AnaTypeID = ''I05'' and I5.DivisionID = AT9000.DivisionID
			Left Join AT1208 on AT9000.PaymentTermID = AT1208.PaymentTermID AND AT1208.DivisionID = AT9000.DivisionID
	'
	set @sSQL1 = 'Where AT9000.DivisionID=N'''+@DivisionID+''' and AT9000.TransactionTypeID in (N''T03'',N''T30'')
		and '+@sSQLWhere+'
	Group by AT9000.ObjectID, AT1202.ObjectName, AT9000.InventoryID, AT1302.InventoryName, DebitAccountID,
				AT1005.AccountName,
				AT1302.UnitID,
				AT1309.UnitID,
				AT1309.ConversionFactor,
				AT1309.Operator,
				AT9000.DivisionID,
				AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
				O1.AnaName, O2.AnaName, O3.AnaName, O4.AnaName, O5.AnaName,
				BDescription, TDescription, AT9000.PaymentTermID, AT1208.PaymentTermName,
				AT1302.[I01ID], AT1302.[I02ID], AT1302.[I03ID], AT1302.[I04ID], AT1302.[I05ID],
				I1.AnaName, I2.AnaName, I3.AnaName, I4.AnaName, I5.AnaName   '
	
END	

---print @sSQL + @sSQL1

If not exists (Select top 1 1 From SysObjects Where name = 'AV0602' and Xtype ='V')
	Exec ('Create view AV0602 --AP0602
	as '+@sSQL + @sSQL1)
Else
	Exec ('Alter view AV0602  --AP0602
	as '+@sSQL + @sSQL1)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

