-- <Summary>
---- 
-- <History>
---- Create on 19/11/2011 by Le Thi Thu Hien
---- Modified on 15/05/2012 by Thien Huynh: Bo sung phan quyen hien thi Gia von, Thanh tien
---- <Example>
DECLARE @Division nvarchar(50)
DECLARE cur_AllDivision CURSOR FOR
SELECT DivisionID FROM AT1101
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @Division
WHILE @@fetch_status = 0
  BEGIN	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1408STD WHERE DataTypeID = 'VD')
		BEGIN
			INSERT INTO AT1408STD(		DataTypeID,		DataTypeName,		DataTypeNameE	)
			VALUES	(		'VD',		N'Ngày chứng từ',		'VoucherDate'	)
		END	
	ELSE
		BEGIN
			UPDATE AT1408STD
			SET
				DataTypeName = N'Ngày chứng từ',
				DataTypeNameE = 'VoucherDate'
			WHERE DataTypeID = 'VD'			
		END	
	--Hiển thị Đơn giá
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1408STD WHERE DataTypeID = 'PR')
		BEGIN
			INSERT INTO AT1408STD(		DataTypeID,		DataTypeName,		DataTypeNameE	)
			VALUES	(		'PR',		N'Hiển thị Giá vốn',		'UnitPrice'	)
		END	
	ELSE
		BEGIN
			UPDATE AT1408STD
			SET
				DataTypeName = N'Hiển thị Giá vốn',
				DataTypeNameE = 'UnitPrice'
			WHERE DataTypeID = 'PR'			
		END		
	--Hiển thị Thành tiền
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1408STD WHERE DataTypeID = 'AM')
		BEGIN
			INSERT INTO AT1408STD(		DataTypeID,		DataTypeName,		DataTypeNameE	)
			VALUES	(		'AM',		N'Hiển thị Thành tiền',		'Amount'	)
		END	
	ELSE
		BEGIN
			UPDATE AT1408STD
			SET
				DataTypeName = N'Hiển thị Thành tiền',
				DataTypeNameE = 'Amount'
			WHERE DataTypeID = 'AM'			
		END		
    FETCH NEXT FROM cur_AllDivision INTO @Division
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision
