IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0021]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0021]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Loc ra cac don hang  mua cho man hinh truy van 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/08/2004 by Vo Thanh Huong
---- 
---- Last Edit Thuy Tuyen '' them truong  OT3101.ConTractNo, date 22/01/2008
---- Last edit Bao Anh, them cac truong tham so va thue nhap khau cho view master OV0013, OV0014	Date 25/03/2008
---- Last Edit Tuyen date: 25/01/2010
---- Modified on 28/12/2011 by Le Thi Thu Hien : Bo sung 1 so truong
---- Modified on 30/12/2011 by Le Thi Thu Hien : Bo sung tim kiem duoi server
---- Modified on 30/12/2011 by Le Thi Thu Hien : Bo sung tim kiem duoi server 1 so truong
---- Modified on 10/05/2012 by Thien Huynh : Bo sung 5 Khoan muc
---- Modified on 07/09/2012 by Le Thi Thu Hien : Bổ sung @POrderID
---- Modified on 18/04/2013 by Le Thi Thu Hien : Bổ sung @DivisionID
---- Modified on 11/06/2013 by Le Thi Thu Hien : Bổ sung 1 số trường
---- Modified on 02/10/2014 by Le Thi Thu Hien : Bổ sung KindVoucherID
---- Modified on 18/12/2015 by Tiểu Mai: Bổ sung 20 cột quy cách khi thiết lập quản lý mặt hàng theo quy cách
-- <Example>
---- 
CREATE PROCEDURE [dbo].[OP0021]
(	@IsServer AS INT = 0,	--0 : Tim kiem Master
							-- 1 : Tim kiem Detail
	@StrWhere AS NVARCHAR(4000) = '', --Dieu kien tim kiem tren luoi 
	@POrderID AS NVARCHAR(50) = '',
	@DivisionID AS NVARCHAR(50) = ''

)
 AS
DECLARE @sSQL1 AS nvarchar(MAX),
		@sSQL11 AS nvarchar(MAX),
		@sSQL2 AS nvarchar(MAX),
		@sSQL22 AS nvarchar(MAX),
		@sSQL3 AS NVARCHAR(MAX),
		@sSQL33 AS NVARCHAR(MAX),
		@sSQL4 AS NVARCHAR(MAX),
		@sWHERE AS NVARCHAR(MAX),
		@SWhereVoucherID AS NVARCHAR(50)
		
IF ISNULL(@StrWhere, '') <> ''
BEGIN
	SET @sWHERE = N' 
			AND 	'+@StrWhere
END

SET @SWhereVoucherID = ''

IF @POrderID <> '' AND @POrderID <> '%'
SET @SWhereVoucherID = N'
			AND		OT3001.POrderID = '''+@POrderID+'''	'
						
---- Buoc  2 : Tra ra thong tin Master View OV0013
IF @IsServer = 1
BEGIN
	SET @sSQL3 = N'
		,OT3002.ShipDate, OT3002.Notes, OT3002.Notes01, OT3002.Notes02 , AT1302.Barcode  '
	SET @sSQL33 = N'
		LEFT JOIN OT3002 ON OT3002.POrderID = OT3001.POrderID AND OT3002.DivisionID = OT3001.DivisionID
		LEFT JOIN AT1302 ON AT1302.InventoryID = OT3002.InventoryID AND AT1302.DivisionID = OT3002.DivisionID
		'
END
ELSE 
BEGIN
	SET @sSQL33 = N''
END	

