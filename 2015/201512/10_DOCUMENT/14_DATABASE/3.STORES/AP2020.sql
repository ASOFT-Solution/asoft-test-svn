IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2020]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP2020]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [28/07/2010]
'********************************************/

---- Create by Tiểu Mai, Date 06/11/2015
---- Purpose: Nhat ky nhap xuat kho theo quy cách hàng


CREATE PROCEDURE [dbo].[AP2020]
       @DivisionID AS nvarchar(50) ,
       @FromWareHouseID AS nvarchar(50) ,
       @ToWareHouseID AS nvarchar(50) ,
       @FromInventoryID AS nvarchar(50) ,
       @ToInventoryID AS nvarchar(50) ,
       @FromDate AS datetime ,
       @ToDate AS DATETIME
AS
SET NOCOUNT ON
DECLARE
        @sSQLSelect AS nvarchar(4000) ,
        @AT2020Cursor AS cursor ,
        @WareHouseID AS nvarchar(50) ,
        @VoucherID AS nvarchar(50) ,
        @TransactionID AS nvarchar(50) ,
        @VoucherDate AS datetime ,
        @InventoryID AS nvarchar(50) ,
        @BeginQuantity AS decimal(28,8) ,
        @BeginAmount AS decimal(28,8) ,
        @ImQuantity AS decimal(28,8) ,
        @ExQuantity AS decimal(28,8) ,
        @ImQuant AS decimal(28,8) ,
        @ExQuant AS decimal(28,8) ,
        @EndQuant AS decimal(28,8) ,
        @ImAmount AS decimal(28,8) ,
        @ExAmount AS decimal(28,8) ,
        @ImportAmount AS decimal(28,8) ,
        @ExportAmount AS decimal(28,8) ,
        @EndAmount AS decimal(28,8) ,
        @Orders AS nvarchar(250) ,
        @WareHouseID2 AS nvarchar(50) ,
        @WareHouseID1 AS nvarchar(200) ,
        @KindVoucherListIm AS nvarchar(200) ,
        @KindVoucherListEx1 AS nvarchar(200), 
        @KindVoucherListEx2 AS nvarchar(200), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20),
		@S01ID VARCHAR(50),
		@S02ID VARCHAR(50),
		@S03ID VARCHAR(50),
		@S04ID VARCHAR(50),
		@S05ID VARCHAR(50),
		@S06ID VARCHAR(50),
		@S07ID VARCHAR(50),
		@S08ID VARCHAR(50),
		@S09ID VARCHAR(50),
		@S10ID VARCHAR(50),
		@S11ID VARCHAR(50),
		@S12ID VARCHAR(50),
		@S13ID VARCHAR(50),
		@S14ID VARCHAR(50),
		@S15ID VARCHAR(50),
		@S16ID VARCHAR(50),
		@S17ID VARCHAR(50),
		@S18ID VARCHAR(50),
		@S19ID VARCHAR(50),
		@S20ID VARCHAR(50)
    
	SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
	SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

	SET @KindVoucherListEx1 = '(2,4,3,8,10,14,20) '
	SET @KindVoucherListEx2 = '(2,4,8,10,14,20) '
	SET @KindVoucherListIm = '(1,3,5,7,9,15,17) '

	SET @WareHouseID2 = ' AT2006.WareHouseID '
	SET @WareHouseID1 = ' Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end '
	EXEC AP7012 @DivisionID , @FromWareHouseID , @ToWareHouseID , @FromInventoryID , @ToInventoryID , '%' , 11 , 2015 , 11 , 2015 , @FromDate , @ToDate , 1 , 1
	--SELECT * FROM AV7012
	
	
	SET @sSQLSelect = '
		SELECT		DivisionID, WareHouseID, 
					InventoryID,
					sum(isnull(BeginQuantity,0)) AS BeginQuantity,
					sum(isnull(BeginAmount,0)) AS BeginAmount,
					S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID, S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
		FROM		AV7012
		WHERE		DivisionID = ''' + @DivisionID + '''
		GROUP BY	DivisionID, WareHouseID, InventoryID, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID, S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
		'

	IF NOT EXISTS ( SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[AV2020_1]') AND OBJECTPROPERTY(id , N'IsView') = 1 )
	   BEGIN
			 EXEC ( '  CREATE VIEW AV2020_1 	--CREATED BY AP2020
						AS '+@sSQLSelect )
	   END
	ELSE
	   BEGIN
			 EXEC ( '  ALTER VIEW AV2020_1 	--CREATED BY AP2020
						AS '+@sSQLSelect )
	   END

	IF EXISTS ( SELECT TOP 1 1 FROM SysObjects WHERE ID = Object_ID('AT20201_Tmp') AND xType = 'U' )
   BEGIN
         DROP TABLE AT20201_Tmp
   END
	EXEC ( 'SELECT * INTO AT20201_Tmp FROM AV2020_1' )

	DECLARE
        @sSQLFrom AS nvarchar(4000) ,
        @sSQLWhere AS nvarchar(4000) ,
        @sSQLUnionSelect AS nvarchar(4000) ,
        @sSQLUnionFrom AS nvarchar(4000) ,
        @sSQLUnionWhere AS nvarchar(4000)

	SET @sSQLSelect = '
		---1 Phan Nhap kho
		Select 	' + @WareHouseID2 + ' AS WareHouseID,
			AT1303.WareHouseName, 
			AT2006.VoucherID,
			AT2007.TransactionID,
			--cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in' + @KindVoucherListIm + ' then 1 else 2 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
			cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in(1,5,7,9,15,17)  then 1  When AT2006.KindVoucherID=3 then 2 Else  3 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
			AT2006.VoucherDate,
			VoucherNo,	
			VoucherDate AS ImVoucherDate,
			VoucherNo AS ImVoucherNo,		
			SourceNo AS ImSourceNo,
			AT2006.WareHouseID AS ImWareHouseID,		
			AT2007.ActualQuantity AS ImQuantity,
			AT2007.UnitPrice AS ImUnitPrice ,
			AT2007.ConvertedAmount AS ImConvertedAmount,
			AT2007.OriginalAmount AS ImOriginalAmount,
			isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ImConvertedQuantity,
			Null AS ExVoucherDate,
			Null AS ExVoucherNo,		
			Null AS ExSourceNo,
			Null AS ExWareHouseID,		
			0 AS ExQuantity,
			Null AS ExUnitPrice ,
			0 AS ExConvertedAmount,
			0 AS ExOriginalAmount,
			0 AS ExConvertedQuantity,
			VoucherTypeID,
			AT2006.Description,
			AT2006.RefNo01,AT2006.RefNo02,
			AT2007.InventoryID,	
			AT1302.InventoryName,
			AT2007.UnitID,		
			isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
			AT1309.UnitID AS ConversionUnitID,
			AT1309.ConversionFactor AS ConversionFactor2,
			AT1309.Operator,
			isnull(AV2015.BeginQuantity,0) AS BeginQuantity,
			isnull(AV2015.BeginAmount,0) AS BeginAmount,
			0 AS EndQuantity,
			0 AS EndAmount,
			AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
			A1.AnaName AS Ana01Name, A2.AnaName AS Ana02Name, A3.AnaName AS Ana03Name, A4.AnaName AS Ana04Name, A5.AnaName AS Ana05Name, AT1302.Notes01,
			AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
			I1.AnaName AS I01Name, I2.AnaName AS I02Name, I3.AnaName AS I03Name, I4.AnaName AS I04Name, I5.AnaName AS I05Name,
			AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID, AT2007.DebitAccountID, AT2007.CreditAccountID,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
			 '

	SET @sSQLFrom = ' 
		FROM AT2007
		LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID 	
		INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
		INNER JOIN AT2006 on AT2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
		INNER JOIN AT1303 on AT1303.WarehouseID = AT2006.WarehouseID AND AT1303.DivisionID = AT2007.DivisionID
		LEFT JOIN AT20201_Tmp AV2015 on AV2015.InventoryID = AT2007.InventoryID and
 				AV2015.WareHouseID = AT2006.WareHouseID  AND AV2015.DivisionID = AT2007.DivisionID AND 
 				ISNULL(AV2015.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
				ISNULL(AV2015.S02ID,'''') = Isnull(O99.S02ID,'''') AND
				ISNULL(AV2015.S03ID,'''') = Isnull(O99.S03ID,'''') AND
				ISNULL(AV2015.S04ID,'''') = Isnull(O99.S04ID,'''') AND
				ISNULL(AV2015.S05ID,'''') = Isnull(O99.S05ID,'''') AND 
				ISNULL(AV2015.S06ID,'''') = Isnull(O99.S06ID,'''') AND
				ISNULL(AV2015.S07ID,'''') = Isnull(O99.S07ID,'''') AND
				ISNULL(AV2015.S08ID,'''') = Isnull(O99.S08ID,'''') AND
				ISNULL(AV2015.S09ID,'''') = Isnull(O99.S09ID,'''') AND
				ISNULL(AV2015.S10ID,'''') = Isnull(O99.S10ID,'''') AND
				ISNULL(AV2015.S11ID,'''') = Isnull(O99.S11ID,'''') AND 
				ISNULL(AV2015.S12ID,'''') = Isnull(O99.S12ID,'''') AND
				ISNULL(AV2015.S13ID,'''') = Isnull(O99.S13ID,'''') AND
				ISNULL(AV2015.S14ID,'''') = Isnull(O99.S14ID,'''') AND
				ISNULL(AV2015.S15ID,'''') = Isnull(O99.S15ID,'''') AND
				ISNULL(AV2015.S16ID,'''') = Isnull(O99.S16ID,'''') AND
				ISNULL(AV2015.S17ID,'''') = Isnull(O99.S17ID,'''') AND
				ISNULL(AV2015.S18ID,'''') = Isnull(O99.S18ID,'''') AND
				ISNULL(AV2015.S19ID,'''') = Isnull(O99.S19ID,'''') AND
				ISNULL(AV2015.S20ID,'''') = Isnull(O99.S20ID,'''')
		LEFT JOIN (SELECT	DivisionID,InventoryID,Min(UnitID) AS UnitID, 
							Min(ConversionFactor) AS ConversionFactor, 
							Min(Operator) AS Operator 
				   FROM		AT1309 
				   GROUP BY DivisionID,InventoryID) AT1309 
			ON	AT2007.InventoryID = AT1309.InventoryID AND AT1309.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A1 On AT2007.Ana01ID = A1.AnaID AND A1.AnaTypeID = ''A01''  AND A1.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A2 On AT2007.Ana02ID = A2.AnaID AND A2.AnaTypeID = ''A02''  AND A2.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A3 On AT2007.Ana03ID = A3.AnaID AND A3.AnaTypeID = ''A03''  AND A3.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A4 On AT2007.Ana04ID = A4.AnaID AND A4.AnaTypeID = ''A04''  AND A4.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A5 On AT2007.Ana05ID = A5.AnaID AND A5.AnaTypeID = ''A05''  AND A5.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I1 On AT1302.I01ID = I1.AnaID AND I1.AnaTypeID = ''I01''  AND I1.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I2 On AT1302.I02ID = I2.AnaID AND I2.AnaTypeID = ''I02''  AND I2.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I3 On AT1302.I03ID = I3.AnaID AND I3.AnaTypeID = ''I03''  AND I3.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I4 On AT1302.I04ID = I4.AnaID AND I4.AnaTypeID = ''I04''  AND I4.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I5 On AT1302.I05ID = I5.AnaID AND I5.AnaTypeID = ''I05''  AND I5.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1202 On AT2006.ObjectID = AT1202.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID'
	SET @sSQLWhere = ' 
		WHERE	AT2007.DivisionID =''' + @DivisionID + ''' and
			(AT2006.VoucherDate Between ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) and
			KindVoucherID in ' + @KindVoucherListIm + ' and
			(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') and
			(AT2006.WareHouseID between N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')'
	SET @sSQLUnionSelect = ' 
		UNION ALL

		--- Phan Xuat kho
		SELECT 	' + @WareHouseID1 + ' AS WareHouseID,
			AT1303.WareHouseName, 
			AT2006.VoucherID,
			AT2007.TransactionID,
			--cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in' + @KindVoucherListIm + ' then 1 else 2 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
			cast(Day(AT2006.VoucherDate)+Month(AT2006.VoucherDate)* 100 + Year(AT2006.VoucherDate)*10000 AS char(8)) +  cast((Case when AT2006.KindVoucherID in(1,5,7,9,15,17)  then 1  When AT2006.KindVoucherID=3 then 2 Else  3 end) AS char(1)) + cast(AT2006.VoucherNo AS char(20))+ cast(AT2007.TransactionID AS char(20)) + cast(AT2007.InventoryID AS char(20))  AS Orders,
			AT2006.VoucherDate,
			VoucherNo,	
			Null AS ImVoucherDate,
			Null AS ImVoucherNo,		
			Null AS ImSourceNo,
			Null AS ImWareHouseID,	
			0 AS ImQuantity,
			Null AS ImUnitPrice ,
			0 AS ImConvertedAmount,
			0 AS ImOriginalAmount,
			0 AS ImConvertedQuantity,
			VoucherDate AS ExVoucherDate,
			VoucherNo AS ExVoucherNo,		
			SourceNo AS ExSourceNo,
			(Case when KindVoucherID = 3 then WareHouseID2 else AT2006.WareHouseID end) AS ExWareHouseID,	
			AT2007.ActualQuantity AS ExQuantity,
			AT2007.UnitPrice AS ExUnitPrice ,
			AT2007.ConvertedAmount AS ExConvertedAmount,
			AT2007.OriginalAmount AS ExOriginalAmount,
			isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ExConvertedQuantity,
			VoucherTypeID,
			AT2006.Description,
			AT2006.RefNo01,AT2006.RefNo02,
			AT2007.InventoryID,	
			AT1302.InventoryName,
			AT2007.UnitID,		
			isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
			AT1309.UnitID AS ConversionUnitID,
			AT1309.ConversionFactor AS ConversionFactor2,
			AT1309.Operator,
			isnull(AV2015.BeginQuantity,0) AS BeginQuantity,
			isnull(AV2015.BeginAmount,0) AS BeginAmount,
			0 AS EndQuantity,
			0 AS EndAmount,

			AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
			A1.AnaName AS Ana01Name, A2.AnaName AS Ana02Name, A3.AnaName AS Ana03Name, A4.AnaName AS Ana04Name, A5.AnaName AS Ana05Name, AT1302.Notes01,
			AT1302.I01ID, AT1302.I02ID, AT1302.I03ID, AT1302.I04ID, AT1302.I05ID,
			I1.AnaName AS I01Name, I2.AnaName AS I02Name, I3.AnaName AS I03Name, I4.AnaName AS I04Name, I5.AnaName AS I05Name,
			AT2006.ObjectID, AT1202.ObjectName, AT2007.DivisionID ,AT2007.DebitAccountID, AT2007.CreditAccountID,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID '

	SET @sSQLUnionFrom = ' 
		FROM AT2007
		LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID 	
		INNER JOIN AT1302 on AT1302.InventoryID = AT2007.InventoryID AND  AT1302.DivisionID = AT2007.DivisionID
		INNER JOIN AT2006 on AT2006.VoucherID = AT2007.VoucherID AND  AT2006.DivisionID = AT2007.DivisionID
		INNER JOIN AT1303 on AT1303.WareHouseID = 
			(Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end)  AND  AT1303.DivisionID = AT2007.DivisionID
		LEFT JOIN AT20201_Tmp AV2015 on AV2015.InventoryID = AT2007.InventoryID and
			AV2015.WareHouseID = (Case When KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end)  AND  AV2015.DivisionID = AT2007.DivisionID and
			ISNULL(AV2015.S01ID,'''') = Isnull(O99.S01ID,'''') AND 
			ISNULL(AV2015.S02ID,'''') = Isnull(O99.S02ID,'''') AND
			ISNULL(AV2015.S03ID,'''') = Isnull(O99.S03ID,'''') AND
			ISNULL(AV2015.S04ID,'''') = Isnull(O99.S04ID,'''') AND
			ISNULL(AV2015.S05ID,'''') = Isnull(O99.S05ID,'''') AND 
			ISNULL(AV2015.S06ID,'''') = Isnull(O99.S06ID,'''') AND
			ISNULL(AV2015.S07ID,'''') = Isnull(O99.S07ID,'''') AND
			ISNULL(AV2015.S08ID,'''') = Isnull(O99.S08ID,'''') AND
			ISNULL(AV2015.S09ID,'''') = Isnull(O99.S09ID,'''') AND
			ISNULL(AV2015.S10ID,'''') = Isnull(O99.S10ID,'''') AND
			ISNULL(AV2015.S11ID,'''') = Isnull(O99.S11ID,'''') AND 
			ISNULL(AV2015.S12ID,'''') = Isnull(O99.S12ID,'''') AND
			ISNULL(AV2015.S13ID,'''') = Isnull(O99.S13ID,'''') AND
			ISNULL(AV2015.S14ID,'''') = Isnull(O99.S14ID,'''') AND
			ISNULL(AV2015.S15ID,'''') = Isnull(O99.S15ID,'''') AND
			ISNULL(AV2015.S16ID,'''') = Isnull(O99.S16ID,'''') AND
			ISNULL(AV2015.S17ID,'''') = Isnull(O99.S17ID,'''') AND
			ISNULL(AV2015.S18ID,'''') = Isnull(O99.S18ID,'''') AND
			ISNULL(AV2015.S19ID,'''') = Isnull(O99.S19ID,'''') AND
			ISNULL(AV2015.S20ID,'''') = Isnull(O99.S20ID,'''')
		LEFT JOIN (SELECT	DivisionID,InventoryID,Min(UnitID) AS UnitID, 
							Min(ConversionFactor) AS ConversionFactor, 
							Min(Operator) AS Operator 
				   FROM		AT1309 
				   GROUP BY DivisionID,InventoryID) AT1309 
			ON	AT2007.InventoryID = AT1309.InventoryID AND  AT1309.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A1 On AT2007.Ana01ID = A1.AnaID AND A1.AnaTypeID = ''A01''  AND  A1.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A2 On AT2007.Ana02ID = A2.AnaID AND A2.AnaTypeID = ''A02''  AND  A2.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A3 On AT2007.Ana03ID = A3.AnaID AND A3.AnaTypeID = ''A03''  AND  A3.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A4 On AT2007.Ana04ID = A4.AnaID AND A4.AnaTypeID = ''A04''  AND  A4.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1011 A5 On AT2007.Ana05ID = A5.AnaID AND A5.AnaTypeID = ''A05''  AND  A5.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I1 On AT1302.I01ID = I1.AnaID AND I1.AnaTypeID = ''I01''  AND  I1.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I2 On AT1302.I02ID = I2.AnaID AND I2.AnaTypeID = ''I02''  AND  I2.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I3 On AT1302.I03ID = I3.AnaID AND I3.AnaTypeID = ''I03''  AND  I3.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I4 On AT1302.I04ID = I4.AnaID AND I4.AnaTypeID = ''I04''  AND  I4.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1015 I5 On AT1302.I05ID = I5.AnaID AND I5.AnaTypeID = ''I05''  AND  I5.DivisionID = AT2007.DivisionID
		LEFT JOIN AT1202 On AT2006.ObjectID = AT1202.ObjectID  AND  AT1202.DivisionID = AT2007.DivisionID'
	SET @sSQLUnionWhere = ' 
Where	AT2007.DivisionID =''' + @DivisionID + ''' and
	(AT2006.VoucherDate Between ''' + @FromDateText + ''' AND ''' + @ToDateText + ''' ) and
	(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') and
	( (KindVoucherID in ' + @KindVoucherListEx2 + ' AND  
	(AT2006.WareHouseID between N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')) 
	or  (KindVoucherID = 3 AND (AT2006.WareHouseID2 between N''' + @FromWareHouseID + ''' AND N''' + @ToWareHouseID + ''')))
'
--PRINT (@sSQLSelect)
--PRINT (@sSQLFrom)
--PRINT(@sSQLWhere)
--PRINT(@sSQLUnionSelect)
--PRINT(@sSQLUnionFrom)
--PRINT(@sSQLUnionWhere)

	IF EXISTS ( SELECT TOP 1 1 FROM SysObjects  WHERE Name = 'AT2020' AND Xtype = 'U' )
	BEGIN
         DROP TABLE [dbo].[AT2020]
	
         CREATE TABLE [dbo].[AT2020]
         (
			--[APK] [uniqueidentifier] DEFAULT NEWID(),
			[WareHouseID] [nvarchar](50) NOT NULL ,
			[WareHouseName] [nvarchar](250) NULL ,
			[VoucherID] [nvarchar](50) NOT NULL ,
			[TransactionID] [nvarchar](50) NOT NULL ,
			[Orders] [nvarchar](250) NULL ,
			[VoucherDate] [datetime] NULL ,
			[VoucherNo] [nvarchar](50) NULL ,
			[ImVoucherDate] [datetime] NULL ,
			[ImVoucherNo] [nvarchar](50) NULL ,
			[ImSourceNo] [nvarchar](50) NULL ,
			[ImWareHouseID] [nvarchar](50) NULL ,
			[ImQuantity] [decimal](28,8) NULL ,
			[ImUnitPrice] [decimal](28,8) NULL ,
			[ImConvertedAmount] [decimal](28,8) NULL ,
			[ImOriginalAmount] [decimal](28,8) NULL ,
			[ImConvertedQuantity] [decimal](28,8) NULL ,
			[ExVoucherDate] [datetime] NULL ,
			[ExVoucherNo] [nvarchar](50) NULL ,
			[ExSourceNo] [nvarchar](50) NULL ,
			[ExWareHouseID] [nvarchar](50) NULL ,
			[ExQuantity] [decimal](28,8) NULL ,
			[ExUnitPrice] [decimal](28,8) NULL ,
			[ExConvertedAmount] [decimal](28,8) NULL ,
			[ExOriginalAmount] [decimal](28,8) NULL ,
			[ExConvertedQuantity] [decimal](28,8) NULL ,
			[VoucherTypeID] [nvarchar](50) NULL ,
			[Description] [nvarchar](250) NULL ,
			RefNo01 [nvarchar](100) NULL ,
			RefNo02 [nvarchar](100) NULL ,
			[InventoryID] [nvarchar](50) NULL ,
			[InventoryName] [nvarchar](250) NULL ,
			[UnitID] [nvarchar](50) NULL ,
			[ConversionFactor] [decimal](28,8) NULL ,
			[ConversionUnitID] [nvarchar](50) NULL ,
			[ConversionFactor2] [decimal](28,8) NULL ,
			[Operator] [tinyint] NULL ,
			[BeginQuantity] [decimal](28,8) NULL ,
			[BeginAmount] [decimal](28,8) NULL ,
			[EndQuantity] [decimal](28,8) NULL ,
			[EndAmount] [decimal](28,8) NULL ,
			[Ana01ID] [nvarchar](50) NULL ,
			[Ana02ID] [nvarchar](50) NULL ,
			[Ana03ID] [nvarchar](50) NULL ,
			[Ana04ID] [nvarchar](50) NULL ,
			[Ana05ID] [nvarchar](50) NULL ,
			[Ana01Name] [nvarchar](250) NULL ,
			[Ana02Name] [nvarchar](250) NULL ,
			[Ana03Name] [nvarchar](250) NULL ,
			[Ana04Name] [nvarchar](250) NULL ,
			[Ana05Name] [nvarchar](250) NULL ,
			[Notes01] [nvarchar](500) NULL ,
			[I01ID] [nvarchar](50) NULL ,
			[I02ID] [nvarchar](50) NULL ,
			[I03ID] [nvarchar](50) NULL ,
			[I04ID] [nvarchar](50) NULL ,
			[I05ID] [nvarchar](50) NULL ,
			[I01Name] [nvarchar](250) NULL ,
			[I02Name] [nvarchar](250) NULL ,
			[I03Name] [nvarchar](250) NULL ,
			[I04Name] [nvarchar](250) NULL ,
			[I05Name] [nvarchar](250) NULL ,
			[ObjectID] [nvarchar](50) NULL ,
			[ObjectName] [nvarchar](250) NULL ,
			[DivisionID] [nvarchar] (3) NOT NULL,
			[DebitAccountID] [nvarchar] (50) NULL,
			[CreditAccountID] [nvarchar] (50) NULL,
			[S01ID] [VARCHAR] (50) NULL,
			[S02ID] [VARCHAR] (50) NULL,
			[S03ID] [VARCHAR] (50) NULL,
			[S04ID] [VARCHAR] (50) NULL,
			[S05ID] [VARCHAR] (50) NULL,
			[S06ID] [VARCHAR] (50) NULL,
			[S07ID] [VARCHAR] (50) NULL,
			[S08ID] [VARCHAR] (50) NULL,
			[S09ID] [VARCHAR] (50) NULL,
			[S10ID] [VARCHAR] (50) NULL,
			[S11ID] [VARCHAR] (50) NULL,
			[S12ID] [VARCHAR] (50) NULL,
			[S13ID] [VARCHAR] (50) NULL,
			[S14ID] [VARCHAR] (50) NULL,
			[S15ID] [VARCHAR] (50) NULL,
			[S16ID] [VARCHAR] (50) NULL,
			[S17ID] [VARCHAR] (50) NULL,
			[S18ID] [VARCHAR] (50) NULL,
			[S19ID] [VARCHAR] (50) NULL,
			[S20ID] [VARCHAR] (50) NULL,
--	CONSTRAINT [PK_AT2018] PRIMARY KEY NONCLUSTERED 
--(
--	[APK] ASC
--    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--) ON [PRIMARY]
) ON [PRIMARY]
	END
	ELSE 
		CREATE TABLE [dbo].[AT2020]
         (
			--[APK] [uniqueidentifier] DEFAULT NEWID(),
			[WareHouseID] [nvarchar](50) NOT NULL ,
			[WareHouseName] [nvarchar](250) NULL ,
			[VoucherID] [nvarchar](50) NOT NULL ,
			[TransactionID] [nvarchar](50) NOT NULL ,
			[Orders] [nvarchar](250) NULL ,
			[VoucherDate] [datetime] NULL ,
			[VoucherNo] [nvarchar](50) NULL ,
			[ImVoucherDate] [datetime] NULL ,
			[ImVoucherNo] [nvarchar](50) NULL ,
			[ImSourceNo] [nvarchar](50) NULL ,
			[ImWareHouseID] [nvarchar](50) NULL ,
			[ImQuantity] [decimal](28,8) NULL ,
			[ImUnitPrice] [decimal](28,8) NULL ,
			[ImConvertedAmount] [decimal](28,8) NULL ,
			[ImOriginalAmount] [decimal](28,8) NULL ,
			[ImConvertedQuantity] [decimal](28,8) NULL ,
			[ExVoucherDate] [datetime] NULL ,
			[ExVoucherNo] [nvarchar](50) NULL ,
			[ExSourceNo] [nvarchar](50) NULL ,
			[ExWareHouseID] [nvarchar](50) NULL ,
			[ExQuantity] [decimal](28,8) NULL ,
			[ExUnitPrice] [decimal](28,8) NULL ,
			[ExConvertedAmount] [decimal](28,8) NULL ,
			[ExOriginalAmount] [decimal](28,8) NULL ,
			[ExConvertedQuantity] [decimal](28,8) NULL ,
			[VoucherTypeID] [nvarchar](50) NULL ,
			[Description] [nvarchar](250) NULL ,
			RefNo01 [nvarchar](100) NULL ,
			RefNo02 [nvarchar](100) NULL ,
			[InventoryID] [nvarchar](50) NULL ,
			[InventoryName] [nvarchar](250) NULL ,
			[UnitID] [nvarchar](50) NULL ,
			[ConversionFactor] [decimal](28,8) NULL ,
			[ConversionUnitID] [nvarchar](50) NULL ,
			[ConversionFactor2] [decimal](28,8) NULL ,
			[Operator] [tinyint] NULL ,
			[BeginQuantity] [decimal](28,8) NULL ,
			[BeginAmount] [decimal](28,8) NULL ,
			[EndQuantity] [decimal](28,8) NULL ,
			[EndAmount] [decimal](28,8) NULL ,
			[Ana01ID] [nvarchar](50) NULL ,
			[Ana02ID] [nvarchar](50) NULL ,
			[Ana03ID] [nvarchar](50) NULL ,
			[Ana04ID] [nvarchar](50) NULL ,
			[Ana05ID] [nvarchar](50) NULL ,
			[Ana01Name] [nvarchar](250) NULL ,
			[Ana02Name] [nvarchar](250) NULL ,
			[Ana03Name] [nvarchar](250) NULL ,
			[Ana04Name] [nvarchar](250) NULL ,
			[Ana05Name] [nvarchar](250) NULL ,
			[Notes01] [nvarchar](500) NULL ,
			[I01ID] [nvarchar](50) NULL ,
			[I02ID] [nvarchar](50) NULL ,
			[I03ID] [nvarchar](50) NULL ,
			[I04ID] [nvarchar](50) NULL ,
			[I05ID] [nvarchar](50) NULL ,
			[I01Name] [nvarchar](250) NULL ,
			[I02Name] [nvarchar](250) NULL ,
			[I03Name] [nvarchar](250) NULL ,
			[I04Name] [nvarchar](250) NULL ,
			[I05Name] [nvarchar](250) NULL ,
			[ObjectID] [nvarchar](50) NULL ,
			[ObjectName] [nvarchar](250) NULL ,
			[DivisionID] [nvarchar] (3) NOT NULL,
			[DebitAccountID] [nvarchar] (50) NULL,
			[CreditAccountID] [nvarchar] (50) NULL,
			[S01ID] [VARCHAR] (50) NULL,
			[S02ID] [VARCHAR] (50) NULL,
			[S03ID] [VARCHAR] (50) NULL,
			[S04ID] [VARCHAR] (50) NULL,
			[S05ID] [VARCHAR] (50) NULL,
			[S06ID] [VARCHAR] (50) NULL,
			[S07ID] [VARCHAR] (50) NULL,
			[S08ID] [VARCHAR] (50) NULL,
			[S09ID] [VARCHAR] (50) NULL,
			[S10ID] [VARCHAR] (50) NULL,
			[S11ID] [VARCHAR] (50) NULL,
			[S12ID] [VARCHAR] (50) NULL,
			[S13ID] [VARCHAR] (50) NULL,
			[S14ID] [VARCHAR] (50) NULL,
			[S15ID] [VARCHAR] (50) NULL,
			[S16ID] [VARCHAR] (50) NULL,
			[S17ID] [VARCHAR] (50) NULL,
			[S18ID] [VARCHAR] (50) NULL,
			[S19ID] [VARCHAR] (50) NULL,
			[S20ID] [VARCHAR] (50) NULL,
--	CONSTRAINT [PK_AT2018] PRIMARY KEY NONCLUSTERED 
--(
--	[APK] ASC
--    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

--) ON [PRIMARY]
) ON [PRIMARY]

	EXEC ( 'INSERT INTO AT2020  (WareHouseID, WareHouseName, 	VoucherID,
	TransactionID, Orders,VoucherDate,
	VoucherNo, ImVoucherDate, ImVoucherNo,ImSourceNo, ImWareHouseID, ImQuantity, ImUnitPrice ,
	ImConvertedAmount, ImOriginalAmount, ImConvertedQuantity, ExVoucherDate,
	 ExVoucherNo,	 ExSourceNo, ExWareHouseID,	ExQuantity,ExUnitPrice ,
	ExConvertedAmount,ExOriginalAmount, ExConvertedQuantity,
	VoucherTypeID, Description, RefNo01,RefNo02,InventoryID,	
	InventoryName,UnitID,	 ConversionFactor, ConversionUnitID, ConversionFactor2, Operator, 
	BeginQuantity, BeginAmount, EndQuantity,EndAmount,
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,Ana01Name, Ana02Name, Ana03Name, Ana04Name, Ana05Name,Notes01,
	I01ID, I02ID, I03ID, I04ID, I05ID,I01Name, I02Name, I03Name, I04Name, I05Name, ObjectID, ObjectName, DivisionID,
	DebitAccountID ,CreditAccountID, S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID,
	S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
	)'+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnionSelect+@sSQLUnionFrom+@sSQLUnionWhere )



	SET @AT2020Cursor = CURSOR SCROLL KEYSET FOR SELECT
                                                 WareHouseID ,
                                                 VoucherID ,
                                                 TransactionID ,
                                                 VoucherDate ,
                                                 InventoryID ,
                                                 BeginQuantity ,
                                                 BeginAmount ,
                                                 ImQuantity ,
                                                 ExQuantity ,
                                                 ImConvertedAmount ,
                                                 ExConvertedAmount ,
                                                 Orders,
                                                 S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID, S09ID, S10ID, 
                                                 S11ID, S12ID, S13ID, S14ID, S15ID, S16ID, S17ID, S18ID, S19ID, S20ID
                                             FROM
                                                 AT2020
                                             Where DivisionID = @DivisionID

	OPEN @AT2020Cursor
	FETCH NEXT FROM @AT2020Cursor INTO @WareHouseID,@VoucherID,@TransactionID,@VoucherDate,@InventoryID,@BeginQuantity,@BeginAmount,@ImQuantity,@ExQuantity,@ImAmount,@ExAmount,@Orders,
										@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
										@S11ID, @S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID
	WHILE @@FETCH_STATUS = 0
      BEGIN
            SET @ImQuant = ( SELECT
                                 sum(isnull(ImConvertedQuantity , 0))
                             FROM
                                 AT2020
                             WHERE
                                 Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID AND DivisionID = @DivisionID AND
									ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
									ISNULL(S02ID,'') = isnull(@S02ID,'') AND
									ISNULL(S03ID,'') = isnull(@S03ID,'') AND
									ISNULL(S04ID,'') = isnull(@S04ID,'') AND
									ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
									ISNULL(S06ID,'') = isnull(@S06ID,'') AND
									ISNULL(S07ID,'') = isnull(@S07ID,'') AND
									ISNULL(S08ID,'') = isnull(@S08ID,'') AND
									ISNULL(S09ID,'') = isnull(@S09ID,'') AND
									ISNULL(S10ID,'') = isnull(@S10ID,'') AND
									ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
									ISNULL(S12ID,'') = isnull(@S12ID,'') AND
									ISNULL(S13ID,'') = isnull(@S13ID,'') AND
									ISNULL(S14ID,'') = isnull(@S14ID,'') AND
									ISNULL(S15ID,'') = isnull(@S15ID,'') AND
									ISNULL(S16ID,'') = isnull(@S16ID,'') AND
									ISNULL(S17ID,'') = isnull(@S17ID,'') AND
									ISNULL(S18ID,'') = isnull(@S18ID,'') AND
									ISNULL(S19ID,'') = isnull(@S19ID,'') AND
									ISNULL(S20ID,'') = isnull(@S20ID,''))
            SET @ExQuant = ( SELECT
                                 sum(isnull(ExConvertedQuantity , 0))
                             FROM
                                 AT2020
                             WHERE
                                 Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID  AND DivisionID = @DivisionID AND
									ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
									ISNULL(S02ID,'') = isnull(@S02ID,'') AND
									ISNULL(S03ID,'') = isnull(@S03ID,'') AND
									ISNULL(S04ID,'') = isnull(@S04ID,'') AND
									ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
									ISNULL(S06ID,'') = isnull(@S06ID,'') AND
									ISNULL(S07ID,'') = isnull(@S07ID,'') AND
									ISNULL(S08ID,'') = isnull(@S08ID,'') AND
									ISNULL(S09ID,'') = isnull(@S09ID,'') AND
									ISNULL(S10ID,'') = isnull(@S10ID,'') AND
									ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
									ISNULL(S12ID,'') = isnull(@S12ID,'') AND
									ISNULL(S13ID,'') = isnull(@S13ID,'') AND
									ISNULL(S14ID,'') = isnull(@S14ID,'') AND
									ISNULL(S15ID,'') = isnull(@S15ID,'') AND
									ISNULL(S16ID,'') = isnull(@S16ID,'') AND
									ISNULL(S17ID,'') = isnull(@S17ID,'') AND
									ISNULL(S18ID,'') = isnull(@S18ID,'') AND
									ISNULL(S19ID,'') = isnull(@S19ID,'') AND
									ISNULL(S20ID,'') = isnull(@S20ID,''))
			SET @ImportAmount = ( SELECT
                                      sum(isnull(ImConvertedAmount , 0))
                                  FROM
                                      AT2020
                                  WHERE
                                      Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID  AND DivisionID = @DivisionID AND
									ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
									ISNULL(S02ID,'') = isnull(@S02ID,'') AND
									ISNULL(S03ID,'') = isnull(@S03ID,'') AND
									ISNULL(S04ID,'') = isnull(@S04ID,'') AND
									ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
									ISNULL(S06ID,'') = isnull(@S06ID,'') AND
									ISNULL(S07ID,'') = isnull(@S07ID,'') AND
									ISNULL(S08ID,'') = isnull(@S08ID,'') AND
									ISNULL(S09ID,'') = isnull(@S09ID,'') AND
									ISNULL(S10ID,'') = isnull(@S10ID,'') AND
									ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
									ISNULL(S12ID,'') = isnull(@S12ID,'') AND
									ISNULL(S13ID,'') = isnull(@S13ID,'') AND
									ISNULL(S14ID,'') = isnull(@S14ID,'') AND
									ISNULL(S15ID,'') = isnull(@S15ID,'') AND
									ISNULL(S16ID,'') = isnull(@S16ID,'') AND
									ISNULL(S17ID,'') = isnull(@S17ID,'') AND
									ISNULL(S18ID,'') = isnull(@S18ID,'') AND
									ISNULL(S19ID,'') = isnull(@S19ID,'') AND
									ISNULL(S20ID,'') = isnull(@S20ID,''))
            SET @ExportAmount = ( SELECT
                                      sum(isnull(ExConvertedAmount , 0))
                                  FROM
                                      AT2020
                                  WHERE
                                      Orders < @Orders AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID  AND DivisionID = @DivisionID AND
									ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
									ISNULL(S02ID,'') = isnull(@S02ID,'') AND
									ISNULL(S03ID,'') = isnull(@S03ID,'') AND
									ISNULL(S04ID,'') = isnull(@S04ID,'') AND
									ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
									ISNULL(S06ID,'') = isnull(@S06ID,'') AND
									ISNULL(S07ID,'') = isnull(@S07ID,'') AND
									ISNULL(S08ID,'') = isnull(@S08ID,'') AND
									ISNULL(S09ID,'') = isnull(@S09ID,'') AND
									ISNULL(S10ID,'') = isnull(@S10ID,'') AND
									ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
									ISNULL(S12ID,'') = isnull(@S12ID,'') AND
									ISNULL(S13ID,'') = isnull(@S13ID,'') AND
									ISNULL(S14ID,'') = isnull(@S14ID,'') AND
									ISNULL(S15ID,'') = isnull(@S15ID,'') AND
									ISNULL(S16ID,'') = isnull(@S16ID,'') AND
									ISNULL(S17ID,'') = isnull(@S17ID,'') AND
									ISNULL(S18ID,'') = isnull(@S18ID,'') AND
									ISNULL(S19ID,'') = isnull(@S19ID,'') AND
									ISNULL(S20ID,'') = isnull(@S20ID,''))
            SET @BeginQuantity = isnull(@BeginQuantity , 0) + isnull(@ImQuant , 0) - isnull(@ExQuant , 0)




	--Set @BeginAmount = isnull(@BeginAmount,0) + isnull(@ImAmount,0) - isnull(@ExAmount,0)
            SET @BeginAmount = isnull(@BeginAmount , 0) + isnull(@ImportAmount , 0) - isnull(@ExportAmount , 0)

            SET @EndQuant = isnull(@BeginQuantity , 0) + isnull(@ImQuantity , 0) - isnull(@ExQuantity , 0)

	--Set @EndAmount = @BeginAmount + isnull(@ImportAmount,0) - isnull(@ExportAmount,0)
            SET @EndAmount = isnull(@BeginAmount , 0) + isnull(@ImAmount , 0) - isnull(@ExAmount , 0)

            UPDATE
                AT2020
            SET
                BeginQuantity = @BeginQuantity ,
                BeginAmount = @BeginAmount ,
                EndQuantity = @EndQuant ,
                EndAmount = @EndAmount
            WHERE
                WareHouseID = @WareHouseID AND VoucherID = @VoucherID AND TransactionID = @TransactionID AND VoucherDate = @VoucherDate AND InventoryID = @InventoryID AND DivisionID = @DivisionID AND
                ISNULL(S01ID,'') = Isnull(@S01ID,'') AND 
				ISNULL(S02ID,'') = isnull(@S02ID,'') AND
				ISNULL(S03ID,'') = isnull(@S03ID,'') AND
				ISNULL(S04ID,'') = isnull(@S04ID,'') AND
				ISNULL(S05ID,'') = isnull(@S05ID,'') AND 
				ISNULL(S06ID,'') = isnull(@S06ID,'') AND
				ISNULL(S07ID,'') = isnull(@S07ID,'') AND
				ISNULL(S08ID,'') = isnull(@S08ID,'') AND
				ISNULL(S09ID,'') = isnull(@S09ID,'') AND
				ISNULL(S10ID,'') = isnull(@S10ID,'') AND
				ISNULL(S11ID,'') = isnull(@S11ID,'') AND 
				ISNULL(S12ID,'') = isnull(@S12ID,'') AND
				ISNULL(S13ID,'') = isnull(@S13ID,'') AND
				ISNULL(S14ID,'') = isnull(@S14ID,'') AND
				ISNULL(S15ID,'') = isnull(@S15ID,'') AND
				ISNULL(S16ID,'') = isnull(@S16ID,'') AND
				ISNULL(S17ID,'') = isnull(@S17ID,'') AND
				ISNULL(S18ID,'') = isnull(@S18ID,'') AND
				ISNULL(S19ID,'') = isnull(@S19ID,'') AND
				ISNULL(S20ID,'') = isnull(@S20ID,'')
            FETCH NEXT FROM @AT2020Cursor INTO @WareHouseID,@VoucherID,@TransactionID,@VoucherDate,@InventoryID,@BeginQuantity,@BeginAmount,@ImQuantity,@ExQuantity,@ImAmount,@ExAmount,@Orders,
												@S01ID, @S02ID, @S03ID, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID, @S09ID, @S10ID,
												@S11ID,	@S12ID, @S13ID, @S14ID, @S15ID, @S16ID, @S17ID, @S18ID, @S19ID, @S20ID
      END

	CLOSE @AT2020Cursor
	DEALLOCATE @AT2020Cursor

	SET NOCOUNT OFF
-------------SELECT dữ liệu
	SELECT AT2020.*,
		A10.StandardName AS StandardName01, A11.StandardName AS StandardName02, A12.StandardName AS StandardName03, A13.StandardName AS StandardName04, A14.StandardName AS StandardName05,
		A15.StandardName AS StandardName06, A16.StandardName AS StandardName07, A17.StandardName AS StandardName08, A18.StandardName AS StandardName09, A19.StandardName AS StandardName10,
		A20.StandardName AS StandardName11, A21.StandardName AS StandardName12, A22.StandardName AS StandardName13, A23.StandardName AS StandardName14, A24.StandardName AS StandardName15, 
		A25.StandardName AS StandardName16, A26.StandardName AS StandardName17, A27.StandardName AS StandardName18, A28.StandardName AS StandardName19, A29.StandardName AS StandardName20
  FROM AT2020
	LEFT JOIN AT0128 A10 ON A10.DivisionID = AT2020.DivisionID AND A10.StandardID = AT2020.S01ID AND A10.StandardTypeID = 'S01'
	LEFT JOIN AT0128 A11 ON A11.DivisionID = AT2020.DivisionID AND A11.StandardID = AT2020.S02ID AND A11.StandardTypeID = 'S02'
	LEFT JOIN AT0128 A12 ON A12.DivisionID = AT2020.DivisionID AND A12.StandardID = AT2020.S03ID AND A12.StandardTypeID = 'S03'
	LEFT JOIN AT0128 A13 ON A13.DivisionID = AT2020.DivisionID AND A13.StandardID = AT2020.S04ID AND A13.StandardTypeID = 'S04'
	LEFT JOIN AT0128 A14 ON A14.DivisionID = AT2020.DivisionID AND A14.StandardID = AT2020.S05ID AND A14.StandardTypeID = 'S05'
	LEFT JOIN AT0128 A15 ON A15.DivisionID = AT2020.DivisionID AND A15.StandardID = AT2020.S06ID AND A15.StandardTypeID = 'S06'
	LEFT JOIN AT0128 A16 ON A16.DivisionID = AT2020.DivisionID AND A16.StandardID = AT2020.S07ID AND A16.StandardTypeID = 'S07'
	LEFT JOIN AT0128 A17 ON A17.DivisionID = AT2020.DivisionID AND A17.StandardID = AT2020.S08ID AND A17.StandardTypeID = 'S08'
	LEFT JOIN AT0128 A18 ON A18.DivisionID = AT2020.DivisionID AND A18.StandardID = AT2020.S09ID AND A18.StandardTypeID = 'S09'
	LEFT JOIN AT0128 A19 ON A19.DivisionID = AT2020.DivisionID AND A19.StandardID = AT2020.S10ID AND A19.StandardTypeID = 'S10'
	LEFT JOIN AT0128 A20 ON A20.DivisionID = AT2020.DivisionID AND A20.StandardID = AT2020.S11ID AND A20.StandardTypeID = 'S11'
	LEFT JOIN AT0128 A21 ON A21.DivisionID = AT2020.DivisionID AND A21.StandardID = AT2020.S12ID AND A21.StandardTypeID = 'S12'
	LEFT JOIN AT0128 A22 ON A22.DivisionID = AT2020.DivisionID AND A22.StandardID = AT2020.S13ID AND A22.StandardTypeID = 'S13'
	LEFT JOIN AT0128 A23 ON A23.DivisionID = AT2020.DivisionID AND A23.StandardID = AT2020.S14ID AND A23.StandardTypeID = 'S14'
	LEFT JOIN AT0128 A24 ON A24.DivisionID = AT2020.DivisionID AND A24.StandardID = AT2020.S15ID AND A24.StandardTypeID = 'S15'
	LEFT JOIN AT0128 A25 ON A25.DivisionID = AT2020.DivisionID AND A25.StandardID = AT2020.S16ID AND A25.StandardTypeID = 'S16'
	LEFT JOIN AT0128 A26 ON A26.DivisionID = AT2020.DivisionID AND A26.StandardID = AT2020.S17ID AND A26.StandardTypeID = 'S17'
	LEFT JOIN AT0128 A27 ON A27.DivisionID = AT2020.DivisionID AND A27.StandardID = AT2020.S18ID AND A27.StandardTypeID = 'S18'
	LEFT JOIN AT0128 A28 ON A28.DivisionID = AT2020.DivisionID AND A28.StandardID = AT2020.S19ID AND A28.StandardTypeID = 'S19'
	LEFT JOIN AT0128 A29 ON A29.DivisionID = AT2020.DivisionID AND A29.StandardID = AT2020.S20ID AND A29.StandardTypeID = 'S20'

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

