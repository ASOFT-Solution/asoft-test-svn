IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoanthuong]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoanthuong]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[sodutaikhoanthuong]
	@tk varchar (16),
	@ngayCt datetime,
	@dk nvarchar(256)= null,
	@soduno decimal(28, 6) output,
	@soduco decimal(28, 6) output
as

	declare @dauky decimal(28, 6)
	declare @count1 int 
	--Số dư đầu kỳ
	set @dauky=(SELECT sum(Duno-Duco) from obtk where  left(tk,len(@tk))=@tk)
	
	set @count1=(select count(*) from obtk where  left(tk,len(@tk))=@tk)
	set @dauky= case when @count1<>0 then @dauky else 0 end
	--Số phát sinh
	declare @ps decimal(28, 6)
	set @ps=(select sum(psNo)-sum(Psco)from bltk where left(tk,len(@tk))=@tk and ngayCt<=@NgayCT )
set @count1=(select count(*) from bltk where left(tk,len(@tk))=@tk and ngayCt<=@NgayCT)
set @ps=case when @count1>0 then @ps else 0 end
declare @sodu decimal(28, 6)
	set @sodu=@dauky+@ps	
	set @soduno=case when @sodu>0 then @sodu else 0 end
	set @soduco=case when @sodu<0 then abs(@sodu) else 0 end

return