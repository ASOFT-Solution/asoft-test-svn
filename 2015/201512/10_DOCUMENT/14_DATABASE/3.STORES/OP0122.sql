IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0122]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0122]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 11/11/2013
---- Purpose : Duyệt các nhân viên quản lý cần tính hoa hồng (Sinolife)
---- Update by Mai Duyen : bo sung @OrderNo 
---- Update by Mai Duyen,date 09/12/2013 : Bo sung @ContractNo , AccAmount bang OT0123
---- Update by Bảo Anh,date 14/08/2014 : Bổ sung @Orders, dùng để xét thứ tự tách đơn hàng
---- OP0122 'AS','SO/02/2012/0001','02/04/2012',250000000,'CN2'

CREATE PROCEDURE [dbo].[OP0122]
	@DivisionID nvarchar(50),
	@SOrderID nvarchar(50),
	@OrderDate datetime,
	@OrderAmount decimal(28,8),
	@SalemanID nvarchar(50)	,
	@ContractNo nvarchar(50),
	@OrderNo int, --  thu tu tach don hang
	@Orders int --- thứ tự dùng để xét tách đơn hàng
	
AS

BEGIN
    Declare @ManagerID nvarchar(50),
			@LevelNo int			
			
    SELECT @ManagerID = ManagerID FROM AT1202 WHERE DivisionID = @DivisionID And ObjectID = @SalemanID And ObjectTypeID = 'NV'
    SELECT @LevelNo = LevelNo  FROM AT1202 WHERE DivisionID = @DivisionID And ObjectID = @ManagerID And ObjectTypeID = 'NV'
    
    IF Isnull(@ManagerID,'') <> '' AND @OrderNo IS NOT NULL
		INSERT INTO OT0123 (DivisionID, OrderID, OrderDate, OrderAmount, SalesmanID, PreLevelNo, ExtendAmount,ContractNo,OrderNo)
				VALUES (@DivisionID, @SOrderID, @OrderDate, @OrderAmount, @ManagerID, @LevelNo, 1,@ContractNo, @OrderNo)
	
	IF Isnull(@ManagerID,'') <> '' AND @Orders is not NULL
	BEGIN
		INSERT INTO OT0143 (DivisionID, SalesmanID, LevelNo, ExtendAmount,Orders)
		VALUES (@DivisionID, @ManagerID, @LevelNo, 1, @Orders)
		
		SET @Orders = @Orders + 1
	END
	
    IF Isnull(@ManagerID,'') <> ''
		EXEC OP0122 @DivisionID, @SOrderID, @OrderDate, @OrderAmount, @ManagerID ,@ContractNo,@OrderNo, @Orders
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

