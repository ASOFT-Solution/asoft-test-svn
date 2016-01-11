-- <Summary>
---- 
-- <History>
---- Create on 31/05/2013 on Lê Thị Thu Hiền
---- Modified on 21/05/2015 by Thanh Sơn: Thêm 10 tham số nhập text chi tiết đơn hàng bán
---- <Example>
---- Add Data

IF NOT EXISTS (SELECT TOP 1 1 FROM OT0005 WHERE TransactionID = 'Purchase Detail')
BEGIN
	INSERT INTO OT0005
	(	
		DivisionID,
		TypeID,
		SystemName,
		UserName,
		IsUsed,
		UserNameE,
		SystemNameE,
		TransactionID
	)
	SELECT 	DivisionID,
		TypeID,
		SystemName,
		UserName,
		IsUsed,
		UserNameE,
		SystemNameE,
		'Purchase Detail'
	FROM OT0005STD, AT1101
	WHERE OT0005STD.TransactionID = 'Purchase Detail'

END
-------- Modified on 25/02/2014 on Lê Thị Thu Hiền
IF NOT EXISTS (SELECT TOP 1 1 FROM OT0005 WHERE TransactionID = 'Estimate Manufacture')
BEGIN
	INSERT INTO OT0005
	(	
		DivisionID,
		TypeID,
		SystemName,
		UserName,
		IsUsed,
		UserNameE,
		SystemNameE,
		TransactionID
	)
	SELECT 	DivisionID,
		TypeID,
		SystemName,
		UserName,
		IsUsed,
		UserNameE,
		SystemNameE,
		'Estimate Manufacture'
	FROM OT0005STD, AT1101
	WHERE OT0005STD.TransactionID = 'Estimate Manufacture'
END
--------- Modified on 15/11/2011 by Le Thi Thu Hien
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005 WHERE TypeID LIKE 'M%')	
	INSERT INTO OT0005 (DivisionID, TypeID,SystemName,UserName,IsUsed,UserNameE,SystemNameE)
		SELECT	AT.DivisionID, STD.TypeID,STD.SystemName,STD.UserName,STD.IsUsed,STD.UserNameE,STD.SystemNameE 
		FROM	OT0005STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TypeID  LIKE 'M%'
		
--------- Modified on 15/11/2011 by Le Thi Thu Hien		
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005 WHERE TypeID LIKE 'Q%')	
	INSERT INTO OT0005 (DivisionID, TypeID,SystemName,UserName,IsUsed,UserNameE,SystemNameE)
		SELECT	AT.DivisionID, STD.TypeID,STD.SystemName,STD.UserName,STD.IsUsed,STD.UserNameE,STD.SystemNameE 
		FROM	OT0005STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TypeID  LIKE 'Q%'

--------- Modified on 04/09/2015 by Tiểu Mai
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005 WHERE TypeID LIKE 'ED%')	
	INSERT INTO OT0005 (DivisionID, TypeID,SystemName,UserName,IsUsed,UserNameE,SystemNameE)
		SELECT	AT.DivisionID, STD.TypeID,STD.SystemName,STD.UserName,STD.IsUsed,STD.UserNameE,STD.SystemNameE 
		FROM	OT0005STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TypeID  LIKE 'ED%'
		
--------- Modified on 04/09/2015 by Tiểu Mai		
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005 WHERE TypeID LIKE 'QD%')	
	INSERT INTO OT0005 (DivisionID, TypeID,SystemName,UserName,IsUsed,UserNameE,SystemNameE)
		SELECT	AT.DivisionID, STD.TypeID,STD.SystemName,STD.UserName,STD.IsUsed,STD.UserNameE,STD.SystemNameE 
		FROM	OT0005STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TypeID  LIKE 'QD%'	
--------------------------------------------------------------------------------

DECLARE @Cur CURSOR,
		@DivisionID VARCHAR(50),
		@sSQL NVARCHAR(1000)
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT DivisionID FROM AT0001

OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @i INT = 10
	WHILE @i <= 20
	BEGIN
		SET @sSQL = '
		INSERT INTO OT0005
		VALUES (NEWID(), '''+@DivisionID+''', ''SD'+CONVERT(VARCHAR(2),@i)+''', N'''+'SD'+CONVERT(VARCHAR(2),@i)+' - '+N'Tham số '+CONVERT(VARCHAR(2),@i)+''', N'''+N'Chưa sử dụng'+''', 0, ''Not use'', NULL, ''Sales Detail'')'
		IF NOT EXISTS (SELECT TOP 1 1 FROM OT0005 WHERE DivisionID = @DivisionID AND TypeID = 'SD'+ CONVERT(VARCHAR(2),@i))		
		EXEC (@sSQL)
		PRINT(@sSQL)
		SET @i = @i + 1
	END
	FETCH NEXT FROM @Cur INTO @DivisionID
END
