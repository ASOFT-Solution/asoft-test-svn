
-- <Summary>
---- 
-- <History>
---- Create on 16/05/2011 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
declare @Division nvarchar(50)

declare cur_AllDivision cursor for
select DivisionID from AT1101

open cur_AllDivision
fetch next from cur_AllDivision into @Division
while @@fetch_status = 0
  begin
  
  if not exists (
	select * from AT1404 
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0247'
	and DivisionID = @Division)
  	begin
  		INSERT AT1404 ([DivisionID], [ModuleID], [ScreenID], [ScreenName], [ScreenType], [CreateUserID], [CreateDate], [LastModifyUserID], [LastModifyDate], [ScreenNameE]) 
  		VALUES (@Division, N'AsoftT', N'AF0247', N'Cập nhật giá trị tham số', 3, N'ASOFTDADMIN', NULL, N'ASOFTDADMIN', NULL, NULL)
  	end
  	else
  	begin
  		UPDATE AT1404 SET [ScreenName] = N'Cập nhật giá trị tham số' WHERE ModuleID = 'ASOFTT' and ScreenID = 'AF0247' and DivisionID = @Division
  	end
  	
	if not exists (
	select * from AT1404STD 
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0247')
  	begin
  		INSERT [dbo].[AT1404STD] ([ModuleID], [ScreenID], [ScreenName], [ScreenType], [CreateUserID], [CreateDate], [LastModifyUserID], [LastModifyDate], [ScreenNameE]) 
  		VALUES (N'AsoftT', N'AF0247', N'Cập nhật giá trị tham số', 3, N'ASOFTDADMIN', NULL, N'ASOFTDADMIN', NULL, N'Update Parameter')
  	end
  	else
  	begin
  		UPDATE AT1404STD SET [ScreenName] = N'Cập nhật giá trị tham số' 
  		WHERE ModuleID = 'ASOFTT' and ScreenID = 'AF0247'
  	end
  	
  	if not exists (
	select * from AT1403STD
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0247'
	and GroupID = 'ADMIN')
  	begin
  		INSERT [dbo].[AT1403STD] ([ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'AF0247', N'ADMIN', N'AsoftT', 1, 1, 1, 1, 1, CAST(0x00009DD400000000 AS DateTime), N'ASOFTADMIN', N'ADMIN', CAST(0x00009DD400000000 AS DateTime))
  	end
  	
  	if not exists (
	select * from AT1403 
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0247'
	and GroupID = 'ADMIN'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1403] ( [DivisionID], [ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'AF0247', N'ADMIN', N'AsoftT', 1, 1, 1, 1, 1, CAST(0x00009E9400A4F05A AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009E9400A4F05A AS DateTime))
  	end
	-- get next record
    fetch next from cur_AllDivision into @Division
  end  
close cur_AllDivision
deallocate cur_AllDivision
declare cur_AllDivision cursor for
select DivisionID from AT1101

open cur_AllDivision
fetch next from cur_AllDivision into @Division

while @@fetch_status = 0
  begin
  
  if exists (
	select * from AT1404 
	where ModuleID = 'ASOFTCI'
	and ScreenID = 'CF0029'
	and DivisionID = @Division)
  	begin
  		UPDATE AT1404 SET ScreenID = N'AS0053' 
  		WHERE ModuleID = 'ASOFTCI' and ScreenID = 'CF0029' and DivisionID = @Division
  	end
  		
	if exists (
	select * from AT1404STD 
	where ModuleID = 'ASOFTCI'
	and ScreenID = 'CF0029')
  	begin
  		UPDATE AT1404STD SET ScreenID = N'AS0053' 
  		WHERE ModuleID = 'ASOFTCI' and ScreenID = 'CF0029'
  	end
  	
  	if exists (
	select * from AT1403STD
	where ModuleID = 'ASOFTCI'
	and ScreenID = 'CF0029'
	and GroupID = 'ADMIN')
  	begin
  		UPDATE [AT1403STD] SET ScreenID = N'AS0053' 
  		WHERE ModuleID = 'ASOFTCI' and ScreenID = 'CF0029' and GroupID = 'ADMIN'
  	end
  	
  	if exists (
	select * from AT1403 
	where ModuleID = 'ASOFTCI'
	and ScreenID = 'CF0029'
	and GroupID = 'ADMIN'
	and DivisionID = @Division)
  	begin
  		UPDATE [AT1403] SET ScreenID = N'AS0053' 
  		WHERE ModuleID = 'ASOFTCI' and ScreenID = 'CF0029' and GroupID = 'ADMIN' and DivisionID = @Division
  	end
		
  -- get next record
    fetch next from cur_AllDivision into @Division
  end
  
close cur_AllDivision
deallocate cur_AllDivision