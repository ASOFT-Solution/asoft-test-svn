IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP3021]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP3021]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by Hoang Thi Lan
--Date :17/10/2003
--Purpose: Dïng cho report Doanh sè hµng b¸n
--Last Update by Nguyen Van Nhan
--Last Update: Nguyen Thi Thuy Tuyen  tinh Thanh tien VAT 23/10/2007
--Edit By Nguyen Quoc Huy Date 01/12/2008
--Edit by: Dang Le Bao Quynh; Date:30/09/2009
--Purpose: Them 5 ma phan tich mat hang
--Edit by: Dang Le Bao Quynh; Date:19/10/2009
--Purpose: Them cac truong tien thue VAT
--- Edit by B.Anh, date 05/12/2009	Lay them cac truong Loai chung tu, chiet khau
/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
--- Edit by B.Anh, date 09/09/2012:	Lay them cac truong UParameter01 -> 05
---- Modified on 11/03/2013 by Le Thi Thu Hien : Bo sung truong AT1302.IsStocked
---- Modified on 21/11/2013 by Thanh Sơn: Bổ sung thêm 5 trường Mã phân tích đối tượng (Mã + Tên) 
---- Modified on 05/03/2014 by Le Thi Thu Hien : Bo sung phan quyen xem du lieu cua nguoi khac
---- Modified on 24/03/2014 by Mai Duyen: Bổ sung thêm truong AT1302.Notes01 va AT1202.Note
---- Modified on 26/03/2014 by Bảo Anh : Bổ sung InventoryTypeName, ComAmountOB, ComAmountEM (Long Trường Vũ)
---- Modified on 26/03/2014 by Mai Duyen : Bổ sung AT9000.VATNo  (KingCom)
---- Modified on 21/01/2015 by Mai Duyen : Bổ sung AT2007.SoureNo,AT2007.LimitDate   (Savi)
---- Modified on 20/03/2015 by Lê Thị Hạnh: Bổ sung lấy thông tin thuế BVMT: ETaxID, ETaxName, ETaxAmount, ETaxConvertedUnit, ETaxConvertedAmount
---- Modified on 10/09/2015 by Tiểu Mai: Bổ sung 10 MPT, 10 Tham số.
---- Modified on 08/01/2016 by Tiểu Mai: Bổ sung thông tin quy cách khi có thiết lập quản lý mặt hàng theo quy cách.
-- <Example>
----
---- EXEC AP3021 'CTY', '', 'ASOFTADMIN'
CREATE PROCEDURE [dbo].[AP3021] 
	(
		@DivisionID AS nvarchar(50) ,
		@sSQLWhere AS nvarchar(4000) ,
		@UserID AS VARCHAR(50) = '' 
	)
AS

DECLARE @sSQL1 AS varchar(max) ,
		@sSQL2 AS varchar(max) ,
		@sSQL3 AS NVARCHAR(MAX),
		@sSQL4 AS NVARCHAR(MAX),
		@sWhere AS NVARCHAR(max)
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS VARCHAR(MAX),
		@sWHEREPer AS VARCHAR(MAX)
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

SET @sWhere = N''
------ Thong tin quy cach------
SET @sSQL3 = ',
			O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
			O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
			'
SET @sSQL4 = '
			LEFT JOIN AT8899 O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND O99.TransactionID = AT9000.TransactionID'
	
