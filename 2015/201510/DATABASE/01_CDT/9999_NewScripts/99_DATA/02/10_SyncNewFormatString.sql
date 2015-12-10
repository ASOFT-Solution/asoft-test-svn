USE [CDT]

declare @Key nvarchar (128),
		@EditMask nvarchar(128)

declare cur_formatString cursor for 
SELECT distinct _Key FROM sysFormatString

open cur_formatString 
fetch cur_formatString into @Key

	while @@FETCH_STATUS = 0
	BEGIN
	select @EditMask = dbo.GetFormatString(@Key)
	
	if isnull(@EditMask, '') <> ''
	BEGIN
		Update sysField set EditMask = @EditMask where FieldName in (select distinct Fieldname from sysFormatString where _Key = @Key)
	END
	
	fetch cur_formatString into @Key	
	END
	
close cur_formatString
deallocate cur_formatString