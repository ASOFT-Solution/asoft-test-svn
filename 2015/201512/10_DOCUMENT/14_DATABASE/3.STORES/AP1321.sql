IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1321]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP1321]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Kiem tra mã phụ chứa trong mặt hàng đã sử dụng hay chưa. Customize index = 43 (Secoin)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 21/07/2003 by Hoàng Vũ
---- 
-- <Example> 
--EXEC AP1321 'AS', 'TP001_MP001', 'TP001'
--SELECT * FROM  OT2002
---- 


CREATE PROCEDURE [dbo].[AP1321]
				@DivisionID as nvarchar(250),
				@ExtraID as nvarchar(250),
				@InventoryID AS nvarchar(250)			
				
 AS

Declare @Status AS tinyint,
		@IsAsoftM AS tinyint,
		@IsAsoftOP AS tinyint	
	
SELECT	@Status = 0, @IsAsoftM = IsAsoftM, @IsAsoftOP = IsAsoftOP 
FROM	AT0000

------- Đơn hàng bán, Đơn hàng sản xuất
IF EXISTS (SELECT TOP 1  1 FROM  OT2002 Where DivisionID = @DivisionID And InventoryID = @InventoryID and ExtraID = @ExtraID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
------- Phiếu giao viêc
IF EXISTS (SELECT TOP 1  1 FROM  MT2008 Where DivisionID = @DivisionID And InventoryID = @InventoryID and ExtraID = @ExtraID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

------- Kết quả sản xuất
IF EXISTS (SELECT TOP 1  1 FROM  MT1001 Where DivisionID = @DivisionID And InventoryID = @InventoryID and ExtraID = @ExtraID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

---- Tra ra gia tri
RETURN_VALUES:
Select @Status AS Status


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
