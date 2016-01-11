IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP00111]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP00111]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Khi lưu thực thi store để UPDATE lại giá trị hàng đã nhận của phiếu yêu cầu VCNB
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/06/2014 by Le Thi Thu Hien
---- 
---- Modified on 11/06/2014 by 
-- <Example>
---- 
CREATE PROCEDURE WP00111
( 
@DivisionID NVARCHAR(50),
@UserID VARCHAR(50),
@TranMonth AS int,
@TranYear AS int,
@VoucherID AS nvarchar(50) ,
@Mode AS tinyint
) 
AS 

UPDATE WT0096
SET WT0096.ReceiveQuantity = A.ReceiveQuantity
FROM WT0096 WT0096
INNER JOIN (
SELECT	SUM(ActualQuantity) AS ReceiveQuantity, 
		InheritVoucherID, InheritTransactionID , DivisionID
FROM	AT2007 
WHERE	DivisionID = @DivisionID
		AND InheritTransactionID IN ( SELECT InheritTransactionID FROM AT2007 WHERE AT2007.DivisionID = @DivisionID AND AT2007.VoucherID = @VoucherID)
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

--UPDATE WT0096 
--SET [Status] = 8 
--WHERE DivisionID = @DivisionID
--AND VoucherID = @WT0095VoucherID
--AND ReceiptQuantity = ActualQuantity

IF NOT EXISTS ( SELECT TOP 1 1 FROM WT0096 
                WHERE DivisionID = @DivisionID 
					AND VoucherID  = @WT0095VoucherID 
					AND ISNULL(ReceiveQuantity,0) <> ActualQuantity)
UPDATE WT0095
SET [Status] = 8
FROM WT0095 WT0095
WHERE WT0095.DivisionID = @DivisionID
AND WT0095.VoucherID = @WT0095VoucherID


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

