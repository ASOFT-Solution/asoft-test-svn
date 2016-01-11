IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3024]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3024]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Hoang Thi Lan
--Date 16/10/2003
--Purpose:Dung cho bao cao ban hang(tonh hop theo khach hang) 

---- SQL 1 -- tra ra doanh so
--Edit by: Dang Le Bao Quynh; Date:12/11/2009
--Purpose: Them cac truong Von dieu le, Note, Note1 cua doi tuong
--- Edit by B.Anh, date 05/12/2009	Lay them truong VoucherTypeID, DiscountAmount, MPT doi tuong
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified by Thanh Sơn on 22/01/2015: Lấy thêm trường Ana01 cho VienGut
---- Modified on 08/01/2016 by Tiểu Mai: Bổ sung thông tin quy cách khi có thiết lập quản lý mặt hàng theo quy cách.
-- <Example>

CREATE PROCEDURE AP3024
(
	@DivisionID as nvarchar(50),
	@sSQLWhere as nvarchar(MAX) ,
	@UserID AS VARCHAR(50) = ''
)
as 
Declare @sSQL1 as nvarchar(MAX),
		@sSQL2 as nvarchar(MAX),
		@sSQL3 as nvarchar(MAX),
		@sSQL4 as nvarchar(MAX)
		
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
IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	Set @sSQL1 = N'
	Select 	AT9000.VoucherID, BatchID,  Serial, InvoiceNo, InvoiceDate, AT9000.CurrencyID, 
			AT9000.ObjectID, T01.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription,
			Sum(OriginalAmount) as OriginalAmount,
			Sum(ConvertedAmount) as ConvertedAmount,
			Sum(DiscountAmount) as DiscountAmount,
			 0 as TaxConvertedAmount,
			AT9000.VoucherNo,
			AT9000.VoucherDate,VDescription,
			AT9000.VATObjectID,
			T02.ObjectName As VATObjectName,Duedate,
			AT9000.VoucherTypeID,
			T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
			O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name, AT9000.DivisionID,
			AT9000.Ana01ID, A11.AnaName Ana01NAme,
			O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
			O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	'

	Set @sSQL2=N'
	From AT9000
	LEFT JOIN AT1011 A11 ON A11.DivisionID = AT9000.DivisionID AND A11.AnaID = AT9000.Ana01ID
	LEFT JOIN AT1202 T01 on AT9000.ObjectID=T01.ObjectID and AT9000.DivisionID=T01.DivisionID
	LEFT JOIN AT1202 T02 on AT9000.VATObjectID=T02.ObjectID and AT9000.DivisionID=T02.DivisionID
	LEFT JOIN AT1015 O1 on T01.O01ID = O1.AnaID And O1.AnaTypeID = ''O01'' and AT9000.DivisionID=O1.DivisionID
	LEFT JOIN AT1015 O2 on T01.O02ID = O2.AnaID And O2.AnaTypeID = ''O02'' and AT9000.DivisionID=O2.DivisionID
	LEFT JOIN AT1015 O3 on T01.O03ID = O3.AnaID And O3.AnaTypeID = ''O03'' and AT9000.DivisionID=O3.DivisionID
	LEFT JOIN AT1015 O4 on T01.O04ID = O4.AnaID And O4.AnaTypeID = ''O04'' and AT9000.DivisionID=O4.DivisionID
	LEFT JOIN AT1015 O5 on T01.O05ID = O5.AnaID And O5.AnaTypeID = ''O05'' and AT9000.DivisionID=O5.DivisionID
	LEFT JOIN AT8899 O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID
	'+@sSQLPer+'
	WHERE	TransactionTypeID in (''T04'',''T40'')
			'+@sWHEREPer+'
			AND  AT9000.DivisionID='''+@DivisionID+''' 
			AND '+@sSQLWhere+'
	Group By AT9000.VoucherID, BatchID, Serial, InvoiceNo, InvoiceDate,AT9000.CurrencyID, AT9000.ObjectID,T01.ObjectName, AT9000.VATObjectID, T02.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription,AT9000.VoucherNo,
		AT9000.VoucherDate,VDescription,Duedate, AT9000.VoucherTypeID,
		T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
		O1.AnaName, O2.AnaName, O3.AnaName, O4.AnaName, O5.AnaName, AT9000.DivisionID, AT9000.Ana01ID, A11.AnaName,
		O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
		O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	'

	Set @sSQL3=N'
	Union All
	---- SQL 2 tra ra thue
	Select 	  AT9000.VoucherID, BatchID,  Serial, InvoiceNo, InvoiceDate,AT9000.CurrencyID,  
	AT9000.ObjectID,T01.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription,
		0 as OriginalAmount,
		0 as ConvertedAmount,
		0 as DiscountAmount,	
		Sum(ConvertedAmount)  as TaxConvertedAmount,
		AT9000.VoucherNo,
		AT9000.VoucherDate ,VDescription,
		AT9000.VATObjectID,
		T02.ObjectName As VATObjectName,Duedate, AT9000.VoucherTypeID,
		T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
		O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name, 
		AT9000.DivisionID, AT9000.Ana01ID, A11.AnaName Ana01NAme,
		O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
		O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	'

	Set @sSQL4=N'
	From AT9000
	LEFT JOIN AT1011 A11 ON A11.DivisionID = AT9000.DivisionID AND A11.AnaID = AT9000.Ana01ID
	LEFT JOIN AT1202 T01 on AT9000.ObjectID=T01.ObjectID and AT9000.DivisionID=T01.DivisionID
	LEFT JOIN AT1202 T02 on AT9000.VATObjectID=T02.ObjectID  and AT9000.DivisionID=T02.DivisionID
	LEFT JOIN AT1015 O1 on T01.O01ID = O1.AnaID And O1.AnaTypeID = ''O01'' and AT9000.DivisionID=O1.DivisionID
	LEFT JOIN AT1015 O2 on T01.O02ID = O2.AnaID And O2.AnaTypeID = ''O02'' and AT9000.DivisionID=O2.DivisionID
	LEFT JOIN AT1015 O3 on T01.O03ID = O3.AnaID And O3.AnaTypeID = ''O03'' and AT9000.DivisionID=O3.DivisionID
	LEFT JOIN AT1015 O4 on T01.O04ID = O4.AnaID And O4.AnaTypeID = ''O04'' and AT9000.DivisionID=O4.DivisionID
	LEFT JOIN AT1015 O5 on T01.O05ID = O5.AnaID And O5.AnaTypeID = ''O05'' and AT9000.DivisionID=O5.DivisionID
	LEFT JOIN AT8899 O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID
	'+@sSQLPer + '
	Where	TransactionTypeID =''T14''
			'+@sWHEREPer+'
		   and AT9000.DivisionID='''+@DivisionID+''' 
		   and '+@sSQLWhere+'
	 Group By AT9000.VoucherID, BatchID, Serial, InvoiceNo, InvoiceDate, AT9000.CurrencyID, 
	 AT9000.ObjectID,T01.ObjectName, AT9000.VATObjectID, T02.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription, AT9000.VoucherNo,
		AT9000.VoucherDate, VDescription,Duedate, AT9000.VoucherTypeID,
		T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
		O1.AnaName, O2.AnaName, O3.AnaName, O4.AnaName, O5.AnaName , AT9000.DivisionID, AT9000.Ana01ID, A11.AnaName,
		O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
		O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
	'	
