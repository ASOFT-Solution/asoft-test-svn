-- <Summary>
---- 
-- <History>
---- Create on Create on 19/11/2011 by Le Thi Thu Hien
---- Modified on 15/05/2012 by Thien Huynh: Bo sung phan quyen hien thi Gia von, Thanh tien
---- <Example>
DECLARE @Division nvarchar(50)
DECLARE cur_AllDivision CURSOR FOR
SELECT DivisionID FROM AT1101
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @Division
WHILE @@fetch_status = 0
  BEGIN	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1408 WHERE DataTypeID = 'VD' AND DivisionID = @Division)
		BEGIN
			INSERT INTO AT1408(		DivisionID,		DataTypeID,		DataTypeName,		DataTypeNameE	)
			VALUES	(		@Division,		'VD',		N'Ngày chứng từ',		'VoucherDate')
		END
	ELSE
		BEGIN
			UPDATE AT1408
			SET
				DataTypeName = N'Ngày chứng từ',
				DataTypeNameE = 'VoucherDate'
			WHERE	DataTypeID = 'VD'
					AND DivisionID = @Division
		END		
	--Hiển thị Giá vốn
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1408 WHERE DataTypeID = 'PR' AND DivisionID = @Division)
		BEGIN
			INSERT INTO AT1408(		DivisionID,		DataTypeID,		DataTypeName,		DataTypeNameE	)
			VALUES	(		@Division,		'PR',		N'Hiển thị Giá vốn',		'UnitPrice')
		END
	ELSE
		BEGIN
			UPDATE AT1408
			SET
				DataTypeName = N'Hiển thị Giá vốn',
				DataTypeNameE = 'UnitPrice'
			WHERE	DataTypeID = 'PR'
					AND DivisionID = @Division
		END		
	--Hiển thị Thành tiền
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1408 WHERE DataTypeID = 'AM' AND DivisionID = @Division)
		BEGIN
			INSERT INTO AT1408(		DivisionID,		DataTypeID,		DataTypeName,		DataTypeNameE	)
			VALUES	(		@Division,		'AM',		N'Hiển thị Thành tiền',		'Amount')
		END
	ELSE
		BEGIN
			UPDATE AT1408
			SET
				DataTypeName = N'Hiển thị Thành tiền',
				DataTypeNameE = 'Amount'
			WHERE	DataTypeID = 'AM'
					AND DivisionID = @Division
		END
	
    FETCH NEXT FROM cur_AllDivision INTO @Division
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision
INSERT INTO AT1408(	DivisionID,		DataTypeID,		DataTypeName,		DataTypeNameE	)
	SELECT DivisionID, 'CR', N'Báo cáo đặc thù','Customize Report'
	FROM AT1101 PQ
	WHERE NOT EXISTS(	SELECT TOP 1 1 FROM AT1408 TMP 
	     	           	WHERE TMP.DivisionID = PQ.DivisionID
	     	           			AND TMP.DataTypeID = 'CR')