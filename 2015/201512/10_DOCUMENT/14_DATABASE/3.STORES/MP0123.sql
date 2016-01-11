IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0123]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0123]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Master cho màn hình MF0018 - kế thừa tiến độ sản xuất [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 19/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/* -- VÍ DỤ
 MP0123 @DivisionID = 'VG', @FromMonth = 9, @FromYear = 2014, @ToMonth = 10, @ToYear = 2014, @SPMVoucherID = N'MP2014000000002'
  */
 
CREATE PROCEDURE [dbo].[MP0123] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@SPMVoucherID NVARCHAR(50), -- VoucherID của phiếu kết quả sản xuất - Truyền vào khi Edit
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX)
		
SET @SPMVoucherID = ISNULL(@SPMVoucherID,'')
SET @sSQL1 = '
SELECT CONVERT(BIT,1) AS [Choose], MT24.VoucherID, MT24.VoucherTypeID, MT24.VoucherNo, MT24.VoucherDate,
       MT24.[Description], ISNULL(MT24.[Status],0) AS [Status], MT24.EmployeeID, MT24.KCSEmployeeID,
       MT24.InventoryTypeID, AT13.FullName AS EmployeeName, AT11.FullName AS KCSEmployeeName
FROM MT2004 MT24
INNER JOIN MT2005 MT25 ON MT25.DivisionID = MT24.DivisionID AND MT25.VoucherID = MT24.VoucherID
LEFT JOIN MT1001 MT11 ON MT11.DivisionID = MT25.DivisionID  AND MT11.InheritTableID = ''MT2004'' AND MT11.InheritVoucherID = MT24.VoucherID AND MT11.InheritTransactionID = MT25.TransactionID
LEFT JOIN AT1103 AT13 ON AT13.DivisionID = MT24.DivisionID AND AT13.EmployeeID = MT24.EmployeeID
LEFT JOIN AT1103 AT11 ON AT11.DivisionID = MT24.DivisionID AND AT11.EmployeeID = MT24.KCSEmployeeID
WHERE MT24.DivisionID = '''+@DivisionID+''' AND MT11.VoucherID = '''+@SPMVoucherID+'''
GROUP BY MT24.VoucherID, MT24.VoucherTypeID, MT24.VoucherNo, MT24.VoucherDate,
		 MT24.[Description], MT24.[Status], MT24.EmployeeID, MT24.KCSEmployeeID,
		 MT24.InventoryTypeID, AT13.FullName, AT11.FullName
UNION 
SELECT CONVERT(BIT,0) AS [Choose], MT24.VoucherID, MT24.VoucherTypeID, MT24.VoucherNo, MT24.VoucherDate,
       MT24.[Description], ISNULL(MT24.[Status],0) AS [Status], MT24.EmployeeID, MT24.KCSEmployeeID,
       MT24.InventoryTypeID, AT13.FullName AS EmployeeName, AT11.FullName AS KCSEmployeeName
FROM MT2004 MT24
INNER JOIN MT2005 MT25 ON MT25.DivisionID = MT24.DivisionID AND MT25.VoucherID = MT24.VoucherID
LEFT JOIN MT1001 MT11 ON MT11.DivisionID = MT25.DivisionID  AND MT11.InheritTableID = ''MT2004'' AND MT11.InheritVoucherID = MT24.VoucherID AND MT11.InheritTransactionID = MT25.TransactionID
LEFT JOIN AT1103 AT13 ON AT13.DivisionID = MT24.DivisionID AND AT13.EmployeeID = MT24.EmployeeID
LEFT JOIN AT1103 AT11 ON AT11.DivisionID = MT24.DivisionID AND AT11.EmployeeID = MT24.KCSEmployeeID
WHERE MT24.DivisionID = '''+@DivisionID+''' AND MT24.VoucherID NOT IN (
														SELECT MT11.InheritVoucherID
														FROM MT1001 MT11
														WHERE MT11.DivisionID = '''+@DivisionID+''' AND MT11.InheritTableID = ''MT2004'' AND MT11.VoucherID = '''+@SPMVoucherID+''')
	  AND MT24.TranYear*12 + MT24.TranMonth BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+'
GROUP BY MT24.VoucherID, MT24.VoucherTypeID, MT24.VoucherNo, MT24.VoucherDate,
		 MT24.[Description], MT24.[Status], MT24.EmployeeID, MT24.KCSEmployeeID,
		 MT24.InventoryTypeID, AT13.FullName, AT11.FullName, MT25.ActualQuantity
HAVING ISNULL(MT25.ActualQuantity,0) - SUM(ISNULL(MT11.Quantity,0)) > 0
ORDER BY [Choose] DESC, MT24.VoucherDate, MT24.VoucherTypeID, MT24.VoucherNo
'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

