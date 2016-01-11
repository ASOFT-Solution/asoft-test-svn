IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0109]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0109]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO PHIẾU PHA TRỘN DẦU NHỜN [LBA] [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 20/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
-- MP0109 @DivisionID = 'AP', @VoucherID = '2BDB52AC-93AB-4212-9A54-AE17079C3FD2'

CREATE PROCEDURE [dbo].[MP0109] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX)
-- Lấy dữ liệu Master + BaseOil + Additive
SET @sSQL1 = '
SELECT MT07.VoucherID, MT07.VoucherDate AS MixVoucherDate, OT21.VoucherNo AS MOVoucherNo, MT07.VoucherNo AS MixVoucherNo, 
	   OT21.ObjectID, AT12.ObjectName, MT07.ProductID, AT13.InventoryName AS ProductName, 
	   ISNULL(MT08.TypeID,0) AS TypeID, MT08.MaterialID, AT02.InventoryName AS MaterialName, MT08.Notes01, 
	   0 AS VolumeTotal, SUM(ISNULL(AT27.ActualQuantity,0)) AS WeightTotal, MT07.[Description], 
	   ISNULL(MT07.ProductQuantity,0) AS MixProductQuantity, AT13.UnitID, AT14.UnitName AS ProductUnitName, 
	   MT07.BatchNo, OT21.OrderDate AS MOVoucherDate
FROM MT0107 MT07
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT07.DivisionID AND MT08.VoucherID = MT07.VoucherID
LEFT JOIN OT2001 OT21 ON OT21.DivisionID = MT07.DivisionID AND MT07.MOVoucherID = OT21.SOrderID AND OT21.OrderType = 1
LEFT JOIN MT2001 MT21 ON MT21.DivisionID = MT07.DivisionID AND MT21.MixVoucherID = MT07.VoucherID AND MT21.ProductID = MT07.ProductID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT07.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT08.TransactionID
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = OT21.DivisionID AND AT12.ObjectID = OT21.ObjectID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = MT07.DivisionID AND AT13.InventoryID = MT07.ProductID
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT08.DivisionID AND AT02.InventoryID = MT08.MaterialID
LEFT JOIN AT1304 AT14 ON AT14.DivisionID = MT07.DivisionID AND AT14.UnitID = AT13.UnitID
WHERE MT07.DivisionID = '''+@DivisionID+''' AND MT07.VoucherID = '''+@VoucherID+'''
GROUP BY MT07.VoucherID, MT07.VoucherDate, OT21.VoucherNo, MT07.VoucherNo, OT21.ObjectID, AT12.ObjectName, 
	     MT07.ProductID, AT13.InventoryName, MT08.TypeID, MT08.MaterialID, AT02.InventoryName, MT08.Notes01,
	     MT07.[Description], MT07.ProductQuantity, AT13.UnitID, AT14.UnitName, MT07.BatchNo, OT21.OrderDate
' 
EXEC (@sSQL1)
--PRINT @sSQL1
---- Lấy dữ liệu Packing Material
SET @sSQL2 = '
SELECT MT07.VoucherID, MT64.InventoryID AS MaterialID, AT02.InventoryName AS MaterialName, AT02.Notes01, 
	   SUM(ISNULL(AT27.ActualQuantity,0)) AS Quantity
FROM MT0107 MT07
LEFT JOIN OT2001 OT21 ON OT21.DivisionID = MT07.DivisionID AND MT07.MOVoucherID = OT21.SOrderID AND OT21.OrderType = 1
LEFT JOIN MT2001 MT21 ON MT21.DivisionID = MT07.DivisionID AND MT21.MixVoucherID = MT07.VoucherID AND MT21.ProductID = MT07.ProductID
LEFT JOIN MT0164 MT64 ON MT64.DivisionID = MT07.DivisionID AND MT64.PlanID = MT21.PlanID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT07.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT64.APK
LEFT JOIN AT1302 AT02 ON AT02.DivisionID = MT64.DivisionID AND AT02.InventoryID = MT64.InventoryID
WHERE MT07.DivisionID = '''+@DivisionID+''' AND MT07.VoucherID = '''+@VoucherID+'''
GROUP BY MT07.VoucherID, MT64.InventoryID, AT02.InventoryName, AT02.Notes01
HAVING SUM(ISNULL(AT27.ActualQuantity,0)) > 0
'
EXEC (@sSQL2)
--PRINT @sSQL2
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

