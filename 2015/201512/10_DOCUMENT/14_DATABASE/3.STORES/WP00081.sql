IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00081]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00081]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Thực thi store cập nhật lại số lượng hàng tại phiếu yêu cầu nhập - xuất - chuyển kho khi xóa phiếu nhập - xuất - chuyển kho
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/06/2014 by Lê Thị Thu hiền
---- 
---- Modified on 28/07/2014 by Le Thi Thu Hien : Xoa phieu xuat ben POS
-- <Example>
---- 
CREATE PROCEDURE WP00081
( 
@DivisionID AS NVARCHAR(50),
@TranMonth AS INT,
@TranYear AS INT,
@UserID AS NVARCHAR(50),
@VoucherID AS NVARCHAR(50)
) 
AS 

UPDATE WT0096
SET WT0096.ReceiveQuantity = WT0096.ReceiveQuantity - A.ReceiveQuantity
FROM WT0096 WT0096
INNER JOIN (
SELECT	SUM(ActualQuantity) AS ReceiveQuantity, 
		InheritVoucherID, InheritTransactionID , DivisionID
FROM	AT2007 
WHERE	DivisionID = @DivisionID
		AND AT2007.VoucherID = @VoucherID
		AND InheritTableID = 'WT0095'
GROUP BY InheritVoucherID, InheritTransactionID,DivisionID
) A
ON A.DivisionID = WT0096.DivisionID 
AND A.InheritVoucherID = WT0096.VoucherID
AND A.InheritTransactionID = WT0096.TransactionID

DECLARE @WT0095VoucherID AS NVARCHAR(50)
SET @WT0095VoucherID = ( SELECT TOP 1 InheritVoucherID 
                         FROM AT2007 
                         WHERE AT2007.DivisionID = @DivisionID
							AND AT2007.VoucherID = @VoucherID
							AND InheritTableID = 'WT0095')
IF EXISTS ( SELECT TOP 1 1 FROM WT0096 
                WHERE DivisionID = @DivisionID 
					AND VoucherID  = @WT0095VoucherID 
					AND ISNULL(ReceiveQuantity,0) <> ActualQuantity)
UPDATE WT0095
SET [Status] = 1
FROM WT0095 WT0095
WHERE WT0095.DivisionID = @DivisionID
AND WT0095.VoucherID = @WT0095VoucherID

DELETE FROM POST0028 WHERE APKMaster = (SELECT APK FROM POST0027 WHERE VoucherID = @VoucherID ) 
DELETE FROM POST9000 WHERE APKMaster = (SELECT TOP 1 APK FROM POST0027 WHERE VoucherID = @VoucherID)
DELETE FROM POST0027 WHERE VoucherID = @VoucherID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

