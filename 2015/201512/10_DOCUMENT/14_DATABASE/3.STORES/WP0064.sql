IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0064]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP0064]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kế thừa dự trù từ màn hình nghiệp vụ xuất kho
---- Source = 1 : Dự trù chi phí sản xuất của Quản lý đơn hàng
---- Source = 2 : Dự trù nguyên vật liệu của Quản lý Giá Thành
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 01/03/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 29/05/2012 by Thiên Huỳnh: Bổ sung 5 Khoản mục Ana06ID - Ana10ID
---- Modified on 28/10/2015 by Tiểu Mai: Bổ sung trường S01ID -> S20ID, điều kiện where TranMonth, TranYear 
-- <Example>
---- 
--exec WP0064 @DivisionID=N'AS',@UserID=N'ASOFTADMIN',@ObjectID=N'123',@FromMonth=1,@FromYear=2012,@ToMonth=3,@ToYear=2012,@IsDisplayAll=1,@IsSource=2

CREATE PROCEDURE WP0064
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@ObjectID AS NVARCHAR(50),
		@FromMonth AS INT,
		@FromYear AS INT,
		@ToMonth AS INT,
		@ToYear AS INT,
		@IsDisplayAll AS INT,
		@IsSource AS INT
		
) 
AS 
DECLARE @Ssql AS VARCHAR(8000),
		@SWhere AS VARCHAR(8000)

SET @SWhere = ''

IF @ObjectID <> '' AND @IsSource = 1
	SET @SWhere = '
		AND		OT2201.ObjectID = '''+@ObjectID+''''
	
IF @IsSource = 1 
SET @Ssql = '
SELECT 
		OT2201.EstimateID, OT2201.DivisionID, OT2201.TranMonth, OT2201.TranYear, 
		OT2201.VoucherTypeID, OT2201.VoucherNo, OT2201.VoucherDate, 
		OT2201.ObjectID, AT1202.ObjectName, OT2201.Description,  
		OT2201.WareHouseID, 
		OT2203.TransactionID,
		OT2203.Orders, OT2203.MaterialID, M.InventoryName AS MaterialName, 
		M.UnitID, M.AccountID, OT2203.MaterialDate AS EstimateExportDate,  
		M.MethodID, M.IsSource, M.IsLimitDate, 
		OT2203.MaterialQuantity, 
		(	SELECT	MAX(VoucherDate) 
			FROM	AT2006 
			INNER JOIN AT2007 ON AT2006.VoucherID = AT2007.VoucherID  AND AT2006.DivisionID = AT2007.DivisionID 
		 	WHERE	AT2007.ETransactionID = OT2203.TransactionID) AS ExportDate,
		ISNULL((	SELECT	SUM(ISNULL(ActualQuantity,0)) 
					FROM	AT2007 
		        	WHERE	AT2007.DivisionID = '''+@DivisionID +'''
		        			AND AT2007.ETransactionID = OT2203.TransactionID),0) AS InheritedQuantity,
		OT2203.MaterialQuantity - ISNULL((	SELECT	SUM(ISNULL(ActualQuantity,0)) 
											FROM	AT2007 
		                                  	WHERE	AT2007.DivisionID = '''+@DivisionID +'''
		                                  			AND AT2007.ETransactionID = OT2203.TransactionID),0) AS RemainQuantity,
		MDescription, 
		OT2201.PeriodID, MT1601.Description AS PeriodName,
		OT2202.ProductID, P.InventoryName AS ProductName ,
		OT2202.Ana01ID, OT2202.Ana02ID, OT2202.Ana03ID, OT2202.Ana04ID, OT2202.Ana05ID, 
		OT2202.Ana06ID, OT2202.Ana07ID, OT2202.Ana08ID, OT2202.Ana09ID, OT2202.Ana10ID, 
		A1.AnaName AS Ana01Name, A2.AnaName AS Ana02Name, A3.AnaName AS Ana03Name, A4.AnaName AS Ana04Name, A5.AnaName AS Ana05Name,
		A6.AnaName AS Ana06Name, A7.AnaName AS Ana07Name, A8.AnaName AS Ana08Name, A9.AnaName AS Ana09Name, A10.AnaName AS Ana10Name,
		OT2202.MOrderID, OT2202.SOrderID, OT2202.MTransactionID, OT2202.STransactionID,
		'''' as S01ID, '''' as S02ID, '''' as S03ID, '''' as S04ID, '''' as S05ID, '''' as S06ID, '''' as S07ID, '''' as S08ID, '''' as S09ID, '''' as S10ID,
		'''' as S11ID, '''' as S12ID, '''' as S13ID, '''' as S14ID, '''' as S15ID, '''' as S16ID, '''' as S17ID, '''' as S18ID, '''' as S19ID, '''' as S20ID