END	
ELSE
BEGIN
	Set @sSQL1 = N'
	Select 	VoucherID, BatchID,  Serial, InvoiceNo, InvoiceDate, AT9000.CurrencyID, 
			AT9000.ObjectID, T01.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription,
			Sum(OriginalAmount) as OriginalAmount,
			Sum(ConvertedAmount) as ConvertedAmount,
			Sum(DiscountAmount) as DiscountAmount,
			 0 as TaxConvertedAmount,
			AT9000.VoucherNo,
			AT9000.VoucherDate,VDescription,
			AT9000.VATObjectID,
			T02.ObjectName As VATObjectName,Duedate,
			AT9000.VoucherTypeID,
			T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
			O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name, AT9000.DivisionID,
			AT9000.Ana01ID, A11.AnaName Ana01NAme
	'

	Set @sSQL2=N'
	From AT9000
	LEFT JOIN AT1011 A11 ON A11.DivisionID = AT9000.DivisionID AND A11.AnaID = AT9000.Ana01ID
	LEFT JOIN AT1202 T01 on AT9000.ObjectID=T01.ObjectID and AT9000.DivisionID=T01.DivisionID
	LEFT JOIN AT1202 T02 on AT9000.VATObjectID=T02.ObjectID and AT9000.DivisionID=T02.DivisionID
	LEFT JOIN AT1015 O1 on T01.O01ID = O1.AnaID And O1.AnaTypeID = ''O01'' and AT9000.DivisionID=O1.DivisionID
	LEFT JOIN AT1015 O2 on T01.O02ID = O2.AnaID And O2.AnaTypeID = ''O02'' and AT9000.DivisionID=O2.DivisionID
	LEFT JOIN AT1015 O3 on T01.O03ID = O3.AnaID And O3.AnaTypeID = ''O03'' and AT9000.DivisionID=O3.DivisionID
	LEFT JOIN AT1015 O4 on T01.O04ID = O4.AnaID And O4.AnaTypeID = ''O04'' and AT9000.DivisionID=O4.DivisionID
	LEFT JOIN AT1015 O5 on T01.O05ID = O5.AnaID And O5.AnaTypeID = ''O05'' and AT9000.DivisionID=O5.DivisionID
	'+@sSQLPer+'
	WHERE	TransactionTypeID in (''T04'',''T40'')
			'+@sWHEREPer+'
			AND  AT9000.DivisionID='''+@DivisionID+''' 
			AND '+@sSQLWhere+'
	Group By VoucherID, BatchID, Serial, InvoiceNo, InvoiceDate,AT9000.CurrencyID, AT9000.ObjectID,T01.ObjectName, AT9000.VATObjectID, T02.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription,AT9000.VoucherNo,
		AT9000.VoucherDate,VDescription,Duedate, AT9000.VoucherTypeID,
		T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
		O1.AnaName, O2.AnaName, O3.AnaName, O4.AnaName, O5.AnaName, AT9000.DivisionID, AT9000.Ana01ID, A11.AnaName
	'

	Set @sSQL3=N'
	Union All
	---- SQL 2 tra ra thue
	Select 	  VoucherID, BatchID,  Serial, InvoiceNo, InvoiceDate,AT9000.CurrencyID,  
	AT9000.ObjectID,T01.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription,
		0 as OriginalAmount,
		0 as ConvertedAmount,
		0 as DiscountAmount,	
		Sum(ConvertedAmount)  as TaxConvertedAmount,
		AT9000.VoucherNo,
		AT9000.VoucherDate ,VDescription,
		AT9000.VATObjectID,
		T02.ObjectName As VATObjectName,Duedate, AT9000.VoucherTypeID,
		T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
		O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name, 
		AT9000.DivisionID, AT9000.Ana01ID, A11.AnaName Ana01NAme
	'

	Set @sSQL4=N'
	From AT9000
	LEFT JOIN AT1011 A11 ON A11.DivisionID = AT9000.DivisionID AND A11.AnaID = AT9000.Ana01ID
	LEFT JOIN AT1202 T01 on AT9000.ObjectID=T01.ObjectID and AT9000.DivisionID=T01.DivisionID
	LEFT JOIN AT1202 T02 on AT9000.VATObjectID=T02.ObjectID  and AT9000.DivisionID=T02.DivisionID
	LEFT JOIN AT1015 O1 on T01.O01ID = O1.AnaID And O1.AnaTypeID = ''O01'' and AT9000.DivisionID=O1.DivisionID
	LEFT JOIN AT1015 O2 on T01.O02ID = O2.AnaID And O2.AnaTypeID = ''O02'' and AT9000.DivisionID=O2.DivisionID
	LEFT JOIN AT1015 O3 on T01.O03ID = O3.AnaID And O3.AnaTypeID = ''O03'' and AT9000.DivisionID=O3.DivisionID
	LEFT JOIN AT1015 O4 on T01.O04ID = O4.AnaID And O4.AnaTypeID = ''O04'' and AT9000.DivisionID=O4.DivisionID
	LEFT JOIN AT1015 O5 on T01.O05ID = O5.AnaID And O5.AnaTypeID = ''O05'' and AT9000.DivisionID=O5.DivisionID
	'+@sSQLPer + '
	Where	TransactionTypeID =''T14''
			'+@sWHEREPer+'
		   and AT9000.DivisionID='''+@DivisionID+''' 
		   and '+@sSQLWhere+'
	 Group By VoucherID, BatchID, Serial, InvoiceNo, InvoiceDate, AT9000.CurrencyID, 
	 AT9000.ObjectID,T01.ObjectName, AT9000.VATObjectID, T02.ObjectName, T01.LegalCapital, T01.Note, T01.Note1, BDescription, AT9000.VoucherNo,
		AT9000.VoucherDate, VDescription,Duedate, AT9000.VoucherTypeID,
		T01.O01ID, T01.O02ID, T01.O03ID, T01.O04ID, T01.O05ID,
		O1.AnaName, O2.AnaName, O3.AnaName, O4.AnaName, O5.AnaName , AT9000.DivisionID, AT9000.Ana01ID, A11.AnaName
	'	
