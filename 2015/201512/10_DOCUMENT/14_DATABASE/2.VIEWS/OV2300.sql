IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV2300]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV2300]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- (view chet) Loc ra cac don hang phuc vu cho cong tac bao cao	
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 05/07/2005 by Vo Thanh Huong
---- 
---- Modified on 12/11/2009 by Thuy Tuyen : Lay ten ma phan tich cua don hang ban, lay cac truong theo don vi tinh qui doi, so luong, don gia qui doi
---- Modified on 11/02/2010 by Thuy Tuyen : Them truong FOrderQuantity
---- Modified on 10/05/2010 by Thuy Tuyen : Them cac truong m aphan tich nghiep vu
---- Modified on 23/09/2011 by Le Thi Thu Hien : Bo sung SalesMan2
---- Modified on 03/10/2011 by Le Thi Thu Hien : Bo sung check FirstOrder de biet don hang la don hang dau tien cua khach hang do
---- Modified on 07/11/2011 by Thien Huynh: Bo sung PeriodID, PeriodName
---- Modified on 11/11/2011 by Le Thi Thu Hien : Bo sung ActualQuantity( So luong xuat kho theo bo Khach hang EUROVIE)
---- Modified on 06/09/2012 by Bao Anh : Bo sung tham so Parameter01 -> 05
---- Modified on 30/01/2013 by Le Thi Thu Hien : Bo sung tham so Nvarchar01->nvarchar10
---- Modified on 17/04/2013 by Le Thi Thu Hien : Bo sung Ana06 -->Ana10
---- Modified on 02/03/2014 by Le Thi Thu Hien : Bo sung CreateUserID
---- Modified on 02/10/2014 by Thanh Sơn: Bổ sung thêm 5 mã phân tích nghiệp vụ (Name)
---- Modified on 02/10/2014 by Thanh Sơn: Lấy thêm trường tên kho cho APSG
---- Modified on 25/05/2015 by Lê Thị Hạnh: Bổ sung AT1302.ETaxConvertedUnit (Customize Index: 36 - SGPT)
---- Modified on 09/09/2015 by Tiểu Mai: Bổ sung mã, tên MPT Ana06-->Ana10
---- Modified on 10/12/2015 by Kim Vu: Bổ sung Varchar01 - Varchar10 as nvarchar10 -> nvarchar20 ( ABA)
-- <Example>
----
 
