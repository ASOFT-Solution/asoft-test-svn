IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0116]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0116]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO BẢNG TÍNH GIÁ VỐN VÀ DANH MỤC GIÁ VỐN SẢN PHẨM [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 26/09/2014 by Lê Thị Hạnh 
---- Modified by Lê Thị Hạnh on 05/11/2014: Thay đổi cách lấy giá trị trường Notes01 
---- Modified by Lê Thị Hạnh on 16/01/2015: Cập nhật cách lấy dữ liệu lên báo cáo MR0116-MR0115: Giá bao bì * số lượng
---- Modified by Lê Thị Hạnh on 13/04/2015: Cập nhật cách lấy thông tin bao bì - 10/04/2015 
-- <Example>
-- MP0116 @DivisionID = 'VG', @VoucherID = '90AB9ED0-AE5A-4A86-A78C-DCA4504F31E1', @FromMonth = 7, @FromYear = 2014, @ToMonth = 9, @ToYear = 2014, @FromProductID = '1521A00001', @ToProductID = 'ZZ'

CREATE PROCEDURE [dbo].[MP0116] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50) = NULL,
	@FromMonth INT = NULL,
	@FromYear INT = NULL,
	@ToMonth INT = NULL,
	@ToYear INT = NULL,
	@FromProductID NVARCHAR(50) = NULL,
	@ToProductID NVARCHAR(50) = NULL
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX),
		@sSQL3 NVARCHAR(MAX)

IF ISNULL(@VoucherID,'') <> ''
	BEGIN
	-- IN BẢNG TÍNH GIÁ VỐN - MR0116
	-- Lấy quy cách đóng gói
-- PackingCost = SUM(MT16.ConvertedAmount) với TypeID = 3
	SET @sSQL1 = '
SELECT MT15.ProductID, AT12.UnitID, AT14.UnitName,
       ISNULL(MT13.ProductQuantity,0) AS QuanPacks, ISNULL(MT13.Notes02,0) AS NetVolume, 
       ISNULL(MT13.TotalVolume,0) AS TotalVolume, 
       SUM(ISNULL(MT16.ConvertedAmount,0)) AS PackingCost 
FROM MT0115 MT15
INNER JOIN MT0116 MT16 ON MT16.DivisionID = MT15.DivisionID AND MT16.VoucherID = MT15.VoucherID
LEFT JOIN MT0113 MT13 ON MT13.DivisionID = MT15.DivisionID AND MT13.ID = MT15.PMID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT15.DivisionID AND AT12.InventoryID = MT15.ProductID
LEFT JOIN AT1304 AT14 ON AT14.DivisionID = AT12.DivisionID AND AT14.UnitID = AT12.UnitID
WHERE MT15.DivisionID = '''+@DivisionID+''' AND MT15.VoucherID = '''+@VoucherID+'''
      AND MT16.TypeID = 3
GROUP BY MT15.ProductID, MT13.ProductQuantity, MT13.Notes02, MT13.TotalVolume,
         AT12.UnitID, AT14.UnitName
ORDER BY MT15.ProductID, AT12.UnitID
	'
	EXEC (@sSQL1)
	--PRINT @sSQL1
	-- Load Master và chi phí bao bì
-- lấy PacksCost = SUM(MT16.ConvertedAmount) VỚI TYPEID = 3
	SET @sSQL2 = '
