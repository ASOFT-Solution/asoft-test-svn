IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0108]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0108]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO CÔNG THỨC PHA TRỘN VÀ PHIẾU PHA TRỘN [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 16/09/2014 by Lê Thị Hạnh 
---- Modified by Lê Thị Hạnh on 05/11/2014: Trường Notes01 lấy từ phiếu pha trộn
---- Modified by Lê Thị Hạnh on 16/01/2015: Thay đổi cách lấy dữ liệu quy cách đóng gói và phiếu pha trộn
---- Modified on ... by 
-- <Example>
-- MP0108 @DivisionID = 'VG', @VoucherID = '548816ae-b16a-4de5-9da6-243fce7103de'

CREATE PROCEDURE [dbo].[MP0108] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX),
		@sSQL3 NVARCHAR(MAX)
--QUY CÁCH ĐÓNG GÓI - NetVolume,ConvertUnitID - KHỐI LƯỢNG TỊNH (NET VOLUMNE), QuanPacks,UnitID - SỐ LƯỢNG BAO BÌ (QUANTITY OF PACKS)
/*
SELECT MT07.ProductID, ISNULL(OT22.ConvertedQuantity,0) AS QuanPacks, OT22.UnitID AS ConvertUnitID, AT134.UnitName AS ConvertUnitName, 
       ISNULL(AT19.ConversionFactor,1) AS NetVolume, ISNULL(OT22.OrderQuantity,0) AS OrderQuantity, AT12.UnitID, AT14.UnitName
FROM MT0107 MT07
LEFT JOIN OT2002 OT22 ON OT22.DivisionID = MT07.DivisionID AND OT22.SOrderID = MT07.MOVoucherID AND OT22.InventoryID = MT07.ProductID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = OT22.DivisionID AND AT12.InventoryID = OT22.InventoryID
LEFT JOIN AT1309 AT19 ON AT19.DivisionID = OT22.DivisionID AND AT19.InventoryID = OT22.InventoryID AND AT19.UnitID = OT22.UnitID
LEFT JOIN AT1304 AT134 ON AT134.DivisionID = OT22.DivisionID AND AT134.UnitID = OT22.UnitID
LEFT JOIN AT1304 AT14 ON AT14.DivisionID = AT12.DivisionID AND AT14.UnitID = AT12.UnitID 
WHERE MT07.DivisionID = '''+@DivisionID+''' AND MT07.VoucherID = '''+@VoucherID+'''
ORDER BY OT22.UnitID
*/
SET @sSQL1 = '
SELECT MT07.ProductID, ISNULL(MT07.ProductQuantity,0) AS QuanPacks, AT12.UnitID AS UnitID, AT14.UnitName,
       ISNULL(MT07.Notes02,0) AS NetVolume
FROM MT0107 MT07
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT07.DivisionID AND AT12.InventoryID = MT07.ProductID 
LEFT JOIN AT1304 AT14 ON AT14.DivisionID = AT12.DivisionID AND AT14.UnitID = AT12.UnitID 
WHERE MT07.DivisionID = '''+@DivisionID+''' AND MT07.VoucherID = '''+@VoucherID+'''
ORDER BY AT12.UnitID
' 
EXEC (@sSQL1)
--PRINT @sSQL1
---- Lấy ra kết quả thử nghiệm cho báo cáo Phiếu pha trộn
/*
SELECT ROW_NUMBER() OVER (PARTITION BY MT08.TypeID ORDER BY (SELECT 1)) RowNum,
	   MT07.VoucherNo, MT07.VoucherDate, MT07.ProductID, AT12.InventoryName AS ProductName, 
	   MT08.Notes01, MT07.BatchNo,
       MT08.MaterialID, AT132.InventoryName AS MaterialName, MT08.TypeID, MT08.Rate01, MT08.Rate02,
       MT08.Rate03, MT08.Rate04, MT08.Rate05, MT08.VolumeTotal, MT08.WeightTotal,
       MT07.[Description]  
FROM MT0107 MT07 
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT07.DivisionID AND MT08.VoucherID = MT07.VoucherID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT07.DivisionID AND AT12.InventoryID = MT07.ProductID
LEFT JOIN AT1302 AT132 ON AT132.DivisionID = MT08.DivisionID AND AT132.InventoryID = MT08.MaterialID
WHERE MT07.DivisionID = '''+@DivisionID+''' AND MT07.VoucherID = '''+@VoucherID+''' 
ORDER BY MT08.TypeID, RowNum, MT08.MaterialID
*/
SET @sSQL2 = '
SELECT ROW_NUMBER() OVER (PARTITION BY MT08.TypeID ORDER BY (SELECT 1)) RowNum,
	   MT07.VoucherNo, MT07.VoucherDate, ISNULL(MT07.TotalVolume,0) AS TotalVolume,
	   MT07.ProductID, AT12.InventoryName AS ProductName, MT07.BatchNo, MT07.[Description], 
	   ISNULL(MT08.TypeID,0) AS TypeID, MT08.MaterialID, AT132.InventoryName AS MaterialName, MT08.Notes01,
	   ISNULL(MT08.Rate01,0) AS Rate01, ISNULL(MT08.Rate02,0) AS Rate02, ISNULL(MT08.Rate03,0) AS Rate03, 
	   ISNULL(MT08.Rate04,0) AS Rate04, ISNULL(MT08.Rate05,0) AS Rate05, 
	   ISNULL(MT08.VolumeTotal,0) AS VolumeTotal, ISNULL(MT08.WeightTotal,0) AS WeightTotal  