CREATE VIEW [dbo].[OV2300] AS 
SELECT	OT2001.DivisionID,
		OT2001.TranMonth,
		OT2001.TranYear,	
		OT2001.TranYear AS Year,	  
		OV9999.MonthYear,
		OV9999.Quarter,
		OT2001.SOrderID AS OrderID, 	
		OT2001.VoucherTypeID, 
		OT2001.VoucherNo, 
		OT2001.OrderDate AS VoucherDate, 
		OT2001.ContractNo, 
		OT2001.ContractDate, 
		OT2001.ClassifyID, 
		OT2001.OrderType, 
		OT2001.ObjectID, 
		case when ISNULL(OT2001.ObjectName, '') = '' then  AT1202.ObjectName else OT2001.ObjectName end AS ObjectName,
		OT2001.DeliveryAddress, 
		OT2001.Notes AS VDescription, 
		OT2001.OrderStatus, 	
		OT2001.CurrencyID, 
		AT1004.CurrencyName,
		OT2001.ExchangeRate, 
		OT2001.EmployeeID, 
		OT2001.SalesManID, 
		AT1103.FullName AS SalesManName,
		OT2001.SalesMan2ID, 
		AT1103_S2.FullName AS SalesMan2Name,
		OT2001.Transport, 
		OT2001.PaymentID, 
		OT2001.VatNo, 
		OT2001.Address, 
		OT2001.ShipDate, 
		OT2001.Notes AS Description,
		OT2001.PaymentTermID,
		OT2001.Disabled, 
		ISNULL(OT2001.Ana01ID, '') AS VAna01ID, 		ISNULL(OT2001.Ana02ID, '') AS VAna02ID,
		ISNULL(OT2001.Ana03ID, '') AS VAna03ID, 		ISNULL(OT2001.Ana04ID, '') AS VAna04ID,
		ISNULL(OT2001.Ana05ID, '') AS VAna05ID,			ISNULL(OT2001.Ana06ID, '') AS VAna06ID,
		ISNULL(OT2001.Ana07ID, '') AS VAna07ID,			ISNULL(OT2001.Ana08ID, '') AS VAna08ID,
		ISNULL(OT2001.Ana09ID, '') AS VAna09ID,			ISNULL(OT2001.Ana10ID, '') AS VAna10ID,
		ISNULL(T01.AnaName, '') AS VAna01Name, 			ISNULL(T02.AnaName, '') AS VAna02Name, 		
		ISNULL(T03.AnaName, '') AS VAna03name, 	
		ISNULL(T03.AnaName, '') AS VAna04Name, 			ISNULL(T05.AnaName, '') AS VAna05Name,
		OT2002.TransactionID, 
		OT2002.InventoryID,	AT1302.InventoryName,
		OT2002.Parameter01, OT2002.Parameter02, OT2002.Parameter03, OT2002.Parameter04, OT2002.Parameter05,
		AT1310_S1.SName AS SName1, 
		AT1310_S2.SName AS SName2,
		AT1302.Notes01 AS InNotes01,
		AT1302.Notes02 AS InNotes02,
		AT1302.InventoryTypeID,
		AT1302.Specification,
		OT2001.QuotationID,
		OT2001.Contact,
		OT2002.RefInfor,
		OT2002.MethodID, 
		OT2002.OrderQuantity, --So luong tren don hang
		AT2027.ActualQuantity, -- So luong xuat kho theo bo
		CASE WHEN OrderType = 0 THEN   ---neu la don hang ban
			Case when Finish = 0 then OT2002.OrderQuantity else 0 end
		else
			OT2002.OrderQuantity   
		end AS FOrderQuantity,
		OT2002.SalePrice, 
		OT2002.LinkNo,
		ISNULL(OT2002.OriginalAmount,0) AS  OriginalAmount,
		ISNULL(OT2002.ConvertedAmount, 	0) AS ConvertedAmount,
		OT2002.VATPercent, 
		ISNULL(OT2002.VATOriginalAmount, 0) AS VATOriginalAmount,
		ISNULL(OT2002.VATConvertedAmount, 0) AS VATConvertedAmount,
		OT2002.DiscountPercent, 
		ISNULL(OT2002.DiscountOriginalAmount, 0)  AS DiscountOriginalAmount,
		ISNULL(OT2002.DiscountConvertedAmount, 0) AS DiscountConvertedAmount,
		OT2002.CommissionPercent, 
		ISNULL(OT2002.CommissionOAmount, 0) AS CommissionOAmount, 
		ISNULL(OT2002.CommissionCAmount,0) AS  CommissionCAmount,
		OT2002.IsPicking, 
		OT2002.WareHouseID, A03.WareHouseName,
		(ISNULL(OT2002.OriginalAmount, 0) + ISNULL(OT2002.VATOriginalAmount, 0) - ISNULL(OT2002.DiscountOriginalAmount, 0) - ISNULL(OT2002.CommissionOAmount, 0)) AS TotalOriginalAmount,
		(ISNULL(OT2002.ConvertedAmount, 0) + ISNULL(OT2002.VATConvertedAmount, 0) - ISNULL(OT2002.DiscountConvertedAmount, 0) - ISNULL(OT2002.CommissionCAmount,0)) AS TotalConvertedAmount,
		OT2002.Orders, 
		OT2002.Description AS TDescription,  	
		ISNULL(OT2002.Ana01ID, '') AS Ana01ID, 		ISNULL(OT2002.Ana02ID, '') AS Ana02ID, 		
		ISNULL(OT2002.Ana03ID, '') AS Ana03ID, 		ISNULL(OT2002.Ana04ID, '') AS Ana04ID, 		
		ISNULL(OT2002.Ana05ID, '') AS Ana05ID,		ISNULL(OT2002.Ana06ID, '') AS Ana06ID,
		ISNULL(OT2002.Ana07ID, '') AS Ana07ID,		ISNULL(OT2002.Ana08ID, '') AS Ana08ID,
		ISNULL(OT2002.Ana09ID, '') AS Ana09ID,		ISNULL(OT2002.Ana10ID, '') AS Ana10ID,
		OT2002.InventoryCommonName, 
		OT2002.AdjustQuantity, 	
		AT1302.UnitID,	
		AT1304.UnitName,
		ISNULL(AT1302.S1, '')  AS CI1ID,	ISNULL(AT1302.S2, '')  AS CI2ID, 	ISNULL(AT1302.S3, '') AS CI3ID,  
		ISNULL(AT1302.I01ID, '') AS I01ID, 	ISNULL(AT1302.I02ID, '') AS I02ID, 	ISNULL(AT1302.I03ID, '') AS I03ID,
		ISNULL(AT1302.I04ID, '') AS I04ID, 	ISNULL(AT1302.I05ID, '') AS I05ID,
		ISNULL(AT1202.S1, '')  AS CO1ID,	ISNULL(AT1202.S2, '') AS CO2ID, 	ISNULL(AT1202.S3, '') AS CO3ID,
		ISNULL(AT1202.O01ID, '') AS O01ID,  ISNULL(AT1202.O02ID, '') AS O02ID, 		
		ISNULL(AT1202.O03ID, '') AS O03ID,	ISNULL( AT1202.O04ID, '') AS O04ID,  ISNULL(AT1202.O05ID, '') AS O05ID,
		OV1001.Description AS StatusName,
		OT2002.Notes , OT2002.Notes01 , OT2002.Notes02,
		OT2002.SaleOffPercent01,		OT2002.SaleOffAmount01,
		OT2002.SaleOffPercent02,		OT2002.SaleOffAmount02,
		OT2002.SaleOffPercent03,		OT2002.SaleOffAmount03,
		OT2002.SaleOffPercent04,		OT2002.SaleOffAmount04,
		OT2002.SaleOffPercent05,		OT2002.SaleOffAmount05,
		OT2002.UnitID AS ConversionUnitID, 
		AV1319.ConversionFactor,
		AV1319.UnitName AS ConversionUnitName,
		OT2002.ConvertedQuantity,
		OT2002.ConvertedSalePrice,
		OT2002.Finish,
		OT2001.Varchar01,OT2001.Varchar02,OT2001.Varchar03,OT2001.Varchar04,OT2001.Varchar05,
        OT2001.Varchar06,OT2001.Varchar07,OT2001.Varchar08,OT2001.Varchar09,OT2001.Varchar10,
        OT2001.Varchar11,OT2001.Varchar12,OT2001.Varchar13,OT2001.Varchar14,OT2001.Varchar15,
        OT2001.Varchar16,OT2001.Varchar17,OT2001.Varchar18,OT2001.Varchar19,OT2001.Varchar20,
		AT01.AnaName AS AnaName01, AT02.AnaName AS AnaName02,AT03.AnaName AS AnaName03,
		AT04.AnaName AS AnaName04, AT05.AnaName AS AnaName05,AT06.AnaName AS AnaName06,
		AT07.AnaName AS AnaName07, AT08.AnaName AS AnaName08,AT09.AnaName AS AnaName09, AT10.AnaName AS AnaName10,
		CASE WHEN (	SELECT TOP 1 1 FROM OT2001 CO 
					WHERE	CO.DivisionID = OT2001.DivisionID AND CO.OrderType = OT2001.OrderType
							AND CO.ObjectID = OT2001.ObjectID AND CO.OrderDate < OT2001.OrderDate) IS NOT NULL THEN 0 ELSE 1 END AS FirstOrder,
		MT1601.PeriodID, MT1601.[Description] AS PeriodName,
		OT2002.nvarchar01,OT2002.nvarchar02,OT2002.nvarchar03,OT2002.nvarchar04,OT2002.nvarchar05,
		OT2002.nvarchar06,OT2002.nvarchar07,OT2002.nvarchar08,OT2002.nvarchar09,OT2002.nvarchar10,
		OT2002.Varchar01 as nvarchar11, OT2002.Varchar02 as nvarchar12, OT2002.Varchar03 as nvarchar13,
		OT2002.Varchar04 as nvarchar14, OT2002.Varchar05 as nvarchar15, OT2002.Varchar06 as nvarchar16,
		OT2002.Varchar07 as nvarchar17, OT2002.Varchar08 as nvarchar18, OT2002.Varchar09 as nvarchar19,
		OT2002.Varchar10 as nvarchar20,
		OT2001.CreateUserID, ISNULL(AT1302.ETaxConvertedUnit,0) AS ETaxConvertedUnit
