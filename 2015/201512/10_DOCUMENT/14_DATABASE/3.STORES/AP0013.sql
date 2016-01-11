IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0013]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0013]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Loc ra cac phieu Nhap, xuat, VCNB de len man hinh truy van
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 31/05/2003 by Nguyen Van Nhan.
----Edited by Nguyen Quoc Huy, Date: 18/11/2006
----Edit by: Dang Le Bao Quynh; Date: 17/04/2007
----Purpose: Them cot so luong ton cuoi
----Edit by: Dang Le Bao Quynh; Date: 21/05/2008
----Purpose: Them he so quy doi cho mat hang
----Edit by: Dang Le Bao Quynh; Date:07/11/2008 
----Purpose: Cai thien toc do
----Bo sung them truong ty le thue VAT, chi phi mua hang 
----Edit by: Dang Le Bao Quynh; Date: 05/01/2009
----Purpose: Bo sung them truong tien chiet khau 
----Edit by: Dang Le Bao Quynh; Date: 16/01/2009
----Purpose: Bo sung truong hop xuat hang mua tra lai
----Edit by B.Anh; Date: 14/05/2009; Lay them truong Barcode cho view AV0014
----Edit by: Dang Le Bao Quynh; Date: 13/10/2009
----Purpose: Xu ly ten doi tuong vang lai
----Edit by  Thuy Tuyen; date 22/03/2009
----Purpose: Them 5 cot tham so và convertedQuantity, ConvertedPrice cho view AV0014
--- Edit by B.Anh, date 01/04/2010	Lay truong InventoryTypeID tu AT2006
--- Edit Tuyen, date 16/04/2010  Lay ten kho,  ten doi tuong
---- Modified on 26/10/2011 by Nguyễn Bình Minh: Bổ sung phần xác định là phiếu nhận hàng trước
---- Modified on 11/05/2012 by Nguyễn Bình Minh: Bổ sung các trường vị trí PlaceID, Position01ID... Position)5ID
---- Modified on 14/05/2012 by Võ Việt Khánh: Sửa tên PlaceID, Position01ID... Position05ID thành LocationID, Location01ID... Location05ID
---- Modified on 29/05/2012 by Thien Huynh: Bo sung 5 Khoan muc: Ana06ID - Ana10ID
---- Modified on 03/08/2012 by Thien Huynh: Bổ sung AT2006.IsInheritWarranty
---- Modified on 15/08/2012 by Bao Anh: Bổ sung SL mark (2T)
---- Modified on 05/09/2012 by Le Thi Thu Hien : Bổ sung AT2006.IDescription
---- Modified on 05/09/2012 by Bao Anh: Bổ sung EVoucherID, các chi phí khác (2T)
---- Modified on 02/10/2012 by Tan Phu: Bổ sung InvoiceDate, ngay hoa don
---- Modified on 05/11/2012 by Bao Anh: Bổ sung WVoucherID (2T)
---- Modified on 25/01/2013 by Bao Anh: Bổ sung các trường tham số Notes01 -> Notes15 (2T)
---- Modified on 18/02/2013 by Lê Thị Thu Hiền : Bổ sung nhóm GroupID của tài khoản để kiểm tra
---- Modified on 23/06/2013 by Bảo Anh : Bổ sung trường IsVoucher (Thuận Lợi)
---- Modified in 09/06/2014 by Lê Thị Hạnh: Bổ sung lấy đơn giá và thành tiền nguyên tệ bảng AT9000 (TBIV)
---- Modified on 17/06/2014 by Thanh Sơn: Lấy thêm trường ReVoucherInfor (thông tin liên quan)
---- Modified on 30/06/2014 by Thanh Sơn: Rem customize cho TBIV
---- Modified on 20/04/2015 by Mai Duyen: Bo sung AT1302.Barcode

