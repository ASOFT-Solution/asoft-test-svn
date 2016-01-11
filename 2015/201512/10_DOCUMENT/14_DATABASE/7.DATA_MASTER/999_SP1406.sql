----Create by Trung Dung , 17/11/2011
----Purpose : Push du lieu moi (new) tu nhung table danh muc vao table phan quyen AT1406, AT1407

Declare @cur0 cursor,
	@cur1 cursor,
	@cur2 cursor,
	@cur3 cursor,
	@GroupID as varchar(20),
	@DivisionID varchar(20),
	@ModuleID as varchar(20),
	@DataID as varchar(20),
	@DataName as varchar(500),
	@GroupCount as int,
	@sSQL varchar(1000)

Set @GroupCount = 0
if object_id('Tempdb..[#AT1406]') IS NOT null 
	Drop Table #AT1406
if object_id('Tempdb..[#AT1407]') IS NOT null 
	Drop Table #AT1407

Select Top 0 * Into #AT1406 From AT1406
Select Top 0 * Into #AT1407 From AT1407
--Delete from #At1406 
--Delete from #At1407
Set @cur0 = cursor static for
Select distinct GroupID From AT1401 Where Disabled = 0

Set @cur1 = cursor static for
Select distinct DivisionID From AT1101

Set @cur2 = cursor static for
Select distinct ModuleID From AT1409


