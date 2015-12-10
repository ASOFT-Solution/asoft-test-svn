use [CDT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetDefaultFormatString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetDefaultFormatString]
GO

CREATE PROCEDURE [dbo].[SetDefaultFormatString]
	@DbName varchar(50)
as
BEGIN

declare @ExistingDb varchar(50)
declare @Key nvarchar(128)
declare @Value nvarchar(128)

-- Lấy tên DB đã tồn tại formatString trong hệ thống
select top 1 @ExistingDb = DbName 
from sysConfig
where DbName <> 'CDT'
and DbName <> @DbName
and IsFormatString = 1
order by sysConfigID

-- Duyệt các format đã tồn tại
declare cur cursor for 
select _Key, _Value from sysConfig 
where DbName = @ExistingDb
and IsFormatString = 1

open cur

fetch next from cur into @Key, @Value

WHILE @@FETCH_STATUS = 0
BEGIN

	-- Update format cho DB mới
	Update sysConfig set _Value = @Value
	where DbName = @DbName and _Key = @Key and IsFormatString = 1 
	
	fetch next from cur into @Key, @Value	
END

close cur
deallocate cur

END