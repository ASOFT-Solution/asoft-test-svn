IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7000_HT]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV7000_HT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 --<Summary>
-- View chet. Xu ly so du hang ton kho
-- <Param>
-- 
-- <Return>
-- 
-- <Reference>
-- 
-- <History>
-- Create on 21/01/2016 By Thị Phượng
-- <Example>
-- 



CREATE VIEW [dbo].[AV7000_HT] AS 
-- So du No cua tai khoan ton kho
SELECT  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BD' AS D_C,  --- So du No
	'' AS RefNo01, '' AS RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName,
	AT1202.O05ID, O5.AnaName as ObjectAnaName5,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID, D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	0 as OExpenseConvertedAmount,
	ActualQuantity AS SignQuantity, 
	ConvertedQuantity AS SignConvertedQuantity, 
	ConvertedAmount AS SignAmount,	
	D16.VoucherTypeID,
	0 AS 	 KindVoucherID,
	(CASE WHEN  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  AS Quarter ,
	str(D17.TranYear) AS Year,D17.SourceNo,
	D17.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
    ,NULL AS ProductID, NULL AS MOrderID, NULL AS ProductName,
    D02.Barcode,D16.Description AS VoucherDesc,
	D17.MarkQuantity, -D17.MarkQuantity as SignMarkQuantity,
    D17.DebitAccountID as InventoryAccountID, isnull(D02.IsBottle,0) as IsBottle
    
From AT2017 AS D17 
INNER JOIN AT2016 AS D16 ON D16.VoucherID = D17.VoucherID AND D16.DivisionID = D17.DivisionID
LEFT JOIN AT1202 ON AT1202.ObjectID = D16.ObjectID AND AT1202.DivisionID = D17.DivisionID
INNER JOIN AT1302 AS D02 ON D02.InventoryID = D17.InventoryID AND D02.DivisionID = D17.DivisionID
LEFT JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID AND D04.DivisionID = D17.DivisionID
INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D16.WareHouseID AND D03.DivisionID = D17.DivisionID
LEFT JOIN AT1015 AS O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID AND O5.DivisionID = D17.DivisionID
LEFT JOIN AT1304 AS D05 ON D05.UnitID = D17.ConvertedUnitID AND D05.DivisionID = D17.DivisionID

Where isnull(DebitAccountID,'') <>''

UNION ALL --- So du co hang ton kho

SELECT  D17.DivisionID, D17.TranMonth, D17.TranYear,
	D16.WareHouseID, D17.InventoryID, D17.DebitAccountID, D17.CreditAccountID,
	'BC' AS D_C,  --- So du Co
	'' AS RefNo01, '' AS RefNo02, 	D17.Notes,
	D16.VoucherID, D16.VoucherDate, D16.VoucherNo, 
	D16.ObjectID,AT1202.ObjectName,  	
	AT1202.O05ID, O5.AnaName as ObjectAnaName5,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	0 AS OExpenseConvertedAmount,
	-ActualQuantity AS SignQuantity, 
		-ConvertedQuantity AS SignConvertedQuantity, 
	-ConvertedAmount AS SignAmount,	
	D16.VoucherTypeID,
	0 AS KindVoucherID,
	(CASE WHEN  D17.TranMonth <10 then '0'+rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) 
	Else rtrim(ltrim(str(D17.TranMonth)))+'/'+ltrim(Rtrim(str(D17.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D17.TranMonth %3 = 0 then D17.TranMonth/3  Else D17.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D17.TranYear)))
	)  AS Quarter ,
	str(D17.TranYear) AS Year, D17.SourceNo,
	D17.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
	,NULL AS ProductID, NULL AS MOrderID, NULL AS ProductName,
	D02.Barcode,D16.Description AS VoucherDesc,
	D17.MarkQuantity, -D17.MarkQuantity as SignMarkQuantity,
	D17.DebitAccountID as InventoryAccountID,
    isnull(D02.IsBottle,0)  as IsBottle
    
	
FROM AT2017 AS D17 
INNER JOIN AT2016 AS D16 ON D16.VoucherID = D17.VoucherID AND D16.DivisionID = D17.DivisionID 
LEFT JOIN AT1202 ON AT1202.ObjectID = D16.ObjectID  AND AT1202.DivisionID = D17.DivisionID
INNER JOIN AT1302 AS D02 ON D02.InventoryID = D17.InventoryID  AND D02.DivisionID = D17.DivisionID
LEFT JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID  AND D04.DivisionID = D17.DivisionID
INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D16.WareHouseID  AND D03.DivisionID = D17.DivisionID
LEFT JOIN AT1015 O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID AND O5.DivisionID = D17.DivisionID
LEFT JOIN AT1304 AS D05 ON D05.UnitID = D17.ConvertedUnitID  AND D05.DivisionID = D17.DivisionID

WHERE ISNULL(CreditAccountID,'') <>''

UNION ALL  -- Nhap kho

