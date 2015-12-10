IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sopstaikhoan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sopstaikhoan]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [dbo].[sopstaikhoan]
	@tk nvarchar (1000),
	@ngayCt datetime,
	@ngayCt1 datetime,
	@dk nvarchar (1000)= null,
	@sopsno decimal(28, 6) output,
	@sopsco decimal(28, 6) output

as	
	if @tk is not null 
		begin
			set @tk = replace(@tk,' ', '')
			set @tk=' where (tk like''' +replace(@tk,',','%'' or tk like''') + '%'') ' 
		end
	if  @dk is NULL begin set  @dk= '' end 
	if @dk<>'' begin set @dk=' and (' + @dk + ')'  end
 		--Số phát sinh
	declare @sql nvarchar (4000)
	declare @count1  int
	set @sql='create view wbltk as select tk,ngayCT, psno , psco from bltk ' +  @tk + @dk 
print @sql
	exec (@sql)

	set @sopsno=(select sum(psno) from wbltk where  (ngayCT between @ngayCT and @ngayCT1))
	set @count1=(select count(psno) from wbltk where (ngayCT between @ngayCT and @ngayCT1))
	set @sopsno=case when @count1>0 then @sopsno else 0 end
	set @sopsco=(select sum(psco) from wbltk where  (ngayCT between @ngayCT and @ngayCT1))
	set @count1=(select count(psco) from wbltk where (ngayCT between @ngayCT and @ngayCT1))
	set @sopsco=case when @count1>0 then @sopsco else 0 end
	set @sql ='drop view wbltk '
	exec (@sql)
return
















GO


