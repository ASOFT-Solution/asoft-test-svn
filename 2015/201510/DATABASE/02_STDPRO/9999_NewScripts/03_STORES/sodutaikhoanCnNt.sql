IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoanCnNt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoanCnNt]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE    PROCEDURE [dbo].[sodutaikhoanCnNt]
	@tk varchar (16),
	@ngayCt datetime,
	@dk nvarchar(256)=null,
	@soduno decimal(28, 6) output,
	@soduco decimal(28, 6) output,
	@sodunont decimal(28, 6) output,
	@soducont decimal(28, 6) output
as

	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wob]'))
		DROP VIEW [dbo].[wob]
		
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wps]'))
		DROP VIEW [dbo].[wps]
		
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wG]'))
		DROP VIEW [dbo].[wG]
		
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wducuoi]'))
		DROP VIEW [dbo].[wducuoi]

	if (isnull(@dk,'') = '')
		set @dk = '1=1'
		
	declare @sql nvarchar (256)
	set @sql='create view wob as select maKH,sum(duNo) - sum(Duco) as sodu,sum(dunont) - sum(ducont) as sodunt from obkh where left(tk,' + convert(nvarchar,len(@tk)) + ')='''+ @tk +''' and ' + @dk + ' group by tk,makh'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='create view wps as select maKH,sum(PsNo) - sum(Psco) as sodu,sum(PsNoNt) - sum(PsCoNt) as sodunt from bltk where left(tk,' + convert(nvarchar,len(@tk)) + ')='''+ @tk +''' and ngayCT<=convert(datetime,'''+convert(nvarchar,@ngayCT) + ''' ) and ' + @dk + ' group by tk,makh'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='create view wG as select * from wob union all select * from wps'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='create view wducuoi as select maKH,sum(sodu)as sodu,sum(sodunt) as sodunt from wG group by maKH'
	exec (@sql)-- sq_sqlexec @sql
	set @soduno=(select sum(sodu) from wducuoi where sodu>0)
	set @soduno= case when @soduno>0 then @soduno else 0 end
	set @soduco=(select sum(abs(sodu)) from wducuoi where sodu<0)
	set @soduco= case when @soduco>0 then @soduco else 0 end
	set @sodunont=(select sum(sodunt) from wducuoi where sodu>0)
	set @sodunont= case when @sodunont>0 then @sodunont else 0 end
	set @soducont=(select sum(abs(sodunt)) from wducuoi where sodunt<0)
	set @soducont= case when @soducont>0 then @soducont else 0 end
	set @sql='drop view wob'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='drop view wps'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='drop view wG'
	exec (@sql)-- sq_sqlexec @sql
	set @sql='drop view wducuoi'
	exec (@sql)-- sq_sqlexec @sql
return