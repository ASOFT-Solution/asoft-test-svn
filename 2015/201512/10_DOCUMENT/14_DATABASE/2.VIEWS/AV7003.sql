IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7003]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV7003]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- View chet
---- So du va phat sinh khong lay van chuyen noi bo
---- Created by Tiểu Mai, on 06/11/2015: giống view AV7001

CREATE VIEW [dbo].[AV7003] AS 
--- So du No cua tai khoan ton kho

Select  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BD' AS D_C,  --- So du No
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, D16.ObjectID,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	D02.S1, D02.S2, D02.S3, D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.VATPercent, D02.Specification, 
	D02.Notes01 as D02Notes01, D02.Notes02 as D02Notes02, D02.Notes03 as D02Notes03,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	isnull(D03.IsTemp,0) AS IsTemp,D03.FullName [WHFullName],
	D17.Parameter01, D17.Parameter02, D17.Parameter03, D17.Parameter04, D17.Parameter05,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
		D17.Notes01, D17.Notes02, D17.Notes03, D17.Notes04, D17.Notes05, D17.Notes06, D17.Notes07, D17.Notes08,
	D17.Notes09, D17.Notes10, D17.Notes11, D17.Notes12, D17.Notes13, D17.Notes14, D17.Notes15, D17.MarkQuantity, D17.SourceNo,
	D16.KindVoucherID, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
	

From AT2017 AS D17 
INNER JOIN AT2016 AS D16 On D16.VoucherID = D17.VoucherID
LEFT JOIN WT8899 O99 ON O99.DivisionID = D17.DivisionID AND O99.VoucherID = D17.VoucherID AND O99.TransactionID = D17.TransactionID
INNER JOIN AT1302 AS D02 on D02.InventoryID = D17.InventoryID
INNER JOIN AT1304 AS D04 on D04.UnitID = D02.UnitID
INNER JOIN AT1303 AS D03 on D03.WareHouseID = D16.WareHouseID
Where isnull(DebitAccountID,'') <>''

UNION ALL --- So du co hang ton kho

Select  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BC' AS D_C,  --- So du Co
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, D16.ObjectID,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	D02.S1, D02.S2, D02.S3, D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID,  D02.VATPercent, D02.Specification,
	D02.Notes01 as D02Notes01, D02.Notes02 as D02Notes02, D02.Notes03 as D02Notes03,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	isnull(D03.IsTemp,0) AS IsTemp,D03.FullName [WHFullName],
	D17.Parameter01, D17.Parameter02, D17.Parameter03, D17.Parameter04, D17.Parameter05,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
			D17.Notes01, D17.Notes02, D17.Notes03, D17.Notes04, D17.Notes05, D17.Notes06, D17.Notes07, D17.Notes08,
	D17.Notes09, D17.Notes10, D17.Notes11, D17.Notes12, D17.Notes13, D17.Notes14, D17.Notes15, D17.MarkQuantity, D17.SourceNo,
	D16.KindVoucherID, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
From AT2017 AS D17 
INNER JOIN AT2016 AS D16 On D16.VoucherID = D17.VoucherID
INNER JOIN AT1302 AS D02 on D02.InventoryID = D17.InventoryID
INNER JOIN AT1304 AS D04 on D04.UnitID = D02.UnitID
INNER JOIN AT1303 AS D03 on D03.WareHouseID = D16.WareHouseID
LEFT JOIN WT8899 O99 ON O99.DivisionID = D17.DivisionID AND O99.VoucherID = D17.VoucherID AND O99.TransactionID = D17.TransactionID
Where isnull(CreditAccountID,'') <>''

UNION ALL  -- Nhap kho

Select  D07.DivisionID, D07.TranMonth, D07.TranYear,
	D06.WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'D' AS D_C,  --- Phat sinh No
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, D06.ObjectID,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	D02.S1, D02.S2, D02.S3, D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID,  D02.VATPercent, D02.Specification,
	D02.Notes01 as D02Notes01, D02.Notes02 as D02Notes02, D02.Notes03 as D02Notes03,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	isnull(D03.IsTemp,0) AS IsTemp,D03.FullName [WHFullName],
	D07.Parameter01, D07.Parameter02, D07.Parameter03, D07.Parameter04, D07.Parameter05,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
		D07.Notes01, D07.Notes02, D07.Notes03, D07.Notes04, D07.Notes05, D07.Notes06, D07.Notes07, D07.Notes08,
	D07.Notes09, D07.Notes10, D07.Notes11, D07.Notes12, D07.Notes13, D07.Notes14, D07.Notes15, D07.MarkQuantity, D07.SourceNo,
	D06.KindVoucherID, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
From AT2007 AS D07 
INNER JOIN AT2006 D06 On D06.VoucherID = D07.VoucherID
INNER JOIN AT1302 AS D02 on D02.InventoryID = D07.InventoryID
INNER JOIN AT1304 AS D04 on D04.UnitID = D02.UnitID
INNER JOIN AT1303 AS D03 on D03.WareHouseID = D06.WareHouseID
LEFT JOIN WT8899 O99 ON O99.DivisionID = D07.DivisionID AND O99.VoucherID = D07.VoucherID AND O99.TransactionID = D07.TransactionID
Where D06.KindVoucherID in (1,5,7)

UNION ALL  -- Nhap kho
Select  D07.DivisionID, D07.TranMonth, D07.TranYear,
	Case when D06.KindVoucherID = 3 then D06.WareHouseID2 Else  D06.WareHouseID End AS WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'C' AS D_C,  --- So du Co
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, D06.ObjectID,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID,
	D02.S1, D02.S2, D02.S3, D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID,  D02.VATPercent, D02.Specification, 
	D02.Notes01 as D02Notes01, D02.Notes02 as D02Notes02, D02.Notes03 as D02Notes03,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	isnull(D03.IsTemp,0) AS IsTemp,D03.FullName [WHFullName],
	D07.Parameter01, D07.Parameter02, D07.Parameter03, D07.Parameter04, D07.Parameter05,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
		D07.Notes01, D07.Notes02, D07.Notes03, D07.Notes04, D07.Notes05, D07.Notes06, D07.Notes07, D07.Notes08,
	D07.Notes09, D07.Notes10, D07.Notes11, D07.Notes12, D07.Notes13, D07.Notes14, D07.Notes15, D07.MarkQuantity, D07.SourceNo,
	D06.KindVoucherID, O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
From AT2007 AS D07 
INNER JOIN AT2006 D06 On D06.VoucherID = D07.VoucherID
INNER JOIN AT1302 AS D02 on D02.InventoryID = D07.InventoryID
INNER JOIN AT1304 AS D04 on D04.UnitID = D02.UnitID
INNER JOIN AT1303 AS D03 on D03.WareHouseID = D06.WareHouseID
LEFT JOIN WT8899 O99 ON O99.DivisionID = D07.DivisionID AND O99.VoucherID = D07.VoucherID AND O99.TransactionID = D07.TransactionID
Where D06.KindVoucherID in (2,4,10)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