SELECT  D07.DivisionID, D07.TranMonth, D07.TranYear,
	D06.WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'D' AS D_C,  --- Phat sinh No
	RefNo01 AS RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName,
	AT1202.O05ID, O5.AnaName as ObjectAnaName5,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,
	D03.WareHouseName,	
	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	isnull(OExpenseConvertedAmount,0) as OExpenseConvertedAmount,
	ActualQuantity AS SignQuantity, 
	ConvertedQuantity AS SignConvertedQuantity, 
	ConvertedAmount AS SignAmount,	
	D06.VoucherTypeID,
	CASE WHEN  KindVoucherID = 3 then 3 else 0 end AS KindVoucherID,
	(CASE WHEN  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  AS Quarter ,
	str(D07.TranYear) AS Year, D07.SourceNo,
	D07.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
    ,D07.ProductID, D07.MOrderID, P02.InventoryName AS ProductName,
    D02.Barcode,D06.Description AS VoucherDesc,
	D07.MarkQuantity, D07.MarkQuantity as SignMarkQuantity,
    D07.DebitAccountID as InventoryAccountID, isnull(D02.IsBottle,0)  as IsBottle
    
FROM AT2007 AS D07 
INNER JOIN AT2006 D06 ON D06.VoucherID = D07.VoucherID AND D06.DivisionID = D07.DivisionID
LEFT JOIN AT1202 ON AT1202.ObjectID = D06.ObjectID  AND AT1202.DivisionID = D07.DivisionID
INNER JOIN AT1302 AS D02 ON D02.InventoryID = D07.InventoryID  AND D02.DivisionID = D07.DivisionID
LEFT JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID  AND D04.DivisionID = D07.DivisionID
INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D06.WareHouseID  AND D03.DivisionID = D07.DivisionID
LEFT JOIN AT1302 AS P02 ON P02.InventoryID = D07.ProductID  AND P02.DivisionID = D07.DivisionID
LEFT JOIN AT1015 O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID  AND O5.DivisionID = D07.DivisionID
LEFT JOIN AT1304 AS D05 ON D05.UnitID = D07.ConvertedUnitID	 AND D05.DivisionID = D07.DivisionID

WHERE D06.KindVoucherID in (1,3,5,7,9,15,17)

UNION ALL  -- xuat kho

SELECT  D07.DivisionID, D07.TranMonth, D07.TranYear,
	CASE WHEN D06.KindVoucherID = 3 then D06.WareHouseID2 Else  D06.WareHouseID End AS WareHouseID, 
	D07.InventoryID, D07.DebitAccountID, D07.CreditAccountID,
	'C' AS D_C,  --- So du Co
	RefNo01 AS RefNo01, RefNo02, 	D07.Notes,
	D06.VoucherID, D06.VoucherDate, D06.VoucherNo, 
	D06.ObjectID,AT1202.ObjectName, 	
	AT1202.O05ID,O5.AnaName as ObjectAnaName5,
	AT1202.Address,
	D02.InventoryName, D02.UnitID, D04.UnitName, D02.InventoryTypeID , D02.VATPercent,
	CASE WHEN D06.KindVoucherID = 3 then D031.WareHouseName Else  D03.WareHouseName End  AS WareHouseName,	

	ActualQuantity, 
	ConvertedQuantity, 
	ConvertedAmount,
	isnull(OExpenseConvertedAmount,0) as OExpenseConvertedAmount,
	-ActualQuantity AS SignQuantity, 
	-ConvertedQuantity AS SignConvertedQuantity, 
	-ConvertedAmount AS SignAmount,	
	D06.VoucherTypeID,
	CASE WHEN  KindVoucherID = 3 then 3 else 0 end AS KindVoucherID,
	(CASE WHEN  D07.TranMonth <10 then '0'+rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) 
	Else rtrim(ltrim(str(D07.TranMonth)))+'/'+ltrim(Rtrim(str(D07.TranYear))) End) AS MonthYear,
	('0'+ ltrim(rtrim(CASE WHEN D07.TranMonth %3 = 0 then D07.TranMonth/3  Else D07.TranMonth/3+1  End))+'/'+ltrim(Rtrim(str(D07.TranYear)))
	)  AS Quarter ,
	str(D07.TranYear) AS Year, D07.SourceNo,
	D07.ConvertedUnitID, D05.UnitName AS ConvertedUnitName
	,D07.ProductID, D07.MOrderID, P02.InventoryName AS ProductName,
	D02.Barcode,D06.Description AS VoucherDesc,
	D07.MarkQuantity, D07.MarkQuantity as SignMarkQuantity,
	D07.CreditAccountID as InventoryAccountID, isnull(D02.IsBottle, 0)  as IsBottle
	
    
	
From AT2007 AS D07 
INNER JOIN AT2006 D06 ON D06.VoucherID = D07.VoucherID AND D06.DivisionID = D07.DivisionID
LEFT JOIN AT1202 ON AT1202.ObjectID = D06.ObjectID AND AT1202.DivisionID = D07.DivisionID
INNER JOIN AT1302 AS D02 ON D02.InventoryID = D07.InventoryID AND D02.DivisionID = D07.DivisionID
LEFT JOIN AT1304 AS D04 ON D04.UnitID = D02.UnitID AND D04.DivisionID = D07.DivisionID
INNER JOIN AT1303 AS D03 ON D03.WareHouseID = D06.WareHouseID AND D03.DivisionID = D07.DivisionID
LEFT JOIN AT1302 AS P02 ON P02.InventoryID = D07.ProductID  AND P02.DivisionID = D07.DivisionID
LEFT JOIN AT1303 AS  D031 ON D031.WareHouseID = D06.WareHouseID2 AND D031.DivisionID = D07.DivisionID
LEFT JOIN AT1015 O5 ON 	O5.AnaTypeID = 'O05' AND O5.AnaID = AT1202.O05ID AND O5.DivisionID = D07.DivisionID
LEFT JOIN AT1304 AS D05 ON D05.UnitID = D07.ConvertedUnitID  AND D05.DivisionID = D07.DivisionID


Where D06.KindVoucherID in (2,3,4,6,8,10,14,20)



GO
