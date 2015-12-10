use [CDT]

declare @sysTableID int
declare @sysReportID int
declare @sysParentReportID int
declare @soCTCongNoKH int

select @sysTableID = sysTableID from sysTable where TableName = N'BLTK'
select @sysParentReportID = sysReportID from sysReport where ReportName = N'Bảng cân đối phát sinh công nợ'
select @soCTCongNoKH = sysReportID from sysReport where ReportName = N'Sổ chi tiết công nợ khách hàng'

if not exists (select top 1 1 from sysReport where Reportname = N'Sổ chi tiết công nợ nhà cung cấp' and [sysPackageID] = 8)
INSERT [dbo].[sysReport] ([ReportName], [RpType], [mtTableID], [dtTableID], [Query], [ReportFile], [ReportName2], [ReportFile2], [sysReportParentID], [LinkField], [ColField], [ChartField1], [ChartField2], [ChartField3], [sysPackageID], [mtAlias], [dtAlias], [TreeData]) 
VALUES (N'Sổ chi tiết công nợ nhà cung cấp', 0, @sysTableID, NULL, N'declare @kh varchar(16)
declare @tkrp varchar(16)
declare @nocodk bit
declare @nocock bit
set @tkrp=@@TK
set @kh=@@MaKH
declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @NgayCt1=cast(@@ngayct1 as datetime)
set @NgayCt2=cast(@@ngayct2 as datetime)
declare @dauky float, @daukynt float
--tìm số dư đầu kỳ=Số dư đầu năm + số phát sinh trước ngàyCt1
	
	declare @daunam float, @daunamnt float
	declare @count1 int 
	--Số phát inh đầu năm
	set @daunamnt=(SELECT sum(Dunont-Ducont) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunam=(SELECT sum(Duno-Duco) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @count1=(select count(*) from obkh where  left(tk,len(@tkrp))=@tkrp and maKH=@kh and @@ps)
	set @daunamnt = case when @count1<>0 then @daunamnt else 0 end
	set @daunam = case when @count1<>0 then @daunam else 0 end
	set @daukynt=(select sum(psNont)-sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @dauky=(select sum(psNo)-sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and ngayCt<@NgayCT1 and maKH=@kh and @@ps)
	set @daukynt=case when @count1>0 then @daukynt else 0 end
	set @dauky=case when @count1>0 then @dauky else 0 end

	set @daukynt=@daukynt + @daunamnt
	set @dauky=@dauky + @daunam
	set @nocodk = case when @dauky>=0 then 1 else 0 end

--tìm số dư cuối kỳ
	declare @psNo float, @psNont float
	declare @psCo float, @psCont float
	declare @cuoiky float, @cuoikynt float
	set @psNont=(select sum(psNont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCont=(select sum(Pscont)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNo=(select sum(psNo)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psCo=(select sum(Psco)from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @count1=(select count(*) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2)and maKH=@kh and @@ps)
	set @psNont=case when @count1>0 then @psNont else 0 end
	set @psCont=case when @count1>0 then @psCont else 0 end
	set @psNo=case when @count1>0 then @psNo else 0 end
	set @psCo=case when @count1>0 then @psCo else 0 end
	set @cuoikynt=@daukynt + @psNont-@psCont
	set @cuoiky=@dauky + @psNo-@psCo
	set @nocock = case when @cuoiky>=0 then 1 else 0 end

--Lấy số phát sinh

declare @nophatsinh float, @nophatsinhnt float
declare @phatsinhco float, @phatsinhcont float
select @nophatsinhnt=sum(psnont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhcont=sum(pscont) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @nophatsinh=sum(psno) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
select @phatsinhco=sum(psco) from bltk where left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps

select null as ngayct,null as MTID,null as MaCT,null as soct, case when @@lang = 1 then N''Beginning amount'' else N''Số dư đầu kỳ'' end as diengiai,
null as tkdu,psnont=case when @nocodk=0 then 0 else @daukynt end,psno=case when @nocodk=0 then 0 else @dauky end,
pscont=case when @nocodk=0 then abs(@daukynt) else 0 end,psco=case when @nocodk=0 then abs(@dauky) else 0 end, null as makh, null as tenkh, 0 as Stt
union  all
select ngayCt,MTID, maCT,SoCt,diengiai,tkdu,psnont,psno,pscont,psco ,maKH,tenkh,1 from bltk
where  left(tk,len(@tkrp))=@tkrp and (ngayCt between @ngayCT1 and @ngayCT2 ) and maKH=@kh and @@ps
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Total of arinsing'' else N''Tổng phát sinh'' end as diengiai,
null as tkdu,@nophatsinhnt as sopsnt,@nophatsinh as sops,@phatsinhcont as pscont,@phatsinhco as psco, null as makh, null as tenkh,2
union all
select null as ngayct,null as MTID,null as mact,null as soct, case when @@lang = 1 then N''Closing amount'' else N''Số dư cuối kỳ'' end as diengiai,
null as tkdu,sopsnt=case when @nocock=0 then 0 else @cuoikynt end,sops=case when @nocock=0 then 0 else @cuoiky end,
pscont=case when @nocock=0 then abs(@cuoikynt) else 0 end, psco=case when @nocock=0 then abs(@cuoiky) else 0 end, null as makh, null as tenkh, 3
order by stt,ngayCt, soct, tkdu', N'SCTCNMKHANG', N'Book details the debt providers', NULL, @sysParentReportID, N'MTID', NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL)

select @sysReportID = sysReportID from [sysReport] where ReportName = N'Sổ chi tiết công nợ nhà cung cấp' and [sysPackageID] = 8

Update sysMenu set sysReportID = @sysReportID
where MenuName = N'Sổ chi tiết công nợ phải trả' and sysReportID <> @sysReportID

-- Step 2: Tham số báo cáo
if not exists (select top 1 1 from [sysReportFilter] where sysReportID = @sysReportID)
INSERT [dbo].[sysReportFilter] ([sysFieldID], [AllowNull], [DefaultValue], [sysReportID], [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond]) 
select [sysFieldID], [AllowNull], [DefaultValue], @sysReportID, [IsBetween], [TabIndex], [Visible], [IsMaster], [SpecialCond], [FilterCond] from [sysReportFilter] where sysReportID = @soCTCongNoKH

-- Step 3: Biểu mẫu báo cáo
if not exists (select top 1 1 from sysFormReport where sysReportID = @sysReportID)
INSERT [dbo].[sysFormReport] ([sysReportID], [ReportName], [ReportFile], [ReportName2], [ReportFile2]) 
VALUES (@sysReportID, N'Sổ chi tiết công nợ nhà cung cấp', N'SCTCNMKHANG', N'Book details the debt providers', NULL)

if not exists (select top 1 1 from Dictionary where Content = N'Yếu tố giá thành đã tồn tại!')
	insert into Dictionary(Content, Content2) Values (N'Yếu tố giá thành đã tồn tại!',N'Cost factor exists!')
