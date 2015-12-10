IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoannt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoannt]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [dbo].[sodutaikhoannt]
	@tk varchar (16),
	@ngayCt datetime,
	@dk nvarchar(256),
	@Rsoduno decimal(28, 6) output,
	@Rsoduco decimal(28, 6) output,
	@RsodunoNt decimal(28, 6) output,
	@RsoducoNt decimal(28, 6) output
as
	declare @isCn bit
	set @isCn=(select tkcongno from dmtk where tk=@tk)
	set @isCn = case when @iscn>0 then 1 else 0 end
	if @isCn=1
		begin
			execute sodutaikhoanCnNt @tk,@ngayCt,@dk,@soduno=@Rsoduno output,@soduco=@Rsoduco output
				,@sodunont=@Rsodunont output,@soducont=@Rsoducont output
		end
	else
		begin
			execute sodutaikhoanthuongNt @tk,@ngayCt,@dk,@soduno=@Rsoduno output,@soduco=@Rsoduco output
				,@sodunont=@Rsodunont output,@soducont=@Rsoducont output

		end