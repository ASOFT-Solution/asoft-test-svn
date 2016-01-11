IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0813]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP0813]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 20/08/2013
--- Purpose: Kết chuyển KQSX sang chấm công sản phẩm (Thuận Lợi)
--- Modify on 05/09/2013 by Bảo Anh: Bỏ kết chuyển giá qua HRM
--- EXEC MP0813 'AS','04/15/2012','MP2012000000022','admin'

CREATE PROCEDURE [dbo].[MP0813]  
				@DivisionID nvarchar(50),
				@VoucherDate datetime,				
				@VoucherID nvarchar(50),
				@CreateUserID nvarchar(50)
AS

DECLARE 	@sSQL nvarchar(4000),
	    	@TimesID nvarchar(50),
	    	@DepartmentID nvarchar(50),
			@TeamID nvarchar(50),
			@EmployeeID nvarchar(50),
			@ProductID nvarchar(50),
			@ProductName nvarchar(250),
			@UnitID nvarchar(50),
			@ProductTypeID nvarchar(50),
			@ProductTypeName nvarchar(250),
			@Quantity decimal(28,8),
			@TranMonth int,
			@TranYear int,
			@_Cur as cursor		

--- Lấy lần chấm công mặc định đầu tiên trong danh mục
SELECT Top 1 @TimesID = TimesID FROM HT1019 WHERE DivisionID = @DivisionID Order by TimesID

SET NOCOUNT ON

Set @_Cur = Cursor Scroll KeySet For
SELECT	MT1001.TranMonth, MT1001.TranYear, HT1400.DepartmentID, HT1400.TeamID,
		MT1001.HRMEmployeeID, MT1001.ProductID, AT1302.InventoryTypeID,
		MT1001.Quantity
FROM MT1001
Left join HT1400 On MT1001.DivisionID = HT1400.DivisionID And MT1001.HRMEmployeeID = HT1400.EmployeeID
Left join AT1302 On  MT1001.DivisionID = AT1302.DivisionID And MT1001.ProductID = AT1302.InventoryID
WHERE MT1001.DivisionID = @DivisionID And MT1001.VoucherID = @VoucherID

Open @_Cur
Fetch Next From @_Cur Into @TranMonth, @TranYear, @DepartmentID, @TeamID, @EmployeeID, @ProductID, @ProductTypeID, @Quantity

WHILE @@Fetch_Status = 0		
BEGIN
	--- Thực hiện insert vào các table của HRM
	IF ISNULL(@EmployeeID,'') <> ''
	BEGIN
		--- Insert vào bảng loại sản phẩm
		IF NOT EXISTS (SELECT TOP 1 1 FROM HT1018 Where DivisionID = @DivisionID And Isnull(ProductTypeID,'') = @ProductTypeID)
		Begin	
			SELECT @ProductTypeName = InventoryTypeName
			FROM AT1301 WHERE DivisionID = @DivisionID AND Isnull(InventoryTypeID,'') = @ProductTypeID
			
			INSERT INTO HT1018 (DivisionID,ProductTypeID,ProductType,[Disabled],CreateUserID,CreateDate,LastModifyUserID,LastModifyDate)
			VALUES (@DivisionID,@ProductTypeID,@ProductTypeName,0,@CreateUserID,GETDATE(),@CreateUserID,GETDATE())
		End
		
		--- Insert vào bảng danh mục sản phẩm
		IF NOT EXISTS (SELECT TOP 1 1 FROM HT1015 Where DivisionID = @DivisionID And Isnull(ProductID,'') = @ProductID)
		Begin
			SELECT @ProductName = InventoryName, @UnitID = UnitID
			FROM AT1302 WHERE DivisionID = @DivisionID AND Isnull(InventoryID,'') = @ProductID
			
			INSERT INTO HT1015 (DivisionID,ProductID,ProductName,[Disabled],MethodID,ProductTypeID,UnitID,Orders,CreateDate,LastModifyDate,CreateUserID,LastModifyUserID)
			VALUES	(@DivisionID,@ProductID,@ProductName,0,2,@ProductTypeID,@UnitID,
					(select max(Orders)+1 from HT1015 Where DivisionID = @DivisionID),GETDATE(),GETDATE(),@CreateUserID,@CreateUserID)
		End
		
		--- Insert vào bảng chấm công sản phẩm	
		IF NOT EXISTS (SELECT 1 FROM HT2403 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND EmployeeID = @EmployeeID AND TimesID = @TimesID AND ProductID = @ProductID)
			BEGIN
				INSERT HT2403(TimesID, TranMonth, TranYear, DivisionID, DepartmentID, TeamID, EmployeeID, ProductID, Quantity, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, TrackingDate, IsFromAsoftM) 
				VALUES (@TimesID, @TranMonth, @TranYear, @DivisionID, @DepartmentID, @TeamID, @EmployeeID, @ProductID, @Quantity, @CreateUserID, GETDATE(), @CreateUserID, GETDATE(), @VoucherDate, 1) 
			END
		ELSE
			BEGIN
				UPDATE HT2403 SET Quantity = Quantity + Isnull(@Quantity,0), LastModifyUserID = @CreateUserID,
								LastModifyDate = GETDATE(), TrackingDate = @VoucherDate, IsFromAsoftM = 1
				WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND EmployeeID = @EmployeeID AND TimesID = @TimesID AND ProductID = @ProductID 
			END
	END
	Fetch Next From @_Cur Into @TranMonth, @TranYear, @DepartmentID, @TeamID, @EmployeeID, @ProductID, @ProductTypeID, @Quantity
END
	
SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