END	

If not Exists (Select top 1 1 From SysObjects Where Xtype ='V' and name ='AV3024')
	 Exec ('Create view AV3024 as '  +@sSQL1+@sSQL2+@sSQL3+@sSQL4)
Else
	Exec ('Alter view AV3024 as '+@sSQL1+@sSQL2+@sSQL3+@sSQL4)	


--print @sSQL
IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN

	Set @sSQL1=N'
	Select  VoucherID, 
			BatchID,
			Serial,
			InvoiceNo,
			InvoiceDate,
 			CurrencyID,ObjectID,ObjectName ,
			LegalCapital, Note, Note1,	
			Sum(OriginalAmount) as OriginalAmount,
			BDescription,
			Sum(ConvertedAmount) as TurnOverAmount,
			Sum(TaxConvertedAmount) as TaxAmount,
			Sum(DiscountAmount) as DiscountAmount,
			VoucherNo,
			VoucherDate, VDescription,
			Max(VATObjectID) As VATObjectID,
			Max(VATObjectName) As VATObjectName,Duedate, VoucherTypeID,
			O01ID, O02ID, O03ID, O04ID, O05ID,
			O01Name, O02Name, O03Name, O04Name, O05Name, DivisionID,
			Ana01ID, Ana01Name,
			S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,
			S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID'
	
	Set @sSQL2=N'
	From	AV3024
	Group By VoucherID,	 BatchID,	 Serial,	 InvoiceNo,	 InvoiceDate,
	 		 CurrencyID, ObjectID,ObjectName , LegalCapital, Note, Note1, BDescription, VoucherNo,
			VoucherDate , VDescription,Duedate, VoucherTypeID,
			O01ID, O02ID, O03ID, O04ID, O05ID,
			O01Name, O02Name, O03Name, O04Name, O05Name, DivisionID, Ana01ID, Ana01Name,
			S01ID,S02ID,S03ID,S04ID,S05ID,S06ID,S07ID,S08ID,S09ID,S10ID,
			S11ID,S12ID,S13ID,S14ID,S15ID,S16ID,S17ID,S18ID,S19ID,S20ID '
	
