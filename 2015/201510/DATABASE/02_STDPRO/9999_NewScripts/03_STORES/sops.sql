IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sops]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sops]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sops] 
@tk nvarchar (16),
@ngayCt datetime,
@ngayCt1 datetime,
@dk as nvarchar (256)=null,
@psno decimal(28, 6) output,
@psco decimal(28, 6) output
as
	IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wbltk]'))
		DROP VIEW [dbo].[wbltk]

	declare @sql nvarchar (400)
	set @sql='create view wbltk as select sum(psno) as psno, sum(psco) as psco from bltk where left(tk,len(''' + @tk + ''')) = ''' + @tk + ''' and ngayCt between cast(''' + convert(nvarchar,@ngayCt) + ''' as datetime) and cast(''' + convert(nvarchar,@ngayCt1) + ''' as datetime)  '
	if (@dk is not   null)	
		set @sql= @sql + ' and ' +  @dk
	exec (@sql)
	set @psno=(select psno from wbltk) 
	set @psno=case when @psno>0 then @psno else 0 end
	set @psco=(select psco from wbltk) 
	set @psco=case when @psco>0 then @psco else 0 end
	drop view wbltk
return