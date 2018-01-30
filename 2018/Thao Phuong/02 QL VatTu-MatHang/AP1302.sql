USE [ASOFT8.3.7]
GO
/****** Object:  StoredProcedure [dbo].[AP1302]    Script Date: 1/19/2018 10:01:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- Kiem tra mat hang da duoc su dung hay chua.
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/10/2003 by Nguyen Van Nhan
---- 
---- Modified on 01/12/2005 by Vo Thanh huong
---- Modified on 18/11/2011 by Le Thi Thu Hien : Bo sung kiem tra trong Bang gia
---- Modified on 24/12/2012 by Bao Anh : Bo sung DivisionID
---- Modified on 02/12/2015 by Hoàng vũ : CustomizeIndex = 43 (Secoin): Bổ sung thêm/sửa mặt hàng bên CI thì Insert/Update qua sản phẩm bên HRM
---- Modified by Bảo Thy on 27/05/2016: Bổ sung WITH (NOLOCK)
---- modified by Tiểu Mai on 22/06/2016: Bổ sung kiểm tra trong định mức theo quy cách
-- <Example>
---- 


ALTER PROCEDURE [dbo].[AP1302]
				@DivisionID as nvarchar(50), 	
				@InventoryID AS nvarchar(50)			
				
 AS
BEGIN

Declare @Status AS tinyint,
		@IsAsoftM AS tinyint,
		@IsAsoftOP AS tinyint,	
		@IsAsoftHRM AS tinyint
	
SELECT	@Status = 0, @IsAsoftM = IsAsoftM, @IsAsoftOP = IsAsoftOP, @IsAsoftHRM = IsAsoftHRM
FROM	AT0000

---do mã hàng CI dùng chung bắn qua HRM nên phải kiểm tra đã sử dụng bên HRM 
---CustomizeIndex = 43 (Secoin): Bổ sung thêm/sửa mặt hàng bên CI thì Insert/Update qua sản phẩm bên HRM
If @IsAsoftHRM = 1
IF EXISTS (Select Top 1 1 FROM HT2403 WITH (NOLOCK) Where ProductID = @InventoryID and DivisionID = @DivisionID	
		   Union all
		   Select Top 1 1 FROM HT1904 WITH (NOLOCK) Where ProductID = @InventoryID and DivisionID = @DivisionID	
		   Union all
		   Select Top 1 1 FROM HT1903 WITH (NOLOCK) Where ProductID = @InventoryID and DivisionID = @DivisionID
			)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End



------- Bang so du
IF EXISTS (SELECT TOP 1  1 FROM  AT2017 WITH (NOLOCK) Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
----- Bang but toan
IF EXISTS (SELECT TOP 1  1 FROM  AT9000 WITH (NOLOCK)  Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

----- Bang phieu nhap xuat
IF EXISTS (SELECT  TOP 1 1  FROM  AT2008  WITH (NOLOCK)	Where DivisionID = @DivisionID And InventoryID = @InventoryID
	Having Sum(BeginQuantity)<>0 or Sum(EndQuantity)<>0 or Sum(DebitQuantity)<>0 or Sum(CreditQuantity)<>0
	)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

---Bang don hang ban
If @IsAsoftOP = 1
IF EXISTS (SELECT TOP 1  1 FROM  OT2002  WITH (NOLOCK)	Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

---Bang don hang mua
If @IsAsoftOP = 1
IF EXISTS (SELECT TOP 1  1 FROM  OT3002  WITH (NOLOCK)	Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

---Bang chao gia
If @IsAsoftOP = 1
IF EXISTS (SELECT TOP 1  1 FROM  OT2102  WITH (NOLOCK)	Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
------- Bang gia
IF EXISTS (SELECT TOP 1  1 FROM  OT1302 WITH (NOLOCK) Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End
---Bang  ke hoach san xuat
If @IsAsoftM = 1
IF EXISTS (SELECT TOP 1  1 FROM  MT2002  WITH (NOLOCK)	Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

----Bang tien do san xuat
If @IsAsoftM = 1
IF EXISTS (SELECT TOP 1  1 FROM  MT2005  WITH (NOLOCK)	Where DivisionID = @DivisionID And InventoryID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

----Bang dinh muc quy cach
If @IsAsoftM = 1
IF EXISTS (SELECT TOP 1  1 FROM  MT0136  WITH (NOLOCK)	Where DivisionID = @DivisionID And ProductID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	END
----Bang dinh muc quy cach	
If @IsAsoftM = 1
IF EXISTS (SELECT TOP 1  1 FROM  MT0137  WITH (NOLOCK)	Where DivisionID = @DivisionID And MaterialID = @InventoryID)
	Begin
		 Set @Status =1
		GOTO RETURN_VALUES
	End

---- Tra ra gia tri
RETURN_VALUES:
Select @Status AS Status