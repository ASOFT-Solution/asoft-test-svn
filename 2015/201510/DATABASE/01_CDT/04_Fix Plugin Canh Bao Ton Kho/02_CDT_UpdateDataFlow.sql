use [CDT]

-- Update dong di chuyen du lieu cot SoCT
declare @blConfigDetailID int
declare @mtFieldID int
declare @NewMtFieldID int

declare cur_ConfigDT cursor for
select blConfigDetailID, mtFieldID from sysDataConfigDt sDCD inner join 
				SysField sf on sf.SysFieldID = sDCD.mtFieldID
				inner join sysTable sT on St.SysTableID = sf.SysTableID
where blConfigID in (select blConfigID from sysDataConfig where NhomDK like 'HDB%')
	and sT.TableName = 'MT32'
	and FieldName = 'SoCT'
	
open cur_ConfigDT
fetch next from cur_ConfigDT into @blConfigDetailID, @mtFieldID

while @@fetch_status = 0
	begin
	set @NewMtFieldID = (select sysFieldID from SysField
										  where SysTableID = (select SysTableID from sysTable
																where TableName = 'MT32')
												and FieldName = 'SoHoaDon')
	Update sysDataConfigDt set mtFieldID = @NewMtFieldID
	where blConfigDetailID = @blConfigDetailID
	
	
	fetch next from cur_ConfigDT into @blConfigDetailID, @mtFieldID
	end
	
close cur_ConfigDT
deallocate cur_ConfigDT