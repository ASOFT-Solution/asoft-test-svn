IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0280]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0280]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Xóa kết chuyển
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 03/06/2014 by Le Thi Thu Hien
---- 
---- Modified on 10/09/2014 by Le Thi Thu Hien : Sửa lại lưu phiếu nhập và phiếu xuất VoucherID = AT9000. VoucherID
-- <Example>
---- EXEC AP0280 'KC', 1, 2014, 'BIGC', '2014-01-01'
CREATE PROCEDURE AP0280
( 
	@DivisionID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@AnaID AS NVARCHAR(50),
	@VoucherDate AS DATETIME,
	@VoucherID AS NVARCHAR(50)
) 
AS 
DECLARE @AVoucherID AS NVARCHAR(50)
DECLARE @AVoucher2ID AS NVARCHAR(50)
DECLARE @AT9000VoucherID AS NVARCHAR(50)
DECLARE @AT9000Voucher2ID AS NVARCHAR(50)

---------- Phieu ban hang
SET @AT9000VoucherID = ( SELECT TOP 1 VoucherID
                         FROM AT9000 
                         WHERE DivisionID = @DivisionID
								AND ReVoucherID = @VoucherID
								AND ReTableID = 'POST0016'
								AND TransactionTypeID = 'T04'
)
--------- Phieu tra hang
SET @AT9000Voucher2ID = ( SELECT TOP 1 VoucherID
                         FROM AT9000 
                         WHERE DivisionID = @DivisionID
								AND ReVoucherID = @VoucherID
								AND ReTableID = 'POST0016'
								AND TransactionTypeID = 'T24'
)
--------- Phieu xuat ban hang
SET @AVoucherID = (SELECT TOP 1 VoucherID 
                   FROM AT2006 AT2006 
                   WHERE AT2006.DivisionID = @DivisionID
						AND AT2006.ReVoucherID = @AT9000VoucherID
)
--------- Phieu nhap tra hang
SET @AVoucher2ID = (SELECT TOP 1 VoucherID 
                   FROM AT2006 AT2006 
                   WHERE AT2006.DivisionID = @DivisionID
						AND AT2006.ReVoucherID = @AT9000Voucher2ID
)

------------>>>>>>> Trả lại trạng thái cho phiếu bán hàng bên POS là chưa chuyển
UPDATE POST0016 
SET IsTransferred = 0
WHERE DivisionID = @DivisionID 
AND ShopID = @AnaID 
AND Convert(nvarchar(10),VoucherDate,21) = Convert(nvarchar(10),@VoucherDate,21) 
AND APK IN (SELECT D.APKMaster FROM AT0281 D WHERE D.DivisionID = @DivisionID AND D.VoucherID = @VoucherID )

----------->>>>>>>>> Xóa phiếu kết chuyển
DELETE FROM AT0280 
WHERE DivisionID = @DivisionID
AND VoucherID = @VoucherID 


DELETE FROM AT0281 
WHERE DivisionID = @DivisionID
AND VoucherID = @VoucherID 
-----------<<<<<<<< Xóa phiếu kết chuyển

----------->>>>>>>>> Xóa phiếu xuất kho
DELETE FROM AT2007 
WHERE DivisionID = @DivisionID 
		AND VoucherID = @AT9000VoucherID

DELETE FROM AT2006 
WHERE DivisionID = @DivisionID 
		AND VoucherID = @AT9000VoucherID
-----------<<<<<<<<< Xóa phiếu xuất kho


----------->>>>>>>>> Xóa phiếu hóa đơn bán hàng và trả hàng
DELETE FROM AT2007 
WHERE DivisionID = @DivisionID 
		AND VoucherID = @AT9000Voucher2ID

DELETE FROM AT2006 
WHERE DivisionID = @DivisionID 
		AND VoucherID = @AT9000Voucher2ID
-----------<<<<<<<<< Xóa phiếu nhap kho tra hang

----------->>>>>>>>> Xóa phiếu hóa đơn bán hàng và trả hàng
DELETE FROM AT9000 
WHERE DivisionID = @DivisionID 
		AND ReVoucherID = @VoucherID
-----------<<<<<<<< Xóa phiếu hóa đơn bán hàng và trả hàng		


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

