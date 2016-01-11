IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].AP2088') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].AP2088
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Bao Anh	Date: 04/10/2012
--- Purpose: Chi tiet nhap xuat vat tu theo quy cach (2T)
--- <Example>
---

CREATE PROCEDURE [dbo].AP2088
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
        @sSQlFrom AS nvarchar(4000) ,
        @sSQlWhere AS nvarchar(4000) ,
        @sSQlUnionSelect AS nvarchar(4000) ,
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
    
EXEC AP7085 @DivisionID , @WareHouseID , @FromInventoryID , @ToInventoryID , @FromMonth , @FromYear , @ToMonth , @ToYear , @FromDate , @ToDate , @IsDate


IF @IsInner = 0
   BEGIN
         SET @KindVoucherListEx1 = '(2,4,8,10,14,20) '
         SET @KindVoucherListEx2 = '(2,4,8,10,14,20) '
         SET @KindVoucherListIm = '(1,5,7,9,15,17) '
   END
ELSE
   BEGIN
         SET @KindVoucherListEx1 = '(2,4,3,8,10,14,20) '
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
					At2006.ObjectID,
					AT1202.ObjectName,
					AT1302.Notes01,
					AT1302.Notes02,
					AT1302.Notes03, AT2007.DivisionID,
					AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
					AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05'

		SET @sSQlFrom = ' 
			FROM AT1302	 	
			INNER JOIN AT2007 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
			INNER JOIN AT2006 on AT2006.VoucherID = AT2007.VoucherID  AND AT2006.DivisionID = AT2007.DivisionID
			LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID AND AV7015.DivisionID = AT2007.DivisionID
							AND Isnull(AV7015.Parameter01,0) = Isnull(AT2007.Parameter01,0) And Isnull(AV7015.Parameter02,0) = Isnull(AT2007.Parameter02,0)
							AND Isnull(AV7015.Parameter03,0) = Isnull(AT2007.Parameter03,0)	AND Isnull(AV7015.Parameter04,0) = Isnull(AT2007.Parameter04,0)
							AND Isnull(AV7015.Parameter05,0) = Isnull(AT2007.Parameter05,0)
			INNER JOIN AT1303 on AT1303.WareHouseID = AT2006.WareHouseID AND AT1303.DivisionID = AT2007.DivisionID
			LEFT  JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID'
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
				At2006.ObjectID,
				AT1202.ObjectName,
				AT1302.Notes01,
				AT1302.Notes02,
				AT1302.Notes03, AT2007.DivisionID,
				AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
				AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05'
		SET @sSQlUnionFrom = ' 
			FROM AT1302 	
			LEFT JOIN AT2007 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
			INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND At2006.DivisionID = AT2007.DivisionID
			LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID	AND AV7015.DivisionID = AT2007.DivisionID
							AND Isnull(AV7015.Parameter01,0) = Isnull(AT2007.Parameter01,0) And Isnull(AV7015.Parameter02,0) = Isnull(AT2007.Parameter02,0)
							AND Isnull(AV7015.Parameter03,0) = Isnull(AT2007.Parameter03,0)	AND Isnull(AV7015.Parameter04,0) = Isnull(AT2007.Parameter04,0)
							AND Isnull(AV7015.Parameter05,0) = Isnull(AT2007.Parameter05,0)
			INNER JOIN AT1303 on AT1303.WareHouseID = ( CASE WHEN KindVoucherID = 3 Then AT2006.WareHouseID2  Else AT2006.WareHouseID end) 	 AND AT1303.DivisionID = AT2007.DivisionID
			LEFT JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID'
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
				N''' + @WareHouseName + ''' AS WareHouseName, 
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
				AT1302.Notes03, AT2007.DivisionID,
				AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
				AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05'
		
		SET @sSQlFrom = ' 
			FROM AT1302	
			LEFT JOIN AT2007  on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
			INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND At2006.DivisionID = AT2007.DivisionID
			LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID AND AV7015.DivisionID = AT2007.DivisionID
							AND Isnull(AV7015.Parameter01,0) = Isnull(AT2007.Parameter01,0) And Isnull(AV7015.Parameter02,0) = Isnull(AT2007.Parameter02,0)
							AND Isnull(AV7015.Parameter03,0) = Isnull(AT2007.Parameter03,0)	AND Isnull(AV7015.Parameter04,0) = Isnull(AT2007.Parameter04,0)
							AND Isnull(AV7015.Parameter05,0) = Isnull(AT2007.Parameter05,0)
			INNER JOIN AT1303 on AT1303.WareHouseID = AT2006.WareHouseID AND AT1303.DivisionID = AT2007.DivisionID
			LEFT JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID'
		
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
					N''' + @WareHouseName + ''' AS WareHouseName, 
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
					AT2007.UnitID,		
					isnull(AT2007.ConversionFactor ,1) AS ConversionFactor,
					isnull(AV7015.BeginQuantity,0) AS BeginQuantity,
					isnull(AV7015.BeginAmount,0) AS BeginAmount,
					2 AS ImExOrders,
					AT2007.DebitAccountID, AT2007.CreditAccountID,
					At2006.ObjectID,
					AT1202.ObjectName,
					AT1302.Notes01,
					AT1302.Notes02,
					AT1302.Notes03,AT2007.DivisionID,
					AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID,
					AT2007.Parameter01, AT2007.Parameter02, AT2007.Parameter03, AT2007.Parameter04, AT2007.Parameter05'	
					
			SET @sSQlUnionFrom = ' 
				FROM AT1302 	
				LEFT JOIN AT2007 on AT1302.InventoryID = AT2007.InventoryID AND AT1302.DivisionID = AT2007.DivisionID
				INNER JOIN AT2006 on At2006.VoucherID = AT2007.VoucherID AND AT2006.DivisionID = AT2007.DivisionID
				LEFT JOIN AV7015 on AV7015.InventoryID = AT2007.InventoryID AND AV7015.DivisionID = AT2007.DivisionID
								AND Isnull(AV7015.Parameter01,0) = Isnull(AT2007.Parameter01,0) And Isnull(AV7015.Parameter02,0) = Isnull(AT2007.Parameter02,0)
								AND Isnull(AV7015.Parameter03,0) = Isnull(AT2007.Parameter03,0)	AND Isnull(AV7015.Parameter04,0) = Isnull(AT2007.Parameter04,0)
								AND Isnull(AV7015.Parameter05,0) = Isnull(AT2007.Parameter05,0)
				INNER JOIN AT1303 on AT1303.WareHouseID = ( CASE WHEN KindVoucherID = 3 Then AT2006.WareHouseID2  Else AT2006.WareHouseID end)  AND AT1303.DivisionID = AT2007.DivisionID
				LEFT JOIN AT1202 on AT1202.ObjectID = AT2006.ObjectID  AND AT1202.DivisionID = AT2007.DivisionID'

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
/*
print @sSQLSelect
print @sSQlFrom
print @sSQlWhere
print @sSQlUnionSelect
print @sSQlUnionFrom
print @sSQlUnionWhere
*/

