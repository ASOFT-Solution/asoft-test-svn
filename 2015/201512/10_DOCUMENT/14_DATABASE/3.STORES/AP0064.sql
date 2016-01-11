IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0064]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0064]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load mức thuế 
-- <History>
---- Create on 19/03/2015 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/* -- VÍ DỤ
 AP0064 @DivisionID = 'VG', @ETaxVoucherID = '01508E53-B4E4-4F9C-8965-3246D1F553BE', 
 @InventoryIDList = '1521A00001'',''1521S00001'',''1521S00002'',''1521S00003'',''1521S00004'',''1522S00002' , @UserID = ''
  */
 
CREATE PROCEDURE [dbo].[AP0064] 	
	@DivisionID NVARCHAR(50),
	@ETaxVoucherID NVARCHAR(50), -- VoucherID của phiếu kết quả sản xuất - Truyền vào khi Edit
	@InventoryIDList NVARCHAR(MAX),
	@UserID NVARCHAR(50)
AS
DECLARE @sSQL1 NVARCHAR(MAX)
		
SET @ETaxVoucherID = ISNULL(@ETaxVoucherID,'')
/*
SELECT AT12.InventoryID, AT12.ETaxID, ISNULL(AT94.ETaxAmount,0) AS ETaxAmount
FROM AT1302 AT12
LEFT JOIN (
	SELECT AT94.VoucherID, AT95.ETaxID, AT95.ETaxAmount 
	FROM AT0294 AT94
	INNER JOIN AT0295 AT95 ON AT95.VoucherID = AT94.VoucherID
	WHERE AT94.VoucherID = '''+@ETaxVoucherID+''') AT94
ON AT94.ETaxID = AT12.ETaxID
WHERE AT12.InventoryID IN ('''+@InventoryIDList+''')
*/
SET @sSQL1 = '
SELECT AT95.ETaxID, AT12.InventoryID, ISNULL(AT95.ETaxAmount,0) AS ETaxAmount
FROM AT0294 AT94
INNER JOIN AT0295 AT95 ON AT95.VoucherID = AT94.VoucherID
LEFT JOIN AT1302 AT12 ON AT12.ETaxID = AT95.ETaxID
WHERE AT94.VoucherID = '''+@ETaxVoucherID+''' AND AT12.InventoryID IN ('''+@InventoryIDList+''')
'
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON