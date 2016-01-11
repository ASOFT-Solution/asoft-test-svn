IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP0104]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP0104]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Summary: Lấy ra danh sách cảnh báo hàng tồn kho theo từng kho
----- *** Chỉ áp dụng cho 1 đơn vị tính ***
----- Create by Lê Thị Hạnh 
----- Create Date 25/06/2014
----- WP0104 'LTV','','Tối thiểu','Tối đ'
----- WP0104 'TBI', '2014-06-25 14:16:26.310'
---------- purpose: Thay đổi cách tính định mức  
---------- Modify on Lê Thị Hạnh 25/06/2014 
-------------- Modify on Lê Thị Hạnh 26/06/2014
-------------- Purpose: Lấy thêm trường đơn vị tính và số lượng quy đổi
--------------------- Modify on Lê Thị Hạnh 26/06/2014
--------------------- Purpose: Lấy thêm trường định mức quy đổi

Create procedure [DBO].[WP0104]
(
	@DivisionID NVARCHAR(50),
	@UserID NVARCHAR(50),
	@WarningMinimum NVARCHAR(500),
	@WarningMaximum NVARCHAR(500)
	--@LoginDate  DATETIME	
)
as
DECLARE @sSQL NVARCHAR(MAX), @sFROM NVARCHAR(MAX), @sWHERE NVARCHAR(MAX), @sSQL1 NVARCHAR(MAX)
SET @sSQL = N'
			SELECT  T07.WareHouseID, T07.WareHouseName, T07.InventoryID, T07.InventoryName, T07.UnitID, T07.UnitName,
			SUM(ISNULL(T07.SignQuantity,0)) AS CurOriginalQuantity,
			SUM(ISNULL(T07.SignConvertedQuantity,0)) AS CurQuantity,
			Isnull(T13.MinQuantity,0) AS MinQuantity, ISNULL(T13.MaxQuantity,0) AS MaxQuantity,
			CASE WHEN (SUM(ISNULL(T07.SignQuantity,0)) - ISNULL(T13.MaxQuantity,0)) > 0 
				THEN N'''+@WarningMaximum+''' 
				ELSE N'''+@WarningMinimum+''' END AS WarStatus,
			CASE WHEN (SUM(ISNULL(T07.SignQuantity,0)) - ISNULL(T13.MaxQuantity,0)) > 0 
				THEN (SUM(ISNULL(T07.SignQuantity,0)) - ISNULL(T13.MaxQuantity,0)) 
				ELSE (ISNULL(T13.MinQuantity,0) - SUM(ISNULL(T07.SignQuantity,0))) END AS DPOriginalQuantity, 
			CASE WHEN (SUM(ISNULL(T07.SignConvertedQuantity,0)) - ISNULL(T13.MaxQuantity,0)) > 0 
				THEN (SUM(ISNULL(T07.SignConvertedQuantity,0)) - ISNULL(T13.MaxQuantity,0)) 
				ELSE (ISNULL(T13.MinQuantity,0) - SUM(ISNULL(T07.SignConvertedQuantity,0))) END AS DPQuantity		 					
			'
SET @sFROM = N'
			FROM AV7000 T07 LEFT JOIN AT1314 T13 ON T13.DivisionID = T07.DivisionID AND 
				 T13.WareHouseID = T07.WareHouseID AND T13.InventoryID = T07.InventoryID
			 '
SET @sWHERE = N'
			WHERE T07.DivisionID = '''+@DivisionID+''' AND T07.VoucherDate <= GETDATE()
			   '
SET @sSQL1 = N'
			GROUP BY T07.WareHouseID, T07.WareHouseName, T07.InventoryID, T07.InventoryName, T13.MinQuantity, T13.MaxQuantity,
					 T07.UnitID, T07.UnitName
			HAVING SUM(ISNULL(T07.SignQuantity,0)) < Isnull(T13.MinQuantity,0) or SUM(ISNULL(T07.SignQuantity,0)) > ISNULL(T13.MaxQuantity,0)
			  '

EXEC (@sSQL + @sFROM + @sWHERE + @sSQL1)
PRINT @sSQL + @sFROM + @sWHERE + @sSQL1
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