IF NOT EXISTS ( SELECT 1 FROM SysObjects WHERE Xtype = 'V' AND Name = 'AV2028' )
   BEGIN
         EXEC ( 'CREATE VIEW AV2028 --CREATED BY AP2018
					AS '+@sSQLSelect+@sSQlFrom+@sSQlWhere+@sSQlUnionSelect+@sSQlUnionFrom+@sSQlUnionWhere )
   END
ELSE
   BEGIN
         EXEC ( 'ALTER VIEW AV2028 --CREATED BY AP2018
					as '+@sSQLSelect+@sSQlFrom+@sSQlWhere+@sSQlUnionSelect+@sSQlUnionFrom+@sSQlUnionWhere )
   END
 
--- Lay du su va phat sinh
SET @sSQLSelect = N' 
	SELECT	AV2028.WareHouseID, AV2028.WareHouseName, AV2028.VoucherID, AV2028.TransactionID, AV2028.Orders,
			DATEADD(d, 0, DATEDIFF(d, 0, AV2028.VoucherDate)) AS VoucherDate, AV2028.VoucherNo, AV2028.ImVoucherDate, AV2028.ImVoucherNo, AV2028.ImSourceNo,
			AV2028.ImLimitDate, AV2028.ImWareHouseID, 
			AV2028.ImRefNo01, AV2028.ImRefNo02,
			AV2028.ImQuantity, AV2028.ImUnitPrice, AV2028.ImConvertedAmount,
			AV2028.ImOriginalAmount, AV2028.ImConvertedQuantity,  
			AV2028.ExVoucherDate, AV2028.ExVoucherNo, AV2028.ExSourceNo,
			AV2028.ExLimitDate, AV2028.ExWareHouseID, 
			AV2028.ExRefNo01, AV2028.ExRefNo02,
			AV2028.ExQuantity, AV2028.ExUnitPrice, AV2028.ExConvertedAmount,
			AV2028.ExOriginalAmount, AV2028.ExConvertedQuantity, AV2028.VoucherTypeID, AV2028.Description,
			AV2028.Notes, AV2028.InventoryID, AV2028.InventoryName, AV2028.UnitID,  AT1304.UnitName, AV2028.ConversionFactor,
	        AT1309.UnitID AS ConversionUnitID, AT1309.ConversionFactor AS  ConversionFactor01, AT1309.Operator,
	        AV2028.BeginQuantity, AV2028.BeginAmount, AV2028.ImExOrders, AV2028.DebitAccountID, AV2028.CreditAccountID,
	        AV2028.ObjectID, AV2028.ObjectName, AV2028.Notes01, AV2028.Notes02, AV2028.Notes03, AV2028.DivisionID,
			AV2028.Ana01ID, AV2028.Ana02ID, AV2028.Ana03ID, AV2028.Ana04ID, AV2028.Ana05ID,
			AV2028.Parameter01, AV2028.Parameter02, AV2028.Parameter03, AV2028.Parameter04, AV2028.Parameter05
	
	FROM	AV2028 
	LEFT JOIN AT1304 on AT1304.UnitID = AV2028.UnitID AND  AT1304.DivisionID = AV2028.DivisionID 
	LEFT JOIN AT1309 on AT1309.InventoryID = AV2028.InventoryID AND AT1309.UnitID = AV2028.UnitID AND AT1309.DivisionID = AV2028.DivisionID 

	WHERE	AV2028.BeginQuantity <> 0 or AV2028.BeginAmount <> 0 or AV2028.ImQuantity <> 0 or
			AV2028.ImConvertedAmount <> 0 or AV2028.ExQuantity <> 0 or AV2028.ExConvertedAmount <> 0 '

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
			NULL AS Ana01ID, NULL AS Ana02ID, NULL AS Ana03ID, NULL AS Ana04ID, NULL AS Ana05ID,
			AV7015.Parameter01, AV7015.Parameter02, AV7015.Parameter03, AV7015.Parameter04, AV7015.Parameter05
	
	FROM	AV7015 
	INNER JOIN AT1304 on AT1304.UnitID = AV7015.UnitID AND AT1304.DivisionID = AV7015.DivisionID
	LEFT JOIN AT1309 on AT1309.InventoryID = AV7015.InventoryID AND AT1309.UnitID = AV7015.UnitID AND AT1309.DivisionID = AV7015.DivisionID

	WHERE AV7015.InventoryID not in (Select InventoryID From AV2028) 
		AND Isnull(AV7015.Parameter01,0) not in (Select Isnull(Parameter01,0) From AV2028)
		AND Isnull(AV7015.Parameter02,0) not in (Select Isnull(Parameter02,0) From AV2028)
		AND Isnull(AV7015.Parameter03,0) not in (Select Isnull(Parameter03,0) From AV2028)
		AND Isnull(AV7015.Parameter04,0) not in (Select Isnull(Parameter04,0) From AV2028)
		AND Isnull(AV7015.Parameter05,0) not in (Select Isnull(Parameter05,0) From AV2028)
		AND (BeginQuantity<>0 or BeginAmount<>0)
 '
--Print @sSQL

IF NOT EXISTS ( SELECT  1 FROM  SysObjects  WHERE  Xtype = 'V' AND Name = 'AV2018' )
   BEGIN
         EXEC ( 'CREATE VIEW AV2018 	--CREATED BY AP2018
				AS '+@sSQLSelect+@sSQlUnionSelect )
   END
ELSE
   BEGIN
         EXEC ( 'ALTER VIEW AV2018 		--CREATED BY AP2018
				AS '+@sSQLSelect+@sSQlUnionSelect )
   END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

