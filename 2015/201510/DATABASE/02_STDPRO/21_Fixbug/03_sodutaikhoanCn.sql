IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoanCn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoanCn]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[sodutaikhoanCn]
	@tk varchar (16),
	@ngayCt datetime,
	@dk nvarchar(256)= null,
	@soduno float output,
	@soduco float output
as
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wob]'))
		DROP VIEW [dbo].[wob]
		
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wps]'))
		DROP VIEW [dbo].[wps]
		
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wG]'))
		DROP VIEW [dbo].[wG]
		
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wducuoi]'))
		DROP VIEW [dbo].[wducuoi]

if  @dk is NULL 
		begin set  @dk= '' end 
 	else 
		begin set @dk= ' and ' + @dk end
	declare @sql nvarchar (256)
	set @sql='create view wob as select maKH,sum(duNo) - sum(Duco) as sodu from obkh where left(tk,' + convert(nvarchar,len(@tk)) + ')='''+ @tk +''' group by tk,makh'
	print @sql
	exec (@sql)-- sq_sqlexec @sql
	set @sql='create view wps as select maKH,sum(PsNo) - sum(Psco) as sodu from bltk where left(tk,' + convert(nvarchar,len(@tk)) + ')='''+ @tk +''' and ngayCT<=convert(datetime,'''+convert(nvarchar,@ngayCT) + ''' ) ' + @dk + ' group by tk,makh'
exec (@sql)-- sq_sqlexec @sql
	set @sql='create view wG as select * from wob union select * from wps'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='create view wducuoi as select maKH,sum(sodu)as sodu from wG group by maKH'
	exec (@sql)-- sq_sqlexec @sql
	set @soduno=(select sum(sodu) from wducuoi where sodu>0)
	set @soduno= case when @soduno>0 then @soduno else 0 end
	set @soduco=(select sum(abs(sodu)) from wducuoi where sodu<0)
	set @soduco= case when @soduco>0 then @soduco else 0 end
	set @sql='drop view wob'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='drop view wps'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='drop view wG'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='drop view wducuoi'
	exec (@sql)-- sq_sqlexec @sql
return