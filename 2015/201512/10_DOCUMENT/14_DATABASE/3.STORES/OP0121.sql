IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0121]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0121]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 11/11/2013
---- Purpose : Duyệt các nhân viên đồng cấp cần tính hoa hồng
-----Mai Duyen : bo sung @OrderNo 
-----Mai Duyen,Date 09/12/2013 : bo sung @ContractNo, luu AccAmount bang OT0123
---- Update by Bảo Anh,date 14/08/2014: 1/ Bổ sung @Orders, dùng để xét thứ tự tách đơn hàng
----									2/ Chỉ tính hoa hồng giới thiệu khi đồng cấp
---- OP0121 'AS','SO/03/2012/0012','03/04/2012',400000000,'TH/01/2012/0001',NULL,1

CREATE PROCEDURE [dbo].[OP0121]
	@DivisionID nvarchar(50),
	@SOrderID nvarchar(50),
	@OrderDate datetime,
	@OrderAmount decimal(28,8),	
	@ContractNo nvarchar(50),
	@OrderNo int, --thu tu tach don hang
	@Orders int --- thứ tự dùng để xét tách đơn hàng
	
AS

Declare @Generations as int,
		@Times as int,
		@Cur_OT0123 cursor,
		@SalesmanID nvarchar(50),
		@LevelNo int,
		@MiddleID nvarchar(50),
		@MiddleLevelNo int

IF @OrderNo IS NOT NULL	--- dựa vào OT0123 để tính hoa hồng
	SET @Cur_OT0123 = CURSOR SCROLL KEYSET FOR
	SELECT SalesmanID, isnull(UpLevelNo, PreLevelNo) as LevelNo FROM OT0123 Where DivisionID = @DivisionID And OrderID = @SOrderID And ContractNo =@ContractNo And Isnull(OrderNo,0) = Isnull(@OrderNo,0)
	Order by isnull(UpLevelNo, PreLevelNo)
ELSE	--- dựa vào OT0143 để xét tách đơn hàng
	SET @Cur_OT0123 = CURSOR SCROLL KEYSET FOR
	SELECT SalesmanID, LevelNo FROM OT0143 Where DivisionID = @DivisionID
	Order by LevelNo
	
OPEN @Cur_OT0123
FETCH NEXT FROM @Cur_OT0123 INTO @SalesmanID, @LevelNo
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @Generations = Isnull(Generations,0) FROM AT0101 WHERE DivisionID = @DivisionID AND LevelNo = @LevelNo
	SET @Times = 0
	IF @Orders is not NULL	--- nếu dùng store này add data tách đơn hàng thì không cần giới hạn số thế hệ
		SET @Generations = 20000
	
	WHILE @Times < @Generations
	BEGIN
		SELECT @MiddleID = MiddleID FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectID = @SalesmanID AND ObjectTypeID = 'NV'
		SELECT @MiddleLevelNo = LevelNo FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectID = @MiddleID AND ObjectTypeID = 'NV'

		IF ISNULL(@MiddleID,'') <> '' AND @MiddleLevelNo = @LevelNo AND @OrderNo IS NOT NULL
				INSERT INTO OT0123 (DivisionID, OrderID, OrderDate, OrderAmount, SalesmanID, PreLevelNo, SameAmount,ContractNo, OrderNo)
					VALUES (@DivisionID, @SOrderID, @OrderDate, @OrderAmount, @MiddleID, @MiddleLevelNo, 1,@ContractNo,@OrderNo)

		IF ISNULL(@MiddleID,'') <> '' AND @Orders is not NULL
		BEGIN
			INSERT INTO OT0143 (DivisionID, SalesmanID, LevelNo, SameAmount,Orders)
			VALUES (@DivisionID, @MiddleID, @MiddleLevelNo, 1, @Orders)
			
			SET @Orders = @Orders + 1
		END
		
		IF ISNULL(@MiddleID,'') <> '' AND @MiddleLevelNo = @LevelNo
		BEGIN
			SET @SalesmanID = @MiddleID
			SET @Times = @Times + 1
		END
		ELSE
		BEGIN
			SET @SalesmanID = ''
			SET @Times = @Generations
		END
	END
	
	FETCH NEXT FROM @Cur_OT0123 INTO @SalesmanID, @LevelNo
END

CLOSE @Cur_OT0123

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

