IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3022]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP3022]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by Hoang Thi Lan
--Date 17/10/2003
--Purpose:Dïng cho report doanh sè hµng b¸n
--Last Update Van Nhan, 16/08/2006
--Edit by Nguyen Quoc Huy Date 01/12/2008.
--Last Edit : Thuy Tuyen , date 12/08/2008
--Edit by: Dang Le Bao Quynh; Date:30/09/2009
--Purpose: Them 5 ma phan tich mat hang
--Edit by: Dang Le Bao Quynh; Date:19/10/2009
--Purpose: Them cac truong tien thue VAT
--Edit by: Dang Le Bao Quynh; Date:12/11/2009
--Purpose: Them cac truong Von dieu le, Note, Note1 cua doi tuong
--- Edit by B.Anh, date 05/12/2009	Lay them cac truong Loai chung tu, chiet khau
--- Edit by T.Phu, date 10/09/2012	Lay them cac truong AT9000.RefNo01, AT9000.RefNo02
---- Modified on 22/11/2012 by Le Thi Thu Hien : Bổ sung FieldName
---- Modified on 07/12/2012 by Le Thi Thu Hien : Bổ sung Khoan muc Ana06--> Ana10
--  exec AP3025 @DivisionID=N'AS',@FromDate='2012-12-07 10:02:25.37',@ToDate='2012-12-07 10:02:25.37',@FromMonth=5,@FromYear=2012,@ToMonth=5,@ToYear=2012,@IsDate=0,@IsDetail=1,@IsCustomer=0
-- Last Modified on 01/03/2013 by Thiên Huỳnh: Bổ sung InventoryTypeID, WareHouseID, WareHouseName
---- Modified on 17/04/2013 by Le Thi Thu Hien : Sửa lại lấy dữ liệu VATOriginalAmount, VATConvertedAmount
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 24/03/2014 by Bảo Anh : Bổ sung InventoryTypeName, ComAmountOB, ComAmountEM, PriceInList (Long Trường Vũ)
---- Modified on 23/07/2014 by Mai Duyen : Bổ sung them field AT9000.Orders(KH Printech)
---- Modified on 08/08/2014 by Thanh Sơn: Bổ sung thêm điều kiện kết với bảng giá  'AND AT9000.PriceListID = OT1302.ID' do 1 mặt hàng có thể thuộc 2 bảng giá nên bị đúp dòng
---- Modified on 21/01/2015 by Mai Duyen : Bổ sung AT2007.SoureNo,AT2007.LimitDate   (Savi)
---- Modified on 20/03/2015 by Lê Thị Hạnh: Bổ sung lấy thông tin thuế BVMT: ETaxID, ETaxName, ETaxAmount, ETaxConvertedUnit, ETaxConvertedAmount
---- Modified on 10/09/2015 by Tiểu Mai: Bổ sung tên 10 MPT, 10 tham số Parameter.
---- Modified on 08/01/2016 by Tiểu Mai: Bổ sung thông tin quy cách khi có thiết lập quản lý mặt hàng theo quy cách.
-- <Example>
---- 


CREATE PROCEDURE [dbo].[AP3022] 
	@DivisionID as nvarchar(50) ,
	@sSQLWhere as nvarchar(max) ,
	@UserID AS VARCHAR(50) = ''
	
as
declare @sSQL1 as nvarchar(max),
		@sSQL2 as nvarchar(max),
		@sSQL3 as nvarchar(max),
		@sSQL4 AS NVARCHAR(MAX),
		@sSQL5 as NVARCHAR(MAX)
		
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

----------->>>> Kiem tra customize
Declare @AP4444 Table(CustomerName Int, Export Int)
Declare @CustomerName AS Int
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')
Select @CustomerName=CustomerName From @AP4444
-----------<<<< Kiem tra customize

------ Thong tin quy cach------
SET @sSQL4 = ''
SET @sSQL5 = ''
IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN

	SET @sSQL4 = ',
				O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
				O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
				'
	SET @sSQL5 = '
				LEFT JOIN AT8899 O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID'
	
