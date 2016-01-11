IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0111]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0111]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- IN BÁO CÁO CÔNG THỨC PHA TRỘN VÀ PHIẾU PHA TRỘN [Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 16/09/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
-- MP0111 @DivisionID = 'AP', @VoucherID = '31285EAA-7FD0-4FB2-905A-6C71111E5B9F'

CREATE PROCEDURE [dbo].[MP0111] 	
	@DivisionID NVARCHAR(50),
	@VoucherID NVARCHAR(50)
AS
DECLARE @sSQL NVARCHAR(MAX)

-- Lấy ra thông tin Load báo cáo phiếu thử nghiệm

SET @sSQL = '
SELECT MT01.VoucherNo, MT01.VoucherDate, MT07.ProductID, AT12.InventoryName AS ProductName, 
	   MT07.BatchNo, OT21.ObjectID, AT122.ObjectName,
	   MT01.ReceivingDate, MT01.Quantity,
       MT01.RefNo, MT01.[Description], MT02.TestID, MT09.TestName, MT09.TestMethod,
       MT09.UnitID, MT02.ResultID, MT02.Notes AS TestNotes
FROM MT0111 MT01
INNER JOIN MT0112 MT02 ON MT02.DivisionID = MT01.DivisionID AND MT02.VoucherID = MT01.VoucherID
LEFT JOIN MT0109 MT09 ON MT09.DivisionID = MT02.DivisionID AND MT09.TestID = MT02.TestID
LEFT JOIN MT0107 MT07 ON MT07.DivisionID = MT01.DivisionID AND MT07.VoucherID = MT01.MixVoucherID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT07.DivisionID AND AT12.InventoryID = MT07.ProductID
LEFT JOIN OT2001 OT21 ON OT21.DivisionID = MT01.DivisionID AND OT21.SOrderID = MT01.MOVoucherID
LEFT JOIN AT1202 AT122 ON AT122.DivisionID = OT21.DivisionID AND AT122.ObjectID = OT21.ObjectID
WHERE MT01.DivisionID = '''+@DivisionID+''' AND MT01.VoucherID = '''+@VoucherID+'''
ORDER BY MT02.TestID
' 
EXEC (@sSQL)
--PRINT @sSQL

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
