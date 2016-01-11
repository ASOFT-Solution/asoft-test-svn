IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2009]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP2009]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Kiểm tra tồn kho khi lưu dữ liệu Phiếu giao việc
----Customer index = 43 Secoin
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>

-- <Example>
---- EXEC MP2009 'AS', 'K01', 'RAP', 2
CREATE PROCEDURE [DBO].[MP2009]
( 
	@DivisionID AS NVARCHAR(50),	
	@WareHouseID AS NVARCHAR(250),
	@RInventoryID AS NVARCHAR(250),
	@Count AS Decimal(28,8), --Đếm số dòng Rập Cùng kho và cùng Rập,
	@VoucherID AS NVARCHAR(50)
	
) 
AS
SET NOCOUNT ON

DECLARE @TonInventoryID AS NVARCHAR(50),
		@Status AS TINYINT,
		@MessageID AS NVARCHAR(50)		
	SET @Status = 0 -- Không thông báo
	SET @MessageID = ''
	
	-- Lấy giá trị Tồn kho sẵn sàng = Tồn kho thực tế (EndQuantity) - Giữ chỗ (SQuantity) + Đang về (PQuantity)
	SELECT 	TOP 1 @TonInventoryID = InventoryID
	FROM 
	(
		Select	Isnull(y.DivisionID, x.DivisionID) as DivisionID, Isnull(y.WareHouseID, x.WareHouseID) as WareHouseID
		, isnull(y.InventoryID, x.InventoryID) as InventoryID
		, Isnull(y.EndQuantity, 0) as EndQuantity --Tồn kho thực tế
		, isnull(CASE WHEN x.OrderID=@VoucherID THEN 0 ELSE x.OrderQuantity END, 0) - isnull(x.ActualQuantity, 0) as RemainPickingQuantity --Giữ kho chưa sử dụng hết
		, Isnull(y.EndQuantity, 0) - (isnull(CASE WHEN x.OrderID=@VoucherID THEN 0 ELSE x.OrderQuantity END, 0) - isnull(x.ActualQuantity, 0)) as ReadyQuantity
		From OV2800 x 
				Full join 
				(		
					Select DivisionID, WareHouseID, InventoryID, Tranmonth, tranyear, sum(EndQuantity) as EndQuantity
						from OV2411 
						Group by DivisionID, WareHouseID, InventoryID, Tranmonth, tranyear
				) y on x.DivisionID = y.DivisionID and x.WareHouseID = y.WareHouseID and x.InventoryID = y.InventoryID

	) w
	WHERE w.DivisionID = @DivisionID AND w.WareHouseID = @WareHouseID and w.InventoryID = @RInventoryID
		  AND ISNULL(ReadyQuantity, 0) >= @Count

	--Kiểm tra trả ra kết quả là rỗng thì cho phép lưu phiếu giao việc bình thường
	--Kiểm tra trả ra kết quả khác rỗng thì bào message cảnh cáo: (Yes: lưu; No: không lưu)
	PRINT @TonInventoryID
	IF isnull(@TonInventoryID, '')=''
	Begin
		Set @Status = 1
		SET @MessageID =  'MFML000275' 
	End
	--Hiện ID message
	SELECT @Status AS Status, @MessageID AS MessageID, @RInventoryID AS RInventoryID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
