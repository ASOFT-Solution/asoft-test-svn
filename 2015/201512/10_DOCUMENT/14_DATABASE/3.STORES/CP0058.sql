IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CP0058]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CP0058]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- 
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Hoàng Vũ on: 02/12/2015: Customize theo khách hàng SECOIN, Bắn dữ liệu từ mặt hàng CI qua sản phẩm bên HRM. 
---- Modified on  Quoc tuan edit 17/12/2015 sua lai chuyen @InventoryNameTemp thanh NVARCHAR, @DisabledTemp thanh TINYINT, bo sung @SalePrice
-- <Example>: EXEC CP0058 'AS', 'NUOC', 'ASOFTADMIN'
 
CREATE PROCEDURE CP0058 
(
	@DivisionID Varchar(50),
	@InventoryID Varchar(50),
	@UserID Varchar(50)
)

AS
BEGIN
	DECLARE @InventoryTypeIDTemp VARCHAR(50),		
			@InventoryNameTemp NVARCHAR(500),
			@DisabledTemp TINYINT,
			@UnitIDTemp VARCHAR(50),
			@Description NVARCHAR(250),
			@LastModifyDateTemp DateTime,
			@IsToHRM TINYINT,
			@SalePrice DECIMAL(28,8)
		
	Select @InventoryTypeIDTemp = InventoryTypeID, @InventoryNameTemp = InventoryName
		  , @DisabledTemp = Disabled, @Description = Notes01
		  , @LastModifyDateTemp = LastModifyDate
		  , @UnitIDTemp =UnitID
		  , @IsToHRM = Isnull(IsToHRM,0)
		  ,@SalePrice= SalePrice05
	From AT1302 WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID
	

	IF (SELECT TOP 1 CustomerName FROM CustomerIndex) = 43 ---- nếu là Secoin
	BEGIN
		IF @IsToHRM = 1
		BEGIN
						IF EXISTS (SELECT TOP 1 1 FROM HT1015 WHERE DivisionID = @DivisionID AND ProductID = @InventoryID)
							UPDATE HT1015 SET ProductName = @InventoryNameTemp, Disabled = @DisabledTemp
												, LastModifyUserID = @UserID, LastModifyDate = @LastModifyDateTemp
												, UnitID = @UnitIDTemp
												, Description = @Description, ProductTypeID = @InventoryTypeIDTemp
												, UnitPrice  =@SalePrice
							WHERE DivisionID = @DivisionID AND ProductID = @InventoryID
						ELSE
						BEGIN
								INSERT INTO HT1015 (APK, DivisionID, ProductID, ProductName, Description
													, Disabled, MethodID, UnitPrice
													, ProductTypeID, Orders
													, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID, UnitID)
								SELECT NEWID(), DivisionID, InventoryID, InventoryName, Notes01
												, Disabled, 2 as MethodID, @SalePrice
												, InventoryTypeID, (Select Max(Orders)+1 From HT1015) as Orders
												, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID, UnitID
								from AT1302
								Where DivisionID = @DivisionID AND InventoryID = @InventoryID
						END
		END
	
	END
END


