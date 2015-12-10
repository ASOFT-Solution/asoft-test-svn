use [CDT]

Declare @sysReportID int,
		@sysFieldID int,
		@sysTableLanguage int

-- I) Tổng hợp công nợ phải trả
select @sysReportID = sysReportID from sysReport where ReportName = N'Tổng hợp công nợ phải trả'

Update sysReport set Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)

if exists (select distinct name from sys.all_views where name = ''wsodu'') drop view wsodu 
if exists (select distinct name from sys.all_views where name = ''wsotk'') drop view wsotk
if exists (select distinct name from sys.all_views where name = ''wG1'') drop view wG1
if exists (select distinct name from sys.all_views where name = ''wsops'') drop view wsops
if exists (select distinct name from sys.all_views where name = ''wdudau'') drop view wdudau
if exists (select distinct name from sys.all_views where name = ''wG2'') drop view wG2
if exists (select distinct name from sys.all_views where name = ''wkq'') drop view wkq

--lấy số dư đầu bảng OBKH
set @sql=''create view wsodu as select tk, makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select tk, makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by tk, makh''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select tk, makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by tk, makh ''
exec (@sql)
select a.makh as mncc,b.tenkh as tncc, a.tk,
a.nodau as dndk,a.codau as dcdk,a.psno as psn,a.psco as psc,a.nocuoi as dnck,a.cocuoi as dcck,
a.nodaunt as dndkNT,a.codaunt as dcdkNT,a.psnont as psnNT,a.pscont as pscNT,a.nocuoint as dnckNT, a.cocuoint as dcckNT
from wkq a left join dmkh b on  a.makh=b.makh
drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq', mtAlias = NULL
where sysReportID = @sysReportID

-- TK
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')
				
Update [sysReportFilter] set SpecialCond = 1
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and SpecialCond = 0

-- TKDu
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TKDu'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')
				
Update [sysReportFilter] set Visible = 0
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and Visible = 1

-- Multi language
select @sysTableLanguage = sysTableID from sysTable
where TableName = 'wTHCNPTRA'

if not exists (select top 1 1 from sysField where FieldName = 'dndkNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dndkNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư nợ đầu kỳ Nguyên tệ', N'Original beginning debit amount', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'dcdkNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dcdkNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư có đầu kỳ Nguyên tệ', N'Original beginning credit amount', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'psnNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'psnNT', 1, NULL, NULL, NULL, NULL, 2, N'Phát sinh nợ Nguyên tệ', N'Original arising debitt', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'pscNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'pscNT', 1, NULL, NULL, NULL, NULL, 2, N'Phát sinh có Nguyên tệ', N'Original arising credit', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'dnckNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dnckNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư nợ cuối kỳ Nguyên tệ', N'Original closing debit amount', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'dcckNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dcckNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư có cuối kỳ Nguyên tệ', N'Original closing credit amount', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- II) Tổng hợp công nợ phải thu
select @sysReportID = sysReportID from sysReport where ReportName = N'Tổng hợp công nợ phải thu'

Update sysReport set Query = N'declare @tk nvarchar(16),@ngayCt datetime,@ngayCt1 datetime, @sql nvarchar (4000)
set @tk=@@TK
set @ngayCt=@@ngayct1
set @ngayCt1=dateadd(hh,23,@@ngayct2)

if exists (select distinct name from sys.all_views where name = ''wsodu'') drop view wsodu 
if exists (select distinct name from sys.all_views where name = ''wsotk'') drop view wsotk
if exists (select distinct name from sys.all_views where name = ''wG1'') drop view wG1
if exists (select distinct name from sys.all_views where name = ''wsops'') drop view wsops
if exists (select distinct name from sys.all_views where name = ''wdudau'') drop view wdudau
if exists (select distinct name from sys.all_views where name = ''wG2'') drop view wG2
if exists (select distinct name from sys.all_views where name = ''wkq'') drop view wkq

