IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0150]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0150]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Lưu dữ liệu duyệt đơn hàng bán - OF0137-8: Kiểm tra tồn kho sẵn sàng trước khi duyệt
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- OP0034
-- <History>
---- Create on 05/12/2014 by Lê Thị Hạnh
---- 
---- Modified on ... by ...
-- <Example>
/*
OP0150 @DivisionID ='CTY', @SOrderID ='SO/11/2014/0004', @UserID = 'ASOFTADMIN', @IsConfirm = 1, @ActionMode = 0
*/
CREATE PROCEDURE [DBO].[OP0150]
( 
	@DivisionID NVARCHAR(50),	
	@SOrderID NVARCHAR(250),
	@UserID NVARCHAR(50), -- người duyệt
	@IsConfirm TINYINT, -- IsConfirm02 = 1
	@ActionMode TINYINT = 0 -- ActionMode = 1 là luôn lưu
) 
AS
SET NOCOUNT ON

DECLARE @InventoryID AS NVARCHAR(50),
		@Status AS TINYINT,
		@MessageID AS NVARCHAR(50)		
-- Kiểm tra số lượng tồn kho khi duyệt (SOCheckWH)
SET @Status = 0 
-- @Status = 0: Không kiểm tra
-- @Status = 1: Cảnh báo nhưng cho duyệt
-- @Status = 2: Không cho duyệt
SET @MessageID = ''

IF @IsConfirm = 1 -- Chỉ kiểm tra khi trạng thái là xác nhận
BEGIN
	IF @ActionMode = 0
	BEGIN			
/*
SELECT		ISNULL(OP.WareHouseID, WH.WareHouseID) AS WareHouseID,
			ISNULL(OP.InventoryID, WH.InventoryID) AS InventoryID,
			SUM(CASE WHEN OP.TypeID <> 'PO' AND OP.Finish <> 1 THEN OP.OrderQuantity - OP.ActualQuantity ELSE 0 END) AS SQuantity,
			SUM(CASE WHEN TypeID = 'PO' AND OP.Finish <> 1 THEN OP.OrderQuantity - OP.ActualQuantity ELSE 0 END) AS PQuantity,
			SUM(ISNULL(WH.DebitQuantity, 0)) - SUM(ISNULL(WH.CreditQuantity, 0)) AS EndQuantity
INTO		#ReadyQuantityList
FROM		OV2800 OP
FULL JOIN	OV2401 WH
		ON	WH.DivisionID = WH.DivisionID AND WH.WareHouseID = OP.WareHouseID AND WH.InventoryID = OP.InventoryID
GROUP BY	ISNULL(OP.WareHouseID, WH.WareHouseID),	ISNULL(OP.InventoryID, WH.InventoryID)
*/
						
	----- Tồn kho sẵn sàng = Tồn kho thực tế (EndQuantity) - Giữ chỗ (SQuantity) + Đang về (PQuantity)
		SELECT TOP 1 @InventoryID = OT22.InventoryID
					FROM OT2001 OT21
					INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID
					LEFT JOIN OT0034 OT34 ON OT34.DivisionID = OT21.DivisionID AND OT34.InventoryID = OT22.InventoryID 
						  AND ISNULL(OT34.WareHouseID,'') = ISNULL(OT22.WareHouseID,'')
					WHERE OT21.DivisionID = @DivisionID AND OT21.SOrderID = @SOrderID AND OT21.OrderType = 0
						  -- Mặt hàng không đủ số lượng
						  AND ISNULL(OT34.EndQuantity - OT34.SQuantity + OT34.PQuantity,0) < ISNULL(OT22.OrderQuantity,0)
		IF ISNULL(@InventoryID,'') != ''
		BEGIN
			SET @Status = (SELECT TOP 1 ISNULL(OT01.SOCheckWH,0)
						   FROM OT0001 OT01
						   WHERE OT01.DivisionID = @DivisionID AND OT01.TypeID = 'SO')
		END
		IF @Status = 0
		BEGIN
			UPDATE OT2001 SET
				OrderStatus = 1,
				LastModifyUserID = @UserID,
				LastModifyDate = GETDATE()
			WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID AND OrderType = 0
				  AND IsConfirm01 = 1 
				--AND IsConfirm02 = 1
		END		
		IF @Status = 1
		SET @MessageID =  'OFML000200' 
		IF @Status = 2
		SET @MessageID =  'OFML000199' 		
	END		
	ELSE ---IF @ActionMode = 1 ---- Luon luon Luu
	BEGIN
		UPDATE OT2001 SET
			OrderStatus = 1,
			LastModifyUserID = @UserID,
			LastModifyDate = GETDATE()
		WHERE DivisionID = @DivisionID AND SOrderID = @SOrderID AND OrderType = 0
				AND IsConfirm01 = 1 
			--AND IsConfirm02 = 1
	END						
END
------------------------------------------------------	
SELECT @Status AS Status, @MessageID AS MessageID, @InventoryID AS InventoryID, @SOrderID AS SOrderID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

