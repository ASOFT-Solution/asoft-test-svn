USE [CDT]
declare @sysTableID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysMenuParent int,
		@tabIndex int
		
select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = 'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = 'STD'

-- 1) Phiếu điều chuyển kho
select @sysTableID = sysTableID from sysTable where TableName = 'MT44'

if not exists (select top 1 1 from sysField where FieldName = 'InHD' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'InHD', 1, NULL, NULL, NULL, NULL, 10, N'In hóa đơn', N'Print invoice', 5, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, N'DF_MT44_INHD', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'MaLoaiHD' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaLoaiHD', 1, N'MaLoaiHD', N'DMLHD', NULL, NULL, 1, N'Loại hóa đơn', N'Invoice type', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_MT44_DMLHD', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NgayHD' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'NgayHD', 1, NULL, NULL, NULL, NULL, 9, N'Ngày hóa đơn', N'Invoice date', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, N'&', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'SoHoaDon' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoHoaDon', 1, NULL, NULL, NULL, NULL, 2, N'Số hóa đơn', N'Invoice number', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'Soseri' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Soseri', 1, NULL, NULL, NULL, NULL, 2, N'Ký hiệu hóa đơn', N'Seri number', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, N'&', 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ThukhoN' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ThukhoN', 1, N'MaKH', N'DMKH', NULL, N'isNV = 1', 1, N'Thủ kho xuất', N'Storekeeper who release', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_MT44_THUKHON', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ThukhoX' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ThukhoX', 1, N'MaKH', N'DMKH', NULL, N'isNV = 1', 1, N'Thủ kho nhập', N'Storekeeper who store', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_MT44_THUKHOX', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'SoDD' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'SoDD', 1, NULL, NULL, NULL, NULL, 2, N'Số điều động', N'Movement order No.', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'NgayDD' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'NgayDD', 1, NULL, NULL, NULL, NULL, 9, N'Ngày điều động', N'Movement order date', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'DoituongDD' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'DoituongDD', 1, NULL, NULL, NULL, NULL, 2, N'Đối tượng điều động', N'Movement order person', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'DienGiaiDD' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'DienGiaiDD', 1, NULL, NULL, NULL, NULL, 2, N'Diễn giải điều động', N'Movement order description', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PTVanchuyen' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PTVanchuyen', 1, NULL, NULL, NULL, NULL, 2, N'Phương tiện vận chuyển', N'Means of transport', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 2) Update TabIndex
set @tabIndex = 6
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'InHD'
and sysTableID = @sysTableID

set @tabIndex = 7
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'MaLoaiHD'
and sysTableID = @sysTableID

set @tabIndex = 8
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'NgayHD'
and sysTableID = @sysTableID

set @tabIndex = 9
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'SoHoaDon'
and sysTableID = @sysTableID

set @tabIndex = 10
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'Soseri'
and sysTableID = @sysTableID

set @tabIndex = 12
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'ThukhoX'
and sysTableID = @sysTableID

set @tabIndex = 13
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'MaNV'
and sysTableID = @sysTableID

set @tabIndex = 14
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'DienGiai'
and sysTableID = @sysTableID

set @tabIndex = 15
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'MaNT'
and sysTableID = @sysTableID

set @tabIndex = 16
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'TyGia'
and sysTableID = @sysTableID

set @tabIndex = 17
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'MaKho'
and sysTableID = @sysTableID

set @tabIndex = 18
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'MaKhoN'
and sysTableID = @sysTableID

set @tabIndex = 19
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'SoDD'
and sysTableID = @sysTableID

set @tabIndex = 20
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'NgayDD'
and sysTableID = @sysTableID

set @tabIndex = 21
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'DoituongDD'
and sysTableID = @sysTableID

set @tabIndex = 22
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'DienGiaiDD'
and sysTableID = @sysTableID

set @tabIndex = 23
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'PTVanchuyen'
and sysTableID = @sysTableID

set @tabIndex = 24
Update [sysField] set TabIndex = @tabIndex
where FieldName = N'ThukhoN'
and sysTableID = @sysTableID

-- 2) Phiếu bán hàng kiêm phiếu xuất kho
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'

if not exists (select top 1 1 from sysField where FieldName = 'KiemDC' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'KiemDC', 1, NULL, NULL, NULL, NULL, 10, N'Kiêm phiếu chuyển kho', N'Include warehouse movement', 40, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, N'DF_MT32_KiemDC', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'PCKID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PCKID', 1, NULL, NULL, NULL, NULL, 6, N'Mã phiếu điều chuyển', N'Mã phiếu điều chuyển', 41, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

-- 3) Report
select @sysTableID = sysTableID from sysTable where TableName = 'DT44'

Update sysTable set Report = N'INPDCKHO,PXK-VCNB-TUIN,PXK-VCNB-DATIN'
where sysTableID = @sysTableID

--Check exits
if not exists (select top 1 1 from [sysPrintedInvoiceDt] where [sysReportID] = N'PXK-VCNB-TUIN')
BEGIN
	declare @sysSiteID int,
		@DbName varchar(128)
			
	declare cur_invoicedt cursor for 
	SELECT distinct [sysSiteID],[DbName] FROM [sysPrintedInvoiceDt]

	open cur_invoicedt 
	fetch cur_invoicedt into @sysSiteID, @DbName

	--inserting
	while @@FETCH_STATUS = 0
	BEGIN
		INSERT [dbo].[sysPrintedInvoiceDt] 
		([sysSiteID],
		 [sysReportID], 
		 [ReportName], 
		 [ReportName2], 
		 [Pages], 
		 [Page1],
		 [Background1], 
		 [Page2], 
		 [Background2], 
		 [Disabled], 
		 [DbName]
		) 
		VALUES 
		(@sysSiteID, 
		N'PXK-VCNB-TUIN', 
		N'Phiếu xuất kho kiêm vận chuyển nội bộ', 
		N'Export-movement warehouse voucher', 
		2, 
		N'Liên 1: Lưu', 
		NULL, 
		N'Liên 2: Dùng để vận chuyển hàng', 
		NULL, 
		0, 
		@DbName)
		
	fetch cur_invoicedt into @sysSiteID, @DbName
	END
	close cur_invoicedt
	deallocate cur_invoicedt
END	