SET @sSQL1 =N' 
SELECT	DISTINCT
		OT3001.DivisionID, OT3001.TranMonth, OT3001.TranYear,
		OT3001.POrderID, OT3001.VoucherTypeID, OT3001.VoucherNo, 
		OrderDate, OT3001.InventoryTypeID, InventoryTypeName, OT3001.CurrencyID, CurrencyName, 	
		OT3001.ExchangeRate,  OT3001.PaymentID, 
		OT3001.ObjectID, OT3001.PriceListID, ISNULL(OT3001.ObjectName, AT1202.ObjectName)  AS ObjectName, 
		ISNULL(OT3001.VatNo, AT1202.VatNo)  AS VatNo,  ISNULL( OT3001.Address, AT1202.Address)  AS Address,
		OT3001.ReceivedAddress, OT3001.ClassifyID, ClassifyName, OT3001.Transport,
		OT3001.EmployeeID,  AT1103.FullName,  IsSupplier, IsUpdateName, IsCustomer,
		ConvertedAmount = (	SELECT	SUM(ISNULL(ConvertedAmount,0)- ISNULL(DiscountConvertedAmount,0) + ISNULL(VATConvertedAmount, 0))  
							FROM	OT3002 
		                   	WHERE	OT3002.POrderID = OT3001.POrderID
							),
		OriginalAmount = (	SELECT	SUM(ISNULL(OriginalAmount,0)- ISNULL(DiscountOriginalAmount,0) + ISNULL(VATOriginalAmount, 0))  
		                  	FROM	OT3002 
		                  	WHERE	OT3002.POrderID = OT3001.POrderID
							),
		OT3001.Notes AS NotesMaster, OT3001.Disabled, OT3001.OrderStatus, OV1001.Description AS OrderStatusName, 
		OV1001.EDescription AS EOrderStatusName, 
		OT3001.OrderType,  OV1002.Description AS OrderTypeName, 
		OT3001.ContractNo, OT3001.ContractDate,
		OT3001.Ana01ID, OT3001.Ana02ID, OT3001.Ana03ID, OT3001.Ana04ID, OT3001.Ana05ID,
		OT1002_1.AnaName AS Ana01Name, OT1002_2.AnaName AS Ana02Name, 
		OT1002_3.AnaName AS Ana03Name, OT1002_4.AnaName AS Ana04Name, OT1002_5.AnaName AS Ana05Name, 
		OT3001.CreateUserID, OT3001.CreateDate,  
		OT3001.LastModifyUserID, OT3001.LastModifyDate, OT3001.ShipDate As ShipDateMaster, 
		OT3001.DueDate,OT3001.RequestID,
		OT3001.Varchar01, OT3001.Varchar02, OT3001.Varchar03, OT3001.Varchar04, OT3001.Varchar05,
		OT3001.Varchar06, OT3001.Varchar07, OT3001.Varchar08, OT3001.Varchar09, OT3001.Varchar10,
		OT3001.Varchar11, OT3001.Varchar12, OT3001.Varchar13, OT3001.Varchar14, OT3001.Varchar15,
		OT3001.Varchar16, OT3001.Varchar17, OT3001.Varchar18, OT3001.Varchar19, OT3001.Varchar20,
		OT3001.PaymentTermID,
		OT1102.Description AS  IsConfirm,
		OT1102.EDescription AS EIsConfirm,

		OT3001.DescriptionConfirm,
		OT3001.DeliveryDate,
		OT3001.SOrderID,
		OT3001.IsPrinted'
		
SET @sSQL11 =N' 
From OT3001 
LEFT JOIN AT1202 ON AT1202.ObjectID = OT3001.ObjectID AND AT1202.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_1 ON OT1002_1.AnaID = OT3001.Ana01ID AND OT1002_1.AnaTypeID = ''P01'' AND OT1002_1.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_2 ON OT1002_2.AnaID = OT3001.Ana02ID AND OT1002_2.AnaTypeID = ''P02'' AND OT1002_2.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_3 ON OT1002_3.AnaID = OT3001.Ana03ID AND OT1002_3.AnaTypeID = ''P03'' AND OT1002_3.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_4 ON OT1002_4.AnaID = OT3001.Ana04ID AND OT1002_4.AnaTypeID = ''P04'' AND OT1002_4.DivisionID = OT3001.DivisionID
LEFT JOIN OT1002 OT1002_5 ON OT1002_5.AnaID = OT3001.Ana05ID AND OT1002_5.AnaTypeID = ''P05'' AND OT1002_5.DivisionID = OT3001.DivisionID
LEFT JOIN AT1301 ON AT1301.InventoryTypeID = OT3001.InventoryTypeID  AND AT1301.DivisionID = OT3001.DivisionID
INNER JOIN AT1004 ON AT1004.CurrencyID = OT3001.CurrencyID AND AT1004.DivisionID = OT3001.DivisionID
LEFT JOIN AT1103 ON AT1103.EmployeeID = OT3001.EmployeeID AND AT1103.DivisionID = OT3001.DivisionID 
LEFT JOIN OT1001 ON OT1001.ClassifyID = OT3001.ClassifyID AND OT1001.TypeID = ''PO'' AND OT1001.DivisionID = OT3001.DivisionID
LEFT JOIN OV1001 ON OV1001.OrderStatus = OT3001.OrderStatus AND OV1001.TypeID= ''PO'' AND OV1001.DivisionID = OT3001.DivisionID
LEFT JOIN OV1002 ON OV1002.OrderType = OT3001.OrderType AND OV1002.TypeID =''PO'' AND OV1002.DivisionID = OT3001.DivisionID
LEFT JOIN OT1102 ON OT1102.Code = OT3001.IsConfirm  AND OT1102.DivisionID = OT3001.DivisionID AND OT1102.TypeID = ''SO'' 
WHERE OT3001.DivisionID = '''+@DivisionID+'''
AND ISNULL(OT3001.KindVoucherID,0) = 0