--lấy số dư đầu bảng OBKH
set @sql=''create view wsodu as select tk, makh, sum(dunont) as dunont,sum(duno)as duno, sum(ducont) as ducont, sum(duco) as duco from obkh where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư đầu bảng BLTK
set @sql=''create view wsotk as select tk, makh, sum(psnont) as dunont,sum(psno)as duno, sum(pscont) as ducont, sum(psco) as duco from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and '' + @@ps + '' and ngayct<cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) group by tk, makh ''
exec (@sql)
--Lấy số dư đầu kỳ từ hai bảng OBKH và BLTK
set @sql=''create view wG1 as select * from wsodu union all select * from wsotk''
exec (@sql)
set @sql=''create view wdudau as select tk, makh,nodaunt=case when sum(dunont)-sum(ducont)>0 then sum(dunont)-sum(ducont) else 0 end ,
nodau=case when sum(duno)-sum(duco)>0 then sum(duno)-sum(duco) else 0 end ,codaunt=case when sum(dunont)-sum(ducont)<0 then sum(ducont)-sum(dunont) else 0 end,
codau=case when sum(duno)-sum(duco)<0 then sum(duco)-sum(duno) else 0 end,0.0 as psnont, 0.0 as psno, 0.0 as pscont, 0.0 as psco, 
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi from wG1 group by tk, makh''
exec (@sql)
--lấy số phát sinh trong kỳ
set @sql=''create view wsops as select tk, makh,0.0 as nodaunt,0.0 as nodau,0.0 as codaunt,0.0 as codau,
sum(psnont)as psnont,sum(psno)as psno, sum(pscont) as pscont, sum(psco) as psco,
0.0 as nocuoint, 0.0 as nocuoi, 0.0 as cocuoint, 0.0 as cocuoi
from bltk where left(tk,len('' + @tk + ''))=''''''+ @tk +'''''' and ngayct between cast('''''' + convert(nvarchar,@ngayct) + '''''' as datetime) and cast('''''' + convert(nvarchar, @ngayCt1) + '''''' as datetime) and '' + @@ps + '' group by tk, makh''
exec (@sql)
--lấy số dư cuối
set @sql =''create view wG2 as select * from wdudau union all select * from wsops''
exec (@sql)
set @sql=''create view wkq as 
select tk, makh, sum(nodaunt) as nodaunt, sum(nodau) as nodau, sum(codaunt) as codaunt, sum(codau) as codau, 
sum(psnont) as psnont, sum(psno) as psno, sum(pscont) as pscont,sum(psco) as psco,
nocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)>0 then sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)else 0 end,
nocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)>0 then sum(nodau)+sum(psno)-sum(codau)-sum(psco)else 0 end,
cocuoint=case when sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont)<0 then abs(sum(nodaunt)+sum(psnont)-sum(codaunt)-sum(pscont))else 0 end, 
cocuoi=case when sum(nodau)+sum(psno)-sum(codau)-sum(psco)<0 then abs(sum(nodau)+sum(psno)-sum(codau)-sum(psco))else 0 end 
from wG2  group by tk, makh ''
exec (@sql)
select a.makh as mkh,b.tenkh as tkh, a.tk,
a.nodau as dndk,a.codau as dcdk,a.psno as psn,a.psco as psc,a.nocuoi as dnck,a.cocuoi as dcck,
a.nodaunt as dndkNT,a.codaunt as dcdkNT,a.psnont as psnNT,a.pscont as pscNT,a.nocuoint as dnckNT, a.cocuoint as dcckNT
from wkq a left join dmkh b on  a.makh=b.makh
drop view wsodu
drop view wsotk
drop view wG1
drop view wsops
drop view wdudau
drop view wG2
drop view wkq', mtAlias = NULL
where sysReportID = @sysReportID

-- TK
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')
				
Update [sysReportFilter] set SpecialCond = 1
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and SpecialCond = 0

-- TKDu
select @sysFieldID = sysFieldID from SysField
				where FieldName = 'TKDu'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')
				
Update [sysReportFilter] set Visible = 0
where [sysFieldID] = @sysFieldID and sysReportID = @sysReportID and Visible = 1

-- Multi language
select @sysTableLanguage = sysTableID from sysTable
where TableName = 'wTHCNPTHU'

if not exists (select top 1 1 from sysField where FieldName = 'dndkNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dndkNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư nợ đầu kỳ Nguyên tệ', N'Original beginning debit amount', 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'dcdkNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dcdkNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư có đầu kỳ Nguyên tệ', N'Original beginning credit amount', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'psnNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'psnNT', 1, NULL, NULL, NULL, NULL, 2, N'Phát sinh nợ Nguyên tệ', N'Original arising debitt', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'pscNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'pscNT', 1, NULL, NULL, NULL, NULL, 2, N'Phát sinh có Nguyên tệ', N'Original arising credit', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'dnckNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dnckNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư nợ cuối kỳ Nguyên tệ', N'Original closing debit amount', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'dcckNT' and sysTableID = @sysTableLanguage)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableLanguage, N'dcckNT', 1, NULL, NULL, NULL, NULL, 2, N'Dư có cuối kỳ Nguyên tệ', N'Original closing credit amount', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)