FROM MT0107 MT07 
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT07.DivisionID AND MT08.VoucherID = MT07.VoucherID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT07.DivisionID AND AT12.InventoryID = MT07.ProductID
LEFT JOIN AT1302 AT132 ON AT132.DivisionID = MT08.DivisionID AND AT132.InventoryID = MT08.MaterialID
WHERE MT07.DivisionID = '''+@DivisionID+''' AND MT07.VoucherID = '''+@VoucherID+''' 
ORDER BY MT08.TypeID, RowNum, MT08.MaterialID'
EXEC (@sSQL2)
--PRINT @sSQL2
SET @sSQL3 = '
SELECT ''Test ''+ CONVERT(VARCHAR,DENSE_RANK() OVER (ORDER BY MT01.VoucherNo))AS Test, 
        MT01.VoucherDate, MT01.VoucherNo, MT02.TestID, MT09.TestName, 
		ISNULL(MT02.ResultID,0) AS ResultID, MT02.Notes, MT01.EmployeeID, AT13.FullName AS EmployeeName
FROM MT0111 MT01
INNER JOIN MT0112 MT02 ON MT02.DivisionID = MT01.DivisionID AND MT02.VoucherID = MT01.VoucherID
LEFT JOIN MT0109 MT09 ON MT09.DivisionID = MT02.DivisionID AND MT09.TestID = MT02.TestID
LEFT JOIN AT1103 AT13 ON AT13.DivisionID = MT01.DivisionID AND AT13.EmployeeID = MT01.EmployeeID
WHERE MT01.DivisionID = '''+@DivisionID+''' AND MT01.MixVoucherID = '''+@VoucherID+'''
--UNION 
--SELECT ''Pass/Fail'' AS Test, MT02.TestID, MT09.TestName, MT02.ResultID, 
			--CASE WHEN MT02.ResultID = 0 THEN N''Không đạt''
			--	WHEN MT02.ResultID = 1 THEN N''Đạt''
			--	END AS ResultID,
	  --   MT02.Notes, NULL AS EmployeeID, NULL AS EmployeeName
--FROM MT0111 MT01
--INNER JOIN MT0112 MT02 ON MT02.DivisionID = MT01.DivisionID AND MT02.VoucherID = MT01.VoucherID
--INNER JOIN MT0109 MT09 ON MT09.DivisionID = MT02.DivisionID AND MT09.TestID = MT02.TestID
--INNER JOIN AT1103 AT13 ON AT13.DivisionID = MT01.DivisionID AND AT13.EmployeeID = MT01.EmployeeID
--WHERE MT01.DivisionID = '''+@DivisionID+''' AND MT01.MixVoucherID = '''+@VoucherID+'''
--AND MT01.VoucherID = (SELECT TOP 1 VoucherID 
--                      FROM MT0111 
--                      WHERE MixVoucherID = '''+@VoucherID+'''
--                      ORDER BY VoucherDate DESC)
ORDER BY MT01.VoucherDate, MT01.VoucherNo, MT02.TestID
'
EXEC (@sSQL3)
--PRINT @sSQL3
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

