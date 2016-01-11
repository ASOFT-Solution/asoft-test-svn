IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1050]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1050]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Bảo Anh		Date: 26/11/2013
---- Customize cho Sinolife: Cập nhật tình trạng mặt hàng
---- <Example> AP1050 'AS','%',''

CREATE PROCEDURE AP1050
( 
	@DivisionID NVARCHAR(50),
	@InventoryTypeID NVARCHAR(50),
	@InventoryID NVARCHAR(50)
	
)	
AS

Declare @Status as nvarchar(1),
		@ContractNo NVARCHAR(50),
		@Notes01 nvarchar(250),
		@Cur AS cursor

IF Isnull(@InventoryTypeID,'') <> ''
	SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT InventoryID FROM AT1302 Where DivisionID = @DivisionID And InventoryTypeID like @InventoryTypeID
ELSE
	SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT InventoryID FROM AT1302 Where DivisionID = @DivisionID And InventoryID = @InventoryID

OPEN @Cur
FETCH NEXT FROM @Cur INTO @InventoryID
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @Status = LEFT(ltrim(Notes01),1) FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID
	SELECT TOP 1 @ContractNo = OT2002.Ana02ID
	From OT2002 Inner join OT2001 On OT2002.DivisionID = OT2001.DivisionID And OT2002.SOrderID = OT2001.SOrderID
	Where OT2002.DivisionID = @DivisionID And OT2002.InventoryID = @InventoryID And OT2001.OrderStatus = 1

	IF @Status = '4' Or @Status = '5'
	BEGIN
		IF Isnull(@ContractNo,'') = ''
			SET @Notes01 = N'1 - Chưa sử dụng'
	END

	ELSE
	BEGIN
		IF EXISTS (Select Top 1 1 From AT1021 Inner join AT1020 On AT1020.DivisionID = AT1021.DivisionID And AT1020.ContractID = AT1021.ContractID
					Where AT1020.DivisionID = @DivisionID And AT1020.ContractNo = @ContractNo And Isnull(AT1021.IsTransfer,0) = 1)
			SET @Notes01 = N'3 - Chuyển nhượng'
		
		ELSE IF Isnull(@ContractNo,'') <> ''
			SET @Notes01 = N'2 - Đang bán'
				
		ELSE
			SET @Notes01 = N'1 - Chưa sử dụng'
	END

	UPDATE AT1302 SET Notes01 = @Notes01 WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID
	FETCH NEXT FROM @Cur INTO @InventoryID
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
