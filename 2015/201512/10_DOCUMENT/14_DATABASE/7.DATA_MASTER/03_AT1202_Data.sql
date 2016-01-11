-- <Summary>
---- Khi thêm mới đối tượng trong màn hình đối tượng, tự động cập nhật mã và tên đối tượng vào mã phân tích số 5
---- Fix Cập nhật những đối tượng hiện tại đã có trước đó vào MPT A05
-- <History>
---- Create on 17/06/2015 by Lê Thị Hạnh [Customize ABA]
---- Modified on ... by ...
-- <Example> 
DECLARE @CustomerName INT 
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng ABA không (CustomerName = 45)
SET @CustomerName = (SELECT TOP 1 CustomerName FROM CustomerIndex) 
DECLARE @DivisionID NVARCHAR(50),
		@AnaTypeID NVARCHAR(50),
		@ObjectID NVARCHAR(50),
		@ObjectName NVARCHAR(250),
		@CreateUserID NVARCHAR(50),
		@CreateDate DATETIME,
		@LastModifyUserID NVARCHAR(50),
		@LastModifyDate DATETIME
DECLARE @Cur CURSOR,
		@TestID NVARCHAR(50) = ''
IF ISNULL(@CustomerName,0) = 45
BEGIN
	SET @AnaTypeID = 'A05'
	SET @Cur = CURSOR SCROLL KEYSET FOR
	SELECT DISTINCT AT12.DivisionID, AT12.ObjectID, @AnaTypeID, AT12.ObjectName, AT12.CreateUserID,
	       AT12.CreateDate, AT12.LastModifyUserID, AT12.LastModifyDate 
	FROM AT1202 AT12
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID, @ObjectID, @AnaTypeID, @ObjectName, @CreateUserID,
                          @CreateDate, @LastModifyUserID, @LastModifyDate
WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE DivisionID = @DivisionID AND AnaTypeID = @AnaTypeID AND AnaID = @ObjectID)
	BEGIN
		INSERT INTO AT1011 (DivisionID, AnaID, AnaTypeID, AnaName, [Disabled],
		            CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
		VALUES(@DivisionID,@ObjectID,@AnaTypeID,@ObjectName,0,@CreateUserID,@CreateDate,@LastModifyUserID,@LastModifyDate)
	END	
FETCH NEXT FROM @Cur INTO @DivisionID, @ObjectID, @AnaTypeID, @ObjectName, @CreateUserID,
                          @CreateDate, @LastModifyUserID, @LastModifyDate
END
CLOSE @Cur
END
