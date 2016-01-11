IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CP0057]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CP0057]
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
---- Created by: Hoàng Vũ on: 02/12/2015: Customize theo khách hàng SECOIN, Bắn dữ liệu từ loại mặt hàng CI qua Loại sản phẩm bên HRM. 
---- Modified on  Quoc tuan edit 17/12/2015 sua lai chuyen @InventoryTypeNameTemp thanh NVARCHAR, @DisabledTemp thanh TINYINT
-- <Example>: EXEC CP0057 'AS', 'HH', 'ASOFTADMIN'
 
CREATE PROCEDURE CP0057 
(
	@DivisionID Varchar(50),
	@InventoryTypeID Varchar(50),
	@UserID Varchar(50)
)

AS
BEGIN
	DECLARE @InventoryTypeIDTemp VARCHAR(50),		
			@InventoryTypeNameTemp NVARCHAR(500),
			@DisabledTemp TINYINT,
			@LastModifyDateTemp DateTime,
			@IsToHRM TINYINT
		
	Select @InventoryTypeIDTemp = InventoryTypeID, @InventoryTypeNameTemp = InventoryTypeName
		  , @DisabledTemp = Disabled
		  , @LastModifyDateTemp = LastModifyDate
		  , @IsToHRM = Isnull(IsToHRM,0)
	From AT1301 WHERE DivisionID = @DivisionID AND InventoryTypeID = @InventoryTypeID
	

	IF (SELECT TOP 1 CustomerName FROM CustomerIndex) = 43 ---- nếu là Secoin
	BEGIN
		IF @IsToHRM = 1
		BEGIN
						IF EXISTS (SELECT TOP 1 1 FROM HT1018 WHERE DivisionID = @DivisionID AND ProductTypeID = @InventoryTypeID)
							UPDATE HT1018 SET ProductType = @InventoryTypeNameTemp, Disabled = @DisabledTemp
												,  LastModifyUserID = @UserID, LastModifyDate = @LastModifyDateTemp
							WHERE DivisionID = @DivisionID AND ProductTypeID = @InventoryTypeID
						ELSE
						BEGIN
								INSERT INTO HT1018 (APK, DivisionID, ProductTypeID, ProductType
													   , CreateDate, CreateUserID, LastModifyUserID, LastModifyDate
													   , Disabled)
								SELECT NEWID(), DivisionID, InventoryTypeID, InventoryTypeName
													   , CreateDate, CreateUserID, LastModifyUserID, LastModifyDate
													   , [Disabled]
								From AT1301
								Where DivisionID = @DivisionID AND InventoryTypeID = @InventoryTypeID
						END
		END
	
	END
END


