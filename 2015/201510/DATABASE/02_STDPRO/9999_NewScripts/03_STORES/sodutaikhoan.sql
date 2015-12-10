IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoan]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sodutaikhoan]
	@tk varchar (16),
	@ngayCt datetime,
	@dk nvarchar(256)= null,
	@Rsoduno decimal(28, 6) output,
	@Rsoduco decimal(28, 6) output
as
	declare @isCn bit
	set @isCn=(select tkcongno from dmtk where tk=@tk)
	set @isCn = case when @iscn>0 then 1 else 0 end
	if @isCn=1
		begin
			execute sodutaikhoanCn @tk,@ngayCt,@dk,@soduno=@Rsoduno output,@soduco=@Rsoduco output
		end
	else
		begin
			execute sodutaikhoanthuong @tk,@ngayCt,@dk,@soduno=@Rsoduno output,@soduco=@Rsoduco output

		end