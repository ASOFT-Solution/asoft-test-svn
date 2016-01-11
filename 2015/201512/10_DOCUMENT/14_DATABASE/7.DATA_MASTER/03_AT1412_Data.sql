-- <Summary>
---- Du lieu Man hình Thiết lập phân quyền dữ liệu
-- <History>
---- Create on 13/11/2012 by Le Thi Thu Hien
---- Modified on ... by ...
---- <Example>
DECLARE @Division nvarchar(50),
		@GroupID NVARCHAR(50),
		@ModuleID NVARCHAR(50),
		@DataTypeID NVARCHAR(50)
DECLARE cur_AllDivision CURSOR FOR
SELECT	AT1101.DivisionID, AT1401.GroupID, ModuleID , AT1408.DataTypeID
FROM	AT1101
LEFT JOIN	AT1401
	ON		AT1401.DivisionID = AT1101.DivisionID
LEFT JOIN	AT1409
	ON		AT1409.DivisionID = AT1101.DivisionID
LEFT JOIN	AT1408 
	ON		AT1408.DivisionID = AT1401.DivisionID
WHERE	AT1408.DataTypeID IN ('AC', 'DE', 'IV', 'OB', 'VT', 'WA')
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @Division, @GroupID, @ModuleID, @DataTypeID
WHILE @@fetch_status = 0
  BEGIN	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1412 WHERE DataTypeID = @DataTypeID
													AND DivisionID = @Division 
													AND GroupID = @GroupID
													AND ModuleID = @ModuleID
													)
		BEGIN
			INSERT INTO AT1412	(	DivisionID,	ModuleID,GroupID,DataTypeID,Permission,
									CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
			VALUES	(	@Division,	@ModuleID,	@GroupID, @DataTypeID, 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())
		END	
    FETCH NEXT FROM cur_AllDivision INTO @Division,@GroupID, @ModuleID, @DataTypeID
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision
