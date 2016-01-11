IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP2015]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP2015]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Tieu Mai, on 09/11/2015
---- Purpose: Chi tiet nhap xuat vat tu theo quy cách hàng.



CREATE PROCEDURE [dbo].[AP2015]
       @DivisionID nvarchar(50) ,
       @WareHouseID AS nvarchar(50) ,
       @FromInventoryID AS nvarchar(50) ,
       @ToInventoryID AS nvarchar(50) ,
       @FromMonth AS int ,
       @FromYear AS int ,
       @ToMonth AS int ,
       @ToYear AS int ,
       @FromDate AS datetime ,
       @ToDate AS datetime ,
       @IsDate AS tinyint ,
       @IsInner AS tinyint
AS
		DECLARE
				@sSQlSelect AS nvarchar(4000) ,
				@sSQlSelect1 AS nvarchar(4000) ,
				@sSQlFrom AS nvarchar(4000) ,
				@sSQlWhere AS nvarchar(4000) ,
				@sSQlUnionSelect AS nvarchar(4000) ,
				@sSQlUnionSelect1 AS nvarchar(4000) ,
				@sSQlUnionFrom AS nvarchar(4000) ,
				@sSQlUnionWhere AS nvarchar(4000) ,
				@WareHouseName AS nvarchar(4000) ,
				@WareHouseName1 AS nvarchar(4000) ,
				@WareHouseID2 AS nvarchar(4000) ,
				@WareHouseID1 AS nvarchar(4000) ,
				@KindVoucherListIm AS nvarchar(4000) ,
				@KindVoucherListEx1 AS nvarchar(4000) ,
				@KindVoucherListEx2 AS nvarchar(4000)

		SELECT  @WareHouseName1 = WareHouseName
		FROM    AT1303
		WHERE   WareHouseID = @WareHouseID AND DivisionID = @DivisionID
		    
		EXEC AP7015 @DivisionID , @WareHouseID , @FromInventoryID , @ToInventoryID , @FromMonth , @FromYear , @ToMonth , @ToYear , @FromDate , @ToDate , @IsDate


		IF @IsInner = 0
		   BEGIN
				 SET @KindVoucherListEx1 = '(2,4,8,10,14,20) '
				 SET @KindVoucherListEx2 = '(2,4,8,10,14,20) '
				 SET @KindVoucherListIm = '(1,5,7,9,15,17) '
		   END
		ELSE
		   BEGIN
				 SET @KindVoucherListEx1 = '(2,4,3,8,10,14,20)'
				 SET @KindVoucherListEx2 = '(2,4,8,10,14,20) '
				 SET @KindVoucherListIm = '(1,3,5,7,9,15,17) '
		   END

		IF @WareHouseID IN ( '%' , '' )
		   BEGIN
				 SET @WareHouseID2 = '''%'''
				 SET @WareHouseID1 = '''%'''
				 SET @WareHouseName = 'WFML000110'

		   END
		ELSE
		   BEGIN
			--Set @WareHouseID2 = ' CASE WHEN KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end'
				 SET @WareHouseID2 = ' AT2006.WareHouseID '
				 SET @WareHouseID1 = ' CASE WHEN KindVoucherID = 3 then AT2006.WareHouseID2 else AT2006.WareHouseID end '
				 SET @WareHouseName = +'"' + @WareHouseName1 + '"'

		   END

		IF @IsDate = 0
		   BEGIN
				 SET @sSQlSelect = '--- Phan Nhap kho
					SELECT 	' + @WareHouseID2 + ' AS WareHouseID,
							N''' + isnull(@WareHouseName,'') + ''' AS WareHouseName, 
							AT2007.VoucherID,
							AT2007.TransactionID,
							AT2007.Orders,
							VoucherDate,
							VoucherNo,	
							VoucherDate AS ImVoucherDate,
							VoucherNo AS ImVoucherNo,		
							SourceNo AS ImSourceNo,
							LimitDate AS ImLimitDate,	
 							AT2006.WareHouseID AS ImWareHouseID,		
							AT2006.RefNo01 AS ImRefNo01 , AT2006.RefNo02 AS ImRefNo02 , 
							AT2007.ActualQuantity AS ImQuantity,
							AT2007.UnitPrice AS ImUnitPrice ,
							AT2007.ConvertedAmount AS ImConvertedAmount,
							AT2007.OriginalAmount AS ImOriginalAmount,
							isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ImConvertedQuantity,
							Null AS ExVoucherDate,
							Null AS ExVoucherNo,		
							Null AS ExSourceNo,
							Null AS ExLimitDate,	
 							Null AS ExWareHouseID,		
							Null AS ExRefNo01 , Null AS ExRefNo02 , 
							0 AS ExQuantity,
							Null AS ExUnitPrice ,
							0 AS ExConvertedAmount,
							0 AS ExOriginalAmount,
							0 AS ExConvertedQuantity,
							VoucherTypeID,
							AT2006.Description,
							AT2007.Notes,
							AT2007.InventoryID,	
							AT1302.InventoryName,
							AT2007.UnitID,		
							isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
							isnull(AV7015.BeginQuantity,0) AS BeginQuantity,
							isnull(AV7015.BeginAmount,0) AS BeginAmount,
							(CASE WHEN KindVoucherID = 7 then 3 else 1 end) AS ImExOrders,
							AT2007.DebitAccountID, AT2007.CreditAccountID,
							AT2006.ObjectID,
							AT1202.ObjectName,
							AT1302.Notes01,
							AT1302.Notes02,
							AT1302.Notes03, AT2007.DivisionID, AT2007.ConvertedUnitID,
							AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, AT2007.Ana06ID, AT2007.Ana07ID, AT2007.Ana08ID, AT2007.Ana09ID, AT2007.Ana10ID ,
							(Select Distinct InvoiceNo from AT9000 Where VoucherID = AT2007.VoucherID and TransactionID = AT2007.TransactionID and Isnull(InvoiceNo,'''')<>'''') as InvoiceNo,
							A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
							A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name, A10.AnaName AS Ana10Name,
							AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
							O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
							O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID
							 '

				SET @sSQlFrom =  '
					FROM AT1302	 	
					INNER JOIN AT2007 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
					INNER JOIN AT2006 on AT2006.VoucherID = AT2007.VoucherID  AND AT2006.DivisionID = AT2007.DivisionID
					LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
					LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID AND AV7015.DivisionID = AT2007.DivisionID AND
										Isnull(AV7015.S01ID,'''') = Isnull(O99.S01ID,'''') AND
										Isnull(AV7015.S02ID,'''') = Isnull(O99.S02ID,'''') AND
										Isnull(AV7015.S03ID,'''') = Isnull(O99.S03ID,'''') AND
										Isnull(AV7015.S04ID,'''') = Isnull(O99.S04ID,'''') AND
										Isnull(AV7015.S05ID,'''') = Isnull(O99.S05ID,'''') AND
										Isnull(AV7015.S06ID,'''') = Isnull(O99.S06ID,'''') AND
										Isnull(AV7015.S07ID,'''') = Isnull(O99.S07ID,'''') AND
										Isnull(AV7015.S08ID,'''') = Isnull(O99.S08ID,'''') AND
										Isnull(AV7015.S09ID,'''') = Isnull(O99.S09ID,'''') AND
										Isnull(AV7015.S10ID,'''') = Isnull(O99.S10ID,'''') AND
										Isnull(AV7015.S11ID,'''') = Isnull(O99.S11ID,'''') AND
										Isnull(AV7015.S12ID,'''') = Isnull(O99.S12ID,'''') AND
										Isnull(AV7015.S13ID,'''') = Isnull(O99.S13ID,'''') AND
										Isnull(AV7015.S14ID,'''') = Isnull(O99.S14ID,'''') AND
										Isnull(AV7015.S15ID,'''') = Isnull(O99.S15ID,'''') AND
										Isnull(AV7015.S16ID,'''') = Isnull(O99.S16ID,'''') AND
										Isnull(AV7015.S17ID,'''') = Isnull(O99.S17ID,'''') AND
										Isnull(AV7015.S18ID,'''') = Isnull(O99.S18ID,'''') AND
										Isnull(AV7015.S19ID,'''') = Isnull(O99.S19ID,'''') AND
										Isnull(AV7015.S20ID,'''') = Isnull(O99.S20ID,'''')
					INNER JOIN AT1303 on AT1303.WareHouseID = AT2006.WareHouseID AND AT1303.DivisionID = AT2007.DivisionID
					LEFT  JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID
					LEFT JOIN AT1011 AS A01 ON A01.DivisionID = AT2007.DivisionID AND A01.AnaID = AT2007.Ana01ID AND A01.AnaTypeID = ''A01''
					LEFT JOIN AT1011 AS A02 ON A02.DivisionID = AT2007.DivisionID AND A02.AnaID = AT2007.Ana02ID AND A02.AnaTypeID = ''A02''
					LEFT JOIN AT1011 AS A03 ON A03.DivisionID = AT2007.DivisionID AND A03.AnaID = AT2007.Ana03ID AND A03.AnaTypeID = ''A03''
					LEFT JOIN AT1011 AS A04 ON A04.DivisionID = AT2007.DivisionID AND A04.AnaID = AT2007.Ana04ID AND A04.AnaTypeID = ''A04''
					LEFT JOIN AT1011 AS A05 ON A05.DivisionID = AT2007.DivisionID AND A05.AnaID = AT2007.Ana05ID AND A05.AnaTypeID = ''A05''
					LEFT JOIN AT1011 AS A06 ON A06.DivisionID = AT2007.DivisionID AND A06.AnaID = AT2007.Ana06ID AND A06.AnaTypeID = ''A06''
					LEFT JOIN AT1011 AS A07 ON A07.DivisionID = AT2007.DivisionID AND A07.AnaID = AT2007.Ana07ID AND A07.AnaTypeID = ''A07''
					LEFT JOIN AT1011 AS A08 ON A08.DivisionID = AT2007.DivisionID AND A08.AnaID = AT2007.Ana08ID AND A08.AnaTypeID = ''A08''
					LEFT JOIN AT1011 AS A09 ON A09.DivisionID = AT2007.DivisionID AND A09.AnaID = AT2007.Ana09ID AND A09.AnaTypeID = ''A09''
					LEFT JOIN AT1011 AS A10 ON A10.DivisionID = AT2007.DivisionID AND A10.AnaID = AT2007.Ana10ID AND A10.AnaTypeID = ''A10''
					'
				SET @sSQlWhere = ' 
					WHERE	AT2007.DivisionID =N''' + @DivisionID + ''' AND
							(CASE WHEN N''' + @WareHouseID + '''=''%'' then AT1303.IsTemp  else 0 end  = 0 ) AND
							(AT2007.TranMonth + AT2007.TranYear*100 between (' + str(@FromMonth) + ' + ' + str(@FromYear) + ' *100) AND  (' + str(@ToMonth) + ' + ' + str(@ToYear) + ' *100) )  AND
							KindVoucherID in ' + @KindVoucherListIm + ' AND
							(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') AND
							AT2006.WareHouseID like N''' + @WareHouseID + ''''

				 SET @sSQlUnionSelect = N' 
				 UNION
				--- Phan Xuat kho
				SELECT 	' + @WareHouseID1 + ' AS WareHouseID,
						N''' + isnull(@WareHouseName,'') + ''' AS WareHouseName, 
						AT2007.VoucherID,
						AT2007.TransactionID,
						AT2007.Orders,
						VoucherDate,
						VoucherNo,	
						Null AS ImVoucherDate,
						Null AS ImVoucherNo,		
						Null AS ImSourceNo,
						Null AS ImLimitDate,	
 						Null AS ExWareHouseID,	
						Null AS ImRefNo01 , Null  AS ImRefNo02 , 
						0 AS ImQuantity,
						Null AS ImUnitPrice ,
						0 AS ImConvertedAmount,
						0 AS ImOriginalAmount,
						0 AS ImConvertedQuantity,
						VoucherDate AS ExVoucherDate,
						VoucherNo AS ExVoucherNo,		
						SourceNo AS ExSourceNo,
						LimitDate AS ExLimitDate,	
 						(CASE WHEN KindVoucherID = 3 then WareHouseID2 else AT2006.WareHouseID end) AS ExWareHouseID,	
						AT2006.RefNo01 AS ExRefNo01 , AT2006.RefNo02 AS ExRefNo02 , 
						AT2007.ActualQuantity AS ExQuantity,
						AT2007.UnitPrice AS ExUnitPrice ,
						AT2007.ConvertedAmount AS ExConvertedAmount,
						AT2007.OriginalAmount AS ExOriginalAmount,
						isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ExConvertedQuantity,
						VoucherTypeID,
						AT2006.Description,
						AT2007.Notes,
						AT2007.InventoryID,	
						AT1302.InventoryName,
						AT2007.UnitID,		
						isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
						isnull(AV7015.BeginQuantity,0) AS BeginQuantity,
						isnull(AV7015.BeginAmount,0) AS BeginAmount,
						2 AS ImExOrders,
						AT2007.DebitAccountID, AT2007.CreditAccountID,
						AT2006.ObjectID,
						AT1202.ObjectName,
						AT1302.Notes01,
						AT1302.Notes02,
						AT1302.Notes03, AT2007.DivisionID,  AT2007.ConvertedUnitID,
						AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, AT2007.Ana06ID, AT2007.Ana07ID, AT2007.Ana08ID, AT2007.Ana09ID, AT2007.Ana10ID,
						(Select Distinct InvoiceNo from AT9000 Where VoucherID = AT2007.VoucherID and TransactionID = AT2007.TransactionID and Isnull(InvoiceNo,'''')<>'''') as InvoiceNo,
						A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
						A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name, A10.AnaName AS Ana10Name,
						AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
						O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
						O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID  '
				SET @sSQlUnionFrom = ' 
					FROM AT1302 	
					LEFT JOIN AT2007 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
					INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND At2006.DivisionID = AT2007.DivisionID
					LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
					LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID	AND AV7015.DivisionID = AT2007.DivisionID AND
										Isnull(AV7015.S01ID,'''') = Isnull(O99.S01ID,'''') AND
										Isnull(AV7015.S02ID,'''') = Isnull(O99.S02ID,'''') AND
										Isnull(AV7015.S03ID,'''') = Isnull(O99.S03ID,'''') AND
										Isnull(AV7015.S04ID,'''') = Isnull(O99.S04ID,'''') AND
										Isnull(AV7015.S05ID,'''') = Isnull(O99.S05ID,'''') AND
										Isnull(AV7015.S06ID,'''') = Isnull(O99.S06ID,'''') AND
										Isnull(AV7015.S07ID,'''') = Isnull(O99.S07ID,'''') AND
										Isnull(AV7015.S08ID,'''') = Isnull(O99.S08ID,'''') AND
										Isnull(AV7015.S09ID,'''') = Isnull(O99.S09ID,'''') AND
										Isnull(AV7015.S10ID,'''') = Isnull(O99.S10ID,'''') AND
										Isnull(AV7015.S11ID,'''') = Isnull(O99.S11ID,'''') AND
										Isnull(AV7015.S12ID,'''') = Isnull(O99.S12ID,'''') AND
										Isnull(AV7015.S13ID,'''') = Isnull(O99.S13ID,'''') AND
										Isnull(AV7015.S14ID,'''') = Isnull(O99.S14ID,'''') AND
										Isnull(AV7015.S15ID,'''') = Isnull(O99.S15ID,'''') AND
										Isnull(AV7015.S16ID,'''') = Isnull(O99.S16ID,'''') AND
										Isnull(AV7015.S17ID,'''') = Isnull(O99.S17ID,'''') AND
										Isnull(AV7015.S18ID,'''') = Isnull(O99.S18ID,'''') AND
										Isnull(AV7015.S19ID,'''') = Isnull(O99.S19ID,'''') AND
										Isnull(AV7015.S20ID,'''') = Isnull(O99.S20ID,'''')
					INNER JOIN AT1303 on AT1303.WareHouseID = ( CASE WHEN KindVoucherID = 3 Then AT2006.WareHouseID2  Else AT2006.WareHouseID end) 	 AND AT1303.DivisionID = AT2007.DivisionID
					LEFT JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID
					LEFT JOIN AT1011 AS A01 ON A01.DivisionID = AT2007.DivisionID AND A01.AnaID = AT2007.Ana01ID AND A01.AnaTypeID = ''A01''
					LEFT JOIN AT1011 AS A02 ON A02.DivisionID = AT2007.DivisionID AND A02.AnaID = AT2007.Ana02ID AND A02.AnaTypeID = ''A02''
					LEFT JOIN AT1011 AS A03 ON A03.DivisionID = AT2007.DivisionID AND A03.AnaID = AT2007.Ana03ID AND A03.AnaTypeID = ''A03''
					LEFT JOIN AT1011 AS A04 ON A04.DivisionID = AT2007.DivisionID AND A04.AnaID = AT2007.Ana04ID AND A04.AnaTypeID = ''A04''
					LEFT JOIN AT1011 AS A05 ON A05.DivisionID = AT2007.DivisionID AND A05.AnaID = AT2007.Ana05ID AND A05.AnaTypeID = ''A05''
					LEFT JOIN AT1011 AS A06 ON A06.DivisionID = AT2007.DivisionID AND A06.AnaID = AT2007.Ana06ID AND A06.AnaTypeID = ''A06''
					LEFT JOIN AT1011 AS A07 ON A07.DivisionID = AT2007.DivisionID AND A07.AnaID = AT2007.Ana07ID AND A07.AnaTypeID = ''A07''
					LEFT JOIN AT1011 AS A08 ON A08.DivisionID = AT2007.DivisionID AND A08.AnaID = AT2007.Ana08ID AND A08.AnaTypeID = ''A08''
					LEFT JOIN AT1011 AS A09 ON A09.DivisionID = AT2007.DivisionID AND A09.AnaID = AT2007.Ana09ID AND A09.AnaTypeID = ''A09''
					LEFT JOIN AT1011 AS A10 ON A10.DivisionID = AT2007.DivisionID AND A10.AnaID = AT2007.Ana10ID AND A10.AnaTypeID = ''A10''
					'
				SET @sSQlUnionWhere = ' 
				WHERE	AT2007.DivisionID = N''' + @DivisionID + ''' AND
						(CASE WHEN ''' + @WareHouseID + '''=''%'' then AT1303.IsTemp  else 0 end  = 0 ) AND
						AT2006.KindVoucherID in ' + @KindVoucherListEx1 + ' AND
						(AT2007.TranMonth + AT2007.TranYear*100 between (' + str(@FromMonth) + ' + ' + str(@FromYear) + ' *100) AND  (' + str(@ToMonth) + ' + ' + str(@ToYear) + '*100) )  AND	
						(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') AND
						( (KindVoucherID in ' + @KindVoucherListEx2 + ' AND AT2006.WareHouseID like N''' + @WareHouseID + ''') or  ( KindVoucherID = 3 AND WareHouseID2 like N''' + @WareHouseID + ''')) '
			   END
			ELSE
			   BEGIN
					SET @sSQlSelect = N'
				--- Phan Nhap kho
				SELECT 	' + @WareHouseID2 + ' AS WareHouseID,
						N''' + isnull(@WareHouseName,'') + ''' AS WareHouseName, 
						AT2007.VoucherID,
						AT2007.TransactionID,
						AT2007.Orders,
						VoucherDate,
						VoucherNo,	
						VoucherDate AS ImVoucherDate,
						VoucherNo AS ImVoucherNo,		
						SourceNo AS ImSourceNo,
						LimitDate AS ImLimitDate,	
 						AT2006.WareHouseID AS ImWareHouseID,		
						AT2006.RefNo01 AS ImRefNo01 , AT2006.RefNo02 AS ImRefNo02 , 
						AT2007.ActualQuantity AS ImQuantity,
						AT2007.UnitPrice AS ImUnitPrice ,
						AT2007.ConvertedAmount AS ImConvertedAmount,
						AT2007.OriginalAmount AS ImOriginalAmount,
						isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ImConvertedQuantity,
						Null AS ExVoucherDate,
						Null AS ExVoucherNo,		
						Null AS ExSourceNo,
						Null AS ExLimitDate,	
 						Null AS ExWareHouseID,		
						Null AS ExRefNo01 , Null AS ExRefNo02 , 
						0 AS ExQuantity,
						Null AS ExUnitPrice ,
						0 AS ExConvertedAmount,
						0 AS ExOriginalAmount,
						0 AS ExConvertedQuantity,
						VoucherTypeID,
						AT2006.Description,
						AT2007.Notes,
						AT2007.InventoryID,	
						AT1302.InventoryName,
						AT2007.UnitID,		
						isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
						isnull(AV7015.BeginQuantity,0) AS BeginQuantity,
						isnull(AV7015.BeginAmount,0) AS BeginAmount,
						(CASE WHEN KindVoucherID = 7 then 3 else 1 end) AS ImExOrders,
						AT2007.DebitAccountID, AT2007.CreditAccountID,
						At2006.ObjectID,
						AT1202.ObjectName,
						AT1302.Notes01,
						AT1302.Notes02,
						AT1302.Notes03, AT2007.DivisionID, AT2007.ConvertedUnitID,
						AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, AT2007.Ana06ID, AT2007.Ana07ID, AT2007.Ana08ID, AT2007.Ana09ID, AT2007.Ana10ID,
						(Select Distinct InvoiceNo from AT9000 Where VoucherID = AT2007.VoucherID and TransactionID = AT2007.TransactionID and Isnull(InvoiceNo,'''')<>'''') as InvoiceNo,
						A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
						A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name, A10.AnaName AS Ana10Name,
						AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
						O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
						O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID  '
				
				SET @sSQlFrom = ' 
					FROM AT1302	
					LEFT JOIN AT2007  on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
					INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND At2006.DivisionID = AT2007.DivisionID
					LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
					LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID AND AV7015.DivisionID = AT2007.DivisionID AND
										Isnull(AV7015.S01ID,'''') = Isnull(O99.S01ID,'''') AND
										Isnull(AV7015.S02ID,'''') = Isnull(O99.S02ID,'''') AND
										Isnull(AV7015.S03ID,'''') = Isnull(O99.S03ID,'''') AND
										Isnull(AV7015.S04ID,'''') = Isnull(O99.S04ID,'''') AND
										Isnull(AV7015.S05ID,'''') = Isnull(O99.S05ID,'''') AND
										Isnull(AV7015.S06ID,'''') = Isnull(O99.S06ID,'''') AND
										Isnull(AV7015.S07ID,'''') = Isnull(O99.S07ID,'''') AND
										Isnull(AV7015.S08ID,'''') = Isnull(O99.S08ID,'''') AND
										Isnull(AV7015.S09ID,'''') = Isnull(O99.S09ID,'''') AND
										Isnull(AV7015.S10ID,'''') = Isnull(O99.S10ID,'''') AND
										Isnull(AV7015.S11ID,'''') = Isnull(O99.S11ID,'''') AND
										Isnull(AV7015.S12ID,'''') = Isnull(O99.S12ID,'''') AND
										Isnull(AV7015.S13ID,'''') = Isnull(O99.S13ID,'''') AND
										Isnull(AV7015.S14ID,'''') = Isnull(O99.S14ID,'''') AND
										Isnull(AV7015.S15ID,'''') = Isnull(O99.S15ID,'''') AND
										Isnull(AV7015.S16ID,'''') = Isnull(O99.S16ID,'''') AND
										Isnull(AV7015.S17ID,'''') = Isnull(O99.S17ID,'''') AND
										Isnull(AV7015.S18ID,'''') = Isnull(O99.S18ID,'''') AND
										Isnull(AV7015.S19ID,'''') = Isnull(O99.S19ID,'''') AND
										Isnull(AV7015.S20ID,'''') = Isnull(O99.S20ID,'''')
					INNER JOIN AT1303 on AT1303.WareHouseID = AT2006.WareHouseID AND AT1303.DivisionID = AT2007.DivisionID
					LEFT JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID
					LEFT JOIN AT1011 AS A01 ON A01.DivisionID = AT2007.DivisionID AND A01.AnaID = AT2007.Ana01ID AND A01.AnaTypeID = ''A01''
					LEFT JOIN AT1011 AS A02 ON A02.DivisionID = AT2007.DivisionID AND A02.AnaID = AT2007.Ana02ID AND A02.AnaTypeID = ''A02''
					LEFT JOIN AT1011 AS A03 ON A03.DivisionID = AT2007.DivisionID AND A03.AnaID = AT2007.Ana03ID AND A03.AnaTypeID = ''A03''
					LEFT JOIN AT1011 AS A04 ON A04.DivisionID = AT2007.DivisionID AND A04.AnaID = AT2007.Ana04ID AND A04.AnaTypeID = ''A04''
					LEFT JOIN AT1011 AS A05 ON A05.DivisionID = AT2007.DivisionID AND A05.AnaID = AT2007.Ana05ID AND A05.AnaTypeID = ''A05''
					LEFT JOIN AT1011 AS A06 ON A06.DivisionID = AT2007.DivisionID AND A06.AnaID = AT2007.Ana06ID AND A06.AnaTypeID = ''A06''
					LEFT JOIN AT1011 AS A07 ON A07.DivisionID = AT2007.DivisionID AND A07.AnaID = AT2007.Ana07ID AND A07.AnaTypeID = ''A07''
					LEFT JOIN AT1011 AS A08 ON A08.DivisionID = AT2007.DivisionID AND A08.AnaID = AT2007.Ana08ID AND A08.AnaTypeID = ''A08''
					LEFT JOIN AT1011 AS A09 ON A09.DivisionID = AT2007.DivisionID AND A09.AnaID = AT2007.Ana09ID AND A09.AnaTypeID = ''A09''
					LEFT JOIN AT1011 AS A10 ON A10.DivisionID = AT2007.DivisionID AND A10.AnaID = AT2007.Ana10ID AND A10.AnaTypeID = ''A10''	
					'
				
				SET @sSQlWhere = ' 
					WHERE	AT2007.DivisionID = N''' + @DivisionID + ''' AND
							(CASE WHEN ''' + @WareHouseID + '''=''%'' then AT1303.IsTemp  else 0 end  = 0 ) AND
							(CONVERT(DATETIME, CONVERT(VARCHAR(10), VoucherDate, 101), 101) Between ''' + CONVERT(varchar(10) , @FromDate , 101) + ''' AND ''' + CONVERT(varchar(10) , @ToDate , 101) + ''' ) AND
							KindVoucherID in ' + @KindVoucherListIm + ' AND
							(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') AND
							AT2006.WareHouseID like N''' + @WareHouseID + ''''

				SET @sSQlUnionSelect = ' 
					UNION
				--- Phan Xuat kho
					SELECT  ' + @WareHouseID1 + ' AS WareHouseID,
							N''' + isnull(@WareHouseName,'') + ''' AS WareHouseName, 
							AT2007.VoucherID,
							AT2007.TransactionID,
							AT2007.Orders,
							VoucherDate,
							VoucherNo,	
							Null AS ImVoucherDate,
							Null AS ImVoucherNo,		
							Null AS ImSourceNo,
							Null AS ImLimitDate,	
 							Null AS ExWareHouseID,	
							Null AS ImRefNo01 , Null AS ImRefNo02 , 
							0 AS ImQuantity,
							Null AS ImUnitPrice ,
							0 AS ImConvertedAmount,
							0 AS ImOriginalAmount,
							0 AS ImConvertedQuantity,
							VoucherDate AS ExVoucherDate,
							VoucherNo AS ExVoucherNo,		
							SourceNo AS ExSourceNo,
							LimitDate AS ExLimitDate,	
 							(CASE WHEN KindVoucherID = 3 then WareHouseID2 else AT2006.WareHouseID end) AS ExWareHouseID,	
							AT2006.RefNo01 AS ExRefNo01 , AT2006.RefNo02 AS ExRefNo02 , 
							AT2007.ActualQuantity AS ExQuantity,
							AT2007.UnitPrice AS ExUnitPrice ,
							AT2007.ConvertedAmount AS ExConvertedAmount,
							AT2007.OriginalAmount AS ExOriginalAmount,
							isnull(AT2007.ConversionFactor ,1)*ActualQuantity AS ExConvertedQuantity,
							VoucherTypeID,
							AT2006.Description,
							AT2007.Notes,
							AT2007.InventoryID,	
							AT1302.InventoryName,
							AT2007.UnitID,		 							isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
							isnull(AV7015.BeginQuantity,0) AS BeginQuantity,
							isnull(AV7015.BeginAmount,0) AS BeginAmount,
							2 AS ImExOrders,
							AT2007.DebitAccountID, AT2007.CreditAccountID,
							At2006.ObjectID,
							AT1202.ObjectName,
							AT1302.Notes01,
							AT1302.Notes02,
							AT1302.Notes03,AT2007.DivisionID, AT2007.ConvertedUnitID,
							AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, AT2007.Ana06ID, AT2007.Ana07ID, AT2007.Ana08ID, AT2007.Ana09ID, AT2007.Ana10ID ,
							(Select Distinct InvoiceNo from AT9000 Where VoucherID = AT2007.VoucherID and TransactionID = AT2007.TransactionID and Isnull(InvoiceNo,'''')<>'''') as InvoiceNo,
							A01.AnaName AS Ana01Name, A02.AnaName AS Ana02Name, A03.AnaName AS Ana03Name, A04.AnaName AS Ana04Name, A05.AnaName AS Ana05Name,
							A06.AnaName AS Ana06Name, A07.AnaName AS Ana07Name, A08.AnaName AS Ana08Name, A09.AnaName AS Ana09Name, A10.AnaName AS Ana10Name,
							AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05,
							O99.S01ID,O99.S02ID,O99.S03ID,O99.S04ID,O99.S05ID,O99.S06ID,O99.S07ID,O99.S08ID,O99.S09ID,O99.S10ID,
							O99.S11ID,O99.S12ID,O99.S13ID,O99.S14ID,O99.S15ID,O99.S16ID,O99.S17ID,O99.S18ID,O99.S19ID,O99.S20ID '	
							
					SET @sSQlUnionFrom = ' 
						FROM AT1302 	
						LEFT JOIN AT2007 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
						INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
						LEFT JOIN WT8899 O99 ON O99.DivisionID = AT2007.DivisionID AND O99.VoucherID = AT2007.VoucherID AND O99.TransactionID = AT2007.TransactionID
						LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID AND AV7015.DivisionID = AT2007.DivisionID AND
										Isnull(AV7015.S01ID,'''') = Isnull(O99.S01ID,'''') AND
										Isnull(AV7015.S02ID,'''') = Isnull(O99.S02ID,'''') AND
										Isnull(AV7015.S03ID,'''') = Isnull(O99.S03ID,'''') AND
										Isnull(AV7015.S04ID,'''') = Isnull(O99.S04ID,'''') AND
										Isnull(AV7015.S05ID,'''') = Isnull(O99.S05ID,'''') AND
										Isnull(AV7015.S06ID,'''') = Isnull(O99.S06ID,'''') AND
										Isnull(AV7015.S07ID,'''') = Isnull(O99.S07ID,'''') AND
										Isnull(AV7015.S08ID,'''') = Isnull(O99.S08ID,'''') AND
										Isnull(AV7015.S09ID,'''') = Isnull(O99.S09ID,'''') AND
										Isnull(AV7015.S10ID,'''') = Isnull(O99.S10ID,'''') AND
										Isnull(AV7015.S11ID,'''') = Isnull(O99.S11ID,'''') AND
										Isnull(AV7015.S12ID,'''') = Isnull(O99.S12ID,'''') AND
										Isnull(AV7015.S13ID,'''') = Isnull(O99.S13ID,'''') AND
										Isnull(AV7015.S14ID,'''') = Isnull(O99.S14ID,'''') AND
										Isnull(AV7015.S15ID,'''') = Isnull(O99.S15ID,'''') AND
										Isnull(AV7015.S16ID,'''') = Isnull(O99.S16ID,'''') AND
										Isnull(AV7015.S17ID,'''') = Isnull(O99.S17ID,'''') AND
										Isnull(AV7015.S18ID,'''') = Isnull(O99.S18ID,'''') AND
										Isnull(AV7015.S19ID,'''') = Isnull(O99.S19ID,'''') AND
										Isnull(AV7015.S20ID,'''') = Isnull(O99.S20ID,'''')
						INNER JOIN AT1303 on AT1303.WareHouseID = ( CASE WHEN KindVoucherID = 3 Then AT2006.WareHouseID2  Else AT2006.WareHouseID end)  AND AT1303.DivisionID = AT2007.DivisionID
						LEFT JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID
						LEFT JOIN AT1011 AS A01 ON A01.DivisionID = AT2007.DivisionID AND A01.AnaID = AT2007.Ana01ID AND A01.AnaTypeID = ''A01''
						LEFT JOIN AT1011 AS A02 ON A02.DivisionID = AT2007.DivisionID AND A02.AnaID = AT2007.Ana02ID AND A02.AnaTypeID = ''A02''
						LEFT JOIN AT1011 AS A03 ON A03.DivisionID = AT2007.DivisionID AND A03.AnaID = AT2007.Ana03ID AND A03.AnaTypeID = ''A03''
						LEFT JOIN AT1011 AS A04 ON A04.DivisionID = AT2007.DivisionID AND A04.AnaID = AT2007.Ana04ID AND A04.AnaTypeID = ''A04''
						LEFT JOIN AT1011 AS A05 ON A05.DivisionID = AT2007.DivisionID AND A05.AnaID = AT2007.Ana05ID AND A05.AnaTypeID = ''A05''
						LEFT JOIN AT1011 AS A06 ON A06.DivisionID = AT2007.DivisionID AND A06.AnaID = AT2007.Ana06ID AND A06.AnaTypeID = ''A06''
						LEFT JOIN AT1011 AS A07 ON A07.DivisionID = AT2007.DivisionID AND A07.AnaID = AT2007.Ana07ID AND A07.AnaTypeID = ''A07''
						LEFT JOIN AT1011 AS A08 ON A08.DivisionID = AT2007.DivisionID AND A08.AnaID = AT2007.Ana08ID AND A08.AnaTypeID = ''A08''
						LEFT JOIN AT1011 AS A09 ON A09.DivisionID = AT2007.DivisionID AND A09.AnaID = AT2007.Ana09ID AND A09.AnaTypeID = ''A09''
						LEFT JOIN AT1011 AS A10 ON A10.DivisionID = AT2007.DivisionID AND A10.AnaID = AT2007.Ana10ID AND A10.AnaTypeID = ''A10''
						'

					SET @sSQlUnionWhere = ' 
						WHERE	AT2007.DivisionID = N''' + @DivisionID + ''' AND
								(CASE WHEN ''' + @WareHouseID + '''=''%'' then AT1303.IsTemp  else 0 end  = 0 ) AND
								AT2006.KindVoucherID in ' + @KindVoucherListEx1 + ' AND
								(CONVERT(DATETIME, CONVERT(VARCHAR(10), VoucherDate, 101), 101) Between ''' + CONVERT(varchar(10) , @FromDate , 101) + ''' AND ''' + CONVERT(varchar(10) , @ToDate , 101) + ''' ) AND
								(AT2007.InventoryID between N''' + @FromInventoryID + ''' AND N''' + @ToInventoryID + ''') AND
								( (KindVoucherID in ' + @KindVoucherListEx2 + '  AND 
								 AT2006.WareHouseID like N''' + @WareHouseID + ''') or  (KindVoucherID = 3 AND WareHouseID2 like N''' + @WareHouseID + ''')) '
				   END	 


				 --PRINT 'aa' + @sSQLSelect + @sSQlFrom + @sSQlWhere
				 --PRINT @sSQlUnionSelect + @sSQlUnionFrom + @sSQlUnionWhere

		--Edit by Nguyen Quoc Huy

		--print @sSQLSelect+@sSQlFrom+@sSQlWhere+@sSQlUnionSelect+@sSQlUnionFrom+@sSQlUnionWhere
		
		--print @sSQLSelect
		--print @sSQlFrom
		--print @sSQlWhere
		--print @sSQlUnionSelect
		--print @sSQlUnionFrom
		--print @sSQlUnionWhere
		

		IF NOT EXISTS ( SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV2015_1' )
		   BEGIN
				 EXEC ( 'CREATE VIEW AV2015_1--CREATED BY AP2015
							AS '+@sSQLSelect+@sSQlFrom+@sSQlWhere+@sSQlUnionSelect+@sSQlUnionFrom+@sSQlUnionWhere )
		   END
		ELSE
		   BEGIN
				 EXEC ( 'ALTER VIEW AV2015_1 --CREATED BY AP2015
							as '+@sSQLSelect+@sSQlFrom+@sSQlWhere+@sSQlUnionSelect+@sSQlUnionFrom+@sSQlUnionWhere )
		   END
		 
		--- Lay du su va phat sinh
		SET @sSQLSelect = N' 
			SELECT	AV2015_1.WareHouseID, AV2015_1.WareHouseName, AV2015_1.VoucherID, AV2015_1.TransactionID, AV2015_1.Orders,
					DATEADD(d, 0, DATEDIFF(d, 0, AV2015_1.VoucherDate)) AS VoucherDate, AV2015_1.VoucherNo, AV2015_1.ImVoucherDate, AV2015_1.ImVoucherNo, AV2015_1.ImSourceNo,
					AV2015_1.ImLimitDate, AV2015_1.ImWareHouseID, 
					AV2015_1.ImRefNo01, AV2015_1.ImRefNo02,
					AV2015_1.ImQuantity, AV2015_1.ImUnitPrice, AV2015_1.ImConvertedAmount,
					AV2015_1.ImOriginalAmount, AV2015_1.ImConvertedQuantity,  
					AV2015_1.ExVoucherDate, AV2015_1.ExVoucherNo, AV2015_1.ExSourceNo,
					AV2015_1.ExLimitDate, AV2015_1.ExWareHouseID, 
					AV2015_1.ExRefNo01, AV2015_1.ExRefNo02,
					AV2015_1.ExQuantity, AV2015_1.ExUnitPrice, AV2015_1.ExConvertedAmount,
					AV2015_1.ExOriginalAmount, AV2015_1.ExConvertedQuantity, AV2015_1.VoucherTypeID, AV2015_1.Description,
					AV2015_1.Notes, AV2015_1.InventoryID, AV2015_1.InventoryName, AV2015_1.UnitID,  AT1304.UnitName, AV2015_1.ConversionFactor,
					AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor AS  ConversionFactor01, AT1309.Operator,
					AV2015_1.BeginQuantity, AV2015_1.BeginAmount, AV2015_1.ImExOrders, AV2015_1.DebitAccountID, AV2015_1.CreditAccountID,
					AV2015_1.ObjectID, AV2015_1.ObjectName, AV2015_1.Notes01, AV2015_1.Notes02, AV2015_1.Notes03, AV2015_1.DivisionID,
					AV2015_1.Ana01ID, AV2015_1.Ana02ID, AV2015_1.Ana03ID, AV2015_1.Ana04ID, AV2015_1.Ana05ID, AV2015_1.Ana06ID, AV2015_1.Ana07ID, AV2015_1.Ana08ID, AV2015_1.Ana09ID, AV2015_1.Ana10ID ,
					AV2015_1.Ana01Name, AV2015_1.Ana02Name, AV2015_1.Ana03Name, AV2015_1.Ana04Name, AV2015_1.Ana05Name, AV2015_1.Ana06Name, AV2015_1.Ana07Name, AV2015_1.Ana08Name, AV2015_1.Ana09Name, AV2015_1.Ana10Name ,
					AV2015_1.InvoiceNo, AV2015_1.ConvertedUnitID,
					AV2015_1.Parameter01,AV2015_1.Parameter02,AV2015_1.Parameter03,AV2015_1.Parameter04,AV2015_1.Parameter05,
					AV2015_1.S01ID,AV2015_1.S02ID,AV2015_1.S03ID,AV2015_1.S04ID,AV2015_1.S05ID,AV2015_1.S06ID,AV2015_1.S07ID,AV2015_1.S08ID,AV2015_1.S09ID,AV2015_1.S10ID,
					AV2015_1.S11ID,AV2015_1.S12ID,AV2015_1.S13ID,AV2015_1.S14ID,AV2015_1.S15ID,AV2015_1.S16ID,AV2015_1.S17ID,AV2015_1.S18ID,AV2015_1.S19ID,AV2015_1.S20ID,
					A01.StandardName AS StandardName01, A02.StandardName AS StandardName02, A03.StandardName AS StandardName03, A04.StandardName AS StandardName04, 
					A05.StandardName AS StandardName05, A06.StandardName AS StandardName06, A07.StandardName AS StandardName07, A08.StandardName AS StandardName08, 
					A09.StandardName AS StandardName09, A10.StandardName AS StandardName10, A11.StandardName AS StandardName11, A12.StandardName AS StandardName12,
					A13.StandardName AS StandardName13, A14.StandardName AS StandardName14, A15.StandardName AS StandardName15, A16.StandardName AS StandardName16,
					A17.StandardName AS StandardName17, A18.StandardName AS StandardName18, A19.StandardName AS StandardName19, A20.StandardName AS StandardName20
					'
				
			SET @sSQlSelect1 = N'		
			FROM	AV2015_1 
			LEFT JOIN AT1304 on AT1304.UnitID = AV2015_1.UnitID AND  AT1304.DivisionID = AV2015_1.DivisionID 
			LEFT JOIN AT1309 on AT1309.InventoryID = AV2015_1.InventoryID AND AT1309.UnitID = AV2015_1.UnitID AND AT1309.DivisionID = AV2015_1.DivisionID 
			LEFT JOIN AT0128 A01 ON A01.DivisionID = AV2015_1.DivisionID AND AV2015_1.S01ID = A01.StandardID AND A01.StandardTypeID = ''S01''
			LEFT JOIN AT0128 A02 ON A02.DivisionID = AV2015_1.DivisionID AND AV2015_1.S02ID = A02.StandardID AND A02.StandardTypeID = ''S02''
			LEFT JOIN AT0128 A03 ON A03.DivisionID = AV2015_1.DivisionID AND AV2015_1.S03ID = A03.StandardID AND A03.StandardTypeID = ''S03''
			LEFT JOIN AT0128 A04 ON A04.DivisionID = AV2015_1.DivisionID AND AV2015_1.S04ID = A04.StandardID AND A04.StandardTypeID = ''S04''
			LEFT JOIN AT0128 A05 ON A05.DivisionID = AV2015_1.DivisionID AND AV2015_1.S05ID = A05.StandardID AND A05.StandardTypeID = ''S05''
			LEFT JOIN AT0128 A06 ON A06.DivisionID = AV2015_1.DivisionID AND AV2015_1.S06ID = A06.StandardID AND A06.StandardTypeID = ''S06''
			LEFT JOIN AT0128 A07 ON A07.DivisionID = AV2015_1.DivisionID AND AV2015_1.S07ID = A07.StandardID AND A07.StandardTypeID = ''S07''
			LEFT JOIN AT0128 A08 ON A08.DivisionID = AV2015_1.DivisionID AND AV2015_1.S08ID = A08.StandardID AND A08.StandardTypeID = ''S08''
			LEFT JOIN AT0128 A09 ON A09.DivisionID = AV2015_1.DivisionID AND AV2015_1.S09ID = A09.StandardID AND A09.StandardTypeID = ''S09''
			LEFT JOIN AT0128 A10 ON A10.DivisionID = AV2015_1.DivisionID AND AV2015_1.S10ID = A10.StandardID AND A10.StandardTypeID = ''S10''
			LEFT JOIN AT0128 A11 ON A11.DivisionID = AV2015_1.DivisionID AND AV2015_1.S11ID = A11.StandardID AND A11.StandardTypeID = ''S11''
			LEFT JOIN AT0128 A12 ON A12.DivisionID = AV2015_1.DivisionID AND AV2015_1.S12ID = A12.StandardID AND A12.StandardTypeID = ''S12''
			LEFT JOIN AT0128 A13 ON A13.DivisionID = AV2015_1.DivisionID AND AV2015_1.S13ID = A13.StandardID AND A13.StandardTypeID = ''S13''
			LEFT JOIN AT0128 A14 ON A14.DivisionID = AV2015_1.DivisionID AND AV2015_1.S14ID = A14.StandardID AND A14.StandardTypeID = ''S14''
			LEFT JOIN AT0128 A15 ON A15.DivisionID = AV2015_1.DivisionID AND AV2015_1.S15ID = A15.StandardID AND A15.StandardTypeID = ''S15''
			LEFT JOIN AT0128 A16 ON A16.DivisionID = AV2015_1.DivisionID AND AV2015_1.S16ID = A16.StandardID AND A16.StandardTypeID = ''S16''
			LEFT JOIN AT0128 A17 ON A17.DivisionID = AV2015_1.DivisionID AND AV2015_1.S17ID = A17.StandardID AND A17.StandardTypeID = ''S17''
			LEFT JOIN AT0128 A18 ON A18.DivisionID = AV2015_1.DivisionID AND AV2015_1.S18ID = A18.StandardID AND A18.StandardTypeID = ''S18''
			LEFT JOIN AT0128 A19 ON A19.DivisionID = AV2015_1.DivisionID AND AV2015_1.S19ID = A19.StandardID AND A19.StandardTypeID = ''S19''
			LEFT JOIN AT0128 A20 ON A20.DivisionID = AV2015_1.DivisionID AND AV2015_1.S20ID = A20.StandardID AND A20.StandardTypeID = ''S20''
			WHERE	AV2015_1.BeginQuantity <> 0 or AV2015_1.BeginAmount <> 0 or AV2015_1.ImQuantity <> 0 or
					AV2015_1.ImConvertedAmount <> 0 or AV2015_1.ExQuantity <> 0 or AV2015_1.ExConvertedAmount <> 0 
			'
		SET @sSQlUnionSelect = N' 
			UNION 

			SELECT  AV7015.WareHouseID  AS WareHouseID, AV7015.WareHouseName AS WareHouseName, Null AS VoucherID, Null AS TransactionID, 
					Null AS Orders,null AS VoucherDate, null AS VoucherNo, null AS ImVoucherDate, null AS ImVoucherNo, 
					null AS ImSourceNo,null AS ImLimitDate, null AS ImWareHouseID,
    				Null AS ImRefNo01, Null AS  ImRefNo02,

					0 AS ImQuantity, 0 AS ImUnitPrice, 0 AS ImConvertedAmount,
					0 AS ImOriginalAmount, 0 AS ImConvertedQuantity,   0 AS ExVoucherDate, null AS ExVoucherNo, 
					null AS ExSourceNo, null AS ExLimitDate, null AS ExWareHouseID, 
					Null AS ExRefNo01, Null AS  ExRefNo02,
					0 AS ExQuantity, 0 AS ExUnitPrice, 
					0 AS ExConvertedAmount,0 AS ExOriginalAmount, 0 AS ExConvertedQuantity, 
        			null AS VoucherTypeID, null AS Description,null AS Notes, 
					AV7015.InventoryID, InventoryName, AV7015.UnitID, AT1304.UnitName, 1 AS ConversionFactor,
					AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor AS  ConversionFactor01, AT1309.Operator,
					BeginQuantity, BeginAmount, 0 AS ImExOrders,NULL AS DebitAccountID, NULL AS CreditAccountID,
					null AS ObjectID,  null AS ObjectName,null AS Notes01, Null AS Notes02, Null AS Notes03, AV7015.DivisionID,
					NULL AS Ana01ID, NULL AS Ana02ID, NULL AS Ana03ID, NULL AS Ana04ID, NULL AS Ana05ID, NULL AS Ana06ID, NULL AS Ana07ID, NULL AS Ana08ID, NULL AS Ana09ID, NULL AS Ana10ID,
					NULL as Ana01Name, NULL as Ana02Name, NULL as Ana03Name, NULL as Ana04Name, NULL as Ana05Name, NULL as Ana06Name, NULL as Ana07Name, NULL as Ana08Name, NULL as Ana09Name, NULL as Ana10Name , 
					NULL AS InvoiceNo, NULL AS ConvertedUnitID,
					NULL as Parameter01,NULL as Parameter02,NULL as Parameter03,NULL as Parameter04,NULL as Parameter05,
					AV7015.S01ID,AV7015.S02ID,AV7015.S03ID,AV7015.S04ID,AV7015.S05ID,AV7015.S06ID,AV7015.S07ID,AV7015.S08ID,AV7015.S09ID,AV7015.S10ID,
					AV7015.S11ID,AV7015.S12ID,AV7015.S13ID,AV7015.S14ID,AV7015.S15ID,AV7015.S16ID,AV7015.S17ID,AV7015.S18ID,AV7015.S19ID,AV7015.S20ID,
					A01.StandardName AS StandardName01, A02.StandardName AS StandardName02, A03.StandardName AS StandardName03, A04.StandardName AS StandardName04, 
					A05.StandardName AS StandardName05, A06.StandardName AS StandardName06, A07.StandardName AS StandardName07, A08.StandardName AS StandardName08, 
					A09.StandardName AS StandardName09, A10.StandardName AS StandardName10, A11.StandardName AS StandardName11, A12.StandardName AS StandardName12,
					A13.StandardName AS StandardName13, A14.StandardName AS StandardName14, A15.StandardName AS StandardName15, A16.StandardName AS StandardName16,
					A17.StandardName AS StandardName17, A18.StandardName AS StandardName18, A19.StandardName AS StandardName19, A20.StandardName AS StandardName20
					'
					
			SET @sSQlUnionSelect1 = N'		
			FROM	AV7015 
			INNER JOIN AT1304 on AT1304.UnitID = AV7015.UnitID AND AT1304.DivisionID = AV7015.DivisionID
			LEFT JOIN AT1309 on AT1309.InventoryID = AV7015.InventoryID AND AT1309.UnitID = AV7015.UnitID AND AT1309.DivisionID = AV7015.DivisionID
			LEFT JOIN AT0128 A01 ON A01.DivisionID = AV7015.DivisionID AND AV7015.S01ID = A01.StandardID AND A01.StandardTypeID = ''S01''
			LEFT JOIN AT0128 A02 ON A02.DivisionID = AV7015.DivisionID AND AV7015.S02ID = A02.StandardID AND A02.StandardTypeID = ''S02''
			LEFT JOIN AT0128 A03 ON A03.DivisionID = AV7015.DivisionID AND AV7015.S03ID = A03.StandardID AND A03.StandardTypeID = ''S03''
			LEFT JOIN AT0128 A04 ON A04.DivisionID = AV7015.DivisionID AND AV7015.S04ID = A04.StandardID AND A04.StandardTypeID = ''S04''
			LEFT JOIN AT0128 A05 ON A05.DivisionID = AV7015.DivisionID AND AV7015.S05ID = A05.StandardID AND A05.StandardTypeID = ''S05''
			LEFT JOIN AT0128 A06 ON A06.DivisionID = AV7015.DivisionID AND AV7015.S06ID = A06.StandardID AND A06.StandardTypeID = ''S06''
			LEFT JOIN AT0128 A07 ON A07.DivisionID = AV7015.DivisionID AND AV7015.S07ID = A07.StandardID AND A07.StandardTypeID = ''S07''
			LEFT JOIN AT0128 A08 ON A08.DivisionID = AV7015.DivisionID AND AV7015.S08ID = A08.StandardID AND A08.StandardTypeID = ''S08''
			LEFT JOIN AT0128 A09 ON A09.DivisionID = AV7015.DivisionID AND AV7015.S09ID = A09.StandardID AND A09.StandardTypeID = ''S09''
			LEFT JOIN AT0128 A10 ON A10.DivisionID = AV7015.DivisionID AND AV7015.S10ID = A10.StandardID AND A10.StandardTypeID = ''S10''
			LEFT JOIN AT0128 A11 ON A11.DivisionID = AV7015.DivisionID AND AV7015.S11ID = A11.StandardID AND A11.StandardTypeID = ''S11''
			LEFT JOIN AT0128 A12 ON A12.DivisionID = AV7015.DivisionID AND AV7015.S12ID = A12.StandardID AND A12.StandardTypeID = ''S12''
			LEFT JOIN AT0128 A13 ON A13.DivisionID = AV7015.DivisionID AND AV7015.S13ID = A13.StandardID AND A13.StandardTypeID = ''S13''
			LEFT JOIN AT0128 A14 ON A14.DivisionID = AV7015.DivisionID AND AV7015.S14ID = A14.StandardID AND A14.StandardTypeID = ''S14''
			LEFT JOIN AT0128 A15 ON A15.DivisionID = AV7015.DivisionID AND AV7015.S15ID = A15.StandardID AND A15.StandardTypeID = ''S15''
			LEFT JOIN AT0128 A16 ON A16.DivisionID = AV7015.DivisionID AND AV7015.S16ID = A16.StandardID AND A16.StandardTypeID = ''S16''
			LEFT JOIN AT0128 A17 ON A17.DivisionID = AV7015.DivisionID AND AV7015.S17ID = A17.StandardID AND A17.StandardTypeID = ''S17''
			LEFT JOIN AT0128 A18 ON A18.DivisionID = AV7015.DivisionID AND AV7015.S18ID = A18.StandardID AND A18.StandardTypeID = ''S18''
			LEFT JOIN AT0128 A19 ON A19.DivisionID = AV7015.DivisionID AND AV7015.S19ID = A19.StandardID AND A19.StandardTypeID = ''S19''
			LEFT JOIN AT0128 A20 ON A20.DivisionID = AV7015.DivisionID AND AV7015.S20ID = A20.StandardID AND A20.StandardTypeID = ''S20''
			WHERE AV7015.InventoryID not in (Select InventoryID From AV7015) AND (BeginQuantity<>0 or BeginAmount<>0)
		 '
		 
		EXEC (@sSQLSelect + @sSQLSelect1 + @sSQlUnionSelect + @sSQlUnionSelect1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
