USE [CDT]
declare @sysTableID int

-- 1) Trả hàng kiêm phiếu xuất: DT24
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT24'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 2) VATIn
select @sysTableID = sysTableID from sysTable 
where TableName = 'VATIn'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

Update sysField set LabelName = N'Diễn giải', LabelName2 = N'Description'
where sysTableID = @sysTableID
and LabelName = N'Tên vật tư'
and FieldName = 'DienGiai' 

-- 3) VATOut
select @sysTableID = sysTableID from sysTable 
where TableName = 'VATOUT'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 4) TTDBout
select @sysTableID = sysTableID from sysTable 
where TableName = 'TTDBout'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 5) TTDBin
select @sysTableID = sysTableID from sysTable 
where TableName = 'TTDBin'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 6) Hóa đơn mua hàng kiêm phiếu nhập kho: DT22
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT22'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 7) Hóa đơn nhập khẩu kiêm phiếu nhập kho: DT23
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT23'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 8) Hóa đơn mua dịch vụ: DT21
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT21'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MaVT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaVT', 1, N'MaVT', N'DMVT', N'TenVT', N'LoaiVt = 6', 1, N'Dịch vụ', N'Services', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, N'fk_dt21_dmvt', NULL, NULL, 0, NULL)

Update sysField set FormulaDetail = N'MaVT.TKgv'
where sysTableID = @sysTableID
and FormulaDetail = N'MaNV.TK1'
and FieldName = 'TKNo' 

Update sysField set FormulaDetail = N'MaVT.GiaMua'
where sysTableID = @sysTableID
and FormulaDetail is null
and FieldName = 'Ps' 

-- 9) Hóa đơn bán hàng kiêm phiếu xuất kho: DT32
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT32'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 10) Hóa đơn giảm giá, hàng bán trả lại: DT33
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT33'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 11) Hóa đơn dịch vụ: DT31
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT31'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'MaVT')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaVT', 1, N'MaVT', N'DMVT', N'TenVT', N'LoaiVt = 6', 1, N'Dịch vụ', N'Services', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'fk_dt31_dmvt', NULL, NULL, 0, NULL)

Update sysField set FormulaDetail = N'MaVT.TKdt'
where sysTableID = @sysTableID
and FormulaDetail = N'MaNV.TKDU1'
and FieldName = 'TKCo' 

Update sysField set FormulaDetail = N'MaVT.GiaBan'
where sysTableID = @sysTableID
and FormulaDetail is null
and FieldName = 'Gia' 

-- 12) Lắp ráp tháo dở: DT46
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT46'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT2' 

Update sysField set RefCriteria = N'LoaiVt=4'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaSP' 

-- 13) Phiếu xuất kho: DT43
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT43'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 14) Phiếu xuất CCDC: DT45
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT45'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 15) Phiếu điều chuyển kho: DT44
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT44'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 16) Phiếu nhập kho thành phẩm: DT41
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT41'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 17) Phiếu nhập kho: DT42
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT42'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 

-- 18) Số dư BQ: OBVT
select @sysTableID = sysTableID from sysTable 
where TableName = 'OBVT'

Update sysField set RefCriteria = N'TonKho <> 2 and LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria = N'TonKho <> 2'
and FieldName = 'MaVT' 

-- 19) Số dư NTXT: OBNTXT
select @sysTableID = sysTableID from sysTable 
where TableName = 'OBNTXT'

Update sysField set RefCriteria = N'TonKho = 2 and LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria = N'TonKho = 2'
and FieldName = 'MaVT' 

-- 20) Danh mục vật tư: DMVT
select @sysTableID = sysTableID from sysTable 
where TableName = 'DMVT'

Update sysField set RefCriteria = N'(TK like ''6%'' or TK like ''8%'') and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'
where sysTableID = @sysTableID
and RefCriteria = N'TK like ''632%'' and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'
and FieldName = 'TKgv' 

Update sysField set RefCriteria = N'(TK like ''5%'' or TK like ''7%'') and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'
where sysTableID = @sysTableID
and RefCriteria = N'TK like ''51%'' and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'
and FieldName = 'TKdt' 

Update sysField set TabIndex = 2
where sysTableID = @sysTableID
and FieldName = 'LoaiVt' 

Update sysField set AllowNull = 1
where sysTableID = @sysTableID
and FieldName = 'TKkho' 
and AllowNull = 0

-- 21) Danh mục vật tư lắp ráp tháo dở: DMVTLR
select @sysTableID = sysTableID from sysTable 
where TableName = 'DMVTLR'

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVTLR' 

Update sysField set RefCriteria = N'LoaiVt <> 6'
where sysTableID = @sysTableID
and RefCriteria is null
and FieldName = 'MaVT' 