FROM OT2201 
INNER JOIN OT2202 On OT2201.EstimateID = OT2202.EstimateID AND OT2202.DivisionID = OT2201.DivisionID
INNER JOIN OT2203 On OT2202.EstimateID = OT2203.EstimateID And OT2202.EDetailID = OT2203.EDetailID AND OT2202.DivisionID = OT2201.DivisionID
LEFT JOIN AT1202 On OT2201.ObjectID = AT1202.ObjectID AND AT1202.DivisionID = OT2201.DivisionID
LEFT JOIN AT1302 P On OT2202.ProductID = P.InventoryID AND P.DivisionID = OT2201.DivisionID
LEFT JOIN AT1302 M On OT2203.MaterialID = M.InventoryID AND M.DivisionID = OT2201.DivisionID
LEFT JOIN MT1601 On OT2201.PeriodID = MT1601.PeriodID AND MT1601.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A1 On OT2202.Ana01ID = A1.AnaID And A1.AnaTypeID = ''A01'' AND A1.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A2 On OT2202.Ana02ID = A2.AnaID And A2.AnaTypeID = ''A02'' AND A2.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A3 On OT2202.Ana03ID = A3.AnaID And A3.AnaTypeID = ''A03'' AND A3.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A4 On OT2202.Ana04ID = A4.AnaID And A4.AnaTypeID = ''A04'' AND A4.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A5 On OT2202.Ana05ID = A5.AnaID And A5.AnaTypeID = ''A05'' AND A5.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A6 On OT2202.Ana06ID = A6.AnaID And A6.AnaTypeID = ''A06'' AND A6.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A7 On OT2202.Ana07ID = A7.AnaID And A7.AnaTypeID = ''A07'' AND A7.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A8 On OT2202.Ana08ID = A8.AnaID And A8.AnaTypeID = ''A08'' AND A8.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A9 On OT2202.Ana09ID = A9.AnaID And A9.AnaTypeID = ''A09'' AND A9.DivisionID = OT2201.DivisionID
LEFT JOIN AT1011 A10 On OT2202.Ana10ID = A10.AnaID And A10.AnaTypeID = ''A10'' AND A10.DivisionID = OT2201.DivisionID

WHERE OT2201.OrderStatus = 1
		AND OT2201.TranMonth + OT2201.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' AND ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))
		

ELSE
SET @Ssql = '
	SELECT 
		MT2101.EstimateID, MT2101.DivisionID, MT2101.TranMonth, MT2101.TranYear, 
		MT2101.VoucherTypeID, MT2101.VoucherNo, MT2101.VoucherDate, 
		'''' AS ObjectID, '''' AS ObjectName, MT2101.Description,  
		'''' AS WareHouseID, 
		MT2103.TransactionID,
		MT2103.Orders, MT2103.MaterialID, M.InventoryName AS MaterialName, 
		M.UnitID, M.AccountID, 
		CONVERT(DATETIME, NULL) AS EstimateExportDate,  
		M.MethodID, M.IsSource, M.IsLimitDate, 
		MT2103.MaterialQuantity, 
		(	SELECT	MAX(VoucherDate) 
			FROM	AT2006 
			INNER JOIN AT2007 ON AT2006.VoucherID = AT2007.VoucherID  AND AT2006.DivisionID = AT2007.DivisionID 
		 	WHERE	AT2007.ETransactionID = MT2103.TransactionID) AS ExportDate,
		ISNULL((	SELECT	SUM(ISNULL(ActualQuantity,0)) 
					FROM	AT2007 
		        	WHERE	AT2007.DivisionID = '''+@DivisionID +'''
		        			AND AT2007.ETransactionID = MT2103.TransactionID),0) AS InheritedQuantity,
		MT2103.MaterialQuantity - ISNULL((	SELECT	SUM(ISNULL(ActualQuantity,0)) 
											FROM	AT2007 
		                                  	WHERE	AT2007.DivisionID = '''+@DivisionID +'''
		                                  			AND AT2007.ETransactionID = MT2103.TransactionID),0) AS RemainQuantity,
		MDescription, 
		'''' AS PeriodID, '''' AS PeriodName,
		MT2102.ProductID, P.InventoryName AS ProductName ,
		'''' AS Ana01ID, 
		'''' AS Ana02ID, 
		'''' AS Ana03ID, 
		'''' AS Ana04ID, 
		'''' AS Ana05ID, 
		'''' AS Ana06ID, 
		'''' AS Ana07ID, 
		'''' AS Ana08ID, 
		'''' AS Ana09ID, 
		'''' AS Ana10ID, 
		'''' AS Ana01Name, 
		'''' AS Ana02Name, 
		'''' AS Ana03Name, 
		'''' AS Ana04Name, 
		'''' AS Ana05Name,
		'''' AS Ana06Name, 
		'''' AS Ana07Name, 
		'''' AS Ana08Name, 
		'''' AS Ana09Name, 
		'''' AS Ana10Name,
		'''' AS MOrderID, 
		'''' AS SOrderID, 
		'''' AS MTransactionID, 
		'''' AS STransactionID,
		'''' as S01ID, '''' as S02ID, '''' as S03ID, '''' as S04ID, '''' as S05ID, '''' as S06ID, '''' as S07ID, '''' as S08ID, '''' as S09ID, '''' as S10ID,
		'''' as S11ID, '''' as S12ID, '''' as S13ID, '''' as S14ID, '''' as S15ID, '''' as S16ID, '''' as S17ID, '''' as S18ID, '''' as S19ID, '''' as S20ID
FROM MT2101 
INNER JOIN MT2102 On MT2101.EstimateID = MT2102.EstimateID AND MT2101.DivisionID = MT2102.DivisionID
INNER JOIN MT2103 On MT2102.EstimateID = MT2103.EstimateID And MT2102.EDetailID = MT2103.EDetailID AND MT2102.DivisionID = MT2101.DivisionID
LEFT JOIN AT1302 P On MT2102.ProductID = P.InventoryID AND P.DivisionID = MT2101.DivisionID
LEFT JOIN AT1302 M On MT2103.MaterialID = M.InventoryID AND M.DivisionID = MT2101.DivisionID

WHERE MT2101.Status = 1
AND MT2101.TranMonth + MT2101.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' AND ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))

PRINT(@Ssql)
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='WQ3027')
	EXEC ('CREATE VIEW WQ3027  ---TAO BOI WP0064
		AS '+@sSQL )
ELSE
	EXEC( 'ALTER VIEW WQ3027  ---TAO BOI WP0064
		AS '+@sSQL )
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