SELECT MT15.VoucherDate, MT15.ProductID, AT12.InventoryName AS ProductName, MT07.BatchNo, MT15.CurrencyID, 
       ISNULL(MT15.ExchangeRate,0) AS ExchangeRate, ISNULL(MT15.CostAmount,0) AS CostAmount,
       CASE WHEN ISNULL(MT15.IsVND,0) = 1 THEN N''VND''
            WHEN ISNULL(MT15.IsVND,0) = 0 THEN MT15.CurrencyID 
            ELSE N'''' END AS VND,
       ISNULL(MT16.MaterialCost,0) AS MaterialCost, ISNULL(MT16.PacksCost,0) AS PacksCost,
       (ISNULL(MT16.MaterialCost,0) + ISNULL(MT16.PacksCost,0)*ISNULL(MT13.ProductQuantity,0) + ISNULL(MT15.CostAmount,0)*ISNULL(MT13.TotalVolume,0)) AS ProductCost,
       (CASE WHEN ISNULL(MT13.ProductQuantity,0) <> 0 THEN
             (ISNULL(MT16.MaterialCost,0) + ISNULL(MT16.PacksCost,0)*ISNULL(MT13.ProductQuantity,0) + ISNULL(MT15.CostAmount,0)*ISNULL(MT13.TotalVolume,0))/ISNULL(MT13.TotalVolume,0) 
             ELSE 0.0 END) AS CostPerProduct 
FROM MT0115 MT15
INNER JOIN (
	SELECT MT16.DivisionID, MT16.VoucherID,
		   SUM(CASE WHEN ISNULL(MT16.TypeID,0) IN (1,2) THEN ISNULL(MT16.ConvertedAmount,0)
			   ELSE 0.0 END) AS MaterialCost,
		   SUM(CASE WHEN ISNULL(MT16.TypeID,0) IN (3) THEN ISNULL(MT16.ConvertedAmount,0)
			   ELSE 0.0 END) AS PacksCost
	FROM MT0116 MT16
	INNER JOIN MT0115 MT15 ON MT15.DivisionID = MT16.DivisionID AND MT15.VoucherID = MT16.VoucherID
	GROUP BY MT16.DivisionID, MT16.VoucherID
) AS MT16 ON MT16.DivisionID = MT15.DivisionID AND MT16.VoucherID = MT15.VoucherID
LEFT JOIN MT0113 MT13 ON MT13.DivisionID = MT15.DivisionID AND MT13.ID = MT15.PMID
LEFT JOIN MT0107 MT07 ON MT07.DivisionID = MT13.DivisionID AND MT07.VoucherID = MT13.MixVoucherID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT15.DivisionID AND AT12.InventoryID = MT15.ProductID
WHERE MT15.DivisionID = '''+@DivisionID+''' AND MT15.VoucherID = '''+@VoucherID+'''
GROUP BY MT15.VoucherDate, MT15.ProductID, AT12.InventoryName, MT07.BatchNo, MT15.CurrencyID,
         MT15.ExchangeRate, MT15.CostAmount, MT15.IsVND, MT15.CurrencyID, 
         MT16.MaterialCost, MT16.PacksCost, MT13.TotalVolume, MT13.ProductQuantity
	'
	EXEC (@sSQL2)
	--PRINT @sSQL2
	--- Load lưới dầu gốc và phụ gia

	SET @sSQL3 = '
SELECT MT15.CurrencyID, ISNULL(MT16.TypeID,0) AS TypeID, ISNULL(MT16.Orders,0) AS Orders, 
       MT16.MaterialID, AT12.InventoryName AS MaterialName, MT08.Notes01, 
       ISNULL(MT14.VolumeTotal,0) AS VolumeTotal, ISNULL(MT14.WeightTotal,0) AS WeightTotal, 
       ISNULL(MT16.UnitPrice,0) AS UnitPrice, ISNULL(MT16.VATImPercent,0) AS VATImPercent, 
       ISNULL(MT16.VATPercent,0) AS VATPercent, ISNULL(MT16.ConvertedAmount,0) AS ConvertedAmount
FROM MT0116 MT16
INNER JOIN MT0115 MT15 ON MT15.DivisionID = MT16.DivisionID AND MT15.VoucherID = MT16.VoucherID
LEFT JOIN (
	SELECT MT13.DivisionID, MT13.ID, MT13.MixVoucherID, MT14.InventoryID,
	       MT14.TypeID, MT14.VolumeTotal, MT14.WeightTotal
	FROM MT0114 MT14 
	INNER JOIN MT0113 MT13 ON MT13.DivisionID = MT14.DivisionID AND MT13.ID = MT14.ID	
) AS MT14 ON MT14.DivisionID = MT16.DivisionID AND MT14.ID = MT15.PMID AND MT14.InventoryID = MT16.MaterialID AND MT14.TypeID = MT16.TypeID
LEFT JOIN MT0108 MT08 ON MT08.DivisionID = MT14.DivisionID AND MT08.VoucherID = MT14.MixVoucherID AND MT08.MaterialID = MT14.InventoryID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT16.DivisionID AND AT12.InventoryID = MT16.MaterialID
WHERE MT16.DivisionID = '''+@DivisionID+''' AND MT16.VoucherID = '''+@VoucherID+''' AND ISNULL(MT16.TypeID,0) IN (1,2)
ORDER BY MT16.TypeID, MT16.Orders
	'
	EXEC (@sSQL3)
	--PRINT @sSQL3
	END
ELSE 
	BEGIN
	-- IN DANH MỤC GIÁ VỐN SẢN PHẨM - MR0115
-- lấy PacksCost = SUM(MT16.ConvertedAmount) VỚI TYPEID = 3
	SET @sSQL1 ='
SELECT MT15.TranYear, MT15.TranMonth, MT15.VoucherNo, MT15.VoucherDate, MT15.ProductID, AT12.InventoryName AS ProductName,
       MT15.CurrencyID, ISNULL(MT15.ExchangeRate,0) AS ExchangeRate, 
       MT15.VoucherTypeID, MT15.PMID, MT15.PriceListID, MT15.[Description],
       ISNULL(MT15.CostAmount,0) AS CostAmount,
       ISNULL(MT16.MaterialCost,0) AS MaterialCost, ISNULL(MT16.PacksCost,0) AS PacksCost,
       (ISNULL(MT16.MaterialCost,0) + ISNULL(MT16.PacksCost,0)*ISNULL(MT13.ProductQuantity,0) + ISNULL(MT15.CostAmount,0)*ISNULL(MT13.TotalVolume,0)) AS ProductCost,
       (CASE WHEN ISNULL(MT13.ProductQuantity,0) <> 0 THEN
             (ISNULL(MT16.MaterialCost,0) + ISNULL(MT16.PacksCost,0)*ISNULL(MT13.ProductQuantity,0) + ISNULL(MT15.CostAmount,0)*ISNULL(MT13.TotalVolume,0))/ISNULL(MT13.TotalVolume,0) 
             ELSE 0.0 END) AS CostPerProduct, AT12.I01ID, AT01.AnaName AS I01Name
FROM MT0115 MT15
INNER JOIN (
	SELECT MT16.DivisionID, MT16.VoucherID,
		   SUM(CASE WHEN ISNULL(MT16.TypeID,0) IN (1,2) THEN ISNULL(MT16.ConvertedAmount,0)
			   ELSE 0.0 END) AS MaterialCost,
		   SUM(CASE WHEN ISNULL(MT16.TypeID,0) IN (3) THEN ISNULL(MT16.ConvertedAmount,0)
			   ELSE 0.0 END) AS PacksCost
	FROM MT0116 MT16
	INNER JOIN MT0115 MT15 ON MT15.DivisionID = MT16.DivisionID AND MT15.VoucherID = MT16.VoucherID
	GROUP BY MT16.DivisionID, MT16.VoucherID
) AS MT16 ON MT16.DivisionID = MT15.DivisionID AND MT16.VoucherID = MT15.VoucherID
LEFT JOIN MT0113 MT13 ON MT13.DivisionID = MT15.DivisionID AND MT13.ID = MT15.PMID
LEFT JOIN MT0107 MT07 ON MT07.DivisionID = MT13.DivisionID AND MT07.VoucherID = MT13.MixVoucherID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT15.DivisionID AND AT12.InventoryID = MT15.ProductID
LEFT JOIN AT1015 AT01 ON AT01.DivisionID = AT12.DivisionID AND AT12.I01ID = AT01.AnaID AND AT01.AnaTypeID = ''I01''
WHERE MT15.DivisionID = '''+@DivisionID+'''
      AND MT15.TranYear*12 + MT15.TranMonth BETWEEN '+LTRIM(@FromYear * 12 + @FromMonth)+' AND '+LTRIM(@ToYear * 12 + @ToMonth)+'
      AND MT15.ProductID BETWEEN '''+@FromProductID+''' AND '''+@ToProductID+'''
ORDER BY MT15.TranYear, MT15.TranMonth, MT15.VoucherNo, MT15.VoucherDate
	'
	EXEC (@sSQL1)
	--PRINT @sSQL1
	END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
