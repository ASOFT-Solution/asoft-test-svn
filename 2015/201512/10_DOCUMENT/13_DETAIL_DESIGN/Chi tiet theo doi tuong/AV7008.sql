﻿IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7008]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV7008]
GO
SET QUOTED_IDENTIFIER ON
GO

SET ANSI_NULLS ON
GO
-- <Summary>
---- View chet. Xu ly so du hang ton kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on  by 
---- Modified on 25/01/2016 by Thị Phượng thêm trường IsBottle customize Hoàng Trần
-----

 CREATE VIEW [dbo].[AV7008] -- Tạo bởi AP7000 Cách lấy dữ liệu giống AV7000
	        AS 
SELECT  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BD' AS D_C,  --- So du No
	'' AS RefNo01, '' AS RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID, D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity AS SignQuantity, 
	ConvertedAmount AS SignAmount,	
	D02.S1,	D02.S2, D02.S3 ,
	D02.S1 AS CI1ID, D02.S2 AS CI2ID, D02.S3 AS CI3ID, 
	D17.Ana01ID,D17.Ana02ID,D17.Ana03ID, D17.Ana04ID,D17.Ana05ID,
	D17.Ana06ID,D17.Ana07ID,D17.Ana08ID, D17.Ana09ID,D17.Ana10ID,
	D16.VoucherTypeID,
	S1.SName AS S1Name,
	S2.SName AS S2Name,
	S3.SName AS S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification, 
	D02.Notes01, D02.Notes02, D02.Notes03,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
	I1.AnaName AS  InAnaName1, 
	I2.AnaName AS  InAnaName2, 
	I3.AnaName AS  InAnaName3, 
	I4.AnaName AS  InAnaName4, 
	I5.AnaName AS  InAnaName5, 
	ISNULL(D03.IsTemp,0) AS IsTemp,
	0 AS 	 KindVoucherID,
	(CASE WHEN  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  AS Quarter ,
	str(D17.TranYear) AS Year,D17.SourceNo,
	D17.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
    ,NULL AS ProductID, NULL AS MOrderID, NULL AS ProductName,
    D02.Barcode,D16.Description AS VoucherDesc,
    D17.Parameter01, D17.Parameter02, D17.Parameter03, D17.Parameter04, D17.Parameter05,
	A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
	A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name,	A10.AnaName AS Ana10Name,
    D17.LimitDate, AT0114.RevoucherDate, -- 03/01/2014 My Tuyen add new
    isnull(D02.IsBottle, 0) as IsBottle

	FROM AT2017 AS D17 
	INNER JOIN AT2016 AS D16 ON D16.VoucherID = D17.VoucherID AND D16.DivisionID = D17.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = D16.ObjectID AND AT1202.DivisionID = D17.DivisionID
	INNER JOIN AT1302 AS D02 ON D02.InventoryID = D17.InventoryID AND D02.DivisionID = D17.DivisionID
	INNER JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID AND D04.DivisionID = D17.DivisionID
	INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D16.WareHouseID AND D03.DivisionID = D17.DivisionID
	LEFT JOIN AT1310 S1 ON 	S1.STypeID = 'I01' AND S1.S = D02.S1 AND S1.DivisionID = D17.DivisionID
	LEFT JOIN AT1310 S2 ON 	S2.STypeID = 'I02' AND S2.S = D02.S2 AND S2.DivisionID = D17.DivisionID
	LEFT JOIN AT1310 S3 ON 	S3.STypeID = 'I03' AND S3.S = D02.S3 AND S3.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I1 ON 	I1.AnaTypeID = 'I01' AND I1.AnaID = D02.I01ID AND I1.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I2 ON 	I2.AnaTypeID = 'I02' AND I2.AnaID = D02.I02ID AND I2.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I3 ON 	I3.AnaTypeID = 'I03' AND I3.AnaID = D02.I03ID AND I3.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I4 ON 	I4.AnaTypeID = 'I04' AND I4.AnaID = D02.I04ID AND I4.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I5 ON 	I5.AnaTypeID = 'I05' AND I5.AnaID = D02.I05ID AND I5.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID AND O5.DivisionID = D17.DivisionID
	LEFT JOIN AT1304 AS D05 ON D05.UnitID = D17.ConvertedUnitID AND D05.DivisionID = D17.DivisionID
	LEFT JOIN AT1011 A01 ON A01.DivisionID = D17.DivisionID AND A01.AnaTypeID = 'A01' AND A01.AnaID = D17.Ana01ID
	LEFT JOIN AT1011 A02 ON A02.DivisionID = D17.DivisionID AND A02.AnaTypeID = 'A02' AND A02.AnaID = D17.Ana02ID
	LEFT JOIN AT1011 A03 ON A03.DivisionID = D17.DivisionID AND A03.AnaTypeID = 'A03' AND A03.AnaID = D17.Ana03ID
	LEFT JOIN AT1011 A04 ON A04.DivisionID = D17.DivisionID AND A04.AnaTypeID = 'A04' AND A04.AnaID = D17.Ana04ID
	LEFT JOIN AT1011 A05 ON A05.DivisionID = D17.DivisionID AND A05.AnaTypeID = 'A05' AND A05.AnaID = D17.Ana05ID
	LEFT JOIN AT1011 A06 ON A06.DivisionID = D17.DivisionID AND A06.AnaTypeID = 'A06' AND A06.AnaID = D17.Ana06ID
	LEFT JOIN AT1011 A07 ON A07.DivisionID = D17.DivisionID AND A07.AnaTypeID = 'A07' AND A07.AnaID = D17.Ana07ID
	LEFT JOIN AT1011 A08 ON A08.DivisionID = D17.DivisionID AND A08.AnaTypeID = 'A08' AND A08.AnaID = D17.Ana08ID
	LEFT JOIN AT1011 A09 ON A09.DivisionID = D17.DivisionID AND A09.AnaTypeID = 'A09' AND A09.AnaID = D17.Ana09ID
	LEFT JOIN AT1011 A10 ON A10.DivisionID = D17.DivisionID AND A10.AnaTypeID = 'A10' AND A10.AnaID = D17.Ana10ID
	LEFT JOIN AT0114 ON AT0114.Revoucherid=D17.VoucherID  -- 03/01/2014 My Tuyen add new
	WHERE	ISNULL(DebitAccountID,'') <>''
			AND D17.DivisionID LIKE 'AS'
	
		AND D16.WareHouseID >= 'KHOBT'
		AND D16.WareHouseID <= 'KHOBT' 
		AND D17.InventoryID >= '0000000001'
		AND D17.InventoryID <= 'Ke' 
		AND D16.ObjectID >= 'KH001'
		AND D16.ObjectID <= 'KH006' 
		AND D17.TranYear*100+D17.TranMonth <=     201602 
UNION ALL --- So du co hang ton kho

SELECT  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BC' AS D_C,  --- So du Co
	'' AS RefNo01, '' AS RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName, 	
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	-ActualQuantity AS SignQuantity, 
	-ConvertedAmount AS SignAmount,	
	D02.S1,	D02.S2, D02.S3 ,
	D02.S1 AS CI1ID, D02.S2 AS CI2ID, D02.S3 AS CI3ID, 
	D17.Ana01ID,D17.Ana02ID,D17.Ana03ID, D17.Ana04ID,D17.Ana05ID,
	D17.Ana06ID,D17.Ana07ID,D17.Ana08ID, D17.Ana09ID,D17.Ana10ID,
	D16.VoucherTypeID,
	S1.SName AS S1Name,
	S2.SName AS S2Name,

	S3.SName AS S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification,
	D02.Notes01, D02.Notes02, D02.Notes03,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
	I1.AnaName AS  InAnaName1, 
	I2.AnaName AS  InAnaName2, 
	I3.AnaName AS  InAnaName3, 
	I4.AnaName AS  InAnaName4, 
	I5.AnaName AS  InAnaName5, 
	ISNULL(D03.IsTemp,0) AS IsTemp,
	0 AS KindVoucherID,
	(CASE WHEN  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  AS Quarter ,
	str(D17.TranYear) AS Year, D17.SourceNo,
	D17.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
	,NULL AS ProductID, NULL AS MOrderID, NULL AS ProductName,
	D02.Barcode,D16.Description AS VoucherDesc,
    D17.Parameter01, D17.Parameter02, D17.Parameter03, D17.Parameter04, D17.Parameter05,
	A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
	A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name,	A10.AnaName AS Ana10Name,
    D17.LimitDate, AT0114.RevoucherDate,    -- 03/01/2014 My Tuyen add new
    isnull(D02.IsBottle, 0) as IsBottle

	FROM AT2017 AS D17 
	INNER JOIN AT2016 AS D16 ON D16.VoucherID = D17.VoucherID AND D16.DivisionID = D17.DivisionID 
	LEFT JOIN AT1202 ON AT1202.ObjectID = D16.ObjectID  AND AT1202.DivisionID = D17.DivisionID
	INNER JOIN AT1302 AS D02 ON D02.InventoryID = D17.InventoryID  AND D02.DivisionID = D17.DivisionID
	INNER JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID  AND D04.DivisionID = D17.DivisionID
	INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D16.WareHouseID  AND D03.DivisionID = D17.DivisionID
	LEFT JOIN AT1310 S1 ON 	S1.STypeID = 'I01' AND S1.S = D02.S1  AND S1.DivisionID = D17.DivisionID
	LEFT JOIN AT1310 S2 ON 	S2.STypeID = 'I02' AND S2.S = D02.S2  AND S2.DivisionID = D17.DivisionID
	LEFT JOIN AT1310 S3 ON 	S3.STypeID = 'I03' AND S3.S = D02.S3  AND S3.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I1 ON 	I1.AnaTypeID = 'I01' AND I1.AnaID = D02.I01ID  AND I1.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I2 ON 	I2.AnaTypeID = 'I02' AND I2.AnaID = D02.I02ID  AND I2.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I3 ON 	I3.AnaTypeID = 'I03' AND I3.AnaID = D02.I03ID  AND I3.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I4 ON 	I4.AnaTypeID = 'I04' AND I4.AnaID = D02.I04ID  AND I4.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 I5 ON 	I5.AnaTypeID = 'I05' AND I5.AnaID = D02.I05ID  AND I5.DivisionID = D17.DivisionID
	LEFT JOIN AT1015 O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID AND O5.DivisionID = D17.DivisionID
	LEFT JOIN AT1304 AS D05 ON D05.UnitID = D17.ConvertedUnitID  AND D05.DivisionID = D17.DivisionID
	LEFT JOIN AT1011 A01 ON A01.DivisionID = D17.DivisionID AND A01.AnaTypeID = 'A01' AND A01.AnaID = D17.Ana01ID
	LEFT JOIN AT1011 A02 ON A02.DivisionID = D17.DivisionID AND A02.AnaTypeID = 'A02' AND A02.AnaID = D17.Ana02ID
	LEFT JOIN AT1011 A03 ON A03.DivisionID = D17.DivisionID AND A03.AnaTypeID = 'A03' AND A03.AnaID = D17.Ana03ID
	LEFT JOIN AT1011 A04 ON A04.DivisionID = D17.DivisionID AND A04.AnaTypeID = 'A04' AND A04.AnaID = D17.Ana04ID
	LEFT JOIN AT1011 A05 ON A05.DivisionID = D17.DivisionID AND A05.AnaTypeID = 'A05' AND A05.AnaID = D17.Ana05ID
	LEFT JOIN AT1011 A06 ON A06.DivisionID = D17.DivisionID AND A06.AnaTypeID = 'A06' AND A06.AnaID = D17.Ana06ID
	LEFT JOIN AT1011 A07 ON A07.DivisionID = D17.DivisionID AND A07.AnaTypeID = 'A07' AND A07.AnaID = D17.Ana07ID
	LEFT JOIN AT1011 A08 ON A08.DivisionID = D17.DivisionID AND A08.AnaTypeID = 'A08' AND A08.AnaID = D17.Ana08ID
	LEFT JOIN AT1011 A09 ON A09.DivisionID = D17.DivisionID AND A09.AnaTypeID = 'A09' AND A09.AnaID = D17.Ana09ID
	LEFT JOIN AT1011 A10 ON A10.DivisionID = D17.DivisionID AND A10.AnaTypeID = 'A10' AND A10.AnaID = D17.Ana10ID
	LEFT JOIN AT0114 ON AT0114.Revoucherid=D17.VoucherID   -- 03/01/2014 My Tuyen add new

	WHERE ISNULL(CreditAccountID,'') <>''
			AND D17.DivisionID LIKE 'AS'
	
		AND D16.WareHouseID >= 'KHOBT'
		AND D16.WareHouseID <= 'KHOBT' 
		AND D17.InventoryID >= '0000000001'
		AND D17.InventoryID <= 'Ke' 
		AND D16.ObjectID >= 'KH001'
		AND D16.ObjectID <= 'KH006' 
		AND D17.TranYear*100+D17.TranMonth <=     201602  
UNION ALL  -- Nhap kho

SELECT  D07.DivisionID, D07.TranMonth, D07.TranYear,
	D06.WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'D' AS D_C,  --- Phat sinh No
	RefNo01 AS RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName,
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedAmount,
	ActualQuantity AS SignQuantity, 
	ConvertedAmount AS SignAmount,	
	D02.S1,	D02.S2, D02.S3, 
	D02.S1 AS CI1ID, D02.S2 AS CI2ID, D02.S3 AS CI3ID, 
	D07.Ana01ID,D07.Ana02ID,D07.Ana03ID, D07.Ana04ID,D07.Ana05ID,
	D07.Ana06ID,D07.Ana07ID,D07.Ana08ID, D07.Ana09ID,D07.Ana10ID,
	D06.VoucherTypeID,
	S1.SName AS S1Name,
	S2.SName AS S2Name,
	S3.SName AS S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification,
	D02.Notes01, D02.Notes02, D02.Notes03,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
	I1.AnaName AS  InAnaName1, 
	I2.AnaName AS  InAnaName2, 
	I3.AnaName AS  InAnaName3, 
	I4.AnaName AS  InAnaName4, 
	I5.AnaName AS  InAnaName5,
	ISNULL(D03.IsTemp,0) AS IsTemp,
	CASE WHEN  KindVoucherID = 3 then 3 else 0 end AS KindVoucherID,
	(CASE WHEN  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  AS Quarter ,
	str(D07.TranYear) AS Year, D07.SourceNo,
	D07.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
    ,D07.ProductID, D07.MOrderID, P02.InventoryName AS ProductName,
    D02.Barcode,D06.Description AS VoucherDesc,
    D07.Parameter01, D07.Parameter02, D07.Parameter03, D07.Parameter04, D07.Parameter05,
	A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
	A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name,	A10.AnaName AS Ana10Name,
    D07.LimitDate, AT0114.RevoucherDate,  -- 03/01/2014 My Tuyen add new 
    isnull(D02.IsBottle, 0) as IsBottle
	 
	FROM AT2007 AS D07 
	INNER JOIN AT2006 D06 ON D06.VoucherID = D07.VoucherID AND D06.DivisionID = D07.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = D06.ObjectID  AND AT1202.DivisionID = D07.DivisionID
	INNER JOIN AT1302 AS D02 ON D02.InventoryID = D07.InventoryID  AND D02.DivisionID = D07.DivisionID
	INNER JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID  AND D04.DivisionID = D07.DivisionID
	INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D06.WareHouseID  AND D03.DivisionID = D07.DivisionID
	LEFT JOIN AT1302 AS P02 ON P02.InventoryID = D07.ProductID  AND P02.DivisionID = D07.DivisionID
	LEFT JOIN AT1310 S1 ON 	S1.STypeID = 'I01' AND S1.S = D02.S1  AND S1.DivisionID = D07.DivisionID
	LEFT JOIN AT1310 S2 ON 	S2.STypeID = 'I02' AND S2.S = D02.S2  AND S2.DivisionID = D07.DivisionID
	LEFT JOIN AT1310 S3 ON 	S3.STypeID = 'I03' AND S3.S = D02.S3  AND S3.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I1 ON 	I1.AnaTypeID = 'I01' AND I1.AnaID = D02.I01ID  AND I1.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I2 ON 	I2.AnaTypeID = 'I02' AND I2.AnaID = D02.I02ID  AND I2.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I3 ON 	I3.AnaTypeID = 'I03' AND I3.AnaID = D02.I03ID  AND I3.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I4 ON 	I4.AnaTypeID = 'I04' AND I4.AnaID = D02.I04ID  AND I4.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I5 ON 	I5.AnaTypeID = 'I05' AND I5.AnaID = D02.I05ID  AND I5.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID AND O5.DivisionID = D07.DivisionID
	LEFT JOIN AT1304 AS D05 ON D05.UnitID = D07.ConvertedUnitID		 AND D05.DivisionID = D07.DivisionID
	LEFT JOIN AT1011 A01 ON A01.DivisionID = D07.DivisionID AND A01.AnaTypeID = 'A01' AND A01.AnaID = D07.Ana01ID
	LEFT JOIN AT1011 A02 ON A02.DivisionID = D07.DivisionID AND A02.AnaTypeID = 'A02' AND A02.AnaID = D07.Ana02ID
	LEFT JOIN AT1011 A03 ON A03.DivisionID = D07.DivisionID AND A03.AnaTypeID = 'A03' AND A03.AnaID = D07.Ana03ID
	LEFT JOIN AT1011 A04 ON A04.DivisionID = D07.DivisionID AND A04.AnaTypeID = 'A04' AND A04.AnaID = D07.Ana04ID
	LEFT JOIN AT1011 A05 ON A05.DivisionID = D07.DivisionID AND A05.AnaTypeID = 'A05' AND A05.AnaID = D07.Ana05ID
	LEFT JOIN AT1011 A06 ON A06.DivisionID = D07.DivisionID AND A06.AnaTypeID = 'A06' AND A06.AnaID = D07.Ana06ID
	LEFT JOIN AT1011 A07 ON A07.DivisionID = D07.DivisionID AND A07.AnaTypeID = 'A07' AND A07.AnaID = D07.Ana07ID
	LEFT JOIN AT1011 A08 ON A08.DivisionID = D07.DivisionID AND A08.AnaTypeID = 'A08' AND A08.AnaID = D07.Ana08ID
	LEFT JOIN AT1011 A09 ON A09.DivisionID = D07.DivisionID AND A09.AnaTypeID = 'A09' AND A09.AnaID = D07.Ana09ID
	LEFT JOIN AT1011 A10 ON A10.DivisionID = D07.DivisionID AND A10.AnaTypeID = 'A10' AND A10.AnaID = D07.Ana10ID
	LEFT JOIN AT0114 ON D07.RevoucherID=AT0114.RevoucherID     -- 03/01/2014 My Tuyen add new

	WHERE D06.KindVoucherID in (1,3,5,7,9,15,17)
			AND D07.DivisionID LIKE 'AS'
	
		AND D06.WareHouseID >= 'KHOBT'
		AND D06.WareHouseID <= 'KHOBT' 
		AND D07.InventoryID >= '0000000001'
		AND D07.InventoryID <= 'Ke' 
		AND D06.ObjectID >= 'KH001'
		AND D06.ObjectID <= 'KH006' 
		AND D07.TranYear*100+D07.TranMonth >=     201602 
		AND D07.TranYear*100+D07.TranMonth <=     201602 
UNION ALL  -- XUAT KHO

SELECT  D07.DivisionID, D07.TranMonth, D07.TranYear,
	CASE WHEN D06.KindVoucherID = 3 THEN D06.WareHouseID2 ELSE  D06.WareHouseID END AS WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'C' AS D_C,  --- So du Co
	RefNo01 AS RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName, 	
	AT1202.O01ID, AT1202.O02ID, AT1202.O03ID, AT1202.O04ID, AT1202.O05ID,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,

	CASE WHEN D06.KindVoucherID = 3 then D031.WareHouseName Else  D03.WareHouseName End  AS WareHouseName,	

	ActualQuantity, 
	ConvertedAmount,
	-ActualQuantity AS SignQuantity, 
	-ConvertedAmount AS SignAmount,	
	D02.S1,	D02.S2, D02.S3, 
	D02.S1 AS CI1ID, D02.S2 AS CI2ID, D02.S3 AS CI3ID, 
	D07.Ana01ID,D07.Ana02ID,D07.Ana03ID, D07.Ana04ID,D07.Ana05ID,
	D07.Ana06ID,D07.Ana07ID,D07.Ana08ID, D07.Ana09ID,D07.Ana10ID,
	D06.VoucherTypeID,
	S1.SName AS S1Name,
	S2.SName AS S2Name,
	S3.SName AS S3Name,
	D02.I01ID, D02.I02ID, D02.I03ID, D02.I04ID, D02.I05ID, D02.Specification,
	D02.Notes01, D02.Notes02, D02.Notes03,
	D02.Varchar01,D02.Varchar02,D02.Varchar03,D02.Varchar04,D02.Varchar05,
	I1.AnaName AS  InAnaName1, 
	I2.AnaName AS  InAnaName2, 
	I3.AnaName AS  InAnaName3, 
	I4.AnaName AS  InAnaName4, 
	I5.AnaName AS  InAnaName5, 
	ISNULL(D03.IsTemp,0) AS IsTemp,
	CASE WHEN  KindVoucherID = 3 then 3 else 0 end AS KindVoucherID,
	(CASE WHEN  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  AS Quarter ,
	str(D07.TranYear) AS Year, D07.SourceNo,
	D07.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
	,D07.ProductID, D07.MOrderID, P02.InventoryName AS ProductName,
	D02.Barcode,D06.Description AS VoucherDesc,
	D07.Parameter01, D07.Parameter02, D07.Parameter03, D07.Parameter04, D07.Parameter05,
	A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
	A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name,	A10.AnaName AS Ana10Name,
    D07.LimitDate, AT0114.ReVoucherDate,   -- 03/01/2014 My Tuyen add new 
    isnull(D02.IsBottle, 0) as IsBottle
		
	FROM AT2007 AS D07 
	INNER JOIN AT2006 D06 ON D06.VoucherID = D07.VoucherID AND D06.DivisionID = D07.DivisionID
	LEFT JOIN AT1202 ON AT1202.ObjectID = D06.ObjectID AND AT1202.DivisionID = D07.DivisionID
	INNER JOIN AT1302 AS D02 ON D02.InventoryID = D07.InventoryID AND D02.DivisionID = D07.DivisionID
	INNER JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID AND D04.DivisionID = D07.DivisionID
	INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D06.WareHouseID AND D03.DivisionID = D07.DivisionID
	LEFT JOIN AT1302 AS P02 ON P02.InventoryID = D07.ProductID  AND P02.DivisionID = D07.DivisionID
	LEFT JOIN AT1303 AS  D031 ON D031.WareHouseID = D06.WareHouseID2 AND D031.DivisionID = D07.DivisionID
	LEFT JOIN AT1310 S1 ON 	S1.STypeID = 'I01' AND S1.S = D02.S1  AND S1.DivisionID = D07.DivisionID
	LEFT JOIN AT1310 S2 ON 	S2.STypeID = 'I02' AND S2.S = D02.S2  AND S2.DivisionID = D07.DivisionID
	LEFT JOIN AT1310 S3 ON 	S3.STypeID = 'I03' AND S3.S = D02.S3  AND S3.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I1 ON 	I1.AnaTypeID = 'I01' AND I1.AnaID = D02.I01ID  AND I1.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I2 ON 	I2.AnaTypeID = 'I02' AND I2.AnaID = D02.I02ID  AND I2.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I3 ON 	I3.AnaTypeID = 'I03' AND I3.AnaID = D02.I03ID  AND I3.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I4 ON 	I4.AnaTypeID = 'I04' AND I4.AnaID = D02.I04ID  AND I4.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 I5 ON 	I5.AnaTypeID = 'I05' AND I5.AnaID = D02.I05ID  AND I5.DivisionID = D07.DivisionID
	LEFT JOIN AT1015 O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID AND O5.DivisionID = D07.DivisionID
	LEFT JOIN AT1304 AS D05 ON D05.UnitID = D07.ConvertedUnitID  AND D05.DivisionID = D07.DivisionID
	LEFT JOIN AT1011 A01 ON A01.DivisionID = D07.DivisionID AND A01.AnaTypeID = 'A01' AND A01.AnaID = D07.Ana01ID
	LEFT JOIN AT1011 A02 ON A02.DivisionID = D07.DivisionID AND A02.AnaTypeID = 'A02' AND A02.AnaID = D07.Ana02ID
	LEFT JOIN AT1011 A03 ON A03.DivisionID = D07.DivisionID AND A03.AnaTypeID = 'A03' AND A03.AnaID = D07.Ana03ID
	LEFT JOIN AT1011 A04 ON A04.DivisionID = D07.DivisionID AND A04.AnaTypeID = 'A04' AND A04.AnaID = D07.Ana04ID
	LEFT JOIN AT1011 A05 ON A05.DivisionID = D07.DivisionID AND A05.AnaTypeID = 'A05' AND A05.AnaID = D07.Ana05ID
	LEFT JOIN AT1011 A06 ON A06.DivisionID = D07.DivisionID AND A06.AnaTypeID = 'A06' AND A06.AnaID = D07.Ana06ID
	LEFT JOIN AT1011 A07 ON A07.DivisionID = D07.DivisionID AND A07.AnaTypeID = 'A07' AND A07.AnaID = D07.Ana07ID
	LEFT JOIN AT1011 A08 ON A08.DivisionID = D07.DivisionID AND A08.AnaTypeID = 'A08' AND A08.AnaID = D07.Ana08ID
	LEFT JOIN AT1011 A09 ON A09.DivisionID = D07.DivisionID AND A09.AnaTypeID = 'A09' AND A09.AnaID = D07.Ana09ID
	LEFT JOIN AT1011 A10 ON A10.DivisionID = D07.DivisionID AND A10.AnaTypeID = 'A10' AND A10.AnaID = D07.Ana10ID
	LEFT JOIN AT0114 ON D07.RevoucherID=AT0114.RevoucherID   -- 03/01/2014 My Tuyen add new

	WHERE D06.KindVoucherID in (2,3,4,6,8,10,14,20)
			AND D07.DivisionID LIKE 'AS'

		AND CASE WHEN D06.KindVoucherID = 3 THEN D06.WareHouseID2 ELSE  D06.WareHouseID END >= 'KHOBT'
		AND CASE WHEN D06.KindVoucherID = 3 THEN D06.WareHouseID2 ELSE  D06.WareHouseID END <= 'KHOBT' 
		AND D07.InventoryID >= '0000000001'
		AND D07.InventoryID <= 'Ke' 
		AND D06.ObjectID >= 'KH001'
		AND D06.ObjectID <= 'KH006' 
		AND D07.TranYear*100+D07.TranMonth >=     201602 
		AND D07.TranYear*100+D07.TranMonth <=     201602 
GO


