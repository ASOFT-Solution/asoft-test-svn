use [CDT]

--1- Cập nhật Nhật ký chứng từ số 02
DECLARE @mtTableID AS int
DECLARE @sysSiteIDPRO AS INT
DECLARE @sysSiteIDSTD AS INT
DECLARE @sysMenuModuleID INT
DECLARE @sysMenuParentID INT
DECLARE @sysReportID as  INT
DECLARE @sysFieldID AS INT
select @mtTableID = sysTableID from sysTable
							Where TableName = N'wNKSC'  
--1- Thêm báo cáo
if not exists (select top 1 1 from [sysReport] where [ReportName] = N'Nhật ký chứng từ số 02')
BEGIN  
INSERT INTO sysReport ([ReportName]
           ,mtTableID
		   ,Query
		   ,ReportFile
           ,ReportName2
		   ,ColField
           ,sysPackageID)
     VALUES(N'Nhật ký chứng từ số 02'
		   ,@mtTableID
		   ,N''
           ,N'NKCT02'
           ,N'Diary Vouchers No. 02 '
		   ,N'TK'
           ,8)
END

--2--Cập nhật câu Query của báo cáo
---------------Bảng cân đối phát sinh công nợ----------------------
Update sysReport set Query = N'DECLARE @TK nvarchar(512)
DECLARE @TKDu nvarchar(512)
DECLARE @LoaiTK nvarchar(512)
declare @tungay datetime
declare @denngay datetime
DECLARE @MaxRecord int
declare @Tongpsno float
declare @Tongpsco float

set @tungay = @@ngayct1
set @denngay = dateadd(hh,23,@@ngayct2)

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''#NKCT'') AND type in (N''U''))
BEGIN
CREATE TABLE #NKCT(
    ThuTu int,
    BLTKID int,
    SoCT nvarchar(512) NULL,
    NgayCT smalldatetime NULL,
	DienGiai nvarchar(512) COLLATE database_default NULL,
	TKNo varchar(16) COLLATE database_default NULL,
	TKCo varchar(16) COLLATE database_default NULL,
	Psno decimal(28, 6) NULL, --Hiện theo hàng ngang
	Psco decimal(28, 6) NULL, --Hiện theo cột
	TK nvarchar(512) COLLATE database_default NULL,
	TKDu nvarchar(512) COLLATE database_default NULL,
	LoaiTK nvarchar(512) COLLATE database_default NULL
     )
END
--Lấy dữ liệu phát sinh
INSERT INTO #NKCT ( ThuTu, BLTKID, NgayCT, SoCT, DienGiai, TKNo, TKCo, Psno, Psco, TK,TKDu, LoaiTK )
   select ROW_NUMBER() OVER(ORDER BY ngayct,soct) ,
     BLTKID, 
     NgayCT, 
     SoCT, 
     diengiai, 
     [Tài khoản đối ứng Nợ] = case when psco>0 then TkDu else '''' end, 
     [Tài khoản đối ứng Có] = case when psno>0 then TkDu else '''' end,
     psno + psco,
     psno + psco,
     TK, 
	 TKDu,
     LoaiTK
   From wNKSC c where psno+psco>0 and (NgayCt between @tungay and @denngay) and @@ps
   and TKDu = (select TkDu from wNKSC w where psno>0 and c.BLTKID = w.BLTKID and TKdu like N''11%'')
   Order by ngayct,soct
       
Select @MaxRecord = count (BLTKID)  FROM #NKCT 
 where Psno + Psco > 0 and NgayCt between @tungay and @denngay and @@ps

DECLARE nkct_cursor CURSOR FOR
SELECT DISTINCT TK,TKDu FROM #NKCT
WHERE Psno + Psco > 0 and (NgayCt between @tungay and @denngay) and @@ps

OPEN nkct_cursor

fetch nkct_cursor into @TK,@TKDu

WHILE @@FETCH_STATUS = 0
BEGIN
    
--Lấy Dòng tổng cộng
/*execute Sopstaikhoan @tk,@tungay,@denngay,''@@ps'',@Tongpsno output,@Tongpsco output
 IF (@Tongpsno > 0)
  Set @LoaiTK = N''Nợ''
 Else
  Set @LoaiTK = N''Có''
INSERT INTO #NKCT ( ThuTu, BLTKID, NgayCT, SoCT, DienGiai, TKNo, TKCo, Psno, Psco, TK,TKDu, LoaiTK )
 Values (@MaxRecord+1,NULL,NULL,NULL,case when @@lang = 1 then N''Total'' else N''Tổng cộng'' end,@TK ,@TKDu,@Tongpsno,NULL,@TK,@TKDu,@LoaiTK)
*/
fetch nkct_cursor into @TK,@TKDu

END

CLOSE nkct_cursor
DEALLOCATE nkct_cursor

select ThuTu,SUBSTRING(TKCo, 1, 3) as TKDU, BLTKID, ngayct as [Ngày tháng CT], SoCT as [Số hiệu CT], DienGiai as [Diễn giải],[TKCo],
(select case when @@lang = 1 then dm.TenTK2  else dm.TenTK end from dmtk dm where dm.tk = SUBSTRING(TKCo, 1, 3)) as [Tên TK],
[Psno] as [Số tiền],TK from #NKCT
Where LoaiTK like N''%Nợ%'' and (TKCo like N''11%'' or tkco is null) 
order by ThuTu,ngayct,soct

drop table #NKCT'

where ReportName = N'Nhật ký chứng từ số 02'

--3.Thêm Report Filter---------------------------------------------
SELECT @sysReportID = sysReportID
FROM   sysReport
WHERE  ReportName = N'Nhật ký chứng từ số 02'


