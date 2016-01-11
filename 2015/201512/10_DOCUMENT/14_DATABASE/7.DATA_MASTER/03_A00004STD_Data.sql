-- <Summary>
---- 
-- <History>
---- Create on 27/03/2012 by Huỳnh Tấn Phú
---- Modified on 26/12/2011 by Huỳnh Tấn Phú
---- <Example>
-- AT1404STD
DELETE from AT1404STD where ModuleID = 'ASoftCI'and ScreenID = 'CF0096'
INSERT [dbo].[AT1404STD] ([ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
VALUES (N'ASoftCI', N'CF0096', N'Danh mục hợp đồng', N'Contract List',2,GETDATE(), N'ASOFTADMIN', N'ASOFTADMIN', GETDATE())
-- AT1403STD
DELETE from AT1403STD where ModuleID = 'ASOFTCI'and ScreenID = 'CF0096'
INSERT [dbo].[AT1403STD] ([ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
VALUES (N'CF0096', N'ADMIN', N'AsoftCI', 1, 1, 1, 1, 1, GETDATE(), N'ASOFTADMIN', N'ADMIN', GETDATE())
-- A00004STD
DELETE from A00004STD where ModuleID = 'ASOFTCI' and ScreenID = 'CF0096'
INSERT [dbo].[A00004STD] ([ModuleID], [ScreenID], [CommandMenu]) 
VALUES (N'AsoftCI', N'CF0096', N'mnuList_Other_Contract')	  		
declare @Division nvarchar(50)
declare cur_AllDivision cursor for
select DivisionID from AT1101

open cur_AllDivision
fetch next from cur_AllDivision into @Division

while @@fetch_status = 0
  begin
  
		DELETE from A00004 where ModuleID = 'ASOFTCI'and ScreenID = 'CF0096'and DivisionID = @Division
		INSERT [dbo].[A00004] ([DivisionID], [ModuleID], [ScreenID], [CommandMenu]) 
		VALUES (@Division, N'AsoftCI', N'CF0096', N'mnuList_Other_Contract')

		DELETE from AT1403 where ModuleID = 'ASOFTCI' and ScreenID = 'CF0096'and DivisionID = @Division
		INSERT [dbo].[AT1403] ([DivisionID], [ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
		VALUES (@Division, N'CF0096', N'ADMIN', N'AsoftCI', 1, 1, 1, 1, 1, GETDATE(), N'ASOFTADMIN', N'ASOFTADMIN', GETDATE())

		delete from AT1404 where ModuleID = 'AsoftCI' and ScreenID = 'CF0096'and DivisionID = @Division
		INSERT [dbo].[AT1404] ([DivisionID], [ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], 
		[CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
		VALUES (@Division, N'AsoftCI', N'CF0096', N'Danh mục hợp đồng', N'Contract List',
		2, GETDATE(), N'ASOFTADMIN', N'ASOFTADMIN', GETDATE())  		
  -- get next record
    fetch next from cur_AllDivision into @Division
  end  
close cur_AllDivision
deallocate cur_AllDivision
--declare @Division nvarchar(50)
declare cur_AllDivision cursor for
select DivisionID from AT1101
open cur_AllDivision
fetch next from cur_AllDivision into @Division

while @@fetch_status = 0  begin  
  if not exists (
	select * from A00004 
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0246'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[A00004] ([DivisionID], [ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (@Division, N'AsoftT', N'AF0246', N'mnuList_PrintedInvoice')
  	end
	if not exists (
	select * from A00004STD 
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0246')
  	begin
  		INSERT [dbo].[A00004STD] ([ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (N'AsoftT', N'AF0246', N'mnuList_PrintedInvoice')
  	end  		
  	if not exists (
	select * from AT1403 
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0246'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1403] ([DivisionID], [ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'AF0246', N'ADMIN', N'AsoftT', 1, 1, 1, 1, 1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
	if not exists (
	select * from AT1403STD 
	where ModuleID = 'ASOFTT'
	and ScreenID = 'AF0246')
  	begin
  		INSERT [dbo].[AT1403STD] ([ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'AF0246', N'ADMIN', N'AsoftT', 1, 1, 1, 1, 1, CAST(0x00009DD400000000 AS DateTime), N'ASOFTADMIN', N'ADMIN', CAST(0x00009DD400000000 AS DateTime))
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
  
  if not exists (
	select * from A00004 
	where ModuleID = 'ASoftWM'
	and ScreenID = 'WF0076'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[A00004] ([DivisionID], [ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (@Division, N'ASoftWM', N'WF0076', N'mnuReport_Theodoidathang_SX_NK_GH')
  	end
	if not exists (
	select * from A00004STD 
	where ModuleID = 'ASoftWM'
	and ScreenID = 'WF0076')
  	begin
  		INSERT [dbo].[A00004STD] ([ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (N'ASoftWM', N'WF0076', N'mnuReport_Theodoidathang_SX_NK_GH')
  	end
  		
  	if not exists (
	select * from AT1403 
	where ModuleID = 'ASoftWM'
	and ScreenID = 'WF0076'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1403] ([DivisionID], [ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'WF0076', N'ADMIN', N'ASoftWM', 1, 1, 1, 1, 1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
	if not exists (
	select * from AT1403STD 
	where ModuleID = 'ASoftWM'
	and ScreenID = 'WF0076')
  	begin
  		INSERT [dbo].[AT1403STD] ([ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'WF0076', N'ADMIN', N'ASoftWM', 1, 1, 1, 1, 1, CAST(0x00009DD400000000 AS DateTime), N'ASOFTADMIN', N'ADMIN', CAST(0x00009DD400000000 AS DateTime))
  	end
  		
	if not exists (
	select * from AT1404 
	where ModuleID = 'ASoftWM'
	and ScreenID = 'WF0076'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1404] ([DivisionID], [ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], 
  		[CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'ASoftWM', N'WF0076', N'Theo dõi đặt hàng - sản xuất - nhập kho - giao hàng', N'Order Tracking - manufacturing - warehousing - Delivery',
  		1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
	if not exists (
	select * from AT1404STD 
	where ModuleID = 'ASoftWM'
	and ScreenID = 'WF0076')
  	begin
		INSERT [dbo].[AT1404STD] ([ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'ASoftWM', N'WF0076', N'Theo dõi đặt hàng - sản xuất - nhập kho - giao hàng', N'Order Tracking - manufacturing - warehousing - Delivery',1,CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))

  	end			
  -- get next record
    fetch next from cur_AllDivision into @Division
  end
  
close cur_AllDivision
deallocate cur_AllDivision
if not exists (
	select * from AT1403STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0255')
  	begin
  		INSERT [dbo].[AT1403STD] ([ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'AF0255', N'ADMIN', N'ASoftT', 1, 1, 1, 1, 1, CAST(0x00009DD400000000 AS DateTime), N'ASOFTADMIN', N'ADMIN', CAST(0x00009DD400000000 AS DateTime))
  	end
	if not exists (
	select * from AT1404STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0255')
  	begin
		INSERT [dbo].[AT1404STD] ([ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'ASoftT', N'AF0255', N'Theo dõi chi tiết đơn hàng', N'Detail of Orders',1,CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end	
  	
declare cur_AllDivision cursor for
select DivisionID from AT1101

open cur_AllDivision
fetch next from cur_AllDivision into @Division

while @@fetch_status = 0
  begin
  
  if not exists (
	select * from A00004 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0255'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[A00004] ([DivisionID], [ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (@Division, N'ASoftT', N'AF0255', N'mnuReport_Sales_SOrderDetail')
  	end
	if not exists (
	select * from A00004STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0255')
  	begin
  		INSERT [dbo].[A00004STD] ([ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (N'ASoftT', N'AF0255', N'mnuReport_Sales_SOrderDetail')
  	end
  		
  	if not exists (
	select * from AT1403 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0255'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1403] ([DivisionID], [ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'AF0255', N'ADMIN', N'ASoftT', 1, 1, 1, 1, 1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
  		
	if not exists (
	select * from AT1404 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0255'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1404] ([DivisionID], [ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], 
  		[CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'ASoftT', N'AF0255', N'Theo dõi chi tiết đơn hàng', N'Detail of Orders',
  		1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
		
  -- get next record
    fetch next from cur_AllDivision into @Division
  end
  
close cur_AllDivision
deallocate cur_AllDivision
if not exists (
	select * from AT1403STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0250')
  	begin
  		INSERT [dbo].[AT1403STD] ([ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'AF0250', N'ADMIN', N'ASoftT', 1, 1, 1, 1, 1, CAST(0x00009DD400000000 AS DateTime), N'ASOFTADMIN', N'ADMIN', CAST(0x00009DD400000000 AS DateTime))
  	end
	if not exists (
	select * from AT1404STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0250')
  	begin
		INSERT [dbo].[AT1404STD] ([ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (N'ASoftT', N'AF0250', N'Báo cáo dòng tiền', N'Cash flow report',1,CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end	
  	
declare cur_AllDivision cursor for
select DivisionID from AT1101

open cur_AllDivision
fetch next from cur_AllDivision into @Division

while @@fetch_status = 0
  begin
  
  if not exists (
	select * from A00004 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0250'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[A00004] ([DivisionID], [ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (@Division, N'ASoftT', N'AF0250', N'mnuReport_Finance_CashFlow')
  	end
	if not exists (
	select * from A00004STD 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0250')
  	begin
  		INSERT [dbo].[A00004STD] ([ModuleID], [ScreenID], [CommandMenu]) 
  		VALUES (N'ASoftT', N'AF0250', N'mnuReport_Finance_CashFlow')
  	end
  		
  	if not exists (
	select * from AT1403 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0250'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1403] ([DivisionID], [ScreenID], [GroupID], [ModuleID], [IsAddNew], [IsUpdate], [IsDelete], [IsView], [IsPrint], [CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'AF0250', N'ADMIN', N'ASoftT', 1, 1, 1, 1, 1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
  		
	if not exists (
	select * from AT1404 
	where ModuleID = 'ASoftT'
	and ScreenID = 'AF0250'
	and DivisionID = @Division)
  	begin
  		INSERT [dbo].[AT1404] ([DivisionID], [ModuleID], [ScreenID], [ScreenName], [ScreenNameE], [ScreenType], 
  		[CreateDate], [CreateUserID], [LastModifyUserID], [LastModifyDate]) 
  		VALUES (@Division, N'ASoftT', N'AF0250', N'Báo cáo dòng tiền', N'Cash flow report',
  		1, CAST(0x00009EAD0119A136 AS DateTime), N'ASOFTADMIN', N'ASOFTADMIN', CAST(0x00009EAD0119A136 AS DateTime))
  	end
		
  -- get next record
    fetch next from cur_AllDivision into @Division
  end
  
close cur_AllDivision
deallocate cur_AllDivision
---- process for master menu & form
if not exists (
	select top 1 1 from A00004STD 
	where ModuleID = 'ASoftS' 
	and CommandMenu = 'mnuPermission_GroupUser'
)
	insert A00004STD(ModuleID, ScreenID, CommandMenu)
	Values ('ASoftS','AS0006', 'mnuPermission_GroupUser')
-- process divisionid 
insert into A00004(DivisionID, ModuleID, ScreenID, CommandMenu)
select A.DivisionID, B.ModuleID, B.ScreenID, B.CommandMenu 
from A00004STD B cross join (Select Distinct DivisionID from AT1101) A
Where ModuleID = 'ASoftS'
And CommandMenu = 'mnuPermission_GroupUser'
And not exists(select top 1 1 from A00004 
				where DivisionID = A.DivisionID 
				And ModuleID = B.ModuleID 
				And ScreenID = B.ScreenID
				And CommandMenu = B.CommandMenu
				And ModuleID = 'ASoftS'
				And CommandMenu = 'mnuPermission_GroupUser'
				)
--- process for master menu & form
if not exists (
	select top 1 1 from A00004STD 
	where ModuleID = 'ASoftS' 
	and CommandMenu = 'mnuPermission_GroupUserPermission')
	insert A00004STD(ModuleID, ScreenID, CommandMenu)
	Values ('ASoftS','AS0007', 'mnuPermission_GroupUserPermission')
-- process divisionid
insert into A00004(DivisionID, ModuleID, ScreenID, CommandMenu)
select A.DivisionID, B.ModuleID, B.ScreenID, B.CommandMenu 
from A00004STD B cross join (Select Distinct DivisionID from AT1101) A
Where ModuleID = 'ASoftS'
And CommandMenu = 'mnuPermission_GroupUserPermission'
And not exists(select top 1 1 from A00004 
				where DivisionID = A.DivisionID 
				And ModuleID = B.ModuleID 
				And ScreenID = B.ScreenID
				And CommandMenu = B.CommandMenu
				And ModuleID = 'ASoftS'
				And CommandMenu = 'mnuPermission_GroupUserPermission'
				)
--- process for master menu & form
if not exists (
	select top 1 1 from A00004STD 
	where ModuleID = 'ASoftS' 
	and CommandMenu = 'mnuPermission_DataPermission'
)
	insert A00004STD(ModuleID, ScreenID, CommandMenu)
	Values ('ASoftS','AS0008', 'mnuPermission_DataPermission')
-- process divisionid 
insert into A00004(DivisionID, ModuleID, ScreenID, CommandMenu)
select A.DivisionID, B.ModuleID, B.ScreenID, B.CommandMenu 
from A00004STD B cross join (Select Distinct DivisionID from AT1101) A
Where ModuleID = 'ASoftS'
And CommandMenu = 'mnuPermission_DataPermission'
And not exists(select top 1 1 from A00004 
				where DivisionID = A.DivisionID 
				And ModuleID = B.ModuleID 
				And ScreenID = B.ScreenID
				And CommandMenu = B.CommandMenu
				And ModuleID = 'ASoftS'
				And CommandMenu = 'mnuPermission_DataPermission'
				)				
Update AT1404 set ScreenType = 3
where ScreenID = 'OF0032'
Update AT1404 set ScreenType = 2
where ScreenID = 'OF0028'