-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP0013] 
(
    @DivisionID   AS NVARCHAR(50),
    @TranMonth    AS INT,
    @TranYear     AS INT,
    @WareHouseID  AS NVARCHAR(50) = '',
    @ConnID       NVARCHAR(100) = ''
)
AS
	DECLARE @sSQL   AS NVARCHAR(4000),
			@sSQL0  AS NVARCHAR(4000),
	        @sSQL1  AS NVARCHAR(4000),
	        @sSQL2  AS NVARCHAR(4000),
	        @sSQL3 AS NVARCHAR(4000) ='',
	        @sFROM  AS NVARCHAR(4000) = '',
	        @CustomerName INT

--- Lấy ra Customer TBIV
--	CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
--INSERT #CustomerName EXEC AP4444
--SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

--IF @CustomerName = 29 --- Customer TBIV
--BEGIN
--	SET @sSQL3 =', ISNULL(AT9000.UnitPrice,0) as TUnitPrice, ISNULL(AT9000.OriginalAmount,0) AS TOriginalAmount'
--	SET @sFROM ='LEFT JOIN AT9000 ON AT9000.DivisionID = AT2007.DivisionID AND AT9000. VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID'
--END

IF (ISNULL(@WareHouseID, '') = '') SET @WareHouseID = '%'
	
	----- Buoc  1 : Tra ra thong tin Master View AV0013
	
	SET @sSQL = 
	    '