set @sSQL1='
SELECT  AT9000.InventoryID,
		AT1302.InventoryName,
		CASE WHEN ISNULL(AT9000.InventoryName1,'''')= '''' then  isnull(AT1302.InventoryName,'''')  Else AT9000.InventoryName1 end AS InventoryName1,
		AT1302.UnitID,
		AT1302.S1,
		AT1302.S2,
		AT1302.S3,
		AT1304.UnitName,
	    AT9000.Serial,
		AT9000.ObjectID,
		AT1202.ObjectName,
		AT9000.VATObjectID,
		OB.ObjectName AS VATObjectName,
		AT1202.Address,
		AT9000.InvoiceNo,
		AT9000.VoucherDate,
		AT9000.VoucherNo,
		AT9000.DebitAccountID,
		AT9000.CreditAccountID,
		AT9000.InvoiceDate,
		AT9000.Quantity,
		AT9000.UnitPrice,
		AT9000.CurrencyID,
		AT9000.OriginalAmount,
		AT9000.ConvertedAmount , VATRate,
		AT9000.Ana01ID, AT9000.Ana02ID, AT9000.Ana03ID, AT9000.Ana04ID, AT9000.Ana05ID, 
		AT9000.Ana06ID, AT9000.Ana07ID, AT9000.Ana08ID, AT9000.Ana09ID, AT9000.Ana10ID, 
		A1.AnaName AS Ana01Name,A2.AnaName AS Ana02Name,A3.AnaName AS Ana03Name,A4.AnaName AS Ana04Name,A5.AnaName AS Ana05Name,
		A6.AnaName AS Ana06Name,A7.AnaName AS Ana07Name,A8.AnaName AS Ana08Name,A9.AnaName AS Ana09Name,A10.AnaName AS Ana10Name,
		AT9000.VDescription, AT9000.BDescription, AT9000.TDescription,
		(Isnull (AT9000.OriginalAmount,0) * Isnull (VATRate,0))/100  AS VATOriginalAmount,
		(Isnull (AT9000.ConvertedAmount,0) * Isnull (VATRate,0))/100  AS VATConvertedAmount,
		(Isnull (AT9000.UnitPrice,0) * Isnull (VATRate,0))/100  + Isnull(AT9000.UnitPrice,0) AS VATUnitPrice,
		(SELECT Sum(Isnull (T9.OriginalAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  AS VATOriginalAmountForInvoice,
		(SELECT Sum(Isnull (T9.ConvertedAmount,0)) From AT9000 T9 Where T9.VoucherID = AT9000.VoucherID And T9.TransactionTypeID = ''T14'')  AS VATConvertedAmountForInvoice,
		AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
		I1.AnaName AS I01Name, I2.AnaName AS I02Name, I3.AnaName AS I03Name, I4.AnaName AS I04Name, I5.AnaName AS I05Name,
		AT9000.VoucherTypeID, AT9000.DiscountRate, AT9000.DiscountAmount, AT9000.DivisionID,
		AT9000.UParameter01, AT9000.UParameter02, AT9000.UParameter03, AT9000.UParameter04, AT9000.UParameter05,
		AT1302.IsStocked, AT2006.VoucherNo As WVoucherNo,
		AT1202.[O01ID], AT1202.[O02ID], AT1202.[O03ID], AT1202.[O04ID], AT1202.[O05ID],
		O1.AnaName AS O01Name, O2.AnaName AS O02Name, O3.AnaName AS O03Name, O4.AnaName AS O04Name, O5.AnaName AS O05Name,
		AT1302.Notes01 as Notes01 , AT1202.Note as Notes02, AT1302.InventoryTypeID, AT1301.InventoryTypeName,
		AT9000.VATNo, AT2007.SourceNo, AT2007.LimitDate,
		AT1302.ETaxID, AT93.ETaxName, ISNULL(AT95.ETaxAmount,0) AS ETaxAmount, 
		ISNULL(AT9000.ETaxConvertedUnit,0) AS ETaxConvertedUnit, ISNULL(AT9000.ETaxConvertedAmount,0) AS ETaxConvertedAmount,
		AT9000.Parameter01, AT9000.Parameter02, AT9000.Parameter03, AT9000.Parameter04, AT9000.Parameter05, AT9000.Parameter06, AT9000.Parameter07,
		AT9000.Parameter08, AT9000.Parameter09, AT9000.Parameter10

		'
IF @CustomerName = 24 --- Long Trường Vũ		
	set @sSQL1 = @sSQL1 + ', CMT1.ComAmount as ComAmountOB, CMT2.ComAmount as ComAmountEM'
	
set @sSQL2='
FROM AT9000 

LEFT JOIN AT1302 on AT9000.InventoryID=AT1302.InventoryID and AT9000.DivisionID=AT1302.DivisionID
LEFT JOIN AT1301 on AT1302.DivisionID = AT1301.DivisionID and AT1302.InventoryTypeID = AT1301.InventoryTypeID
LEFT JOIN AT1015 I1 On AT1302.I01ID = I1.AnaID And I1.AnaTypeID = ''I01''  and AT9000.DivisionID=I1.DivisionID
LEFT JOIN AT1015 I2 On AT1302.I02ID = I2.AnaID And I2.AnaTypeID = ''I02''  and AT9000.DivisionID=I2.DivisionID
LEFT JOIN AT1015 I3 On AT1302.I03ID = I3.AnaID And I3.AnaTypeID = ''I03''  and AT9000.DivisionID=I3.DivisionID
LEFT JOIN AT1015 I4 On AT1302.I04ID = I4.AnaID And I4.AnaTypeID = ''I04''  and AT9000.DivisionID=I4.DivisionID
LEFT JOIN AT1015 I5 On AT1302.I05ID = I5.AnaID And I5.AnaTypeID = ''I05''  and AT9000.DivisionID=I5.DivisionID

LEFT JOIN AT1304 on AT1302.UnitID=AT1304.UnitID  and AT9000.DivisionID=AT1304.DivisionID
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID  and AT9000.DivisionID=AT1202.DivisionID

LEFT JOIN AT1015 O1 On AT1202.O01ID = O1.AnaID And O1.AnaTypeID = ''O01''  and AT9000.DivisionID=O1.DivisionID
LEFT JOIN AT1015 O2 On AT1202.O02ID = O2.AnaID And O2.AnaTypeID = ''O02''  and AT9000.DivisionID=O2.DivisionID
LEFT JOIN AT1015 O3 On AT1202.O03ID = O3.AnaID And O3.AnaTypeID = ''O03''  and AT9000.DivisionID=O3.DivisionID
LEFT JOIN AT1015 O4 On AT1202.O04ID = O4.AnaID And O4.AnaTypeID = ''O04''  and AT9000.DivisionID=O4.DivisionID
LEFT JOIN AT1015 O5 On AT1202.O05ID = O5.AnaID And O5.AnaTypeID = ''O05''  and AT9000.DivisionID=O5.DivisionID

LEFT JOIN AT1202 OB on OB.ObjectID = AT9000.VATObjectID  and AT9000.DivisionID=OB.DivisionID
LEFT JOIN AT1010 on AT1010.VATGroupID = AT9000.VATGroupID  and AT9000.DivisionID=AT1010.DivisionID
LEFT JOIN AT2006 on isnull(AT9000.WOrderID,0) = isnull(AT2006.VoucherID,0)  and AT9000.DivisionID=AT2006.DivisionID
LEFT JOIN AT2007 on AT2007.TransactionID =AT9000.TransactionID and
						AT2007.InventoryID = AT9000.InventoryID and AT9000.DivisionID=AT2007.DivisionID
LEFT JOIN AT1011 A1	 ON A1.DivisionID = AT9000.DivisionID  AND A1.AnaID = AT9000.Ana01ID  AND A1.AnaTypeID = ''A01''
LEFT JOIN AT1011 A2	 ON A2.DivisionID = AT9000.DivisionID  AND A2.AnaID = AT9000.Ana02ID  AND A2.AnaTypeID = ''A02''
LEFT JOIN AT1011 A3	 ON A3.DivisionID = AT9000.DivisionID  AND A3.AnaID = AT9000.Ana03ID  AND A3.AnaTypeID = ''A03''
LEFT JOIN AT1011 A4	 ON A4.DivisionID = AT9000.DivisionID  AND A4.AnaID = AT9000.Ana04ID  AND A4.AnaTypeID = ''A04''
LEFT JOIN AT1011 A5	 ON A5.DivisionID = AT9000.DivisionID  AND A5.AnaID = AT9000.Ana05ID  AND A5.AnaTypeID = ''A05''
LEFT JOIN AT1011 A6	 ON A6.DivisionID = AT9000.DivisionID  AND A6.AnaID = AT9000.Ana06ID  AND A6.AnaTypeID = ''A06''
LEFT JOIN AT1011 A7	 ON A7.DivisionID = AT9000.DivisionID  AND A7.AnaID = AT9000.Ana07ID  AND A7.AnaTypeID = ''A07''
LEFT JOIN AT1011 A8	 ON A8.DivisionID = AT9000.DivisionID  AND A8.AnaID = AT9000.Ana08ID  AND A8.AnaTypeID = ''A08''
LEFT JOIN AT1011 A9	 ON A9.DivisionID = AT9000.DivisionID  AND A9.AnaID = AT9000.Ana09ID  AND A9.AnaTypeID = ''A09''
LEFT JOIN AT1011 A10 ON A10.DivisionID = AT9000.DivisionID AND A10.AnaID = AT9000.Ana10ID AND A10.AnaTypeID = ''A10''
LEFT JOIN AT0295 AT95 ON AT95.VoucherID = AT9000.ETaxVoucherID AND AT95.ETaxID = AT1302.ETaxID
LEFT JOIN AT0293 AT93 ON AT93.ETaxID = AT1302.ETaxID
'

IF @CustomerName = 24 --- Long Trường Vũ		
	set @sSQL2 = @sSQL2 + '
	LEFT JOIN (Select VoucherID,Sum(ComAmount) as ComAmount From CMT0010 LEFT JOIN AT1202 T02 on CMT0010.DivisionID = T02.DivisionID And CMT0010.ObjectID = T02.ObjectID
				Where CMT0010.DivisionID = ''' + @DivisionID + ''' And Isnull(T02.ObjectTypeID,'''') <> ''NV'' Group by VoucherID) CMT1
	On AT9000.VoucherID = CMT1.VoucherID
	
	LEFT JOIN (Select VoucherID,Sum(ComAmount) as ComAmount From CMT0010 LEFT JOIN AT1202 T02 on CMT0010.DivisionID = T02.DivisionID And CMT0010.ObjectID = T02.ObjectID
				Where CMT0010.DivisionID = ''' + @DivisionID + ''' And Isnull(T02.ObjectTypeID,'''') = ''NV'' Group by VoucherID) CMT2
	On AT9000.VoucherID = CMT2.VoucherID
	'


IF ISNULL(@sSQLWhere,'') <> ''
SET @sWhere = N' 
		AND '+@sSQLWhere+''

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	SET @sSQL2 = @sSQL2 + @sSQL4 + @sSQLPer + '
WHERE	AT9000.DivisionID='''+@DivisionID+'''
		AND AT9000.TransactionTypeID in  (''T04'',''T40'')
'+@sWHEREPer
END	
ELSE	
	set @sSQL2 = @sSQL2 + @sSQLPer + '
	WHERE	AT9000.DivisionID='''+@DivisionID+'''
			AND AT9000.TransactionTypeID in  (''T04'',''T40'')
	'+@sWHEREPer 
		
--PRINT(@sSQL1)
--PRINT(@sSQL2)

IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE NAME = 'AV3021' AND XTYPE ='V')
	EXEC ('CREATE VIEW AV3021

 -- AP3021
	AS '+@sSQL1 + @sSQL3 + @sSQL2 +@sWhere)
ELSE
	EXEC ('ALTER VIEW AV3021 ---- AP3021
	AS '+@sSQL1 + @sSQL3 +@sSQL2 +@sWhere)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