END		
set @sSQL1=N'
	SELECT  AT1202.ObjectID,
			AT1202.ObjectName,
			AT1202.Address,
			AT1202.LegalCapital,
			AT1202.Note,
			AT1202.Note1,
			AT9000.InventoryID,
			Case when isnull(AT9000.InventoryName1,'''')= '''' then  isnull(AT1302.InventoryName,'''')  Else AT9000.InventoryName1 end as InventoryName,
			AT1302.UnitID,
			AT1304.UnitName,
	       	AT9000.Serial,
			AT9000.InvoiceNo,
			AT9000.VoucherNo,
			AT9000.InvoiceDate,
			AT9000.VoucherDate,
			isnull(AT9000.Quantity,0) as Quantity,
			AT9000.CurrencyID,
			AT9000.UnitPrice,
			isnull(AT9000.OriginalAmount,0)/(Case when isnull(AT9000.Quantity,0)=0 then 1 else AT9000.Quantity end) as SalePrice01,
			isnull(AT9000.ConvertedAmount,0)/(Case when isnull(AT9000.Quantity,0)=0 then 1 else AT9000.Quantity end) as SalePrice02,
			isnull(AT9000.OriginalAmount,0) as OriginalAmount,
			isnull(AT9000.ConvertedAmount,0) as ConvertedAmount, VATRate,  
			Isnull(AT9000.VATOriginalAmount,0) as VATOriginalAmount,
			Isnull(AT9000.VATConvertedAmount,0) as VATConvertedAmount,
			(Isnull (AT9000.UnitPrice,0) * Isnull (VATRate,0))/100  + Isnull(AT9000.UnitPrice,0) as VATUnitPrice,
			(Select Sum(Isnull (T9.OriginalAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  as VATOriginalAmountForInvoice,
			(Select Sum(Isnull (T9.ConvertedAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  as VATConvertedAmountForInvoice,

			isnull(AT2007.UnitPrice,0) as PrimeCostPrice,
			isnull(AT2007.ConvertedAmount,0) as PrimeCostAmount,
			---AT2007.DebitAccountID,
			----AT2007.CreditAccountID,
			AT9000.DebitAccountID,
			AT9000.CreditAccountID,
			AT9000.Orders,
			AT9000.Ana01ID,   AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID, AT9000.Ana05ID,
			AT9000.Ana06ID,   AT9000.Ana07ID, AT9000.Ana08ID, AT9000.Ana09ID, AT9000.Ana10ID,
			AT9000.VDescription, AT9000.BDescription, AT9000.TDescription, AT9000.Duedate,
			AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,		'
		
set @sSQL2=N'
			O1.AnaName As O01Name, O2.AnaName As O02Name, O3.AnaName As O03Name, O4.AnaName As O04Name, O5.AnaName As O05Name,
			AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
			I1.AnaName As I01Name, I2.AnaName As I02Name, I3.AnaName As I03Name, I4.AnaName As I04Name, I5.AnaName As I05Name,
			AT9000.VoucherTypeID, AT9000.DiscountRate, AT9000.DiscountAmount, AT9000.DivisionID,
			AT9000.Parameter01,AT9000.Parameter02,AT9000.Parameter03,AT9000.Parameter04,
			AT9000.Parameter05,AT9000.Parameter06,AT9000.Parameter07,AT9000.Parameter08,AT9000.Parameter09,AT9000.Parameter10,
			A1.AnaName as Ana01Name, A2.AnaName as Ana02Name, A3.AnaName as Ana03Name, A4.AnaName as Ana04Name, A5.AnaName as Ana05Name,
			A6.AnaName as Ana06Name, A7.AnaName as Ana07Name, A8.AnaName as Ana08Name, A9.AnaName as Ana09Name, A10.AnaName as Ana10Name,
			AT9000.RefNo01, AT9000.RefNo02,
			(Select Count(ObjectID) From AT1202 A Where A.O02ID = AT1202.O02ID) As FieldName, 
			AT1302.InventoryTypeID, AT2006.WareHouseID, AT1303.WareHouseName, AT9000.IsMultiTax, AT2006.VoucherNo as WVoucherNo,
			AT1301.InventoryTypeName , AT2007.SourceNo, AT2007.LimitDate,
			AT1302.ETaxID, AT93.ETaxName, ISNULL(AT95.ETaxAmount,0) AS ETaxAmount, 
			ISNULL(AT9000.ETaxConvertedUnit,0) AS ETaxConvertedUnit, ISNULL(AT9000.ETaxConvertedAmount,0) AS ETaxConvertedAmount
			 '

IF @CustomerName = 24 --- Long Trường Vũ
	set @sSQL2 = @sSQL2 + ',CMT1.ComAmount as ComAmountOB, CMT2.ComAmount as ComAmountEM, OT1302.UnitPrice as PriceInList'

set @sSQL2 = @sSQL2 + @sSQL4 + '
	FROM AT9000 	
	LEFT JOIN AT1302 on AT9000.InventoryID=AT1302.InventoryID and AT9000.DivisionID=AT1302.DivisionID
	LEFT JOIN AT1301 on AT1302.InventoryTypeID=AT1301.InventoryTypeID and AT1302.DivisionID=AT1301.DivisionID
	LEFT JOIN AT1015 I1 On AT1302.I01ID = I1.AnaID And I1.AnaTypeID = ''I01''  and AT9000.DivisionID=I1.DivisionID
	LEFT JOIN AT1015 I2 On AT1302.I02ID = I2.AnaID And I2.AnaTypeID = ''I02''  and AT9000.DivisionID=I2.DivisionID
	LEFT JOIN AT1015 I3 On AT1302.I03ID = I3.AnaID And I3.AnaTypeID = ''I03''  and AT9000.DivisionID=I3.DivisionID
	LEFT JOIN AT1015 I4 On AT1302.I04ID = I4.AnaID And I4.AnaTypeID = ''I04''  and AT9000.DivisionID=I4.DivisionID
	LEFT JOIN AT1015 I5 On AT1302.I05ID = I5.AnaID And I5.AnaTypeID = ''I05''   and AT9000.DivisionID=I5.DivisionID
   	LEFT JOIN AT1202 on AT9000.ObjectID=AT1202.ObjectID	 and AT9000.DivisionID=AT1202.DivisionID
	LEFT JOIN AT1304 on AT1304.UnitID = AT1302.UnitID and AT9000.DivisionID=AT1304.DivisionID
	LEFT JOIN AT1010 on AT1010.VATGroupID = AT9000.VATGroupID and AT9000.DivisionID=AT1010.DivisionID
	LEFT JOIN AT2007 on AT2007.TransactionID =AT9000.TransactionID and
						AT2007.InventoryID = AT9000.InventoryID and AT9000.DivisionID=AT2007.DivisionID
	'
set @sSQL3=N'
	LEFT JOIN AT1015 O1 on AT1202.O01ID = O1.AnaID And O1.AnaTypeID = ''O01'' and AT9000.DivisionID=O1.DivisionID
	LEFT JOIN AT1015 O2 on AT1202.O02ID = O2.AnaID And O2.AnaTypeID = ''O02'' and AT9000.DivisionID=O2.DivisionID
	LEFT JOIN AT1015 O3 on AT1202.O03ID = O3.AnaID And O3.AnaTypeID = ''O03'' and AT9000.DivisionID=O3.DivisionID
	LEFT JOIN AT1015 O4 on AT1202.O04ID = O4.AnaID And O4.AnaTypeID = ''O04'' and AT9000.DivisionID=O4.DivisionID
	LEFT JOIN AT1015 O5 on AT1202.O05ID = O5.AnaID And O5.AnaTypeID = ''O05'' and AT9000.DivisionID=O5.DivisionID
	LEFT JOIN AT1011 A1 on AT9000.Ana01ID = A1.AnaID and A1.AnaTypeID = ''A01'' and A1.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A2 on AT9000.Ana02ID = A2.AnaID and A2.AnaTypeID = ''A02'' and A2.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A3 on AT9000.Ana03ID = A3.AnaID and A3.AnaTypeID = ''A03'' and A3.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A4 on AT9000.Ana04ID = A4.AnaID and A4.AnaTypeID = ''A04'' and A4.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A5 on AT9000.Ana05ID = A5.AnaID and A5.AnaTypeID = ''A05'' and A5.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A6 on AT9000.Ana06ID = A6.AnaID and A6.AnaTypeID = ''A06'' and A6.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A7 on AT9000.Ana07ID = A7.AnaID and A7.AnaTypeID = ''A07'' and A7.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A8 on AT9000.Ana08ID = A8.AnaID and A8.AnaTypeID = ''A08'' and A8.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A9 on AT9000.Ana09ID = A9.AnaID and A9.AnaTypeID = ''A09'' and A9.DivisionID = AT9000.DivisionID
	LEFT JOIN AT1011 A10 on AT9000.Ana10ID = A10.AnaID and A10.AnaTypeID = ''A10'' and A10.DivisionID = AT9000.DivisionID
	LEFT JOIN AT2006 on (AT9000.VoucherID = AT2006.VoucherID Or AT9000.WOrderID = AT2006.VoucherID) And AT9000.DivisionID = AT2006.DivisionID
	LEFT JOIN AT1303 on AT2006.WareHouseID = AT1303.WareHouseID And AT2006.DivisionID = AT1303.DivisionID
	LEFT JOIN AT0295 AT95 ON AT95.VoucherID = AT9000.ETaxVoucherID AND AT95.ETaxID = AT1302.ETaxID
	LEFT JOIN AT0293 AT93 ON AT93.ETaxID = AT1302.ETaxID '

IF @CustomerName = 24 --- Long Trường Vũ
	set @sSQL3 = @sSQL3 + N'
	LEFT JOIN (Select VoucherID,Sum(ComAmount) as ComAmount From CMT0010 LEFT JOIN AT1202 T02 on CMT0010.DivisionID = T02.DivisionID And CMT0010.ObjectID = T02.ObjectID
				Where CMT0010.DivisionID = ''' + @DivisionID + ''' And Isnull(T02.ObjectTypeID,'''') <> ''NV'' Group by VoucherID) CMT1
	On AT9000.VoucherID = CMT1.VoucherID
	
	LEFT JOIN (Select VoucherID,Sum(ComAmount) as ComAmount From CMT0010 LEFT JOIN AT1202 T02 on CMT0010.DivisionID = T02.DivisionID And CMT0010.ObjectID = T02.ObjectID
				Where CMT0010.DivisionID = ''' + @DivisionID + ''' And Isnull(T02.ObjectTypeID,'''') = ''NV'' Group by VoucherID) CMT2
	On AT9000.VoucherID = CMT2.VoucherID
	
	LEFT JOIN (Select InventoryID, OT1302.ID, UnitPrice, FromDate, ToDate From OT1302 Inner join OT1301 On OT1302.DivisionID = OT1301.DivisionID And OT1302.ID = OT1301.ID
				Where OT1302.DivisionID = ''' + @DivisionID + ''') OT1302
	On AT9000.InventoryID = OT1302.InventoryID and AT9000.VoucherDate >= OT1302.FromDate and AT9000.VoucherDate <= Isnull(OT1302.ToDate,''01/01/9999'')
	 AND AT9000.PriceListID = OT1302.ID
	'
	
set @sSQL3 = @sSQL3 + @sSQL5 + N'
	/*Lay truc tiep thue thue row
	LEFT JOIN (	SELECT	DivisionID, VoucherID, BatchID, OriginalAmount AS VATOriginalAmount, ConvertedAmount AS VATConvertedAmount
				FROM	AT9000 A
	           	WHERE	A.DivisionID = '''+@DivisionID+'''
	           			AND A.TransactionTypeID = ''T14''
				) VAT
		ON		VAT.DivisionID = AT9000.DivisionID AND VAT.VoucherID = AT9000.VoucherID 
				AND VAT.BatchID = AT9000.BatchID
	*/	
	'+@sSQLPer+ '		
	WHERE	AT9000.DivisionID='''+@DivisionID+'''
			'+@sWHEREPer+'
			and AT9000.TransactionTypeID in (''T04'',''T40'')
			and '+@sSQLWhere+''

--PRINT(@sSQL1)
--PRINT(@sSQL2)
--PRINT(@sSQL3)
IF  EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV3025' AND XTYPE ='V')
	DROP VIEW AV3025
EXEC ('CREATE VIEW AV3025 --tao boi AP3022
			 as '+@sSQL1+@sSQL2+@sSQL3)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