From	OT2002 
LEFT JOIN AT1303 A03 ON A03.DivisionID = OT2002.DivisionID AND A03.WareHouseID = OT2002.WareHouseID
INNER JOIN OT2001           on OT2001.DivisionID = OT2002.DivisionID    and OT2001.SOrderID = OT2002.SOrderID 
LEFT JOIN AT1302            on AT1302.DivisionID = OT2002.DivisionID    and AT1302.InventoryID = OT2002.InventoryID 
LEFT JOIN AT1310 AT1310_S1  on AT1310_S1.DivisionID = OT2002.DivisionID and AT1310_S1.STypeID= 'I01' and AT1310_S1.S = AT1302.S1 
LEFT JOIN AT1310 AT1310_S2  on AT1310_S2.DivisionID = OT2002.DivisionID and AT1310_S2.STypeID= 'I02' and AT1310_S2.S = AT1302.S2 
LEFT JOIN AT1202            on AT1202.DivisionID = OT2002.DivisionID    and AT1202.ObjectID = OT2001.ObjectID
LEFT JOIN AT1004            on AT1004.DivisionID = OT2002.DivisionID    and AT1004.CurrencyID = OT2001.CurrencyID
LEFT JOIN AT1304            on AT1304.DivisionID = OT2002.DivisionID    and AT1302.UnitID = AT1304.UnitID
LEFT JOIN OV9999            on OV9999.DivisionID = OT2002.DivisionID    and OT2001.TranMonth = OV9999.TranMonth and OT2001.TranYear = OV9999.TranYear
LEFT JOIN OV1001            on OV1001.DivisionID = OT2002.DivisionID    and OV1001.TypeID = 'SO' and OV1001.OrderStatus = OT2001.OrderStatus
LEFT JOIN AT1103            on AT1103.DivisionID = OT2002.DivisionID    and AT1103.EmployeeID = OT2001.SalesManID
LEFT JOIN AT1103  AT1103_S2 on AT1103.DivisionID = OT2002.DivisionID    and AT1103.EmployeeID = OT2001.SalesMan2ID

