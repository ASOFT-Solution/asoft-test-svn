declare @TK varchar(16)
declare @TKCha varchar(16)
declare @Cap int

IF OBJECT_ID('tempdb..#tableFollowGrade') IS NOT NULL
BEGIN
    DROP TABLE #tableFollowGrade
END

create table #tableFollowGrade
(
	[TK] varchar(16) NOT NULL,	
	[TKCha] varchar(16) NULL,
	[Cap] int null
) 

-- Tk cấp 1
Update DMTK set TkMe = NULL where Tk = TkMe
Update DMTK set GradeTK = 1 where TKMe is null
Update DMTK set GradeTK = -1 where TKMe is not null

insert into #tableFollowGrade(Tk, TKCha, Cap)
select TK, TKMe, GradeTK from DMTK

-- Duyệt đến khi đã xác định cấp cho tất cả các TK
while exists (select * from #tableFollowGrade where Cap = -1)
Begin
	-- Lấy TK đã xác định cấp
	select top 1 @TK = Tk, @Cap = Cap from #tableFollowGrade where Cap <> -1
	
	-- Thiết định cấp cho các TK con
	Update #tableFollowGrade set Cap = @Cap + 1 where TKCha = @TK
	Update DMTK set GradeTK = @Cap + 1 where TKMe = @TK
	
	-- Hoàn tất việc xác định cấp, xóa TK khỏi bảng tạm
	delete from #tableFollowGrade where TK = @TK
	
End

drop table #tableFollowGrade