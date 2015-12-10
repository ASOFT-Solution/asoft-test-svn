IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LayTkConTuBac]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[LayTkConTuBac]
GO

-- Lấy tất cả các tài khoản con từ bậc truyền
CREATE PROCEDURE [dbo].[LayTkConTuBac](@TK varchar(16), @Bac int ,@TKCon varchar(512) OUTPUT)
as
	
Begin

declare @TKMe varchar(16)
declare @BacTKPara int

select @BacTKPara = GradeTK from DMTK where TK = @TK

IF OBJECT_ID('tempdb..#tableFollowGrade') IS NOT NULL
BEGIN
    DROP TABLE #tableFollowGrade
END

create table #tableFollowGrade
(
	[TK] varchar(16) NOT NULL,	
	[TKMe] varchar(16) NULL,
	[Cap] int null
);

-- Đệ qui tất cả các tài khoản con của TK đối số theo cấp
WITH TK_CTE(TK,TKMe,GradeTK)
AS
(
SELECT TK, TKMe, GradeTK
FROM DMTK
WHERE TK = @TK

UNION ALL

SELECT dm.TK, dm.TKMe, dm.GradeTK AS GradeTK
FROM DMTK AS dm INNER JOIN TK_CTE AS cte ON dm.TKMe = cte.TK
)
insert into #tableFollowGrade(TK,TKMe,Cap)
SELECT TK, TKMe, GradeTK
FROM TK_CTE

declare cur_tk CURSOR for
select TK from #tableFollowGrade tbl 

open cur_tk
fetch next from cur_tk into @TKMe

while @@fetch_status = 0
BEGIN
	-- Chỉ lấy các tài khoản không có tài khoản con
	if exists (select TK from #tableFollowGrade where TKMe = @TKMe)
		-- Loại bỏ các tài khoản cấp lớn hơn
		delete #tableFollowGrade where TK = @TKMe
	
	fetch next from cur_tk into @TKMe
END

if @Bac > 0 AND @Bac <> @BacTKPara
	delete #tableFollowGrade where Cap > @Bac
	
select * from #tableFollowGrade

close cur_tk
deallocate cur_tk

-- ============= Trả về chuỗi kết quả =============
declare cur_tk CURSOR for select TK from #tableFollowGrade tbl 

open cur_tk
fetch next from cur_tk into @TKMe

set @TKCon = ''

while @@fetch_status = 0
BEGIN
	if isnull(@TKCon,'') <> ''
		set @TKCon = @TKCon + ',' + @TKMe
	else
		set @TKCon = @TKMe
	
	fetch next from cur_tk into @TKMe
END

drop table #tableFollowGrade

End