LEFT JOIN OT1002 T01        on T01.DivisionID = OT2002.DivisionID       and T01.AnaID = OT2001.Ana01ID and T01.AnaTypeID ='S01'
LEFT JOIN OT1002 T02        on T02.DivisionID = OT2002.DivisionID       and T02.AnaID = OT2001.Ana02ID and T02.AnaTypeID ='S02'
LEFT JOIN OT1002 T03        on T03.DivisionID = OT2002.DivisionID       and T03.AnaID = OT2001.Ana03ID and  T03.AnaTypeID ='S03'
LEFT JOIN OT1002 T04        on T04.DivisionID = OT2002.DivisionID       and T04.AnaID = OT2001.Ana04ID and T04.AnaTypeID ='S04'
LEFT JOIN OT1002 T05        on T05.DivisionID = OT2002.DivisionID       and T05.AnaID = OT2001.Ana05ID and  T05.AnaTypeID ='S05'

LEFT JOIN AT1011 AT01       on AT01.DivisionID = OT2002.DivisionID      and AT01.AnaID = OT2002.Ana01ID and AT01.AnaTypeID ='A01'
LEFT JOIN AT1011 AT02       on AT02.DivisionID = OT2002.DivisionID      and AT02.AnaID = OT2002.Ana02ID and AT02.AnaTypeID ='A02'
LEFT JOIN AT1011 AT03       on AT03.DivisionID = OT2002.DivisionID      and AT03.AnaID = OT2002.Ana03ID and AT03.AnaTypeID ='A03'
LEFT JOIN AT1011 AT04       on AT04.DivisionID = OT2002.DivisionID      and AT04.AnaID = OT2002.Ana04ID and AT04.AnaTypeID ='A04'
LEFT JOIN AT1011 AT05       on AT05.DivisionID = OT2002.DivisionID      and AT05.AnaID = OT2002.Ana05ID and AT05.AnaTypeID ='A05'
LEFT JOIN AT1011 AT06       on AT06.DivisionID = OT2002.DivisionID      and AT06.AnaID = OT2002.Ana06ID and AT06.AnaTypeID ='A06'
LEFT JOIN AT1011 AT07       on AT07.DivisionID = OT2002.DivisionID      and AT07.AnaID = OT2002.Ana07ID and AT07.AnaTypeID ='A07'
LEFT JOIN AT1011 AT08       on AT08.DivisionID = OT2002.DivisionID      and AT08.AnaID = OT2002.Ana08ID and AT08.AnaTypeID ='A08'
LEFT JOIN AT1011 AT09       on AT09.DivisionID = OT2002.DivisionID      and AT09.AnaID = OT2002.Ana09ID and AT09.AnaTypeID ='A09'
LEFT JOIN AT1011 AT10       on AT10.DivisionID = OT2002.DivisionID      and AT10.AnaID = OT2002.Ana10ID and AT10.AnaTypeID ='A10'

LEFT JOIN AV1319            on AV1319.DivisionID = OT2002.DivisionID    and AV1319.InventoryID = OT2002.InventoryID  and  AV1319.UnitID  = OT2002.UnitID
LEFT JOIN MT1601			On MT1601.PeriodID = OT2001.PeriodID
LEFT JOIN	(	SELECT		SUM(ISNULL(ActualQuantity,0)) AS ActualQuantity, OrderID 
				FROM		AT2027
				GROUP BY	OrderID
	   	 )AT2027
ON		OT2002.SOrderID = AT2027.OrderID




GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
