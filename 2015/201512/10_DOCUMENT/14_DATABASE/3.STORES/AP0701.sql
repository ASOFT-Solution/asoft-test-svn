IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0701]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0701]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiem tra trang thai phieu co duoc phep Sua, Xoa hay khong.
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 07/06/2004 by Nguyen Van Nhan
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
---- Modified on 25/10/2011 by Nguyễn Bình Minh: Bổ sung kiểm tra phiếu nhận hàng trước đã có hóa đơn thì không được Sửa/Xóa. 
--												Bổ sung Division vào các điều kiện kiểm tra
---- Modified by Bao Anh	Date: 11/09/2012	Kiểm tra phiếu xuất đã được chọn khi nhập kho thành phẩm thì không cho Sửa/Xóa (2T)
---- Modified by Bao Anh	Date: 21/08/2014	Kiểm tra phiếu nhập hàng TTDD/theo lô/hết hạn đã được xuất thì không cho sửa/xóa
---- Modified by Lê Thị Thu Hiền on 31/07/2014 : Bổ sung kiểm tra Phiếu kết chuyển từ POS Hàng bán trả lại
---- Modified by Quốc Tuấn on 18/09/2014 : Bổ sung thêm KindVoucherID  kiểm tra Phiếu kết chuyển từ POS Hàng bán trả lại và bán hàng xuất kho
---- Modified by Tiểu Mai on 18/08/2015: Bổ sung kiểm tra phiếu Xuất kho tự động tạo từ phiếu Kết quả sản xuất đã tập hợp chi phí
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP0701]
(
	@DivisionID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@VoucherID AS NVARCHAR(50),
	@Status AS TINYINT OUTPUT,
	@EngMessage AS NVARCHAR(250) OUTPUT,
	@VieMessage AS NVARCHAR(250) OUTPUT
)	
AS
DECLARE @Message AS NVARCHAR(250)
SET @Status = 0
------------ Phiếu kết chuyển từ POS Hàng bán trả lại
IF EXISTS (SELECT TOP 1 1 FROM AT2006
			INNER JOIN AT9000 ON AT9000.DivisionID = AT2006.DivisionID 
			AND AT9000.VoucherID = AT2006.ReVoucherID 
			Where AT9000.DivisionID =@DivisionID 
			AND AT9000.ReTableID = 'POST0016' 
			AND AT2006.KindVoucherID ='7'
			AND AT2006.VoucherID = @VoucherID)
	BEGIN
		SET @Status = 3
		SET @Message =N'AFML000381' 
		SET @Message =N'AFML000381'
		Goto MESS
	END

IF EXISTS (SELECT TOP 1 1 FROM AT2006
			INNER JOIN AT9000 ON AT9000.DivisionID = AT2006.DivisionID 
			AND AT9000.VoucherID = AT2006.ReVoucherID 
			Where AT9000.DivisionID =@DivisionID 
			AND AT9000.ReTableID = 'POST0016' 
			AND AT2006.VoucherID = @VoucherID)
	BEGIN
		SET @Status = 1
		SET @Message =N'AFML000381' 
		SET @Message =N'AFML000381'
		Goto MESS
	END
	
					
				
				

IF EXISTS (	SELECT		TOP 1 1 
			FROM		AT0114
			INNER JOIN	AT1302
					ON  AT1302.InventoryID = AT0114.InventoryID
					AND AT1302.DivisionID = AT0114.DivisionID
			WHERE		AT0114.DivisionID = @DivisionID
						AND ReVoucherID = @VoucherID
						AND DeQuantity <> 0
						AND (MethodID = 3 or Isnull(AT1302.IsSource,0) <> 0 or ISNULL(AT1302.IsLimitDate,0) <> 0)
			)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000090'
    GOTO MESS
END


IF EXISTS (SELECT TOP 1 1 FROM AT2006 WHERE KindVoucherID = 5 AND VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000091'
    GOTO MESS
END

If  Exists (Select	top 1  1 
			From	AT2006 
			Where	KindVoucherID = 4 and DivisionID = @DivisionID and VoucherID = @VoucherID 
					and exists(select top 1 1 from AT9000 where DivisionID = @DivisionID and TransactionTypeID = 'T04' and VoucherID = @VoucherID))
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000092'
    GOTO MESS
END	

IF EXISTS (SELECT TOP 1 1 FROM AT2006 WHERE KindVoucherID = 7 AND VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000093'
    GOTO MESS
END	

IF EXISTS (SELECT TOP 1 1 FROM AT2006 WHERE KindVoucherID = 10 AND VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000094'
    GOTO MESS
END

IF EXISTS (SELECT TOP 1 1 FROM AT2006 WHERE TableID = 'MT0810' AND VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000095'
    GOTO MESS
END

IF EXISTS (SELECT TOP 1 1 FROM   AT9000 WHERE TableID = 'AT2006' AND VoucherID = @VoucherID AND (STATUS <> 0 OR IsCost <> 0) AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000096'
END	

IF EXISTS (SELECT TOP 1 1 FROM AT2026 WHERE VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000097'
END	

IF EXISTS (SELECT TOP 1 1 FROM AT2026 WHERE KindVoucherID = 4 AND VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'AFML000098'
    GOTO MESS
END 

IF EXISTS (SELECT TOP 1 1 FROM AT2006 WHERE KindVoucherID = 1 AND IsGoodsFirstVoucher = 1 AND VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
	IF EXISTS(SELECT TOP 1 1 FROM AT9000 WHERE ReVoucherID = @VoucherID AND IsLateInvoice = 1 AND DivisionID = @DivisionID)
	BEGIN
		SET @Status = 1
	    SET @Message = N'WFML000142'
		GOTO MESS			
	END 
END

IF EXISTS (SELECT TOP 1 1 FROM AT2006 WHERE DivisionID = @DivisionID And KindVoucherID = 2 And VoucherID = @VoucherID And Isnull(EVoucherID,'') <> '')
BEGIN
	SET @Status = 1
    SET @Message = N'WFML000156'
	GOTO MESS
END

IF EXISTS (SELECT TOP 1 1 FROM AT2006 INNER JOIN AT9000 ON AT9000.DivisionID = AT2006.DivisionID AND AT9000.VoucherID = AT2006.VoucherID 
							Where AT9000.DivisionID =@DivisionID 
							AND AT2006.VoucherID = @VoucherID
							AND IsNull(AT9000.MaterialTypeID,'') <>''
							AND IsNull(AT9000.PeriodID,'')<>''
							AND AT9000.ExpenseID='COST001')
BEGIN
	SET @Status = 1
    SET @Message = N'WFML000176'
	GOTO MESS
END

IF EXISTS (SELECT TOP 1 1 FROM WT2026 WHERE VoucherID = @VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'WFML000157'
END	

IF EXISTS (SELECT TOP 1 1 FROM WT2026 WHERE @VoucherID = 'NNL'+VoucherID AND DivisionID = @DivisionID)
BEGIN
    SET @Status = 1
    SET @Message = N'WFML000157'
END	
MESS:

SET @VieMessage = @Message
SET @EngMessage = @Message

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
