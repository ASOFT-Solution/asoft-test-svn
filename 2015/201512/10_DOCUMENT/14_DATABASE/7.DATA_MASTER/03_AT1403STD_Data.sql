-- <Summary>
---- 
-- <History>
---- Create on 03/08/2011 by Trung Dung
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
	select * from AT1403 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0251'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1403] ([DivisionID], [ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'AF0251', N'ADMIN', N'ASoftT', 1, 1, 1, 1, 1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
	if not exists (
	select * from AT1403STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0251')
  	begin
  		INSERT [dbo].[AT1403STD] ([ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'AF0251', N'ADMIN', N'ASoftT', 1, 1, 1, 1, 1, CAST(0x00009DD400000000 AS DateTime), N'ASOFTADMIN', N'ADMIN', CAST(0x00009DD400000000 AS DateTime))
  	end
  		
	if not exists (
	select * from AT1404 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0251'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1404] ([DivisionID], [ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], 
  		[CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'ASoftT', N'AF0251', N'Lập hóa đơn từ phiếu thu-chi đã import', N'Invoicing from import receipts-payble',
  		1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
	if not exists (
	select * from AT1404STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0251')
  	begin
		INSERT [dbo].[AT1404STD] ([ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'ASoftT', N'AF0251', N'Lập hóa đơn từ phiếu thu-chi đã import', N'Invoicing from import receipts-payble',1,CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))

  	end			
  -- get next record
    fetch next from cur_AllDivision into @Division
  end
  
close cur_AllDivision
deallocate cur_AllDivision