Select 	AT2006.ReDeTypeID,	
	AT2006.VoucherTypeID,
	VoucherNo,
	VoucherDate,
	AT2006.RefNo01,
	AT2006.RefNo02,
	ConvertedAmount = (Select Sum(AT2007.ConvertedAmount) from At2007 Where voucherID = AT2006.VoucherID AND DivisionID = AT2006.DivisionID),
	AT2006.ObjectID+'' - '' + case when isnull(AT2006.VATObjectName,'''')='''' then ObjectName  else VATObjectName end as ObjectID,  
	AT2006.ObjectID As ObjectIDPermission,
	case when isnull(AT2006.VATObjectName,'''')='''' then AT1202.ObjectName  else VATObjectName end As ObjectName,
	AT1202.Address,
  
	At2006.ContactPerson,
	AT2006.RDAddress   as DEAddress,

	AT2006.EmployeeID, AT1103.FullName,
	(Case when KindVoucherID in (1,3,5,7,9) then AT2006.WareHouseID Else '''' End) as ImWareHouseID,
	(Case when KindVoucherID in (2,4,6,8,10)  then AT2006.WareHouseID Else 
		Case When KindVoucherID =3 then AT2006.WareHouseID2 else '''' End End) as ExWareHouseID,
	AT2006.Description,	AT2006.VoucherID,		AT2006.OrderID,		AT2006.ProjectID,		AT2006.Status,		AT2006.DivisionID,	AT2006.TranMonth,
	AT2006.TranYear,	AT2006.CreateDate,             	AT2006.CreateUserID,            	AT2006.LastModifyUserID,            AT2006.LastModifyDate ,            
	AT2006.KindVoucherID,	AT2004.OrderNo as OrderNo,	AT1303.WareHouseName as WareHouseName,
	WE.WareHouseName as ExWareHouseName,
	(
	Select Top 1 isnull(VATRate,0) 
	From AT9000 
	LEFT JOIN AT1010 On AT9000.DivisionID = AT1010.DivisionID AND AT9000.VATGroupID = AT1010.VATGroupID 
	Where AT9000.VoucherID = AT2006.VoucherID 
	AND AT9000.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(''' + @DivisionID
	    + 
	    '''))
	AND TransactionTypeID in (''T13'',''T14'',''T34'',''T35'')
	) As VATRate,
	AT2006.EVoucherID, (CASE WHEN AT2006.KindVoucherID IN (1,3,5,7,9) THEN A.VoucherID ELSE AT2006.ImVoucherID END) ReVoucherInfor

From AT2006
	LEFT JOIN (SELECT DivisionID, ImVoucherID, VoucherID FROM AT2006)A ON ISNULL(A.ImVoucherID,'''') = ISNULL(AT2006.VoucherID,'''')		
    LEFT JOIN AT1202 on    AT1202.DivisionID = AT2006.DivisionID AND AT1202.ObjectID =AT2006.ObjectID
	LEFT JOIN AT2004 on    AT2004.DivisionID = AT2006.DivisionID AND AT2004.OrderID =AT2006.OrderID
	LEFT JOIN AT1303 on    AT1303.DivisionID = AT2006.DivisionID AND AT2006.WareHouseID = AT1303.WarehouseID 
	LEFT JOIN AT1303 WE on WE.DivisionID     = AT2006.DivisionID AND AT2006.WareHouseID2 = WE.WarehouseID
	LEFT JOIN AT1103 on    AT1103.DivisionID = AT2006.DivisionID AND AT1103.EmployeeID =AT2006.EmployeeID

Where AT2006.DivisionID =''' + @DivisionID + ''' and
	AT2006.TranMonth =' + STR(@TranMonth) + ' and
	AT2006.TranYear =' + STR(@TranYear) + ' '
	
	/*
	IF EXISTS (
	       SELECT id
	       FROM   SysObjects
	       WHERE  id = OBJECT_ID('AT0013_Tmp' + @ConnID)
	              AND xType = 'U'
	   )
	    EXEC ('Drop Table AT0013_Tmp' + @ConnID)
	
	EXEC (
	         'Select * Into AT0013_Tmp' + @ConnID + ' From (' + @sSQL + ') A'
	     )
	--print @ssql
	SET @sSQL = 'Select * From AT0013_Tmp' + @ConnID + 
	    ' Where DivisionID in (Select DivisionID From GetDivisionID(''' + @DivisionID 
	    + '''))'
	*/
	
	IF NOT EXISTS (
	       SELECT 1
	       FROM   SysObjects
	       WHERE  Xtype = 'V'
	              AND NAME = 'AV0013' + @ConnID
	   )
	    EXEC ('Create View  AV0013' + @ConnID + ' as ' + @ssql)
	ELSE
	    EXEC ('Alter View AV0013' + @ConnID + ' as ' + @ssql)
	
	
	
	----- Buoc  2 : Tra ra thong tin Detail View AV0014
	
	SET @ssQL = 
	    '
Select 		AT2006.ReDeTypeID,		AT2006.VoucherTypeID,		AT2006.VoucherNo,	AT2006.IsGoodsFirstVoucher, AT2006.IsGoodsRecycled,
	AT2006.VoucherDate,		
	AT2006.RefNo01,
	AT2006.RefNo02,	
	AT2006.KindVoucherID,
	AT2006.RDAddress,
	AT2006.ContactPerson,
	AT2006.InventoryTypeID,
	AT2006.ObjectID,	
	AT1202.ObjectName,
	AT2006.VATObjectName,	
	(Case when AT2006.KindVoucherID in (1,3,5,7,9) then AT2006.WareHouseID Else '''' End) as ImWareHouseID,
	(Case when AT2006.KindVoucherID in (1,3,5,7,9) then AT1303.WareHouseName Else '''' End) as ImWareHouseName,
	(Case when AT2006.KindVoucherID in (2,4,6,8,10)  then AT2006.WareHouseID Else 
		Case When AT2006.KindVoucherID =3 then AT2006.WareHouseID2 else '''' End End) as ExWareHouseID,

	(Case when AT2006.KindVoucherID in (2,4,6,8,10)  then AT1303.WareHouseName  Else 
		Case When AT2006.KindVoucherID =3 then AT03.WareHouseName else '''' End End) as ExWareHouseName,
	AT2006.EmployeeID,	AT2007.TransactionID,   AT2006.VoucherID,		AT2007.InventoryID,				AT1302.InventoryName,       AT2007.UnitID,		AT1304.UnitName,
    AT2007.ActualQuantity,     AT2007.UnitPrice,       		AT2007.OriginalAmount,      	AT2007.ConvertedAmount,     	AT2006.Description,			AT2006.TranMonth,	AT2006.TranYear,	AT2006.DivisionID,
    AT2007.SaleUnitPrice,      AT2007.SaleAmount,       		AT2007.DiscountAmount,       	AT2007.SourceNo,	
    AT2007.DebitAccountID, 	AT2007.CreditAccountID,		DA.GroupID AS DebitGroupID	,	CA.GroupID AS CreditGroupID,			
    AT2007.LocationID,
	AT2007.ImLocationID, 
	
	AT2007.Ana01ID,    AT1011_01.AnaName as Ana01Name,
	AT2007.Ana02ID,    AT1011_02.AnaName as Ana02Name,
	AT2007.Ana03ID,	AT1011_03.AnaName as Ana03Name,
	AT2007.Ana04ID, 	AT1011_04.AnaName as Ana04Name,
	AT2007.Ana05ID,	AT1011_05.AnaName as Ana05Name,
	AT2007.Ana06ID,    AT1011_06.AnaName as Ana06Name,
	AT2007.Ana07ID,    AT1011_07.AnaName as Ana07Name,
	AT2007.Ana08ID,	AT1011_08.AnaName as Ana08Name,
	AT2007.Ana09ID, 	AT1011_09.AnaName as Ana09Name,
	AT2007.Ana10ID,	AT1011_10.AnaName as Ana10Name,
	AT2006.IsInheritWarranty, AT2006.EVoucherID, AT2007.WVoucherID, AT2006.IsVoucher,
'
SET @sSQL0 = 
'
	AT2007.Orders,        	LimitDate,	AT2007.Notes as Notes,
	AT2007.ConversionFactor,	AT2007.ReVoucherID,	AT2007.ReTransactionID ,	AT2004.OrderNo as OrderNo,
	AT2007.OrderID, AT2007.OTRansactionID, AT2007.MOrderID, AT2007.SOrderID, AT2007.MTransactionID, AT2007.STransactionID,
	AT1302.IsSource,	AT1302.IsLimitDate,	AT1302.IsLocation,
	AT1302.MethodID,
	V06.VoucherNo as ReVoucherNo,
	AT1302.AccountID,
	AT1302.Specification,
	AT1302.S1, AT1302.S2, AT1302.S3,
	
	AT1302.Notes01, AT1302.Notes02, AT1302.Notes03, AT1302.Barcode,
	
	-- Phuc vu bao cao  DVT qui doi  cho cac khach hang dung version cu truoc 7.1
	AT2007.PeriodID,
	AT1309.UnitID As ConversionUnitID,
	AT1309.ConversionFactor As ConversionFactor2,
	AT1309.Operator, 
	---------------------------------------

	M01.Description as PeriodName,
    AT2007.ProductID,	AT02.InventoryName as ProductName,
	(Select Top 1 isnull(ExpenseConvertedAmount,0) From AT9000 Where AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID AND TableID = ''AT9000'' AND TransactionTypeID in (''T03'',''T04'',''T24'',''T25'')) As ExpenseConvertedAmount,
	(Select Top 1 isnull(DiscountAmount,0) From AT9000 Where AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID AND TableID = ''AT9000'' AND TransactionTypeID in (''T03'',''T04'',''T24'',''T25'')) As DiscountAmount2,
	(Select Top 1 InvoiceDate From AT9000 Where AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID AND TableID = ''AT9000'' AND TransactionTypeID in (''T03'',''T04'',''T24'',''T25'')) As InvoiceDate,
	ActEndQty =
	(
	--Ton dau
	Isnull((Select Sum(Isnull(T17.ActualQuantity,0)) From At2016 T16, At2017 T17
	Where T16.DivisionID = T17.DivisionID
	AND T16.VoucherID = T17.VoucherID
	AND T16.DivisionID = ''' + @DivisionID + ''' 
	AND T16.WareHouseID LIKE ''' + @WareHouseID + 
	    ''' 
	AND T17.InventoryID = AT2007.InventoryID),0) 
	+
	--Nhap trong ky
	Isnull((Select Sum(Isnull(T07.ActualQuantity,0)) From At2006 T06, At2007 T07
	Where T06.DivisionID = T07.DivisionID
	AND T06.VoucherID = T07.VoucherID
	AND T06.KindVoucherID In (1,3,5,7,9)
	AND T06.DivisionID = ''' + @DivisionID + ''' 
	AND T06.WareHouseID LIKE ''' + @WareHouseID + 
	    ''' 
	AND T06.TranYear*12 + T06.TranMonth <= ' + LTRIM(@TranYear * 12 + @TranMonth) 
	    + 
	    ' 
	AND T06.VoucherDate <= AT2006.VoucherDate 
	AND T06.VoucherID Not In (Select sT06.VoucherID From AT2006 sT06 Where VoucherDate = AT2006.VoucherDate AND sT06.CreateDate>=At2006.CreateDate) 
	AND T07.InventoryID = AT2007.InventoryID),0) 
	-
	('
	
	SET @sSQL1 = 
	    '--Xuat thuong trong ky
	Isnull((Select Sum(Isnull(T07.ActualQuantity,0)) From At2006 T06, At2007 T07
	Where T06.DivisionID = T07.DivisionID
	AND T06.VoucherID = T07.VoucherID
	AND T06.KindVoucherID In (2,4,6,8,10)
	AND T06.DivisionID = ''' + @DivisionID + ''' 
	AND T06.WareHouseID LIKE ''' + @WareHouseID + 
	    ''' 
	AND T06.TranYear*12 + T06.TranMonth <= ' + LTRIM(@TranYear * 12 + @TranMonth) 
	    + 
	    ' 
	AND T06.VoucherDate <= AT2006.VoucherDate 
	AND T06.VoucherID Not In (Select sT06.VoucherID From AT2006 sT06 Where VoucherDate = AT2006.VoucherDate AND sT06.CreateDate>=AT2006.CreateDate) 
	AND T07.InventoryID = AT2007.InventoryID),0)
	+
	--Xuat VCNB trong ky
	Isnull((SELECT SUM(ISNULL(T07.ActualQuantity,0)) FROM At2006 T06, AT2007 T07
	WHERE T06.DivisionID = T07.DivisionID
	AND T06.VoucherID = T07.VoucherID
	AND T06.KindVoucherID In (3)
	AND T06.DivisionID = ''' + @DivisionID + ''' 
	AND T06.WareHouseID2 LIKE ''' + @WareHouseID + 
	    ''' 
	AND T06.TranYear*12 + T06.TranMonth <= ' + LTRIM(@TranYear * 12 + @TranMonth) 
	    + 
	    ' 
	AND T06.VoucherDate <= AT2006.VoucherDate 
	AND T06.VoucherID Not In (Select sT06.VoucherID From AT2006 sT06 Where VoucherDate = AT2006.VoucherDate AND sT06.CreateDate>=At2006.CreateDate) 
	AND T07.InventoryID = AT2007.InventoryID),0)
	)
	)
	,AT2007.ETransactionID, OT2203.EstimateID,
--- Cac thong tin lien quan den DVT qui doi  cho 
	AT2007.Parameter01,AT2007.Parameter02, AT2007.Parameter03,AT2007.Parameter04, AT2007.Parameter05,
	AT2007.ConvertedQuantity, AT2007.ConvertedPrice, isnull(AT2007.ConvertedUnitID,AT1302.UnitID) as ConvertedUnitID ,  isnull(T04.UnitName,AT1304.UnitName) as ConvertedUnitName,
	Isnull(T09.Operator,0) as T09Operator, isnull(T09.ConversionFactor,1) as  T09ConversionFactor ,
	isnull(T09.DataType,0) as DataType  , T09.FormulaID, AT1319.FormulaDes,
	AT2007.LocationCode, AT2007.Location01ID, AT2007.Location02ID, AT2007.Location03ID, AT2007.Location04ID, AT2007.Location05ID,
--- SL mark (yeu cau cua 2T)
	AT2007.MarkQuantity,
	AT2007.Notes AS TDescription,
--- CP khac	(yeu cau cua 2T)
	AT2007.OExpenseConvertedAmount,
	AT2007.Notes01 as WNotes01, AT2007.Notes02 as WNotes02, AT2007.Notes03 as WNotes03, AT2007.Notes04 as WNotes04, AT2007.Notes05 as WNotes05,
	AT2007.Notes06 as WNotes06, AT2007.Notes07 as WNotes07, AT2007.Notes08 as WNotes08,	AT2007.Notes09 as WNotes09, AT2007.Notes10 as WNotes10,
	AT2007.Notes11 as WNotes11, AT2007.Notes12 as WNotes12, AT2007.Notes13 as WNotes13, AT2007.Notes14 as WNotes14, AT2007.Notes15 as WNotes15, AT2006.CreateUserID, AT2007.RefInfor,
--- Lấy đơn giá và thành tiền nguyên tệ (TBIV)
	(SELECT ISNULL(AT9000.UnitPrice,0) FROM AT9000 WHERE AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID) AS TUnitPrice,
	(SELECT ISNULL(AT9000.OriginalAmount,0) FROM AT9000 WHERE AT9000.DivisionID = AT2007.DivisionID AND AT9000.VoucherID = AT2007.VoucherID AND AT9000.TransactionID = AT2007.TransactionID) AS TOriginalAmount ,
	AT1302.Barcode
		'
	
	SET @sSQL2 = 
	    '
FROM AT2007
INNER JOIN AT1302			on AT1302.DivisionID    = AT2007.DivisionID AND AT1302.InventoryID =AT2007.InventoryID
LEFT JOIN AT1304			on AT1304.DivisionID    = AT2007.DivisionID AND AT1304.UnitID = AT2007.UnitID
INNER JOIN AT2006			on AT2006.DivisionID    = AT2007.DivisionID AND AT2006.VoucherID =AT2007.VoucherID
LEFT JOIN AT2004			on AT2004.DivisionID    = AT2006.DivisionID AND AT2004.OrderID =AT2006.OrderID
LEFT JOIN AV2006 V06		on V06.DivisionID       = AT2007.DivisionID AND V06.VoucherID = AT2007.ReVoucherID AND V06.TransactionID =AT2007.ReTransactionID --AND V06.VoucherNo = AT2006.VoucherNo
LEFT JOIN MT1601 M01		on M01.DivisionID       = AT2007.DivisionID AND M01.PeriodID =AT2007.PeriodID
LEFT JOIN AT1302 AT02		on AT02.DivisionID      = AT2007.DivisionID AND AT02.InventoryID =AT2007.ProductID
LEFT JOIN (Select InventoryID,Min(UnitID) As UnitID, Min(ConversionFactor) As ConversionFactor, Min(Operator) As Operator, DivisionID From AT1309 Group By InventoryID, DivisionID) AT1309 
on AT1309.DivisionID = AT2007.DivisionID AND AT2007.InventoryID = AT1309.InventoryID --- Phuc vu bao cao nen chua bo oin nay duoc
LEFT JOIN AT1011 AT1011_01	on AT1011_01.DivisionID = AT2007.DivisionID AND AT1011_01.AnaID = AT2007.Ana01ID AND AT1011_01.AnaTypeID = ''A01''
LEFT JOIN AT1011 AT1011_02	on AT1011_02.DivisionID = AT2007.DivisionID AND AT1011_02.AnaID = AT2007.Ana02ID AND AT1011_02.AnaTypeID = ''A02''
LEFT JOIN AT1011 AT1011_03	on AT1011_03.DivisionID = AT2007.DivisionID AND AT1011_03.AnaID = AT2007.Ana03ID AND AT1011_03.AnaTypeID = ''A03''
LEFT JOIN AT1011 AT1011_04	on AT1011_04.DivisionID = AT2007.DivisionID AND AT1011_04.AnaID = AT2007.Ana04ID AND AT1011_04.AnaTypeID = ''A04''
LEFT JOIN AT1011 AT1011_05	on AT1011_05.DivisionID = AT2007.DivisionID AND AT1011_05.AnaID = AT2007.Ana05ID AND AT1011_05.AnaTypeID = ''A05''
Left join AT1011 AT1011_06 on AT1011_06.DivisionID = AT2007.DivisionID and AT1011_06.AnaID = AT2007.Ana06ID and AT1011_06.AnaTypeID = ''A06''
Left join AT1011 AT1011_07 on AT1011_07.DivisionID = AT2007.DivisionID and AT1011_07.AnaID = AT2007.Ana07ID and AT1011_07.AnaTypeID = ''A07''
Left join AT1011 AT1011_08 on AT1011_08.DivisionID = AT2007.DivisionID and AT1011_08.AnaID = AT2007.Ana08ID and AT1011_08.AnaTypeID = ''A08''
Left join AT1011 AT1011_09 on AT1011_09.DivisionID = AT2007.DivisionID and AT1011_09.AnaID = AT2007.Ana09ID and AT1011_09.AnaTypeID = ''A09''
Left join AT1011 AT1011_10 on AT1011_10.DivisionID = AT2007.DivisionID and AT1011_10.AnaID = AT2007.Ana10ID and AT1011_10.AnaTypeID = ''A10''
LEFT JOIN OT2203			on OT2203.DivisionID    = AT2007.DivisionID AND OT2203.TransactionID = AT2007.ETransactionID
LEFT JOIN AT1309 T09		on T09.DivisionID       = AT2007.DivisionID AND T09.InventoryID = AT2007.InventoryID AND  AT2007.ConvertedUnitID = T09.UnitID
LEFT JOIN AT1304 T04		on T04.DivisionID       = AT2007.DivisionID AND T04.UnitID =  isnull(AT2007.ConvertedUnitID,'''')
LEFT JOIN AT1319			on AT1319.DivisionID    = T09.DivisionID AND isnull(T09.FormulaID,'''')  = AT1319.FormulaID 
LEFT JOIN AT1303			on AT1303.DivisionID    = AT2006.DivisionID AND AT1303.WareHouseID = AT2006.WareHouseID
LEFT JOIN AT1303 AT03		on AT03.DivisionID      = AT2006.DivisionID AND AT03.WareHouseID = AT2006.WareHouseID
LEFT JOIN AT1202			on AT1202.DivisionID    = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID
LEFT JOIN AT1005 DA	ON DA.DivisionID = AT2007.DivisionID AND DA.AccountID = AT2007.DebitAccountID
LEFT JOIN AT1005 CA	ON CA.DivisionID = AT2007.DivisionID AND CA.AccountID = AT2007.CreditAccountID
'+@sFROM+'
WHERE  	AT2007.DivisionID =''' + @DivisionID + ''' and
		AT2007.TranMonth =' + STR(@TranMonth) + ' and
		AT2007.TranYear =' + STR(@TranYear) + ' '
	
--Print @sSQL + @sSQL1 + @sSQL2

	IF NOT EXISTS (
	       SELECT 1
	       FROM   SysObjects
	       WHERE  Xtype = 'V'
	              AND NAME = 'AV0014'
	   )
	    EXEC ('Create View  AV0014 as ' + @sSQL + @sSQL0 + @sSQL1 + @sSQL2)
	ELSE
	    EXEC ('Alter View AV0014 as ' + @sSQL + @sSQL0 + @sSQL1 + @sSQL2)
	
	IF NOT EXISTS (
	       SELECT 1
	       FROM   SysObjects
	       WHERE  Xtype = 'V'
	              AND NAME = 'AV0014' + @ConnID
	   )
	    EXEC (
	             'Create View AV0014' + @ConnID + ' as ' + @sSQL + @sSQL0 + @sSQL1 + @sSQL2
	         )
	ELSE
	    EXEC (
	             'Alter View AV0014' + @ConnID + ' as ' + @sSQL + @sSQL0 + @sSQL1 + @sSQL2
	         )


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
