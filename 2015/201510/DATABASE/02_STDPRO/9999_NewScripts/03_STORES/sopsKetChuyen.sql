IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sopsKetChuyen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sopsKetChuyen]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[sopsKetChuyen] 
@tk nvarchar (16),
@ngayCt datetime,
@ngayCt1 datetime,
@dk as nvarchar (256)=null,
@psno decimal(28, 6) output

as
	--declare @psno decimal(28, 6)
	declare @sql nvarchar (400)
	set @sql='create view wbltk as select sum(psco) as psco from bltk where left(tk,len(' + @tk + ')) = ' + @tk + ' and ngayCt between cast(''' + convert(nvarchar,@ngayCt) + ''' as datetime) and cast(''' + convert(nvarchar,@ngayCt1) + ''' as datetime) and Nhomdk=''KC'' and left(tkdu,3)=''154'' '
	if (@dk is not   null)	
		set @sql= @sql + ' and ' +  @dk
	exec (@sql)
	set @psno=(select psco from wbltk) 
	set @psno=case when @psno>0 then @psno else 0 end
	drop view wbltk
--return @psno