END
ELSE
BEGIN

	Set @sSQL1=N'
	Select  VoucherID, 
			BatchID,
			Serial,
			InvoiceNo,
			InvoiceDate,
 			CurrencyID,ObjectID,ObjectName ,
			LegalCapital, Note, Note1,	
			Sum(OriginalAmount) as OriginalAmount,
			BDescription,
			Sum(ConvertedAmount) as TurnOverAmount,
			Sum(TaxConvertedAmount) as TaxAmount,
			Sum(DiscountAmount) as DiscountAmount,
			VoucherNo,
			VoucherDate, VDescription,
			Max(VATObjectID) As VATObjectID,
			Max(VATObjectName) As VATObjectName,Duedate, VoucherTypeID,
			O01ID, O02ID, O03ID, O04ID, O05ID,
			O01Name, O02Name, O03Name, O04Name, O05Name, DivisionID,
			Ana01ID, Ana01Name'
	
	Set @sSQL2=N'
	From	AV3024
	Group By VoucherID,	 BatchID,	 Serial,	 InvoiceNo,	 InvoiceDate,
	 		 CurrencyID, ObjectID,ObjectName , LegalCapital, Note, Note1, BDescription, VoucherNo,
			VoucherDate , VDescription,Duedate, VoucherTypeID,
			O01ID, O02ID, O03ID, O04ID, O05ID,
			O01Name, O02Name, O03Name, O04Name, O05Name, DivisionID, Ana01ID, Ana01Name '
	
END	
---print @SQLL
If not exists (Select top 1 1 From SysObjects Where name = 'AV3026' and Xtype ='V')
	 Exec('Create view AV3026 as '+@sSQL1+@sSQL2) 
Else
	Exec ('Alter view AV3026 as '+@sSQL1+@sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