--Ngày chứng từ
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'NgayCT'
and sysTableID = (select sysTableID from sysTable where TableName = 'wNKSC')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @sysReportID)
  INSERT [dbo].[sysReportFilter]
         ([sysFieldID],
          [AllowNull],
          [DefaultValue],
          [sysReportID],
          [IsBetween],
          [TabIndex],
          [Visible],
          [IsMaster],
          [SpecialCond],
          [FilterCond])
  VALUES (@sysFieldID,
          0,
          NULL,
          @sysReportID,
          1,
          0,
          1,
          1,
          1,
          NULL)
-- Tài khoản có
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'TK'
and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @sysReportID)
  INSERT [dbo].[sysReportFilter]
         ([sysFieldID],
          [AllowNull],
          [DefaultValue],
          [sysReportID],
          [IsBetween],
          [TabIndex],
          [Visible],
          [IsMaster],
          [SpecialCond],
          [FilterCond])
  VALUES (@sysFieldID,
          1,
          NULL,
          @sysReportID,
          1,
          1,
          1,
          0,
          0,
          NULL)
-- Tài khoản nợ
SELECT @sysFieldID = sysFieldID
FROM   sysField
WHERE  FieldName = N'TKdu'
and sysTableID = (select sysTableID from sysTable where TableName = 'MT51')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysReportFilter]
               WHERE  [sysFieldID] = @sysFieldID
                      AND [sysReportID] = @sysReportID)
  INSERT [dbo].[sysReportFilter]
         ([sysFieldID],
          [AllowNull],
          [DefaultValue],
          [sysReportID],
          [IsBetween],
          [TabIndex],
          [Visible],
          [IsMaster],
          [SpecialCond],
          [FilterCond])
  VALUES (@sysFieldID,
          0,
          NULL,
          @sysReportID,
          0,
          1,
          1,
          0,
          0,
          N'TK like ''11%''')

--4--Thêm menu

------------PRO----------
SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'PRO'
IF Isnull(@sysSiteIDPRO, '') <> ''
BEGIN
	
	SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Tổng hợp' and sysSiteID = @sysSiteIDPRO
	SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Sổ kế toán' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

IF NOT EXISTS (SELECT TOP 1 1
						 FROM   [sysMenu]
						 WHERE  sysMenuParent = @sysMenuParentID
								AND MenuName = N'Nhật ký chứng từ số 02') 
	BEGIN 
		INSERT [dbo].[sysMenu]
		   ([MenuName],
			[MenuName2],
			[sysSiteID],
			[CustomType],
			[sysTableID],
			[sysReportID],
			[MenuOrder],
			[ExtraSql],
			[sysMenuParent],
			[MenuPluginID],
			[PluginName],
			[UIType],
			[Image])
	VALUES (N'Nhật ký chứng từ số 02',
			N'Diary vouchers No. 02',
			@sysSiteIDPRO,
			NULL,
			NULL,
			@sysReportID,
			3,
			NULL,
			@sysMenuParentID,
			NULL,
			NULL,
			5,
			NULL) 
	END
END

------------STD----------
SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'STD'
IF Isnull(@sysSiteIDPRO, '') <> ''
BEGIN
	
	SELECT @sysMenuModuleID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Tổng hợp' and sysSiteID = @sysSiteIDPRO
	SELECT @sysMenuParentID = sysMenuId	FROM   sysMenu WHERE  menuname = N'Sổ kế toán' and sysSiteID = @sysSiteIDPRO And sysMenuParent = @sysMenuModuleID

IF NOT EXISTS (SELECT TOP 1 1
						 FROM   [sysMenu]
						 WHERE  sysMenuParent = @sysMenuParentID
								AND MenuName = N'Nhật ký chứng từ số 02') 
	BEGIN 
		INSERT [dbo].[sysMenu]
		   ([MenuName],
			[MenuName2],
			[sysSiteID],
			[CustomType],
			[sysTableID],
			[sysReportID],
			[MenuOrder],
			[ExtraSql],
			[sysMenuParent],
			[MenuPluginID],
			[PluginName],
			[UIType],
			[Image])
	VALUES (N'Nhật ký chứng từ số 02',
			N'Diary vouchers No. 02',
			@sysSiteIDPRO,
			NULL,
			NULL,
			@sysReportID,
			3,
			NULL,
			@sysMenuParentID,
			NULL,
			NULL,
			5,
			NULL) 
	END
END

-- Ngôn ngữ row filer
declare @sysTableID int,
		@lang_vn nvarchar(255),
		@lang_en nvarchar(255)
select @sysTableID = sysTableID from sysTable where TableName = 'wReportRvCtrl'


set @lang_vn = N'Diễn giải'
set @lang_en = N'Description'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Số hiệu chứng từ'
set @lang_en = N'Code'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Số hiệu CT'
set @lang_en = N'Code'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Tên TK'
set @lang_en = N'Account Name'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Số tiền'
set @lang_en = N'Amount'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)


set @lang_vn = N'Ngày tháng CT'
set @lang_en = N'Date'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Ngày tháng ghi sổ'
set @lang_en = N'Date Modify'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Tài khoản đối ứng nợ'
set @lang_en = N'Debit account'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Tài khoản đối ứng có'
set @lang_en = N'Credit account'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Số tiền phát sinh'
set @lang_en = N'Amount arising'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

set @lang_vn = N'Loại TK'
set @lang_en = N'Account Type'
if not exists (select top 1 1 from sysField where FieldName = @lang_vn and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, @lang_vn, 1, NULL, NULL, NULL, NULL, 2, @lang_vn, @lang_en, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
