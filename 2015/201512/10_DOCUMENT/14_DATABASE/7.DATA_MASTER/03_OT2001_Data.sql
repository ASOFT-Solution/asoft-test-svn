-- <Summary>
---- Khi thêm mới đơn hàng bán trong màn hình đơn hàng bán, tự động cập nhật số chứng từ vào mã phân tích số 6
---- Fix Cập nhật những đối tượng hiện tại đã có trước đó vào MPT A06
-- <History>
---- Create on 17/06/2015 by Lê Thị Hạnh [Customize ABA]
---- Modified on ... by ...
-- <Example> 
DECLARE @CustomerName INT 
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng ABA không (CustomerName = 45)
SET @CustomerName = (SELECT TOP 1 CustomerName FROM CustomerIndex) 
DECLARE @DivisionID NVARCHAR(50),
		@AnaTypeID NVARCHAR(50),
		@SOrderID NVARCHAR(50),
		@VoucherNo NVARCHAR(50),
		@Notes NVARCHAR(250),
		@CreateUserID NVARCHAR(50),
		@CreateDate DATETIME,
		@LastModifyUserID NVARCHAR(50),
		@LastModifyDate DATETIME
DECLARE @Cur CURSOR,
		@TestID NVARCHAR(50) = ''
IF ISNULL(@CustomerName,0) = 45
BEGIN
	SET @AnaTypeID = 'A06'
	SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT DISTINCT OT21.DivisionID, OT21.SOrderID, @AnaTypeID, OT21.VoucherNo, OT21.Notes, 
		   OT21.CreateUserID, OT21.CreateDate, OT21.LastModifyUserID, OT21.LastModifyDate 
	FROM OT2001 OT21
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID, @SOrderID, @AnaTypeID, @VoucherNo, @Notes, 
						  @CreateUserID, @CreateDate, @LastModifyUserID, @LastModifyDate
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE DivisionID = @DivisionID AND AnaTypeID = @AnaTypeID AND AnaID = @SOrderID)
	BEGIN
		INSERT INTO AT1011 (DivisionID, AnaID, AnaTypeID, AnaName, Notes, [Disabled],
		            CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		VALUES(@DivisionID,@SOrderID,@AnaTypeID,@VoucherNo,@Notes,0,@CreateUserID,@CreateDate,@LastModifyUserID,@LastModifyDate)
	END	
FETCH NEXT FROM @Cur INTO @DivisionID, @SOrderID, @AnaTypeID, @VoucherNo, @Notes, 
						  @CreateUserID, @CreateDate, @LastModifyUserID, @LastModifyDate
END
CLOSE @Cur
END