--Lap 0
Open @cur0
Fetch Next From @cur0 Into @GroupID
While @@Fetch_Status = 0
Begin
	Set @GroupCount = @GroupCount + 1
	--Lap 1
	Open @cur1
	Fetch Next From @cur1 Into @DivisionID
	While @@Fetch_Status = 0
	Begin
		--Lap 2
		Open @cur2
		Fetch Next From @cur2 Into @ModuleID
		While @@Fetch_Status = 0
		Begin
			--Phan quyen loai chung tu
			Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
			Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
				VoucherTypeID As DataID, 'VT' as DataType, Null As BeginChar, 1 As Permission,
				getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
				'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
				From AT1007
			Where VoucherTypeID Not In (Select DataID From AT1406 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And GroupID = @GroupID
						And DataType = 'VT')
						and DivisionID = @DivisionID
			--Phan quyen kho hang
			Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
			Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
				WarehouseID As DataID, 'WA' as DataType, Null As BeginChar, 1 As Permission,
				getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
				'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
				From AT1303
			Where WarehouseID Not In (Select DataID From AT1406 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And GroupID = @GroupID
						And DataType = 'WA')
						and DivisionID = @DivisionID
			--Phan quyen tai khoan
			Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
			Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
				AccountID As DataID, 'AC' as DataType, Null As BeginChar, 1 As Permission,
				getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
				'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
				From AT1005
			Where AccountID Not In (Select DataID From AT1406 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And GroupID = @GroupID
						And DataType = 'AC')
						and DivisionID = @DivisionID
			--Phan quyen doi tuong
			if not exists (Select Top 1 1 From At1406 
					Where DivisionID = @DivisionID
					And ModuleID = @ModuleID
					And GroupID = @GroupID
					And DataType = 'OB')
			Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
			Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
				'OB' As DataID, 'OB' as DataType, Null As BeginChar, 1 As Permission,
				getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
				'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate

			--Phan quyen mat hang
			if not exists (Select Top 1 1 From At1406 
					Where DivisionID = @DivisionID
					And ModuleID = @ModuleID
					And GroupID = @GroupID
					And DataType = 'IV')
			Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
			Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
				'IV' As DataID, 'IV' as DataType, Null As BeginChar, 1 As Permission,
				getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
				'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
			--Phan quyen phong ban
			Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
			Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
				DepartmentID As DataID, 'DE' as DataType, Null As BeginChar, 1 As Permission,
				getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
				'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
				From AT1102
			Where DepartmentID Not In (Select DataID From AT1406 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And GroupID = @GroupID
						And DataType = 'DE')
						and DivisionID = @DivisionID
			--Phan quyen khoa gia ban
			If @ModuleID in ('ASOFTT','ASOFTOP') 
			Begin
				if not exists (Select Top 1 1 From At1406 
					Where DivisionID = @DivisionID
					And ModuleID = @ModuleID
					And GroupID = @GroupID
					And DataType = 'IV' And DataID = 'LP')
				Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
					'LP' As DataID, 'IV' as DataType, N'Sửa giá bán/Price Edit' As BeginChar, 1 As Permission,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate

				if not exists (Select Top 1 1 From At1406 
					Where DivisionID = @DivisionID
					And ModuleID = @ModuleID
					And GroupID = @GroupID
					And DataType = 'IV' And DataID = 'HH')
				Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
					'HH' As DataID, 'IV' as DataType, N'Sửa hoa hồng/Commission Edit' As BeginChar, 1 As Permission,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate

				if not exists (Select Top 1 1 From At1406 
					Where DivisionID = @DivisionID
					And ModuleID = @ModuleID
					And GroupID = @GroupID
					And DataType = 'IV' And DataID = 'CK')
				Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
					'CK' As DataID, 'IV' as DataType, N'Sửa chiết khấu/Discount Edit' As BeginChar, 1 As Permission,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate

				if not exists (Select Top 1 1 From At1406 
					Where DivisionID = @DivisionID
					And ModuleID = @ModuleID
					And GroupID = @GroupID
					And DataType = 'IV' And DataID = 'GG')
				Insert Into #AT1406(DivisionID,ModuleID, GroupID,DataID, DataType, BeginChar,Permission,CreateDate,CreateUserID, LastModifyUserID,LastModifyDate) 
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, @GroupID As GroupID, 
					'GG' As DataID, 'IV' as DataType, N'Sửa giảm giá/Sale off Edit' As BeginChar, 1 As Permission,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate

			End
												
			If @GroupCount = 1
			Begin
				--Phan quyen chung tu
				Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName,  DataType, CreateDate, CreateUserID ,LastModifyUserID, LastModifyDate)
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
					VoucherTypeID As DataID, VoucherTypeName As DataName, 'VT' as DataType,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
					From AT1007
				Where VoucherTypeID Not In (Select DataID From AT1407 
							Where DivisionID = @DivisionID
							And ModuleID = @ModuleID
							And DataType = 'VT')
							and DivisionID = @DivisionID
				--Phan quyen kho hang
				Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName,  DataType, CreateDate, CreateUserID ,LastModifyUserID, LastModifyDate)
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
					WarehouseID As DataID, WarehouseName As DataName, 'WA' as DataType,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
					From AT1303
				Where WarehouseID Not In (Select DataID From AT1407 
							Where DivisionID = @DivisionID
							And ModuleID = @ModuleID
							And DataType = 'WA')
							and DivisionID = @DivisionID
	
				--Phan quyen tai khoan
				Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName,  DataType, CreateDate, CreateUserID ,LastModifyUserID, LastModifyDate)
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
					AccountID As DataID, AccountName As DataName, 'AC' as DataType,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
					From AT1005
				Where AccountID Not In (Select DataID From AT1407 
							Where DivisionID = @DivisionID
							And ModuleID = @ModuleID
							And DataType = 'AC')
							and DivisionID = @DivisionID

				--Phan quyen doi tuong
				if not exists (Select Top 1 1 From At1407 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And DataType = 'OB')
				Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName,  DataType, CreateDate, CreateUserID ,LastModifyUserID, LastModifyDate)
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
					'OB' As DataID,Null As DataName, 'OB' as DataType,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
					
	
				--Phan quyen mat hang
				if not exists (Select Top 1 1 From At1407 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And DataType = 'IV')
				Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName,  DataType, CreateDate, CreateUserID ,LastModifyUserID, LastModifyDate)
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
					'IV' As DataID,Null As DataName, 'IV' as DataType,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
					
				--Phan quyen phong ban
				if not exists (Select Top 1 1 From At1407 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And DataType = 'DE')
				Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName,  DataType, CreateDate, CreateUserID ,LastModifyUserID, LastModifyDate)
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
					DepartmentID As DataID, DepartmentName As DataName, 'DE' as DataType,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
					From AT1102
				Where DepartmentID Not In (Select DataID From AT1407 
							Where DivisionID = @DivisionID
							And ModuleID = @ModuleID
							And DataType = 'DE')
							and DivisionID = @DivisionID
				--Phan quyen khoa gia ban
				If @ModuleID in ('ASOFTT','ASOFTOP') 
				Begin
				if not exists (Select Top 1 1 From At1407 
						Where DivisionID = @DivisionID
						And ModuleID = @ModuleID
						And DataType = 'IV' And DataID = 'LP')
				Insert Into #AT1407(DivisionID, ModuleID, DataID, DataName,  DataType, CreateDate, CreateUserID ,LastModifyUserID, LastModifyDate)
				Select 	@DivisionID as DivisionID, @ModuleID As ModuleID, 
					'LP' As DataID,N'Sửa giá bán/Price Edit' As DataName, 'IV' as DataType,
					getDate() as CreateDate,'ASOFTADMIN' as CreateUserID,
					'ASOFTADMIN' as LastModifyUserID,getDate() as LastModifyDate
				End	
				--Hiển thị Ngày chứng từ		
			IF NOT EXISTS (SELECT TOP 1 1 FROM AT1407 WHERE DataType = 'VD' AND DivisionID = @DivisionID AND ModuleID = @ModuleID)
				INSERT INTO #AT1407	(	DivisionID,	ModuleID,DataID,DataName, DataType, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
				VALUES	(	@DivisionID,	@ModuleID,	 'VD', N'Ngày phiếu', 'VD',  GETDATE(),'ADMIN', 'ADMIN',GETDATE())
			IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'VD' AND DivisionID = @DivisionID AND GroupID = @GroupID AND ModuleID = @ModuleID)
					INSERT INTO #AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
						VALUES	(	@DivisionID,	@ModuleID,	@GroupID, 'VD', 'VD', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())
				--Hiển thị Giá vốn
				IF NOT EXISTS (SELECT TOP 1 1 FROM AT1407 WHERE DataType = 'PR' AND DivisionID = @DivisionID AND ModuleID = @ModuleID)
					INSERT INTO #AT1407	(	DivisionID,	ModuleID,DataID,DataName, DataType, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
						VALUES	(	@DivisionID,	@ModuleID,	 'PR', N'Hiển thị Giá vốn', 'PR',  GETDATE(),'ADMIN', 'ADMIN',GETDATE())
				IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'PR' AND DivisionID = @DivisionID AND GroupID = @GroupID AND ModuleID = @ModuleID)
					INSERT INTO #AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
						VALUES	(	@DivisionID,	@ModuleID,	@GroupID, 'PR', 'PR', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())
				--Hiển thị Thành tiền
				IF NOT EXISTS (SELECT TOP 1 1 FROM AT1407 WHERE DataType = 'AM' AND DivisionID = @DivisionID AND ModuleID = @ModuleID)
					INSERT INTO #AT1407	(	DivisionID,	ModuleID,DataID,DataName, DataType, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
						VALUES	(	@DivisionID,	@ModuleID,	 'AM', N'Hiển thị Thành tiền', 'AM',  GETDATE(),'ADMIN', 'ADMIN',GETDATE())
				IF NOT EXISTS (SELECT TOP 1 1 FROM AT1406 WHERE DataType = 'AM' AND DivisionID = @DivisionID AND GroupID = @GroupID AND ModuleID = @ModuleID)
					INSERT INTO #AT1406	(	DivisionID,	ModuleID,GroupID,DataID,DataType,	Permission, CreateDate,	CreateUserID,LastModifyUserID,	LastModifyDate)
						VALUES	(	@DivisionID,	@ModuleID,	@GroupID, 'AM', 'AM', 1, GETDATE(),'ADMIN', 'ADMIN',GETDATE())

			End
			Fetch Next From @cur2 Into @ModuleID
		End
		Close @cur2

		Fetch Next From @cur1 Into @DivisionID
	End
	Close @cur1
	
	Fetch Next From @cur0 Into @GroupID
End

DEALLOCATE @cur2
DEALLOCATE @cur1
DEALLOCATE @cur0

Insert Into At1407 Select * from #AT1407 order by divisionid,moduleid,Datatype,dataID
Insert Into At1406 Select * from #AT1406 order by divisionid,moduleid,groupid,DataType,dataID

Drop Table #AT1406
Drop Table #AT1407