'



--PRINT (@sSQL1)
--PRINT (@sSQL3)
--PRINT(@sSQL11)
--PRINT(@sSQL33)
--PRINT(@sWHERE)

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE ='V' AND NAME = 'OV00133')
	EXEC('CREATE VIEW OV00133 ---tao boi OP0021
		 AS '+@sSQL1+@sSQL3 + @sSQL11+@sSQL33+@SWhereVoucherID)
ELSE
	EXEC('ALTER VIEW OV00133 ---tao boi OP0021
		 AS '+@sSQL1 +@sSQL3+ @sSQL11+@sSQL33 +@SWhereVoucherID)
		 
-------- Do nguon master
SET @sSQL4 = N'
	SELECT DISTINCT 
			POrderID, VoucherTypeID,VoucherNo, DivisionID, TranMonth, TranYear,
			OrderDate, InventoryTypeID, InventoryTypeName, CurrencyID, CurrencyName, 	
			ExchangeRate,  PaymentID, 
			ObjectID,  ObjectName, PriceListID,
			VatNo,  Address,
			ReceivedAddress, ClassifyID, ClassifyName, Transport,
			EmployeeID,  FullName,  IsSupplier, IsUpdateName, IsCustomer,
			ConvertedAmount ,
			OriginalAmount ,
			NotesMaster AS Notes, Disabled, OrderStatus, OrderStatusName, 
			EOrderStatusName, 
			OrderType,  OrderTypeName, 
			ContractNo, ContractDate,
			Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
			Ana01Name, Ana02Name, 
			Ana03Name, Ana04Name, Ana05Name, 
			CreateUserID, CreateDate,  
			LastModifyUserID,LastModifyDate, ShipDateMaster AS ShipDate, DueDate,RequestID,
			Varchar01, Varchar02, Varchar03, Varchar04, Varchar05,
			Varchar06, Varchar07, Varchar08, Varchar09, Varchar10,
			Varchar11, Varchar12, Varchar13, Varchar14, Varchar15,
			Varchar16, Varchar17, Varchar18, Varchar19, Varchar20,
			PaymentTermID,
			IsConfirm,
			EIsConfirm,
			DescriptionConfirm,
			DeliveryDate,
			SOrderID,
			IsPrinted 
	FROM	OV00133
	WHERE	OV00133.DivisionID = '''+@DivisionID+''' 
	'

--PRINT (@sSQL4)
--PRINT(@sWHERE)
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE ='V' AND NAME = 'OV0013')	
	EXEC('CREATE VIEW OV0013  --tao boi OP0021
		AS '+@sSQL4 +@sWHERE)

Else
	Exec('Alter View OV0013  --- tao boi OP0021
		AS '+@sSQL4 +@sWHERE)
---- Buoc  2 : Tra ra thong tin Detail View OV0014

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
		SET @sSQL2= N'
			SELECT	OT3002.DivisionID, OT3002.POrderID, OT3002.TransactionID, 
					OT3001.VoucherTypeID, OT3001.VoucherNo,OT3001.OrderDate, OT3001.InventoryTypeID, InventoryTypeName, IsStocked,
					AT1302.Barcode, 
					OT3002.InventoryID,  OT3002.UnitID, UnitName, 
					OT3002.MethodID, MethodName, OT3002.OrderQuantity, PurchasePrice, 
					ConvertedAmount, OriginalAmount, 
					VATConvertedAmount, VATOriginalAmount, OT3002.VATPercent, 
					DiscountConvertedAmount,  DiscountOriginalAmount,DiscountPercent, 
					OriginalAmount - DiscountOriginalAmount AS OriginalAmountBeforeVAT,
					OT3002.ImTaxPercent, OT3002.ImTaxOriginalAmount, OT3002.ImTaxConvertedAmount,
					OriginalAmount - DiscountOriginalAmount + OT3002.VATOriginalAmount +  OT3002.ImTaxOriginalAmount AS OriginalAmountAfterVAT,
					IsPicking, OT3002.WareHouseID, WareHouseName, 
					Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
					Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 
					Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
					Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
					Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
					Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30, OT3002.Orders, OT3002.Description, 
					OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID,
					OT3002.Ana06ID, OT3002.Ana07ID, OT3002.Ana08ID, OT3002.Ana09ID, OT3002.Ana10ID,
					AT1302.InventoryName AS AInventoryName, 
					CASE WHEN ISNULL(OT3002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT3002.InventoryCommonName end AS 
					InventoryName	, ActualQuantity, EndQuantity AS RemainQuantity,
					OT3002.Finish ,OT3002.Notes, OT3002.Notes01, OT3002.Notes02, 
					OT3002.Notes03,	OT3002.Notes04,	OT3002.Notes05,	OT3002.Notes06,
					OT3002.Notes07,	OT3002.Notes08,	OT3002.Notes09,		
					OT3002.RefTransactionID, OT3002.ROrderID, OT3101.ContractNo, 
					OT3002.ConvertedQuantity, OT3002.ConvertedSaleprice,
					OT3002.ShipDate, OT3002.ReceiveDate, 
					OT3002.Parameter01, OT3002.Parameter02, OT3002.Parameter03, OT3002.Parameter04, OT3002.Parameter05,
					OT3002.StrParameter01,	OT3002.StrParameter02,	OT3002.StrParameter03,	OT3002.StrParameter04,	OT3002.StrParameter05,
					OT3002.StrParameter06,	OT3002.StrParameter07,	OT3002.StrParameter08,	OT3002.StrParameter09,	OT3002.StrParameter10,
					OT3002.StrParameter11,	OT3002.StrParameter12,	OT3002.StrParameter13,	OT3002.StrParameter14,	OT3002.StrParameter15,
					OT3002.StrParameter16,	OT3002.StrParameter17,	OT3002.StrParameter18,	OT3002.StrParameter19,	OT3002.StrParameter20,
					O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
					O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
					'
		
		SET @sSQL22= N'
			FROM OT3002 
			LEFT JOIN AT1302 ON AT1302.InventoryID= OT3002.InventoryID AND AT1302.DivisionID = OT3002.DivisionID 
			LEFT JOIN OT1003 ON OT1003.MethodID = OT3002.MethodID  AND OT1003.DivisionID = OT3002.DivisionID 
			INNER JOIN OT3001 ON OT3001.POrderID = OT3002.POrderID AND OT3001.DivisionID = OT3002.DivisionID 
			LEFT JOIN AT1303 ON AT1303.WareHouseID = OT3002.WareHouseID AND AT1303.DivisionID = OT3002.DivisionID 
			LEFT JOIN AT1301 ON AT1301.InventoryTypeID = OT3001.InventoryTypeID 	 AND AT1301.DivisionID = OT3001.DivisionID 
			LEFT JOIN AT1304 ON AT1304.UnitID =OT3002.UnitID AND AT1304.DivisionID = OT3002.DivisionID 
			LEFT JOIN OT3003 ON OT3003.POrderID = OT3001.POrderID AND OT3003.DivisionID = OT3001.DivisionID 
			LEFT JOIN OV2902 ON OV2902.POrderID = OT3002.POrderID AND OV2902.TransactionID = OT3002.TransactionID
			LEFT JOIN OT3101 ON OT3101.RorderID = OT3002.RorderID   AND OT3101.DivisionID = OT3002.DivisionID
			LEFT JOIN OT8899 O99 ON O99.DivisionID = OT3002.DivisionID AND O99.VoucherID = OT3002.POrderID and O99.TransactionID = OT3002.TransactionID
			WHERE OT3002.DivisionID = '''+@DivisionID+'''
			AND ISNULL(OT3001.KindVoucherID,0) = 0
			'	
END
ELSE
	BEGIN
		SET @sSQL2= N'
			SELECT	OT3002.DivisionID, OT3002.POrderID, OT3002.TransactionID, 
					OT3001.VoucherTypeID, OT3001.VoucherNo,OT3001.OrderDate, OT3001.InventoryTypeID, InventoryTypeName, IsStocked,
					AT1302.Barcode, 
					OT3002.InventoryID,  OT3002.UnitID, UnitName, 
					OT3002.MethodID, MethodName, OT3002.OrderQuantity, PurchasePrice, 
					ConvertedAmount, OriginalAmount, 
					VATConvertedAmount, VATOriginalAmount, OT3002.VATPercent, 
					DiscountConvertedAmount,  DiscountOriginalAmount,DiscountPercent, 
					OriginalAmount - DiscountOriginalAmount AS OriginalAmountBeforeVAT,
					OT3002.ImTaxPercent, OT3002.ImTaxOriginalAmount, OT3002.ImTaxConvertedAmount,
					OriginalAmount - DiscountOriginalAmount + OT3002.VATOriginalAmount +  OT3002.ImTaxOriginalAmount AS OriginalAmountAfterVAT,
					IsPicking, OT3002.WareHouseID, WareHouseName, 
					Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, Quantity06, Quantity07, Quantity08, Quantity09, Quantity10,
					Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 
					Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
					Date01, Date02, Date03, Date04, Date05, Date06, Date07, Date08, Date09, Date10, 
					Date11, Date12, Date13, Date14, Date15, Date16, Date17, Date18, Date19, Date20, 
					Date21, Date22, Date23, Date24, Date25, Date26, Date27, Date28, Date29, Date30, OT3002.Orders, OT3002.Description, 
					OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID,
					OT3002.Ana06ID, OT3002.Ana07ID, OT3002.Ana08ID, OT3002.Ana09ID, OT3002.Ana10ID,
					AT1302.InventoryName AS AInventoryName, 
					CASE WHEN ISNULL(OT3002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT3002.InventoryCommonName end AS 
					InventoryName	, ActualQuantity, EndQuantity AS RemainQuantity,
					OT3002.Finish ,OT3002.Notes, OT3002.Notes01, OT3002.Notes02, 
					OT3002.Notes03,	OT3002.Notes04,	OT3002.Notes05,	OT3002.Notes06,
					OT3002.Notes07,	OT3002.Notes08,	OT3002.Notes09,		
					OT3002.RefTransactionID, OT3002.ROrderID, OT3101.ContractNo, 
					OT3002.ConvertedQuantity, OT3002.ConvertedSaleprice,
					OT3002.ShipDate, OT3002.ReceiveDate, 
					OT3002.Parameter01, OT3002.Parameter02, OT3002.Parameter03, OT3002.Parameter04, OT3002.Parameter05,
					OT3002.StrParameter01,	OT3002.StrParameter02,	OT3002.StrParameter03,	OT3002.StrParameter04,	OT3002.StrParameter05,
					OT3002.StrParameter06,	OT3002.StrParameter07,	OT3002.StrParameter08,	OT3002.StrParameter09,	OT3002.StrParameter10,
					OT3002.StrParameter11,	OT3002.StrParameter12,	OT3002.StrParameter13,	OT3002.StrParameter14,	OT3002.StrParameter15,
					OT3002.StrParameter16,	OT3002.StrParameter17,	OT3002.StrParameter18,	OT3002.StrParameter19,	OT3002.StrParameter20'
		
		SET @sSQL22= N'
			FROM OT3002 
			LEFT JOIN AT1302 ON AT1302.InventoryID= OT3002.InventoryID AND AT1302.DivisionID = OT3002.DivisionID 
			LEFT JOIN OT1003 ON OT1003.MethodID = OT3002.MethodID  AND OT1003.DivisionID = OT3002.DivisionID 
			INNER JOIN OT3001 ON OT3001.POrderID = OT3002.POrderID AND OT3001.DivisionID = OT3002.DivisionID 
			LEFT JOIN AT1303 ON AT1303.WareHouseID = OT3002.WareHouseID AND AT1303.DivisionID = OT3002.DivisionID 
			LEFT JOIN AT1301 ON AT1301.InventoryTypeID = OT3001.InventoryTypeID 	 AND AT1301.DivisionID = OT3001.DivisionID 
			LEFT JOIN AT1304 ON AT1304.UnitID =OT3002.UnitID AND AT1304.DivisionID = OT3002.DivisionID 
			LEFT JOIN OT3003 ON OT3003.POrderID = OT3001.POrderID AND OT3003.DivisionID = OT3001.DivisionID 
			LEFT JOIN OV2902 ON OV2902.POrderID = OT3002.POrderID AND OV2902.TransactionID = OT3002.TransactionID
			LEFT JOIN OT3101 ON OT3101.RorderID = OT3002.RorderID   AND OT3101.DivisionID = OT3002.DivisionID 
			WHERE OT3002.DivisionID = '''+@DivisionID+'''
			AND ISNULL(OT3001.KindVoucherID,0) = 0
			'
	END

		
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE ='V' AND NAME = 'OV0014')	
	EXEC('CREATE VIEW OV0014  --tao boi OP0021
		AS '+@sSQL2+@sSQL22 +@SWhereVoucherID)

Else
	Exec('Alter View OV0014  --- tao boi OP0021
		AS '+@sSQL2+@sSQL22 +@SWhereVoucherID)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

