IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0034]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0034]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Lưu dữ liệu duyệt đơn hàng bán - OF0034
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 14/09/2011 by Nguyễn Bình Minh: Kiểm tra tồn kho sẵn sàng trước khi duyệt
---- 
---- Modified on 04/10/2011 by Lê Thị Thu Hiền
---- Modified on 01/10/2013 by Bảo Anh: Dùng bảng OT0034 thay cho bảng tạm #ReadyQuantityList để cải thiện tốc độ
---- Modified on 31/03/2015 by Mai Trí Thiện: Lưu thêm thông tin LastModifyUserID và LastModifyDate
-- <Example>
---- 
CREATE PROCEDURE [DBO].[OP0034]
( 
	@DivisionID AS NVARCHAR(50),	
	@SOrderID AS NVARCHAR(250),
	@DescriptionConfirm AS NVARCHAR(250),
	@IsConfirm AS TINYINT,
	@ActionMode AS TINYINT = 0, -- ActionMode = 1 là luôn lưu
	@UserID AS NVARCHAR(50)
) 
AS
SET NOCOUNT ON

DECLARE @InventoryID AS NVARCHAR(50),
		@Status AS TINYINT,
		@MessageID AS NVARCHAR(50)		
		
SET @Status = 0 -- Không thông báo
SET @MessageID = ''

IF @IsConfirm <> 1 -- Nếu không duyệt thì không kiểm tra tồn kho sẵn sàng
BEGIN
	UPDATE		OT2001 
	SET			IsConfirm = @IsConfirm,
				DescriptionConfirm = @DescriptionConfirm, 
				OrderStatus = 0
	WHERE		DivisionID = @DivisionID AND SOrderID = @SOrderID
END
ELSE --- Duyet 
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
			SELECT		TOP 1 @InventoryID = SOD.InventoryID
			FROM		OT2001 SO
			INNER JOIN 	OT2002 SOD
					ON	SO.DivisionID = SOD.DivisionID AND SO.SOrderID = SOD.SOrderID
			LEFT JOIN	OT0034 RQ
					ON	RQ.DivisionID = SOD.DivisionID AND ISNULL(RQ.WareHouseID, '') = ISNULL(SOD.WareHouseID, '') AND RQ.InventoryID = SOD.InventoryID
			WHERE		SO.DivisionID = @DivisionID AND SO.SOrderID = @SOrderID
						AND ISNULL(RQ.EndQuantity - RQ.SQuantity + RQ.PQuantity, 0) < SOD.OrderQuantity
			
			IF ISNULL(@InventoryID, '') <> ''
				BEGIN
					SET @Status = (	SELECT TOP 1 ISNULL(SOCheckWH, 0) 
						FROM	OT0001 
       					WHERE	DivisionID = @DivisionID 
       							AND TypeID = 'SO'
					)
				END	
			
				IF @Status = 0
		            UPDATE		OT2001 
					SET			IsConfirm = @IsConfirm,
								DescriptionConfirm = @DescriptionConfirm, 
								OrderStatus = 1,
								LastModifyUserID = @UserID,
								LastModifyDate = GETDATE()
					WHERE		DivisionID = @DivisionID 
								AND SOrderID = @SOrderID
				
			END		
			
		ELSE ---IF @ActionMode = 1 ---- Luon luon Luu
			BEGIN
				UPDATE		OT2001 
				SET			IsConfirm = @IsConfirm,
							DescriptionConfirm = @DescriptionConfirm, 
							OrderStatus = 1,
							LastModifyUserID = @UserID,
							LastModifyDate = GETDATE()
				WHERE		DivisionID = @DivisionID 
							AND SOrderID = @SOrderID
			END	

			
	END

--OFML000199 : Số lượng tồn kho sẵn sàng của mặt hàng [{0}] trong đơn hàng số [{1}] không đủ. /n Bạn không thể duyệt cho đơn hàng này !.
IF @Status = 2
SET @MessageID =  'OFML000199' 
IF @Status = 1
SET @MessageID =  'OFML000200' 
	
SELECT @Status AS Status, @MessageID AS MessageID, @InventoryID AS InventoryID, @SOrderID AS SOrderID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

