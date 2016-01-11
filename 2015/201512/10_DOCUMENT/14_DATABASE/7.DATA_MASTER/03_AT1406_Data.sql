-- <Summary>
---- 
-- <History>
---- Create on 16/02/2011 by Phát Danh
---- Modified on 19/11/2011 by Le Thi Thu Hien
---- Modified on 15/05/2012 by Thien Huynh: Bo sung phan quyen hien thi Gia von, Thanh tien
---- Modified on 20/12/2013 by Khanh Van
---- <Example>
DECLARE @Division nvarchar(50),
		@GroupID NVARCHAR(50),
		@ModuleID NVARCHAR(50)

declare cur_AllDivision cursor for
select DivisionID from AT1101

open cur_AllDivision
fetch next from cur_AllDivision into @Division

while @@fetch_status = 0
  begin
  
	delete from AT1406
	where DivisionID = @Division
	and ModuleID in ('ASOFTOP', 'ASOFTT')
	and groupid = 'ADMIN'
	and DataType = 'IV'
	and DataID = 'LP' 	
	insert into AT1406([DivisionID],[ModuleID],[GroupID],[DataID],[DataType],[BeginChar],[Permission],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
				values (@Division,'ASOFTOP','ADMIN','LP','IV', N'Sửa giá bán /Price Edit','1',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
	
	insert into AT1406([DivisionID],[ModuleID],[GroupID],[DataID],[DataType],[BeginChar],[Permission],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
				values (@Division,'ASOFTT','ADMIN','LP','IV',N'Sửa giá bán /Price Edit','1',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
							
	delete from AT1407
	where DivisionID = @Division
	and ModuleID in ('ASOFTOP', 'ASOFTT')
	and DataType = 'IV'
	and DataID = 'LP' 
	
	insert into AT1407([DivisionID],[ModuleID],[DataID],[DataName],[DataType],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
				values (@Division,'ASOFTOP','LP',N'Sửa giá bán /Price Edit','IV',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
				
	insert into AT1407([DivisionID],[ModuleID],[DataID],[DataName],[DataType],[CreateDate],[CreateUserID],[LastModifyUserID],[LastModifyDate])
				values (@Division,'ASOFTT','LP',N'Sửa giá bán /Price Edit','IV',NULL,'ASOFTADMIN','ASOFTADMIN',NULL)
				
  -- get next record
    fetch next from cur_AllDivision into @Division
  end  
close cur_AllDivision
deallocate cur_AllDivision

--DECLARE @Division nvarchar(50),
--		@GroupID NVARCHAR(50),
--		@ModuleID NVARCHAR(50)

DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID, AT1401.GroupID, ModuleID FROM AT1101
LEFT JOIN AT1401
	ON	AT1401.DivisionID = AT1101.DivisionID
LEFT JOIN AT1409
	ON AT1409.DivisionID = AT1101.DivisionID

OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @Division, @GroupID, @ModuleID

WHILE @@fetch_status = 0
  BEGIN
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'PE' 
													AND DivisionID = @Division 
													AND GroupID = @GroupID
													AND ModuleID = @ModuleID)
		BEGIN
			INSERT INTO AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission,
									CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
			Select top 1 @Division, @ModuleID, @GroupID, CAST(BeginMonth AS varchar(2))+'/' +Cast(beginyear as varchar(4)), 'PE', 1, getdate(), 'ADMIN', 'ADMIN',GETDATE()
			From AT1101 where divisionID =@Division 

		END
	
	
    FETCH NEXT FROM cur_AllDivision INTO @Division,@GroupID, @ModuleID
  END
  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision

--DECLARE @Division nvarchar(50),
--		@GroupID NVARCHAR(50),
--		@ModuleID NVARCHAR(50)

DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID, AT1401.GroupID, ModuleID FROM AT1101
LEFT JOIN AT1401
	ON	AT1401.DivisionID = AT1101.DivisionID
LEFT JOIN AT1409
	ON AT1409.DivisionID = AT1101.DivisionID

OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @Division, @GroupID, @ModuleID

WHILE @@fetch_status = 0
  BEGIN
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'VD' 
													AND DivisionID = @Division 
													AND GroupID = @GroupID
													AND ModuleID = @ModuleID)
		BEGIN
			INSERT INTO AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission,
									CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
			VALUES	(	@Division,	@ModuleID,	@GroupID, 'VD', 'VD', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())

		END
	
	--Hiển thị Giá vốn
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'PR' 
													AND DivisionID = @Division 
													AND GroupID = @GroupID
													AND ModuleID = @ModuleID)
		BEGIN
			INSERT INTO AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission,
									CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
			VALUES	(	@Division,	@ModuleID,	@GroupID, 'PR', 'PR', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())

		END
		
	--Hiển thị Thành tiền
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'AM' 
													AND DivisionID = @Division 
													AND GroupID = @GroupID
													AND ModuleID = @ModuleID)
		BEGIN
			INSERT INTO AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission,
									CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
			VALUES	(	@Division,	@ModuleID,	@GroupID, 'AM', 'AM', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())

		END
	
    FETCH NEXT FROM cur_AllDivision INTO @Division,@GroupID, @ModuleID
  END
  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision