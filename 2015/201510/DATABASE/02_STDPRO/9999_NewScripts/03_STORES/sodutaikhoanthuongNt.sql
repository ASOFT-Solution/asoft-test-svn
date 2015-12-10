IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoanthuongNt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoanthuongNt]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sodutaikhoanthuongNt]
	@tk varchar (16),
	@ngayCt datetime,
	@dk nvarchar(256),
	@soduno decimal(28, 6) output,
	@soduco decimal(28, 6) output,
	@sodunont decimal(28, 6) output,
	@soducont decimal(28, 6) output
as
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wob]'))
		DROP VIEW [dbo].[wob]

	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wbl]'))
		DROP VIEW [dbo].[wbl]

	declare @sql nvarchar(4000)
	declare @dauky decimal(28, 6)
	declare @daukynt decimal(28, 6)
	--Số dư đầu kỳ
	set @sql = 'create view wob as SELECT sum(DunoNt-DucoNt) as daukynt,sum(Duno-Duco) as dauky from obtk where  left(tk,len(''' + convert(nvarchar, @tk) + '''))= ''' + @tk + ''' and ' +@dk
	exec(@sql)
	set @dauky = (select sum(dauky) from wob)
	set @daukynt = (select sum(daukynt) from wob)
	set @dauky = case when @dauky is not null then @dauky else 0 end
	set @daukynt= case when @daukynt is not null then @daukynt else 0 end
	--Số phát sinh
	set @sql = 'create view wbl as select sum(psNont)-sum(Pscont) as psnt, sum(psNo)-sum(Psco) as ps from bltk where left(tk,len(''' + convert(nvarchar,@tk) + '''))= ''' + @tk + ''' and ngayCt<=convert(datetime,'''+convert(nvarchar,@ngayCT) + ''' ) and ' + @dk
	exec(@sql)
	declare @ps decimal(28, 6)
	declare @psnt decimal(28, 6)
	set @ps=(select sum(ps) from wbl)
	set @psnt=(select sum(psnt) from wbl)
	set @ps=case when @ps is not null then @ps else 0 end
	set @psnt=case when @psnt is not null then @psnt else 0 end
	declare @sodu decimal(28, 6)
	declare @sodunt decimal(28, 6)
	set @sodu=@dauky+@ps	
	set @sodunt=@daukynt+@psnt
	set @soduno=case when @sodu>0 then @sodu else 0 end
	set @soduco=case when @sodu<0 then abs(@sodu) else 0 end

	set @sodunont=case when @sodunt>0 then @sodunt else 0 end
	set @soducont=case when @sodunt<0 then abs(@sodunt) else 0 end
	drop view wob
	drop view wbl
return
