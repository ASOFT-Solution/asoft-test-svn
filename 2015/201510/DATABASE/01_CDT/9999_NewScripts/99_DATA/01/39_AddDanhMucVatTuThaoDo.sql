USE CDT

----01. Cập nhật loại vật tư-----------
UPDATE sysField
SET    MaxValue = 9,
	   Tip = N'1:Hàng hóa; 2: Nguyên liệu; 3: Công cụ dụng cụ; 4:thành phẩm; 5: TSCĐ; 6: Dịch vụ; 7: Xe ô tô; 8: Xe hai bánh gắn máy; 9: Lắp ráp tháo dỡ',
       TipE = N'1: Goods; 2:Material; 3: Tools; 4: Product; 5: Fixed Asset; 6: Services; 7: Cars; 8: Motobike; 9:Assembly;'
FROM   sysField
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DMVT')
       AND FieldName = N'LoaiVt'

-----02. Tạo DMVTLR-----------
DECLARE @sysPackageID INT

SELECT @sysPackageID = sysPackageID
FROM   [sysPackage]
WHERE  Package = N'HTA'

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysTable]
               WHERE  [TableName] = N'DMVTLR')
  INSERT [dbo].[sysTable]
       ([TableName],
        [DienGiai],
        [DienGiai2],
        [Pk],
        [ParentPk],
        [MasterTable],
        [Type],
        [SortOrder],
        [DetailField],
        [System],
        [MaCT],
        [sysPackageID],
        [Report],
        [CollectType])
VALUES (N'DMVTLR',
        N'Vật tư lắp ráp, tháo dỡ',
        N'Materials assembly, dismantling',
        N'Stt',
        NULL,
        N'DMVT',
        4,
        NULL,
        NULL,
        0,
        NULL,
        @sysPackageID,
        NULL,
        0) 

-----03. Tạo 2 bảng DT46 và MT46---------
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysTable]
               WHERE  [TableName] = N'MT46')
  INSERT [dbo].[sysTable]
       ([TableName],
        [DienGiai],
        [DienGiai2],
        [Pk],
        [ParentPk],
        [MasterTable],
        [Type],
        [SortOrder],
        [DetailField],
        [System],
        [MaCT],
        [sysPackageID],
        [Report],
        [CollectType])
VALUES (N'MT46',
        N'Phiếu lắp ráp, tháo dỡ',
        N'Aterials assembly, dismantling form',
        N'MT46ID',
        NULL,
        NULL,
        0,
        NULL,
        NULL,
        0,
        NULL,
        @sysPackageID,
        NULL,
        1) 


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysTable]
               WHERE  [TableName] = N'DT46')
  INSERT [dbo].[sysTable]
       ([TableName],
        [DienGiai],
        [DienGiai2],
        [Pk],
        [ParentPk],
        [MasterTable],
        [Type],
        [SortOrder],
        [DetailField],
        [System],
        [MaCT],
        [sysPackageID],
        [Report],
        [CollectType])
VALUES (N'DT46',
        N'Chi tiết phiếu lắp ráp, tháo dỡ',
        NULL,
        N'DT46ID',
        NULL,
        N'MT46',
        3,
        NULL,
        NULL,
        0,
        N'PLR,PTD',
        @sysPackageID,
        NULL,
        0) 

---03. Tạo field cho bảng  DMVTLR, MT46 và DT46--------------------------------------
DECLARE @DMVTLRTableID INT
DECLARE @MT46TableID INT
DECLARE @DT46TableID INT

SELECT @DMVTLRTableID = sysTableID
FROM   [sysTable]
WHERE  [TableName] = N'DMVTLR'

SELECT @MT46TableID = sysTableID
FROM   [sysTable]
WHERE  [TableName] = N'MT46'

SELECT @DT46TableID = sysTableID
FROM   [sysTable]
WHERE  [TableName] = N'DT46'

---------------BEGIN DMVTLR---------------------------------------------------------
--STT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Stt'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'Stt', 0, NULL, NULL, NULL, NULL, 3, N'Stt', N'No.1', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--MaKho--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaKho'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'MaKho', 0, N'MaKho', N'DMKho', NULL, NULL, 1, N'Mã Kho', N'Warehouse', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, N'FK_DMVTLR_DMKho2', NULL, NULL, 0, NULL)
  END

--MAVTLR--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaVTLR'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'MaVTLR', 0, N'MaVT', N'DMVT', N'TenVT', NULL, 1, N'Mã vật tư lắp ráp', N'Material', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, N'FK_DMVTLR_DMVT9', NULL, NULL, 0, N'')
  END

--MADVT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaDVT'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'MaDVT', 0, N'MaDVT', N'DMDVT', NULL, NULL, 1, N'Đơn vị tính', N'Unit', 3, NULL, N'MaVTLR.MaDVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DMVTLR_DMDVT4', NULL, NULL, 0, NULL)
  END

--SoLuong--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'SoLuong'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'SoLuong', 0, NULL, NULL, NULL, NULL, 8, N'Số lượng', N'Quantity', 4, NULL, NULL, NULL, 0, N'0', NULL, NULL, 1, 0, 0, 0, 1, N'DF_DMVTLR_SoLuong', NULL, N'##,###,###,###,##0', 0, NULL)
  END

--DonGia--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'Gia', 1, NULL, NULL, NULL, NULL, 8, N'Đơn giá', N'Price', 5, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, N'DF_DMVTLR_Gia', NULL, N'##,###,###,###,##0', 0, NULL)
  END

--ThanhTien--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Tien'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'Tien', 1, NULL, NULL, NULL, NULL, 8, N'Thành tiền', N'Amount', 6, N'@Gia*@Soluong', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, N'DF_DMVTLR_Tien', NULL, N'##,###,###,###,##0', 0, NULL)
  END
--MAVT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaVT'
                      AND [sysTableID] = @DMVTLRTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@DMVTLRTableID, N'MaVT', 0, N'MaVT', N'DMVT', NULL, NULL, 1, N'Mã vật tư', N'Material1', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, N'FK_DMVTLR_DMVT8', NULL, N'', 0, NULL)
  END

---------------END DMVTLR---------------------------------------------------------
---------------BEGIN MT46---------------------------------------------------------
--MT46ID--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MT46ID'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'MT46ID', 0, NULL, NULL, NULL, NULL, 6, N'Mã phiếu', N'ID', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END
--MaCT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaCT'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'MaCT', 0, NULL, NULL, NULL, NULL, 2, N'Mã chứng từ', N'Voucher Code', 1, NULL, NULL, NULL, NULL, N'PTR', NULL, NULL, 0, 0, 0, 0, 1, NULL, N'DF_MT46_MaCT', NULL, 0, NULL)
  END

--LoaiCT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'LoaiCT'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'LoaiCT', 1, NULL, NULL, NULL, NULL, 10, N'Loại chứng từ Lắp ráp, tháo dỡ', N'Voucher Type', 2, NULL, NULL, NULL, NULL, N'1', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_LoaiCT', NULL, 0, NULL)
  END

--NgayCT1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'NgayCT1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'NgayCT1', 0, NULL, NULL, NULL, NULL, 9, N'Ngày chứng từ nhập', N'Voucher Date', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, NULL, NULL, N'&', 0, NULL)
  END

--SoCT1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'SoCT1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'SoCT1', 0, NULL, NULL, NULL, NULL, 2, N'Số chứng từ nhập', N'Voucher Number', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 0, 1, NULL, NULL, NULL, 1, NULL)
  END

--DienGiai1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'DienGiai1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'DienGiai1', 0, NULL, NULL, NULL, NULL, 2, N'Diễn giải', N'Description', 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--MaKH1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaKH1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'MaKH1', 1, N'MaKH', N'DMKH', NULL, NULL, 1, N'Người giao', N'Supplier', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMKH7', NULL, NULL, 0, NULL)
  END

--MaKho1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaKho1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'MaKho1', 0, N'MaKho', N'DMKho', NULL, NULL, 1, N'Mã kho', N'Warehouse', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMKho10', NULL, NULL, 0, NULL)
  END
  
--MaVT1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaVT1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'MaVT1', 0, N'MaVT', N'DMVT', NULL, N'MAVT in (select distinct MAVT from DMVTLR)', 1, N'Mã thành phẩm', N'Product Code', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMVT8', NULL, NULL, 0, NULL)
  END
  
--TenVT1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'TenVT1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'TenVT1', 0, NULL, NULL, NULL, NULL, 2, N'Tên thành phẩm', N'Product Name', 9, NULL, N'MaVT1.TenVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--TKKho1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'TKKho1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'TKKho1', 0, N'TK', N'DMTK', NULL, N'TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)', 1, N'Tài khoản kho', N'Warehouse account', 10, NULL, N'MaVT1.TKkho', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMTK11', NULL, NULL, 0, NULL)
  END

--TK--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'TK'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'TK', 0, N'TK', N'DMTK', NULL, NULL, 1, N'Tài khoản trung gian', N'Intermediary account', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMTK12', NULL, NULL, 0, NULL)
  END

--MaDVT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaDVT1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'MaDVT1', 0, N'MaDVT', N'DMDVT', NULL, NULL, 1, N'Đơn vị tính', N'Unit', 12, NULL, N'MaVT1.MaDVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMDVT13', NULL, NULL, 0, NULL)
  END

--Tyle1QD--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Tyle1QD'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'Tyle1QD', 0, NULL, NULL, NULL, NULL, 8, N'Tỷ lệ qui đổi', N'Conversion Rate', 13, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Tyle1QD', N'### ### ### ##0.##', 0, NULL)
  END
  
--MaNT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaNT'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'MaNT', 0, N'MaNT', N'DMNT', NULL, NULL, 1, N'Mã Ngoại tệ', N'Original currency code', 14, NULL, NULL, NULL, NULL, N'VND', NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMNT14', N'DF_MT46_MaNT', N'&', 0, NULL)
  END

--TyGia--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'TyGia'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'TyGia', 0, NULL, NULL, NULL, NULL, 8, N'Tỷ giá', N'Rate of exchange', 15, NULL, N'MaNT.TyGia', NULL, NULL, N'1', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_TyGia', N'##,###,###,###,##0', 0, NULL)
  END

--Soluong1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Soluong1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'Soluong1', 0, NULL, NULL, NULL, NULL, 8, N'Số lượng', N'Quantity', 16, NULL, NULL, NULL, 1, N'1', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Soluong1', N'##,###,###,###,##0', 0, NULL)
  END

--Soluong1QD--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Soluong1QD'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'Soluong1QD', 0, NULL, NULL, NULL, NULL, 8, N'Số lượng (ĐVT chuẩn)', N'Conversion Quantity', 17, N'@Soluong1*@Tyle1QD', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Soluong1QD', N'### ### ### ##0.##', 0, NULL)
  END
  
--Gia1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria])
    VALUES (@MT46TableID, N'Gia1', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá', N'Unit Price', 18, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Gia1', N'##,###,###,###,##0', 0, NULL)
  END

--Gia1QD--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia1QD'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'Gia1QD', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá (ĐVT chuẩn)', N'Conversion Price', 19, N'@Gia1/@Tyle1QD', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Gia1QD', N'### ### ### ##0.##', 0, NULL)
  END
  
--GiaNT1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia1NT'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'Gia1NT', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá nguyên tệ', N'Original Unit Price', 20, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Gia1NT', N'##,###,###,###,##0', 0, NULL)
  END

--GiaDQNT1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia1QDNT'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'Gia1QDNT', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá nguyên tệ  (ĐVT chuẩn)', N'Original  Conversion Price', 21, N'@Gia1NT/@Tyle1QD', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL,  N'DF_MT46_Gia1QDNT', N'### ### ### ##0.##', 0, NULL)
  END
  
--Ps1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Ps1'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'Ps1', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền', N'Amount', 22, N'@Gia1*@Soluong1', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Ps1', N'##,###,###,###,##0', 0, NULL)
  END

--PsNT1--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Ps1NT'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'Ps1NT', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền nguyên tệ', N'Original Amount', 23, N' @Gia1NT*@Soluong1', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_MT46_Ps1NT', N'##,###,###,###,##0', 0, NULL)
  END

--NgayCT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'NgayCT2'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'NgayCT2', 0, NULL, NULL, NULL, NULL, 9, N'Ngày chứng từ xuất', N'Export Date', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'&', 0, NULL)
  END

--SoCT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'SoCT2'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'SoCT2', 0, NULL, NULL, NULL, NULL, 2, N'Số chứng từ xuất', N'Export Number', 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--MaKH2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaKH2'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'MaKH2', 1, N'MaKH', N'DMKH', NULL, NULL, 1, N'Người nhận', N'Receiver', 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT46_DMKH22', NULL, NULL, 0, NULL)
  END

--DienGiai2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'DienGiai2'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@MT46TableID, N'DienGiai2', 0, NULL, NULL, NULL, NULL, 2, N'Lý do xuất', N'Export Reason', 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--SoCTDT--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'SoCTDT'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher for excluding', 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--LotNumBer--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'LotNumBer'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'LotNumber', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot Number', 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--ExpireDate--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'ExpireDate'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'Expire Date', 31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--MTIDDoiTru--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MTIDDoiTru'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'Excluding Code', 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)
  END
--DVTQDID--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'DVTQDID'
                      AND [sysTableID] = @MT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@MT46TableID, N'DVTQDID', 1, NULL, NULL, NULL, NULL, 6, N'DVTQDID', N'DVTQDID', 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)
  END  

------------END MT46------------------------------------------------------------
------------BEGIN DT46---------------------------------------------------------
--DT46ID--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'DT46ID'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'DT46ID', 0, NULL, NULL, NULL, NULL, 6, N'Mã chi tiết', N'ID', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--MT46ID--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MT46ID'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'MT46ID', 1, N'MT46ID', N'MT46', NULL, NULL, 7, N'Mã phiếu', N'Master ID', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 1, N'FK_DT46_MT462', NULL, NULL, 0, NULL)
  END

--MaKho2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Makho2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'Makho2', 0, N'MaKho', N'DMKho', NULL, NULL, 1, N'Mã kho', N'Warehouse Code', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DT46_DMKho3', NULL, N'&', 0, NULL)
  END

--MaVT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaVT2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'MaVT2', 0, N'MaVT', N'wTonkhoTucthoi', NULL, NULL, 1, N'Vật tư', N'Material Code', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DT46_DMVT4', NULL, NULL, 0, NULL)
  END

--TenVT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'TenVT2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'TenVT2', 0, NULL, NULL, NULL, NULL, 2, N'Tên vật tư', N'Material Name', 5, NULL, N'MaVT2.TenVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--MaDVT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaDVT2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'MaDVT2', 0, N'MaDVT', N'DMDVT', NULL, NULL, 1, N'Đơn vị tính', N'Unit Price', 6, NULL, N'MaVT2.MaDVT', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DT46_DMDVT6', NULL, NULL, 0, NULL)
  END

--Tyle1QD--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Tyle2QD'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'Tyle2QD', 0, NULL, NULL, NULL, NULL, 8, N'Tỷ lệ qui đổi', N'Conversion Rate', 7, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Tyle2QD', N'### ### ### ##0.##', 0, NULL)
  END
  
--Soluong2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Soluong2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'Soluong2', 0, NULL, NULL, NULL, NULL, 8, N'Số lượng', N'Quantity', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, N'##,###,###,###,##0', 0, NULL)
  END

--SoluongQD2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Soluong2QD'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'Soluong2QD', 0, NULL, NULL, NULL, NULL, 8, N'Số lượng (ĐVT chuẩn)', N'Conversion Quantity', 9, N'@Soluong2*@Tyle2QD', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Soluong2QD', N'### ### ### ##0.##', 0, NULL)
  END
  
--Gia2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'Gia2', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá', N'Price', 10, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Gia2', N'##,###,###,###,##0', 0, NULL)
  END

--GiaQD2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia2QD'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'Gia2QD', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá (ĐVT chuẩn)', N'Conversion Price', 11, N'@Gia2/@Tyle2QD', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Gia2QD', N'### ### ### ##0.##', 0, NULL)
  END
  
--GiaNT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia2NT'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'Gia2NT', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá NT', N'Original Price', 12, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Gia2NT', N'##,###,###,###,##0', 0, NULL)
  END

--GiaQDNT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Gia2QDNT'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'Gia2QDNT', 0, NULL, NULL, NULL, NULL, 8, N'Đơn giá NT (ĐVT chuẩn)', N'Original Conversion Price', 13, N'@Gia2NT/@Tyle2QD', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Gia2QDNT', N'### ### ### ##0.##', 0, NULL)
  END
  
--Ps2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Ps2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'Ps2', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền', N'Amount', 14, N'@Gia2*@Soluong2', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Ps2', N'##,###,###,###,##0', 0, NULL)
  END

--PsNT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'Ps2NT'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'Ps2NT', 0, NULL, NULL, NULL, NULL, 8, N'Thành tiền NT', N'Original Amount', 15, N'@Gia2NT*@Soluong2', NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT46_Ps2NT', N'##,###,###,###,##0', 0, NULL)
  END

--TKkho2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'TKkho2'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'TKkho2', 0, N'TK', N'DMTK', NULL, N'TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)', 1, N'Tài khoản kho', N'Warehouse account', 16, NULL, N'MaVT2.TKkho', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_DT46_DMTK12', NULL, NULL, 0, NULL)
  END

--SoCTDT2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'SoCTDT'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'SoCTDT', 1, NULL, NULL, NULL, NULL, 2, N'Số chứng từ đối trừ', N'Voucher for excluding', 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--LotNumBer--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'LotNumBer'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'LotNumBer', 1, NULL, NULL, NULL, NULL, 2, N'Số lô', N'Lot number', 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--ExpireDate--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'ExpireDate'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'ExpireDate', 1, NULL, NULL, NULL, NULL, 9, N'Hạn dùng', N'ExpireDate', 31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
  END

--MaSP--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaSP'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'MaSP', 1, N'MaVT', N'DMVT', NULL, NULL, 1, N'Mã sản phẩm', N'Product Code', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_DT46_DMVT16', NULL, NULL, 0, NULL)
  
  END

--MaBP--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaBP'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria])
	VALUES (@DT46TableID, N'MaBP', 1, N'MaBP', N'DMBoPhan', NULL, NULL, 1, N'Mã bộ phận', N'Department Code', 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_DT46_DMBoPhan17', NULL, NULL, 0, NULL)
  END

--MaPhi--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaPhi'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
	INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'MaPhi', 1, N'MaPhi', N'DMPhi', NULL, NULL, 1, N'Mã phí', N'Cost Code', 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_DT46_DMPhi18', NULL, NULL, 0, NULL)
  END

--MaCongTrinh--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaCongTrinh'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'MaCongTrinh', 1, N'MaCongTrinh', N'dmCongtrinh', NULL, NULL, 1, N'Mã công trình', N'Project Code', 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_DT46_dmCongtrinh19', NULL, NULL, 0, NULL)
  END

--MaVV--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MaVV'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
	VALUES (@DT46TableID, N'MaVV', 1, N'MaVV', N'DMVuViec', NULL, NULL, 1, N'Vụ việc', N'Work Code', 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'FK_DT46_DMVuViec20', NULL, NULL, 0, NULL) 
  END

--MTIDDoiTru2--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'MTIDDoiTru'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'MTIDDoiTru', 1, NULL, NULL, NULL, NULL, 6, N'Mã đối trừ', N'DoiTru Code', 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)
  END

--DVTQDID--
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'DVTQDID'
                      AND [sysTableID] = @DT46TableID)
  BEGIN
    INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
    VALUES (@DT46TableID, N'DVTQDID', 1, NULL, NULL, NULL, NULL, 6, N'DVTQDID', N'DVTQDID', 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)
  END  

------------END DT46------------------------------------------------------------
-----03.1- Tạo Danh mục vật tư lắp ráp, tháo dỡ------
----------
DECLARE @sysSiteIDPRO AS INT
DECLARE @sysSiteIDSTD AS INT
DECLARE @sysMenuParentID INT

SELECT @sysSiteIDPRO = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'PRO'

SELECT @sysSiteIDSTD = sysSiteID
FROM   sysSite
WHERE  SiteCode = 'STD'

-----STD----
IF Isnull(@sysSiteIDSTD, '') <> ''
  BEGIN
	SELECT @sysMenuParentID = sysMenuID
	FROM   sysMenu
	WHERE  menuname = N'Danh mục'
	   AND sysMenuParent = (SELECT sysMenuId
							FROM   sysMenu
							WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDSTD)
      IF NOT EXISTS (SELECT TOP 1 1
                     FROM   [sysMenu]
                     WHERE  menuName = N'Danh mục vật tư lắp ráp, tháo dỡ'
							AND sysMenuParent = @sysMenuParentID
                            AND sysSiteID = @sysSiteIDSTD)
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
		VALUES (N'Danh mục vật tư lắp ráp, tháo dỡ',
				N'List of materials and assembly, dismantling',
				@sysSiteIDSTD,
				4,
				@DMVTLRTableID,
				NULL,
				5,
				N'LoaiVT = 9',
				@sysMenuParentID,
				NULL,
				NULL,
				1,
		0x89504E470D0A1A0A0000000D49484452000000300000004608060000008A79175B000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1000000B1001AD23BD7500001665494441546843DD5A097854D5D93E37A0E0D22A68AD5AD1B65AD75AED4FAB56B02AA2282001590C203B0544C1203B2188917D911DC2961020614902D9483249C8BE40F63D24937D269999CC642724269379FB5EE0E2108235587C7EEBF3BCCEE4DC73EFFDF6F3BDDF2001103FE53F493C288454DB9DFFEBE28320C9F700E6F69FF27E212B702B70FF8774AFFF079257D86829F1ECC7524AD85829396C3CF1093191984C4C9392CF4E25261113085E3FCB7DDC9F7C76B4944224077F28457A0D905EBF15192E1BFF566F3CF2AA3421F55F028DBB051A0E12C7085F228C8823D204EA32056A1289182284E0F51AEEAB7121760AD46E1628F952E0F4BB92CFADCA71CB0AF0A51186150297F6126E84171144441329441E514A9410B94412114504129EC4216217B15E20FC23A971C3D352EF5B51E29614D8F917E9A9383BA9BD66B540F526828254D3AAD5C7095AB99AD6AEA622D5E7AF42FE2EAFF910F4C0E5BDF440F5467A82CFC89A2670B4BF34E56753C0F32DC9493D5BA0E5DBAB5694AD295B55B6AE6C65D9DA3957ACDF5C7CF53B43E9522471866B27F9E97AE5DE661AC0B040C07F9074F66751403545EA71FC0D511C692B103D46206A3C3199603E447D4ACC2518D7518B8825C4626221318F98C37BB82792160FF99818490C17081B2670E22DD176A8BFF8535795E87208ED7C4E8C0F5F3614EA300FA8030E40EDEF0CB5EF4EA87DB6101B89358413D71C796D290ACE2C803AC81EEA339F41ED3703EA535351707202D41E63A1761B05F5FEE150EF1D86E4E5AFC2E5CD6EDB6FBB025B7E2FE6149DDEC6F7C825BC1668D511A5443E91C9B524C012C38B61C419E214718C3844ECE51EDEDBB001307C03942E07721700990B51E33A1807FB75DB77DB15D8DC474CCA727180A5B91A6DBA1CB456A4E13BCD397C571E8596B2103497FA13DEB854E681A6B243B858B617174BB7E362F12634E43BA1267D311A5316A33ED61E75619FA23670066ABCC622E3D37BB0EF55B1E9B62BB0E161312663F75CE0A216968A64228E08278261D1F9C26238098BF1082C350761A9DF0D4BD316A0653DCC1797A3367F254CE93BD0983703B83003EDC953D11E3311ED471E41F117027B5E93E896AE1DAC5DCE81350F880F53374F05EA0A80B268A03C14D03054B40C151D43C5E006543312EA7700976850CB1A98CD4B5095EB80166D16505B05D3F9ADA84E1CC3D0F9040860DEF2202C992FB0E36FD2B2DBAEC0AA5EE29DC4D56360D1A7C1AC56C15CE0C74F4F980B8FA2ADD8056DA57BD0A6D98AB6CA0D68AFF906CDB50BA04B73424B859A5E33C06C48457B4124F4C1AB50E2F92C9A297CD336818C5954E0EF92FD6D57C0E93ED12F6EF950984B62D192751A2D99C7D19C791897B2F6E352F64E34E56C4653DE5A5C2C5C095DCA4214A936C05C5949E1AB287C22CC9A20B45D3801B3F74A14CE7F0A21732568BF16489844055E9166DE76051CEF117DE3170F008A82816C0F561157C6B333A0667529D9C8705AC5307284D9B808F97173501CE380C2A8A5A8CFF4627E84518163B8183907898EBF42A6C3DD085F6883021E88053C3F36BD244DBCED0A2CE9215E88B17F0DC8F306D20F0059BBA8C4B740C13AA0F86B2AC03036B034D6CE61F2CA06FD04A68A21D046C8A5D30BED25CBA03DF40472F630FD6289D3C451816C9EECEB5E9046DF76051C7A88A74266BED45E1FEF86DA881DA889D884EA88D53045AC80317231AAA2E7C1103B1BFAF869D09F9BC0301A83ECC0C12855B1E66B1D982FAF42775442304FE6BCB5C47282A775F028494EE2A1B75D8179DDC563C1539F6D6D8ADA858BE1EBD118E184C6480734442F447DDC5CD49F9B89BAA4C9A84B1B87DAAC91A855DB22473500398786B06ABD098BA6072AD8F485B1D5A8DC2750C186AE820D5DC458091BFF22BD73DB15207BB20999F4870644AD07625602F14B80C42F81B4CF809CE9CC058671F9C740D570A07118E5790B45E9F72371DD832CB3BD80A63B5079EA0EA46C60E8B0B9031B3B1C16489C2AB0E249A9DF4F56C0F59FE2F983FDC5269737C4FECBE8FF3D5CFB89FD7BFA0AB740BB475A10B60238BB1888FA02889B0524B11B4E1FCFDC18C564B605F48C869ABE94A727D46CAB431D9F454D812D6A2A8723FB447F24D0EA384BB0BD063BD37856A1E57F94E41BBA7436DDB0F9D09B222C668640DA328194AF88350499530AFBF754D6ECF324303E637B43736401341E7350E63E03A51E935072CC0E45C73F42A1279B33EF7790E9FA04521822A947046278EFBEC9363834B33B0ECDE88E7DE3BA2188276F9A13AF33FE53990F3EB6C2E2F8A4D4E72729F0D513E271BFE1A2D5C01E5D47AAA823D3D29169E9C8B47424257AD2C4322268CA7D309FFC1CEDFE6C070227A03D6C2CCCD1A3608E1F0473C2F33027F6445B96401BF9409B5EA0BD96766A20B404991AC8D864EBB7F1D96DE4126D344AB89DB06C794C9AE5FA7BE94397A7A4612ECF10CF132F4AC35C5F966C0FFE551AECDE5F7AB6A382D77960EF6B625904FBFBBCA56449A48B59B47E166B741695C9228BCAA6BBD34F08047CDC1DD8C37C3B6D07F833CECFFC13087C1208B99B79C1476610141E26E2BBABAF68E22795819AA011408380E4064C68F0D9119F08C43948485F2321ED2B6219B190B0273EE3FA2C0921B652CBBE97A587AD95B8A6803CDA383650E415917C6859DE345B89FD843BC15AAD2125D492AC97A50A04325E1B494C5ABEBE132D1BEF44F376322B86D7252A2733AE465AB72181A0220D14B881DCB8A180EBE944BC40BD8AF026185E0DCE048D14C667D691C5B56B04CCF49E99F79B4309BEDBCC7DED0704F23F27F57C5DFAB45305B6FF9FE877E26DB2263BBA93D608675508677F12CE13329C4A853327C2570A9C65F29D241BCB9BC8068C715CE640C5D6B12432CEF50C0723053304F033829C9734B2969309132D6EA0403A2A5641CE5CC2AAA3269DCC6725CA639E65F21DBE63F98C70EE252535D10826869789829B185E261AD344F25FC686CFE73D29B6530576BE7167C0A9B90370C67114021C462060D9306228BF7F400C42C0F27711E0F80E829DDEC1BAB1CF60FE9B3DB172F8DD583DEE2E6C987117B6DAF7C42E879ED8BFA627DCB6F580C7811EF03EDE1327DD6D7092DE71A782AE14781F05DEC53360EB67021BA608AC262D5DFA8E80C3047AA2901ECC26CE1154F6921FC1106B6688C95E6EE19991602799B7BE203DA528712D845C47FEA1D4509483BA2A0D6A2B0B505B91855A6D323FE3F977046AF52A76C27E68A83B8582A23D088E704048F812A854F3A1F29F0B95D72C04BB4F43D0C18908DA6987E02D63706AD17BD8F2B280F710CE7E4611F4ACCF7482DCD8975EF57514F05BC5BF69DD2886AB2E985EA087E483AE82DEAC6078695850CAD8EC95312F3524FFC9E318016F8AA537287060D8EF324A9323509997888ACC48683342A14D0F8026ED14711CE569878903284BDF0D6DCE76180AB6427F613DF4D9DF409FBE0CFAC485A88CB64745C86C54F84F83C16F3A1216FC1901B6F723F6D3C7893E88FDFC31C4CEFD1D62ED89F98F2276E123885DF230621D7E8BE8650F21743E31EF3708FDE241847EFE004267F746F0B4DE089CD00B81E3EF47E0D8FB1030FAD7F018D8BD98E7D1AF6525AE7960DFFBBDCF17C7FA52A06854A605A332D50F15A95EA848F3200E51997DD066EE84367B3334B96BA1C9FB1ADABCE528CBB04756C897C80D9D054DD41494074D40B9CF3894BA0D82AFDD43A857A7A1B54E8F5663315A0D17D0AACF20128958FE7D96EB4168ADF6E19E13686D3A82D68B07D05ABB9BD7B6A055B30E6D454E6823196A4B5D8836B62AE6D82F103FFF25383D225EB94E813D03EF8D2A0E3B8AAA8C10E8534F132758F78FC090711086AC3D30E46EA3D537C250BC1A86F2AF60342E4545F96CE4C62CA152E75014E7865CD568186346C2A81A01C3AEFB1034FED768D695900B90F8D790D054E7C0624A2512884858AA55243D7E68AF6397DAE88EF6261752CF3D30D76C437B150991E61BB4152C471B497F5BE25CB445CF46AB6A12A2A7F4C28A3EE2C5EB14D8F5564F95DA7F378CA9FED09F3FC69070833E791F15D9C510F916FAAC75D0E73941AF5E0EA376114A0B662033D491C2A7425798065D4638F27D3722F9842D2ADD1F41354FEFC0B1F7A2FE02498C518D3692FF5692FF5692FFEF48FEBF2BF3E710C01B2DE51E68D6B8E292662FB11D4DE59B3892FC068694453025CD4353B23D1BC5D96808998E868069A8DDFA04549C23AD7CF64A225F0BA1EDFD6C7CB28EAD67ADF74469840B4AC39D5112BE1DC56C978B23D7A028920C2A7A194A12E6238BD3842CD5167A440D9D3A9939C35C493CCC327900051BC7E0CC9C6E38C7F6C07FE49D68480F6163472E4CF20F927F5406B1A9F3E5DA497AE408B9F5413678BB79E091FC830D2256A0BE6C019A4A42509FE782C65C3687172603A9ECB5FC5E02587E2339D69CFBB0CDE3D729B0F555E1917BD811C6F8C3D0B355D6C76C813E8E497A8E499AE4C87062AF9F330F79E76623D465265239C8CA0DDB8FCACC33A8483F8CCAC49DC8E6802A62D6A33833F11E1C2541F1196D83FA782F0A9CC8569AE4BF8CE45F43F25F41F2AF27F93792FCD791FC5F24F937AF81C5B20C55F90BD058C852DF54074B651EAAD8F556C5B1BB8D66C8F3FC0089D0D931D2A5990F5C3991AF79E0DBBEE260F6FE79A88ED90F43F86618A2D6C210F3350F200754252D4455FA5C4E16663164A6A23CFF1394950E418CE74868125C5191B10DFA8829502DED8E3496BE123671655B04CE8C665954B9A0B58833A35C3F34E7781247393775E1C47A0F9A2E6C4553FE065C2AFE060D654B18865F719E9443E1AB61AE4AE380200CED1901D0797C8ACC4D36A86487A0E581EA3354AA5FD0477AE03A0536FD55EC4CDA321D15AAED280D5845AC4049E01294047F8992D0CF511C3E03C55193511C3F0EC549A350923E04514746A02C7603ABD554D6F03F2090753A91A7723EEB7A016B371B43E8FCB6A25D1D0C73F67198730EC39CBB9FA47E27DAD49B39C558CB09C64AD4972C41C6E9796C187DD1A2C9660273E25119C2EB27D1C43CAB58FE3A12A6F54200C3B29A4A9CB1958C76F748BFBA4E818D2F898DD1ABC6A1D06703F24E3820F7F842E49CF882BD3BE3FDE434647A4D4086F7C7483F3D0269BE8391E6FF1E7C37BE8B9290B12CB32FC21061031FBEC08FFD8A3CDC8DE6A7E7602AE0499E9C7F9ADCD9958487E4FF02C9BF9AE4BF84E45FEBC8305A84C6727BE8F266C350341179AAC9F8AE30800A704096BF16D99B1F413A7BA5529EE479344C038B43D008A9F22961D3E33A05D6BE20BE4E5E658BBA602718FDE7C3183407C6D019E4B9939917E3614A1E0D53D630980ADE8749F31EEA1A5E81F7BADE2838D68787DF955EC78FA76B31C9493D497A134F56B9B32D7521C1CFE1F482D58C925011927F9E215093FC97F25A25C97F0D27752D4C548C4151AC1D47338760D6AE8225A93F527852D7B12F027F5B00DB7B3395393D542A15A25BB7EB1458F59C589CB8E23D3470A26CF2990D53C074985413610AB78329F62396B421A8CE1A849AC27751A3FD331A1AEF80E76A1B86DA1BA8AE1AC830781F67BEFA2D8AD835D6B1096B621EC4B0BF49DD3C933F76F02C516D6298AD4665F00A54042F8636781E34C1B351A69A86D29009280EA1F061C3107770049AD217C25C3E886DF7BD4860EF14426F26313C93D882C4B3C9741F285DB8A19558F39C98A3B2EF8F0B6EF6C8DC371599FBC723E3E068A4BBDA22CD6D3052DD0721D9FD0DC4ED671B203333F62BDBC8B2368E7E183B66FD0EDBA73F863543EF42387B967822819DA3F78702455B483393767284E204CB390E8559102C2C08969C99B0A8A7C052368E53BE91B0D40E83C5FC3E625D9E418DAA2FDA0DF732DCF81CE6928106C12982DE951B3AAF0FA4F41B14707A5A4C0F9DF377941F9E85C2036351786824D44786417D7C080A3C07A0C0EB395CF0BC0BD96C97B3F94B4C367BF50B24E539F27712F36CBAF70215CBE198309B8996CF1707B1D32C583B1C38C7995034FBAF7892FF2492FF0C92FF3CD6F72296C70A5EA7F068E6B00C0F219C55AC39F2197EE7CCB4E939A47E7B3F8CE424F027A8482B73E0C420E9FC0D0A383E2DC645CDFC13EAC96FABDCC7A0EAC487A8F27A1355DECFC0E8732F8CEC148D1C4499E4FE9E3F1B990C442541A26222C931918999483D4DFCA9C924E7010539C7CE3365D9BBB818B2128D015FA03170164FD4A968383B1EF5A4A0F509CCB9E4A13025F68531E56E18F9DCE38B6D706AE15F70D6E51584ED7D0D07A73C84021AC5C89C3232FE352CA31E03A5A81B1458FEB21811FE11E377796F18D63D0AC3B7BDA0DFD10D7AC6B49E4C4B4F92A12349D191A4E8D8B3EB8A08F6EF3A2AA493C90A7F5ED531D174B4964E26213B1866FCD929C6BE1FAA4E2D622DFF172A8F4F42C5093B68BD46B2E11B8E72DFB750E2D507794CFA5C7A3197EC2B9DA1290F0162D846C73081CF91D6E6326C723900C8E5102C8507E4E1B725D50D0AAC7A450CF665CCE6304932491733993499E4C599ACEB59F2F498164DA532A97C591AAD9CCA97A5329C52F9C254864F324FC804129604BE2881563ACF8AE44383642EF82B093C43279823F970E643CC4740C2DBC07972E8D43B5862191AF4262E5D3B53AF7C97D76820D0BBA0E1409E208F602E529E2303BEFF5DF9DA5D539F167D96BD262E6E1FCA1F1A48EF0E70B4E2C6443CC62AE04D6BF8D1AAC11EA4958CC568B2A54872E45026D6191EEFA749FA4F527877129443F6645DFC116F17A9E97A52D48C893D817DEC61DC5FE510EB05C0FB378C671B2AC357CBD30999E4CB645F26FDF248C842D413CA04831EBF3C3F92CB28DF5F478FB80D10F26F56976FF85EED2BFF60613031959828A4ABB01113A56E62A24DF72BE8768798D85D86FC5D5E97AFCB7BE57BAE87DDDB8F8A75094CE46A72E76ACE7F4C4C6C238D61A4B7AAE835393435F4A286E1594E2135CC23195A2AA76571D0B2FE97904E96B2812B63F29653F84C3EEBE840E172A3025D9C88290FF8A14FBF81E2B747781A47332CE3E9992486643A15C8E11951C0D02B9105278997E74D267AA28A6553CB9029E19A9AD772183219F47C12EF89E7BD313CE93D650EDD577024D8D103B74101F9254FF6128B5F795C1CF8C79F84F33FFF2C9C07F415CEEFBD2E9C3F785B380F7B5F387F642B9CC78C11CE63C70B673B3BE13C6AB8701EFE81701E3A4038BFDF4F380FFC9B707EEB45E1DCEF69E1FC8F2784F3F30F8A03F434E7FB3F93023FC6533F658F55EA5FD1E897865F9CC01D0DFCBFA1C0FC2FE7892E622FF78338D9C5FBBAFA9EFFB8FFB207BA28842C742831F0AA12F267579FF1DFD8BF98EF6543D335057AF12619FF0D017EEA339229074F892B0AC856954342D64A7970DFAB6BF2FA68ABF57556EB7FB45A97EF95F77606D9631D052EFA81FDB257675CBD2E0BAADC2BCBA13C5F7E662F450125A665E194CDCA9AF50364EBD7583DE466E1A3ECB156F06616571497DF67BDA7B37565ED9A4114053A6EB616D4DAFACA3E4540D94A1D05533C27EFF93161D299F76F16158A51AF458AA280E22E4533254CACAD2F3F5476BB2C98A28875C829C2767CD67F524209A58EDEEC6C5D96470EA16B86531450624B1158B9D95A404568D9628A90D621A708AA28DF31243A5344F6B412D3D6E176B375C5F3B2972F3F4F51C0DAED8AA0B212D62F559492F72A0A77760EC85EBCCE4A3F104A4A29EEF82E65DD3A0C3B0D4D45014563F986CEAC6F9DFDD655A66388296126EFF931E7C3CDC2ADB3F5CEAAD2350FC82FB6AE2E1D2DA2C49E92D0B2BB65213B26AAB22E5FFB31E74567D54F96C53A5C3B86E67579677D9059D765EB4D8AF53B2AA5286C2DE8CD42E266897CB37053C245F1B06C18253AAE338CB502CAC33A0AAAAC77AC389DD5FACE2CF74355E886A4B4CA173964AC8D2ACB712D793B26F17F2A75FF6FAF77B517EACA09FBB328DD15056E96B83F8BA0372BC5FF1B84E697C683ADE5FDC57BE0DFB9CC859EB825C6740000000049454E44AE426082) 
	END
END

-----PRO----
IF Isnull(@sysSiteIDPRO, '') <> ''
  BEGIN
		SELECT @sysMenuParentID = sysMenuID
		FROM   sysMenu
		WHERE  menuname = N'Danh mục'
			   AND sysMenuParent = (SELECT sysMenuId
									FROM   sysMenu
									WHERE  menuname = N'Quản lý kho' and sysSiteID = @sysSiteIDPRO)
      IF NOT EXISTS (SELECT TOP 1 1
                     FROM   [sysMenu]
                     WHERE  menuName = N'Danh mục vật tư lắp ráp, tháo dỡ'
							AND sysMenuParent = @sysMenuParentID
                            AND sysSiteID = @sysSiteIDPRO)
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
		VALUES (N'Danh mục vật tư lắp ráp, tháo dỡ',
				N'List of materials and assembly, dismantling',
				@sysSiteIDPRO,
				4,
				@DMVTLRTableID,
				NULL,
				5,
				N'LoaiVT = 9',
				@sysMenuParentID,
				NULL,
				NULL,
				1,
		0x89504E470D0A1A0A0000000D49484452000000300000004608060000008A79175B000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1000000B1001AD23BD7500001665494441546843DD5A097854D5D93E37A0E0D22A68AD5AD1B65AD75AED4FAB56B02AA2282001590C203B0544C1203B2188917D911DC2961020614902D9483249C8BE40F63D24937D269999CC642724269379FB5EE0E2108235587C7EEBF3BCCEE4DC73EFFDF6F3BDDF2001103FE53F493C288454DB9DFFEBE28320C9F700E6F69FF27E212B702B70FF8774AFFF079257D86829F1ECC7524AD85829396C3CF1093191984C4C9392CF4E25261113085E3FCB7DDC9F7C76B4944224077F28457A0D905EBF15192E1BFF566F3CF2AA3421F55F028DBB051A0E12C7085F228C8823D204EA32056A1289182284E0F51AEEAB7121760AD46E1628F952E0F4BB92CFADCA71CB0AF0A51186150297F6126E84171144441329441E514A9410B94412114504129EC4216217B15E20FC23A971C3D352EF5B51E29614D8F917E9A9383BA9BD66B540F526828254D3AAD5C7095AB99AD6AEA622D5E7AF42FE2EAFF910F4C0E5BDF440F5467A82CFC89A2670B4BF34E56753C0F32DC9493D5BA0E5DBAB5694AD295B55B6AE6C65D9DA3957ACDF5C7CF53B43E9522471866B27F9E97AE5DE661AC0B040C07F9074F66751403545EA71FC0D511C692B103D46206A3C3199603E447D4ACC2518D7518B8825C4626221318F98C37BB82792160FF99818490C17081B2670E22DD176A8BFF8535795E87208ED7C4E8C0F5F3614EA300FA8030E40EDEF0CB5EF4EA87DB6101B89358413D71C796D290ACE2C803AC81EEA339F41ED3703EA535351707202D41E63A1761B05F5FEE150EF1D86E4E5AFC2E5CD6EDB6FBB025B7E2FE6149DDEC6F7C825BC1668D511A5443E91C9B524C012C38B61C419E214718C3844ECE51EDEDBB001307C03942E07721700990B51E33A1807FB75DB77DB15D8DC474CCA727180A5B91A6DBA1CB456A4E13BCD397C571E8596B2103497FA13DEB854E681A6B243B858B617174BB7E362F12634E43BA1267D311A5316A33ED61E75619FA23670066ABCC622E3D37BB0EF55B1E9B62BB0E161312663F75CE0A216968A64228E08278261D1F9C26238098BF1082C350761A9DF0D4BD316A0653DCC1797A3367F254CE93BD0983703B83003EDC953D11E3311ED471E41F117027B5E93E896AE1DAC5DCE81350F880F53374F05EA0A80B268A03C14D03054B40C151D43C5E006543312EA7700976850CB1A98CD4B5095EB80166D16505B05D3F9ADA84E1CC3D0F9040860DEF2202C992FB0E36FD2B2DBAEC0AA5EE29DC4D56360D1A7C1AC56C15CE0C74F4F980B8FA2ADD8056DA57BD0A6D98AB6CA0D68AFF906CDB50BA04B73424B859A5E33C06C48457B4124F4C1AB50E2F92C9A297CD336818C5954E0EF92FD6D57C0E93ED12F6EF950984B62D192751A2D99C7D19C791897B2F6E352F64E34E56C4653DE5A5C2C5C095DCA4214A936C05C5949E1AB287C22CC9A20B45D3801B3F74A14CE7F0A21732568BF16489844055E9166DE76051CEF117DE3170F008A82816C0F561157C6B333A0667529D9C8705AC5307284D9B808F97173501CE380C2A8A5A8CFF4627E84518163B8183907898EBF42A6C3DD085F6883021E88053C3F36BD244DBCED0A2CE9215E88B17F0DC8F306D20F0059BBA8C4B740C13AA0F86B2AC03036B034D6CE61F2CA06FD04A68A21D046C8A5D30BED25CBA03DF40472F630FD6289D3C451816C9EECEB5E9046DF76051C7A88A74266BED45E1FEF86DA881DA889D884EA88D53045AC80317231AAA2E7C1103B1BFAF869D09F9BC0301A83ECC0C12855B1E66B1D982FAF42775442304FE6BCB5C47282A775F028494EE2A1B75D8179DDC563C1539F6D6D8ADA858BE1EBD118E184C6480734442F447DDC5CD49F9B89BAA4C9A84B1B87DAAC91A855DB22473500398786B06ABD098BA6072AD8F485B1D5A8DC2750C186AE820D5DC458091BFF22BD73DB15207BB20999F4870644AD07625602F14B80C42F81B4CF809CE9CC058671F9C740D570A07118E5790B45E9F72371DD832CB3BD80A63B5079EA0EA46C60E8B0B9031B3B1C16489C2AB0E249A9DF4F56C0F59FE2F983FDC5269737C4FECBE8FF3D5CFB89FD7BFA0AB740BB475A10B60238BB1888FA02889B0524B11B4E1FCFDC18C564B605F48C869ABE94A727D46CAB431D9F454D812D6A2A8723FB447F24D0EA384BB0BD063BD37856A1E57F94E41BBA7436DDB0F9D09B222C668640DA328194AF88350499530AFBF754D6ECF324303E637B43736401341E7350E63E03A51E935072CC0E45C73F42A1279B33EF7790E9FA04521822A947046278EFBEC9363834B33B0ECDE88E7DE3BA2188276F9A13AF33FE53990F3EB6C2E2F8A4D4E72729F0D513E271BFE1A2D5C01E5D47AAA823D3D29169E9C8B47424257AD2C4322268CA7D309FFC1CEDFE6C070227A03D6C2CCCD1A3608E1F0473C2F33027F6445B96401BF9409B5EA0BD96766A20B404991AC8D864EBB7F1D96DE4126D344AB89DB06C794C9AE5FA7BE94397A7A4612ECF10CF132F4AC35C5F966C0FFE551AECDE5F7AB6A382D77960EF6B625904FBFBBCA56449A48B59B47E166B741695C9228BCAA6BBD34F08047CDC1DD8C37C3B6D07F833CECFFC13087C1208B99B79C1476610141E26E2BBABAF68E22795819AA011408380E4064C68F0D9119F08C43948485F2321ED2B6219B190B0273EE3FA2C0921B652CBBE97A587AD95B8A6803CDA383650E415917C6859DE345B89FD843BC15AAD2125D492AC97A50A04325E1B494C5ABEBE132D1BEF44F376322B86D7252A2733AE465AB72181A0220D14B881DCB8A180EBE944BC40BD8AF026185E0DCE048D14C667D691C5B56B04CCF49E99F79B4309BEDBCC7DED0704F23F27F57C5DFAB45305B6FF9FE877E26DB2263BBA93D608675508677F12CE13329C4A853327C2570A9C65F29D241BCB9BC8068C715CE640C5D6B12432CEF50C0723053304F033829C9734B2969309132D6EA0403A2A5641CE5CC2AAA3269DCC6725CA639E65F21DBE63F98C70EE252535D10826869789829B185E261AD344F25FC686CFE73D29B6530576BE7167C0A9B90370C67114021C462060D9306228BF7F400C42C0F27711E0F80E829DDEC1BAB1CF60FE9B3DB172F8DD583DEE2E6C987117B6DAF7C42E879ED8BFA627DCB6F580C7811EF03EDE1327DD6D7092DE71A782AE14781F05DEC53360EB67021BA608AC262D5DFA8E80C3047AA2901ECC26CE1154F6921FC1106B6688C95E6EE19991602799B7BE203DA528712D845C47FEA1D4509483BA2A0D6A2B0B505B91855A6D323FE3F977046AF52A76C27E68A83B8582A23D088E704048F812A854F3A1F29F0B95D72C04BB4F43D0C18908DA6987E02D63706AD17BD8F2B280F710CE7E4611F4ACCF7482DCD8975EF57514F05BC5BF69DD2886AB2E985EA087E483AE82DEAC6078695850CAD8EC95312F3524FFC9E318016F8AA537287060D8EF324A9323509997888ACC48683342A14D0F8026ED14711CE569878903284BDF0D6DCE76180AB6427F613DF4D9DF409FBE0CFAC485A88CB64745C86C54F84F83C16F3A1216FC1901B6F723F6D3C7893E88FDFC31C4CEFD1D62ED89F98F2276E123885DF230621D7E8BE8650F21743E31EF3708FDE241847EFE004267F746F0B4DE089CD00B81E3EF47E0D8FB1030FAD7F018D8BD98E7D1AF6525AE7960DFFBBDCF17C7FA52A06854A605A332D50F15A95EA848F3200E51997DD066EE84367B3334B96BA1C9FB1ADABCE528CBB04756C897C80D9D054DD41494074D40B9CF3894BA0D82AFDD43A857A7A1B54E8F5663315A0D17D0AACF20128958FE7D96EB4168ADF6E19E13686D3A82D68B07D05ABB9BD7B6A055B30E6D454E6823196A4B5D8836B62AE6D82F103FFF25383D225EB94E813D03EF8D2A0E3B8AAA8C10E8534F132758F78FC090711086AC3D30E46EA3D537C250BC1A86F2AF60342E4545F96CE4C62CA152E75014E7865CD568186346C2A81A01C3AEFB1034FED768D695900B90F8D790D054E7C0624A2512884858AA55243D7E68AF6397DAE88EF6261752CF3D30D76C437B150991E61BB4152C471B497F5BE25CB445CF46AB6A12A2A7F4C28A3EE2C5EB14D8F5564F95DA7F378CA9FED09F3FC69070833E791F15D9C510F916FAAC75D0E73941AF5E0EA376114A0B662033D491C2A7425798065D4638F27D3722F9842D2ADD1F41354FEFC0B1F7A2FE02498C518D3692FF5692FF5692FFEF48FEBF2BF3E710C01B2DE51E68D6B8E292662FB11D4DE59B3892FC068694453025CD4353B23D1BC5D96808998E868069A8DDFA04549C23AD7CF64A225F0BA1EDFD6C7CB28EAD67ADF74469840B4AC39D5112BE1DC56C978B23D7A028920C2A7A194A12E6238BD3842CD5167A440D9D3A9939C35C493CCC327900051BC7E0CC9C6E38C7F6C07FE49D68480F6163472E4CF20F927F5406B1A9F3E5DA497AE408B9F5413678BB79E091FC830D2256A0BE6C019A4A42509FE782C65C3687172603A9ECB5FC5E02587E2339D69CFBB0CDE3D729B0F555E1917BD811C6F8C3D0B355D6C76C813E8E497A8E499AE4C87062AF9F330F79E76623D465265239C8CA0DDB8FCACC33A8483F8CCAC49DC8E6802A62D6A33833F11E1C2541F1196D83FA782F0A9CC8569AE4BF8CE45F43F25F41F2AF27F93792FCD791FC5F24F937AF81C5B20C55F90BD058C852DF54074B651EAAD8F556C5B1BB8D66C8F3FC0089D0D931D2A5990F5C3991AF79E0DBBEE260F6FE79A88ED90F43F86618A2D6C210F3350F200754252D4455FA5C4E16663164A6A23CFF1394950E418CE74868125C5191B10DFA8829502DED8E3496BE123671655B04CE8C665954B9A0B58833A35C3F34E7781247393775E1C47A0F9A2E6C4553FE065C2AFE060D654B18865F719E9443E1AB61AE4AE380200CED1901D0797C8ACC4D36A86487A0E581EA3354AA5FD0477AE03A0536FD55EC4CDA321D15AAED280D5845AC4049E01294047F8992D0CF511C3E03C55193511C3F0EC549A350923E04514746A02C7603ABD554D6F03F2090753A91A7723EEB7A016B371B43E8FCB6A25D1D0C73F67198730EC39CBB9FA47E27DAD49B39C558CB09C64AD4972C41C6E9796C187DD1A2C9660273E25119C2EB27D1C43CAB58FE3A12A6F54200C3B29A4A9CB1958C76F748BFBA4E818D2F898DD1ABC6A1D06703F24E3820F7F842E49CF882BD3BE3FDE434647A4D4086F7C7483F3D0269BE8391E6FF1E7C37BE8B9290B12CB32FC21061031FBEC08FFD8A3CDC8DE6A7E7602AE0499E9C7F9ADCD9958487E4FF02C9BF9AE4BF84E45FEBC8305A84C6727BE8F266C350341179AAC9F8AE30800A704096BF16D99B1F413A7BA5529EE479344C038B43D008A9F22961D3E33A05D6BE20BE4E5E658BBA602718FDE7C3183407C6D019E4B9939917E3614A1E0D53D630980ADE8749F31EEA1A5E81F7BADE2838D68787DF955EC78FA76B31C9493D497A134F56B9B32D7521C1CFE1F482D58C925011927F9E215093FC97F25A25C97F0D27752D4C548C4151AC1D47338760D6AE8225A93F527852D7B12F027F5B00DB7B3395393D542A15A25BB7EB1458F59C589CB8E23D3470A26CF2990D53C074985413610AB78329F62396B421A8CE1A849AC27751A3FD331A1AEF80E76A1B86DA1BA8AE1AC830781F67BEFA2D8AD835D6B1096B621EC4B0BF49DD3C933F76F02C516D6298AD4665F00A54042F8636781E34C1B351A69A86D29009280EA1F061C3107770049AD217C25C3E886DF7BD4860EF14426F26313C93D882C4B3C9741F285DB8A19558F39C98A3B2EF8F0B6EF6C8DC371599FBC723E3E068A4BBDA22CD6D3052DD0721D9FD0DC4ED671B203333F62BDBC8B2368E7E183B66FD0EDBA73F863543EF42387B967822819DA3F78702455B483393767284E204CB390E8559102C2C08969C99B0A8A7C052368E53BE91B0D40E83C5FC3E625D9E418DAA2FDA0DF732DCF81CE6928106C12982DE951B3AAF0FA4F41B14707A5A4C0F9DF377941F9E85C2036351786824D44786417D7C080A3C07A0C0EB395CF0BC0BD96C97B3F94B4C367BF50B24E539F27712F36CBAF70215CBE198309B8996CF1707B1D32C583B1C38C7995034FBAF7892FF2492FF0C92FF3CD6F72296C70A5EA7F068E6B00C0F219C55AC39F2197EE7CCB4E939A47E7B3F8CE424F027A8482B73E0C420E9FC0D0A383E2DC645CDFC13EAC96FABDCC7A0EAC487A8F27A1355DECFC0E8732F8CEC148D1C4499E4FE9E3F1B990C442541A26222C931918999483D4DFCA9C924E7010539C7CE3365D9BBB818B2128D015FA03170164FD4A968383B1EF5A4A0F509CCB9E4A13025F68531E56E18F9DCE38B6D706AE15F70D6E51584ED7D0D07A73C84021AC5C89C3232FE352CA31E03A5A81B1458FEB21811FE11E377796F18D63D0AC3B7BDA0DFD10D7AC6B49E4C4B4F92A12349D191A4E8D8B3EB8A08F6EF3A2AA493C90A7F5ED531D174B4964E26213B1866FCD929C6BE1FAA4E2D622DFF172A8F4F42C5093B68BD46B2E11B8E72DFB750E2D507794CFA5C7A3197EC2B9DA1290F0162D846C73081CF91D6E6326C723900C8E5102C8507E4E1B725D50D0AAC7A450CF665CCE6304932491733993499E4C599ACEB59F2F498164DA532A97C591AAD9CCA97A5329C52F9C254864F324FC804129604BE2881563ACF8AE44383642EF82B093C43279823F970E643CC4740C2DBC07972E8D43B5862191AF4262E5D3B53AF7C97D76820D0BBA0E1409E208F602E529E2303BEFF5DF9DA5D539F167D96BD262E6E1FCA1F1A48EF0E70B4E2C6443CC62AE04D6BF8D1AAC11EA4958CC568B2A54872E45026D6191EEFA749FA4F527877129443F6645DFC116F17A9E97A52D48C893D817DEC61DC5FE510EB05C0FB378C671B2AC357CBD30999E4CB645F26FDF248C842D413CA04831EBF3C3F92CB28DF5F478FB80D10F26F56976FF85EED2BFF60613031959828A4ABB01113A56E62A24DF72BE8768798D85D86FC5D5E97AFCB7BE57BAE87DDDB8F8A75094CE46A72E76ACE7F4C4C6C238D61A4B7AAE835393435F4A286E1594E2135CC23195A2AA76571D0B2FE97904E96B2812B63F29653F84C3EEBE840E172A3025D9C88290FF8A14FBF81E2B747781A47332CE3E9992486643A15C8E11951C0D02B9105278997E74D267AA28A6553CB9029E19A9AD772183219F47C12EF89E7BD313CE93D650EDD577024D8D103B74101F9254FF6128B5F795C1CF8C79F84F33FFF2C9C07F415CEEFBD2E9C3F785B380F7B5F387F642B9CC78C11CE63C70B673B3BE13C6AB8701EFE81701E3A4038BFDF4F380FFC9B707EEB45E1DCEF69E1FC8F2784F3F30F8A03F434E7FB3F93023FC6533F658F55EA5FD1E897865F9CC01D0DFCBFA1C0FC2FE7892E622FF78338D9C5FBBAFA9EFFB8FFB207BA28842C742831F0AA12F267579FF1DFD8BF98EF6543D335057AF12619FF0D017EEA339229074F892B0AC856954342D64A7970DFAB6BF2FA68ABF57556EB7FB45A97EF95F77606D9631D052EFA81FDB257675CBD2E0BAADC2BCBA13C5F7E662F450125A665E194CDCA9AF50364EBD7583DE466E1A3ECB156F06616571497DF67BDA7B37565ED9A4114053A6EB616D4DAFACA3E4540D94A1D05533C27EFF93161D299F76F16158A51AF458AA280E22E4533254CACAD2F3F5476BB2C98A28875C829C2767CD67F524209A58EDEEC6C5D96470EA16B86531450624B1158B9D95A404568D9628A90D621A708AA28DF31243A5344F6B412D3D6E176B375C5F3B2972F3F4F51C0DAED8AA0B212D62F559492F72A0A77760EC85EBCCE4A3F104A4A29EEF82E65DD3A0C3B0D4D45014563F986CEAC6F9DFDD655A66388296126EFF931E7C3CDC2ADB3F5CEAAD2350FC82FB6AE2E1D2DA2C49E92D0B2BB65213B26AAB22E5FFB31E74567D54F96C53A5C3B86E67579677D9059D765EB4D8AF53B2AA5286C2DE8CD42E266897CB37053C245F1B06C18253AAE338CB502CAC33A0AAAAC77AC389DD5FACE2CF74355E886A4B4CA173964AC8D2ACB712D793B26F17F2A75FF6FAF77B517EACA09FBB328DD15056E96B83F8BA0372BC5FF1B84E697C683ADE5FDC57BE0DFB9CC859EB825C6740000000049454E44AE426082
		) 
END
END

-----03.2- Thay đổi và tạo menu phiếu tháo dở, lắm ráp------
DECLARE @sysMenuQuanLyKhoID INT
DECLARE @sysMenuChungTuID INT
---------------PRO--------------------
IF Isnull(@sysSiteIDPRO, '') <> ''
 BEGIN 
	--Lay MenuID
	SELECT @sysMenuQuanLyKhoID = sysMenuID
	FROM   sysMenu
	WHERE  menuName = N'Quản lý kho' 
			and sysMenuParent is null
			and sysSiteID  = @sysSiteIDPRO
	
	SELECT @sysMenuChungTuID = sysMenuID
	FROM   sysMenu
	WHERE  menuName = N'Chứng từ' 
			and sysMenuParent  = @sysMenuQuanLyKhoID
			and sysSiteID  = @sysSiteIDPRO
			
	UPDATE [sysMenu]
	SET    MenuOrder = 9
	WHERE  menuName = N'Phiếu nhập thành phẩm từ sản xuất'
		   AND sysMenuParent = @sysMenuChungTuID
		   
	--Them Image ngang
	IF NOT EXISTS (SELECT TOP 1 1
						 FROM   [sysImageProcess]
						 WHERE  sysMenuParent = @sysMenuQuanLyKhoID
								AND ImageIndex = 13) 
	BEGIN
		INSERT INTO [dbo].[sysImageProcess]
			   ([ImageIndex]
			   ,[Image]
			   ,[sysMenuParent]
			   ,[sysSiteID])
		 VALUES
			   (13
			   ,0x89504E470D0A1A0A0000000D49484452000000100000003C08060000006F9D3A2C000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1300000B1301009A9C18000000D149444154584763FCFFFF3F03085C5A37E30F03C37F6630872060FCAB1F9CC902D60B2240F8E2DAE97F2EAE9DF69F187C7ECDB47F403BF60E3603D64DFF4B8CF3416A4E2E9B000C2F0C2F10E77F98254003B6A28501C906ECA7B2012484C1F9D55340D188E602520C80A4833DA85E20DD00B48444820117D6522725EE1B6C497918E4C6512F0CB1421554AC51A358472FD2867EC5329A948758521EAC2D9421959046CB8369FF471312CE3020BEA98B23108937007B338FF476227A338F781740F302C5060C64731FD25A1FAD9DA1DD3E0020E7C8724A1BA2C90000000049454E44AE426082
			   ,@sysMenuQuanLyKhoID
			   ,@sysSiteIDPRO)						
 
	END
	--Update index 15                            
	UPDATE [dbo].[sysImageProcess]
	SET    [Image] = 0x89504E470D0A1A0A0000000D49484452000000100000003C08060000006F9D3A2C000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1300000B1301009A9C18000000D149444154584763FCFFFF3F03085C5A37E30F03C37F6630872060FCAB1F9CC902D60B2240F8E2DAE97F2EAE9DF69F187C7ECDB47F403BF60E3603D64DFF4B8CF3416A4E2E9B000C2F0C2F10E77F98254003B6A28501C906ECA7B2012484C1F9D55340D188E602520C80A4833DA85E20DD00B48444820117D6522725EE1B6C497918E4C6512F0CB1421554AC51A358472FD2867EC5329A948758521EAC2D9421959046CB8369FF471312CE3020BEA98B23108937007B338FF476227A338F781740F302C5060C64731FD25A1FAD9DA1DD3E0020E7C8724A1BA2C90000000049454E44AE426082
	WHERE  sysMenuParent = @sysMenuQuanLyKhoID
		   AND ImageIndex = 15 
	-- Them menu Phieu lap rap, thao do
	IF NOT EXISTS (SELECT TOP 1 1
						 FROM   [sysMenu]
						 WHERE  sysMenuParent = @sysMenuChungTuID
								AND MenuName = N'Phiếu lắp ráp, tháo dở') 
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
	VALUES (N'Phiếu lắp ráp, tháo dở',
			N'Form assembly, dismantled',
			@sysSiteIDPRO,
			NULL,
			@DT46TableID,
			NULL,
			10,
			NULL,
			@sysMenuChungTuID,
			NULL,
			NULL,
			3,
	0x89504E470D0A1A0A0000000D49484452000000300000004608060000008A79175B000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1000000B1001AD23BD7500001777494441546843D55B0954966516FED1D46ACACC99AC6CB2265B4CD32C47AD29B7CC2CD3DC73C92545C5054505945504D97163DF575964116407D90404041144045414514011C10D841FFEE5997BBFFC3CBF84608D73CE0CE7DCF3FDDFF2BEEF7DEE7DEEF2BE961A00C9FFF51F03F87F9667A67C7C7C7CEF73E7CEBD73E1C28569555555DBABABABFD4932490E9398D1B3659595955F969797BF75E2C489E79E95D1FE1480A3478FBE7CECD8B1515959598BF2F3F32D8A8B8B63CBCACA2E92826DA42C6A6A6A70FDFA75DCB8714390BABA3AE1D9952B5770E9D2A5968A8A8A4B67CF9E4D3F7DFAB4C7C99327758F1F3F3E27212161545858D8C03F0AAC4700B6B6B6831D1D1D277979796D0A0A0A723F72E4483659FB7A5A5A9A3227270785858520CB8394C7B56BD7505F5FAF686C6C94DFB9734771F7EE5D416EDFBEADB875EB969C4029AE5EBDCA204020505252828282029021909494049ABBC9DFDFFF9CB3B373AC8D8D8D8EB1B1F10B3D017A22004343C3B97BF6EC29DBBB776F334D081F1F1F84848480AC8FE4E4645E54468B7790121D172F5EEC20E565376FDE1414BF7FFFBEA2B9B959D9D2D2A22051F2EF7BF7EE313005819013083901EE20AFC9C80B1D44A90EF2A83C2A2A0A010101E0F5080076EFDE9D6F6060D0AF3B105D0258B66C592F2323A36A0B0B0B1C387040E9E6E6D6419691928BA5B1B1B1D2D4D4D476B27E3B2F4E4A741035644415D943E505C55B5B5B59940FAF02908720E4442939C584ECFCF9F31D44BF8EDCDCDC769E333A3ABA23303050E6E2E2A2780800A487CD1F06B073E7CE89E43E585959C9ECEDEDDB3D3D3DA534B1342222424AF491A6A7A7B7E7E5E5B59F3973A69D8256C6D6678AB082AC7C5B5B9BA2A3A3432997CBC157A9542A00624F3048A2998CBD409E939107DB290EDA694E694C4C4C3BD1B4C3D5D555460014A6A6A60C40AEAFAFFFE9934074E9013D3D3D2F1313137663BB83838394F8DF46134B232323A58989896D99999952A28F9402B19DA940B49011D7E50F1E3C50B2F27CA57B10281028B027DADBDB150C8400CAE9B98C825AC663790E4A046C9436F66E7070703B01E8A0D8939B999929D99004E0E45303D8B66DDBCB04A091F8A7A449A414C06D04A095266E238EB611807602D04EC1DB41C1DB41012958B3B6B656419E509052727A2E236A484F9D3AD54A34939295992E0AA21AC78082E8262700721E5B5A5ADAC11EA0A4D04E1E90529CB51165A5147B1D14838A8700B063C70ECDAE40FCCE033A3A3ACB0800087DBB9D9D5DBB9393533B05B0F4F0E1C30247E3E2E214442325015152302B391B112025F158498A28F2F272E539B945B2ACBC0AD9F1DC73B28CACD28EB4F402594646BA9CBE5590A585EF2986944443E1CAF714C44A4A10F2871E68DFB76F9FCCDCDC5C4E0094E401E8EAEA366FDFBE7D706710BF03A0ADAD9DCE03088082AC00F200C8A5A0C002C503C82BD8BF7F3F3C3C3C84AC448040795C4887C5C545283C7319651571A82F5883C68C59A82FFD0567CB7C9153508EDCDC3C90B22010208541B91F647570F6090F0F071909942C84F5780D4B4B4B30008A499061410022BB05A0A9A9398C902A76EDDAA524F4C2049C89C895E08062216020EBC0DBDB1B9495409E109422BAE0744935AE14ED078AD4F0206E149A6266E35EF2BFA038D3173529EB919D5B014A990260CA3A42EE27DE83620B146382F23C2F03108DC5EB514A670A81E88D4D9B36CD5405F1980788F7FE6C7D8A7C250F521506C17C64B1B6B606F1545894AD48F4415E4109CA0BE2A12CEC8D4B85AEB854E683DBA93FE056D45C54269A4096DE1F1549FB90915324782023234300C0D66743B0F2146B420D60006C243622195310D2898399E532E9D05704F11800E2FC422E543C310B5B9785B8CF2915943685CACB57AEBE972F5F16ACCF0B5F6F684573F14A3C68D885ABB5D7003B352080A6AF90A025E1733454BBA1F5C204545CB88EDADA3AC1C2949641A914948984AA4CD948987BF3E6CDF0F3F313EEB3B3B3854A2D0A196D1F01EB1A0055BD21CC6BB608BB95F9CD2EA6128F356BD60855981765ABF133BEE738993B772EDC3C027136F40B7879EF43F81E2DDCD3EE835BD12FA1B989401449E06E6D80D2A8D1B03F6005671757CC9A350B5A5A5A0278B6B8BBBBBB703D74E810BEF9E61B0E5AA1FA73ACF195A9C5429E59F9440A9152A3290B08CA71D0B03B057AE4E5099CA5EC23B89F2AB540213100196C6844022EA74CC0C259E31077C4012D875FC0FD40355C0F1B0D69D448440478A22A610C9293A2119F9024508FE7E3B684D759B06081402B7EC65EE72B0BD3E7975F7E11F46056D0FAA64F0440938DA4410F3843500B2158985DCB5E610094DB4195F7D1BB6C722D5388DD9B9A5E88FA8BBA08F4598D63B6DBF0C0A20FD03000CDF99FC3C5D607B9478C50973F06AE1E41A4B08B604DB62C5385B9CE00A8DA0B16676FF07B3696AFAFAF40298E11FAFE1C1978D51301F0CE8C68B497B304B7C032994CE039D502C13A454594264F9F16F8CFC098AFCC5F2A462465384357B4F921C17732B66A6E405262202EE5DA23F1980B70613E5C5D34B062E5068C1F3F1ECB962FC7AA55AB046FB28559E6CF9F8F79F3E661CA94290285B815E776842B3AC72181FCA9C73A40A9D29015E21680BA47507112D21E5FB97D16856995CBF29062393927909C9E8BD0837AA87390A0216318EA4B1C70BF7227A5D1653864BE025F4F9E81A953BFC19831633079F26481EB7C157F4F9A340913264CC0D8B16385D44D8D22A87F02B725BCEEFAF5EB67770B60CA4F1209A5289DAC93113859B507F1C54BE19730039EA1EA48CB8C14628185C1703ECFA549F3A98071B648498D475CB21FF4CC35B064F64464866E40DD0557941CB78483A531D66BEAE0C71F6762F6ECD942D0CFFAE927CC9C39133366CCC0F4E9D305A5A74E9D2A0883E09AC38664006C48A6D3EAD5ABA7770B60DA7C894443774CF0FEA36F22A8F455B866F4816DA404263EBD61E8F83A22130E08F4A16DA150B89842BC9129292D86AEF917D8E9F60ABC4E0DC691D2198849C84446663EA2625361666E4D99C719070E1EC47E8AADBD94E36DEDEC6045F5842DCDADCBF7DF7F0F4DE2FA16CA4CEAEAEA42C1647A3200A6504A4A0A962F5F3EA95B008B36F69AF8CB5635D90E37096C42DF80B5FF7098BA7D006DBB97B1DE5C024DB381C82F4C11B6876C1DCEE1D41A23E4A839E6AFEF858D567D6071E4650497BD85C20B87403DBFF01D2704CE2042054E4B13DA08CE34B194A68F12B7032875723C706D70A28C64411D007B80E38CBA5734343408E37FFEF9E7F1DD0258B04112BB54EB2584C418E25C450E2AAB8A50529E86E44C7758BBCEC4729DDEB0F75E05EAE905CB3390FA862B58B3F32DA8EB0C46589C09C2E3CC60EDFC13324E06F25E00B43B13005CA1BDF2FD8774A8BF7913B59424F8D9254A12D4B10A412BA455021748159EDB79F630B5E6A09D9EF08E6AC7E86E01CCD3E85D9B90E18496D63BA8AACDC38933CEC82E76C4C9920052C81DE68ED3A0A1FF3EAED55C15028C5A647886ACC39C7512041CD1C1B9F369C82D0CC21EFB4504F0E2A32ABB75EB56A1F87126632A6452DA3D46572E942C5C38A9C78187A7A7905A996ADCB28800D8CB5C50293E3EEE168081ED97F76FDDBE82A2F3A1708BFA0EA905F6F089D087FB91D988CD3446C0D18DD860F03E4E15E5089BF2F4EC70ACD4ED0B1D8B4F91571486ACFC00D8B9CFC5A1103741514E7DAC1C576BB628F55A822C59B2040C8AF33F739D859B46FE867B9ECD5BB60871C114620F3000AA498A71E3C60DED168047C8C63B576FE4C3356A02CA2E6609EE6745BC03F621F0D802F8C5AC848EE5485CBFF11B1D9C827FC432EDBE8888374356410051C8105A469C289EFCD7219343434383AA7102DAA4529AEB06AAE9A4E2229D549450BC7056A32DAC40292E9C0C80EB01EF06478C18F176B7008262B4EFE69639C3E3E80FC220AE051C70DC9FC4E56D8753C444685BBD4359E1064E971FC1DA5D6A303D380599F97E48CADE8F1D7BC6C1D3C506CA8E5628DA5BA094B792B441216B855CFA00B2967B686B9763ADC60681122DA41CEDE48460AF203A9650D63945CD2253893DC085530440FB85E6418306BDDE2D00FF987577D38B0DE192F821AED59D17829501F8511FE319FF05AC0F0F84FE81A1B8D17009070FFF131AC6FD11996889E385CE703EB4141E1B06A33ECE96BA523FB4567AA1BDD6136DD45E34E7A9A3317C216A6DC6E2BAB73AD6AC5E85B4F4E3829B843449799E83FA3201B940998D8F56A82310007016E243B2D0D0D03B7DFBF67DB55B007B03A654669799C22F670812CBE7A1FAFA6924A65250BA4C8681CB7BD8ED33080EC153119D6E024D6B09ECDCE6E1F829274467EA416FD72764E15A7434DF446B63159AEBCB71A73A0FB5F9C1B892EE8A2B0996A849D0C735C7EFB072DAA7D0D1DFF5A8FF77A6DD9E2775A58ED4B238D00E50EFB71DA110C44C6306403D5003753A7FE91680D6FE017B63F29723F5CAD7083D37183E397F8353F24BD861391FEB365841DF662EC25337C2EEF010E858FD03B1E916387ED602BB1DC722DA4D83FAA046D4D765E17CA50D0A2BB4919AB405978AB7E0F6F1AD38EDA0818B115B71DEF83DF858EBC2D2F6B70D0BEFFA5859AE037CCFFB0EA60F9F0B71D1E436820150A35743007E77C8F5D88646CB4132C839E9AFE7A2F27EC5BAED8B893243A06132109E7E4E14680D70F5DA8F3D4EDF62ADDE87D8B86D2392F24D10767C191C7C56A0B5201889595A3874EA6DF89F1A0087C47EB00CE98B3D5EAF2035623CCA9C7F4563E40AD499BD4BBCA97D2CCAB9501953DB5C4567A73514130954E478EFCD9D2F1D4B0A008856970940EF6E3D60EE3959B265D7D889FA66FA4ADD1DD6D4748DC5C7C34693FB2284053D3DFCF0FE3F86E3DBA93F42DFD80E7B3D7461E2F6216E35D520C0692EB4F6AAC12EBE37ACC25EC42EAF17A1EBD00B9B6D24D860D60BDE7A1FA3D17702EAAC864179A7E611002E76AC20A74F3A1D163252346DF485E24780B80FE284426D770577CBDD0238537259A2BE66D387FE41E1CA6B3575940DA88FCFC9A54AD820E4E2BAEB37A8222622F87004E293B26061BF05A171A6B8545582851B7B43D3F44D8427EC42EEA923740A118EB854EA7DBC1642DDE02F58BBE5395C741D876B96C371B7F6A29086991EAC205B9A37EDC5C4F932EAB342A976700BCF198AAB3003A0FD414967E5F9FE3144A6567692FEAFBC32C0748FB9F4F295AB34F96D9CA38A9B975788C27C6EE04A709E162B3F7F093EFEA1D8A83785361B9A98B7743CD61B0E4145E509DC6BBE852BB52771B6321A67CE1FC5C9E210AAD61BB0744B3F786F7C1927360CC0AAC573B078E96FFB01DEAAAE5BBB963B4DA11AF336732DDDF38686A9C5201800D586821E012C59B5EEEDC52BD48F2EFE65B92C2EE118355F593843D530AF3015B9E52EC8CC8B427E5E09F52BE9D86D618D759BD62330241A76CE9A884BB7C1ED7B35482BB0866FE477880C9F82A0C8C988CD364474DA6EE8597F0E374309EA5C3EC2CA453F4367879EA0202BC7FFA6C047EEA514B4DCFCF9D22E8D01B087F81D538CB6B0D93D0208083A3CCC3FE830F63BBA20F2682CF24F16E15A6D258253D661CFE15E30731E87FCF21064D0C6C5722FB5C50EAE888D4F4570A4354ACEC721BF8C36DEE1E3683363839BFE3350EDF236027D870A99CBDC7902BC8D5EC51D9FC9505FB11CBB76F3D6F6B73F3A37158A2637793788AAE17470C0C5936B001739DE1DD2C15A4A8F008CF7587DE4ECE1ADF03D1482A4E4144484C5A0E9763D824ADEA496FA4D44E6AD44D6DDA9883916027B476F68ED3080B1A92D82A3AC5076391AFEC766E06CBC0EEA4DA6A07A1159DB4082D3DBD4E01F378DF613EF23D0E4EFB8EB3313EABFAE8091B189A0BC52A9E4C35F5AE736C5181DB990B2BC07A7C2053A2816B6B44C238A89D81E016CD1D5FF609785F565EB7DF6F2D4F44CCACFB6F04D58807D312FC0396C3A4A311B0792DF868DDD411C74F2C0B2B564596B7B041D35A3BC4FD53A710C8A8FCD43ED921751AF2B41EB4902E0D11B0722DE85F681E71162FB16EEF8CD813A71DFD068D72300ACE86DAAFADC173188203A19E10305CE50A2070E1E3C18DE238085CB573F3767C98A211A9BB7DD8D8A8EA354E68CAFA6BC8FD55B3F8657FC6C98F97F82AF268E83B74F288C4CCDE1E91B44FD4C2B6252ED91516C86B0DC6F1071EA75546DEF8DBB4EB42F6E50C37E9F7EB08F7D0D7AAECF23C5F14D34FBCDC5AF2B34A1BF73CF230AC93B8096FB0A34D2E1D8AD9BAD080C08A7E39663827738061A1A6ED159E981433D02D0D2D5976CD7339AB4C3D814E63607E854EC04B66FDD81CF467F81919F8CC2E79F7E055B9BFD54688EE1578D4D7070A55EA7FD2E2ED6E4509CCC474AF91284950F86F7F181084C78079601CFC339F135F8640E8175E0409C0E5B8BBA4C676C335988DD76CB51DF721CB5F752517533116557236817E78B53E7BDE1E4A583E4C44C01E0D5EA1B3877F60234D66CF5E91140F5B51A494252D2386D0363681B98232E2199AA63156D3E52E9F43882CE7FB2699352096FFF102C58B61A16CE5B90DAF8250A649360756834522B67A1BC752DA22F7D00C7F4DE082CF8074A9BD51153FA35D61BFC00030B77189201E26E0E456AEBEB387AE3558457F747C8C5971050FA02BC0BFBC03D570D8EA9FDE09EF8194273A6C227F14BDADA0EC52ADD17F2A98EBDD76D21E3975A36BDB76F34FD003B8C2CF0C38C597CA44D2DEE690AAEEBC83E914B471B1BF0EDF41958BA7609A2AA46E114DE45F283B7317BE974ACD31B8E2BF76D70178750877DB8073F94361862C19A77B15DD7908087C2CB2706495717E334DE413E3EC2497C886CC550A4B5BC8BC4C6BF23BA868A61E56B3854F222DC4E301809EC1324D817D50BF335D40209C463FF14FBBBD2BC42572D4DDFA537BE9AFE0A9EEB23E1FF0E0136B676C4F536ECDCA92FDC3FFFA21A16690D8053C620B866FE15BB7D876185FA162C5CB61CB3164EC346A369D4764FC71AEDA9F861CE3758B2F2576CA6A34A964D5B8D60B06F3E5C32687CFA20610E87D4BFE140E240EC8B1D00DBA8FEB00C7B09E6C17F8169C00B30F6EE0743F73E30A264B074AB5A23ADFF9DAA177E0760D4976AE6E3A749AA3F9F2869FC6094E4DEE077240F867FFA46DBC4A99F483F1AF1D736BA6F193A427277F81849D3F0CF254DC33E93348DF867AFA6D15F0C681A39F695A64FFED9FF3719F372D38887C2BF451939B67FD3A75FF413C67D4CC273F05C23C64A9A468E23192F691AF5A5A469F4BF48BE96347D3641D244BA348D9B2A69FA70B4DA0902F0C31301686FDFC6FDD2AB247349B4BB128D756B6B589EF4FE593FD7DCB4B171F1E24579342F2BF73DEBC77A8A201EF300BF10857B6F92E75565FBB6AD695A5B361BD2B568B3E6A6A59DDF3FEBFB876BA5F1BCF3E6CE798374BB2DEAD723005530FF23BF17921E29DD0260546BD5D59F56ACE95BF73FF07D4FF3BE4A73DD2679AFA739BB0DE29E06ABBC67E579D19E147BDAF73B69AE854F33DFB300C0D60749E1D32CF8ACBFE90900BB909563B9FC84C5D95AFC7ECCC3F7AA63C4B1DFAA8C4D5199539C571C2B7A68DDD3CED913009E9017E7859EE47E5688ADCF40C46F780C3FE77B7ECE7C561DCFEF58497EC6BFC33ABDE77B36187BB7DB39FF53006C395E849554A5902A0056800DA01A9022008E1B1EA7AA287FC731F55473FEA700786106C1C24A8A81CC00C42CC296E6DFAA41AE4A2355E5458FF178918A22BDBA9CF33F05C08A893CE7AB48239176E23B912E221D440FB0F29D01B0479E7ACE3F03802DC38B729A53E53D3F1379DF99429DE347350698EB62CAE471AA73AAD2A8CB397B02D0554661EB1C796825D5CCA46A35F17757C54D953EAC94483FD5F122609EBFF3BC8FCDD9250095C87FDAC2D3F93BB6E87FAB2EB00144AF09D4FC5D2FF40C00B0957A6C03FEE43A4C2B06F1A8D5F86F00F8B39EFBA3E3D850EBBA02C014E88AD322F7C58C23564CBE57E526FFEE5CBC58392E50E2BC4C31552F75CE5C629556CD6062DBA2AADBB75D01E0416266108B10071BBB8F455559FE56F59EF3BD18A8AA0D192BCF4A8BF540E4B2AAD519846A6210E7110B26BF13418B54EA31063A57D19E003020165658CCF162A651ED791808CFAD0AB2330006C7A0D940FC6DE77A22B4303DC5405700BA4B6D626B2D5660D57EAA7360B3453BF7509D9B469E4FF4846A53F8A88FFA33009E4421D1AAAA00555B0D55059E9507AC9F2500B6A6AA92AA3412BBD63F1B036CB4CE3120B4F1DD0150B524BB5F35EBB0B29DB3107F2FB613AA559C9FA906377FF7345988BF513588180B628612DE75B9A9EFEAECF17FFD598FFF03C4FF3A807F033C27810617C563340000000049454E44AE426082
	) 
	END								
END 


-----STD----
IF Isnull(@sysSiteIDSTD, '') <> ''
BEGIN
    --Lay MenuID
	SELECT @sysMenuQuanLyKhoID = sysMenuID
	FROM   sysMenu
	WHERE  menuName = N'Quản lý kho' 
			and sysMenuParent is null
			and sysSiteID  = @sysSiteIDSTD
	
	SELECT @sysMenuChungTuID = sysMenuID
	FROM   sysMenu
	WHERE  menuName = N'Chứng từ' 
			and sysMenuParent  = @sysMenuQuanLyKhoID
			and sysSiteID  = @sysSiteIDSTD
			
	UPDATE [sysMenu]
	SET    MenuOrder = 9
	WHERE  menuName = N'Phiếu nhập thành phẩm từ sản xuất'
		   AND sysMenuParent = @sysMenuChungTuID
		   
	--Them Image ngang
	IF NOT EXISTS (SELECT TOP 1 1
						 FROM   [sysImageProcess]
						 WHERE  sysMenuParent = @sysMenuQuanLyKhoID
								AND ImageIndex = 13) 
	BEGIN
		INSERT INTO [dbo].[sysImageProcess]
			   ([ImageIndex]
			   ,[Image]
			   ,[sysMenuParent]
			   ,[sysSiteID])
		 VALUES
			   (13
			   ,0x89504E470D0A1A0A0000000D49484452000000100000003C08060000006F9D3A2C000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1300000B1301009A9C18000000D149444154584763FCFFFF3F03085C5A37E30F03C37F6630872060FCAB1F9CC902D60B2240F8E2DAE97F2EAE9DF69F187C7ECDB47F403BF60E3603D64DFF4B8CF3416A4E2E9B000C2F0C2F10E77F98254003B6A28501C906ECA7B2012484C1F9D55340D188E602520C80A4833DA85E20DD00B48444820117D6522725EE1B6C497918E4C6512F0CB1421554AC51A358472FD2867EC5329A948758521EAC2D9421959046CB8369FF471312CE3020BEA98B23108937007B338FF476227A338F781740F302C5060C64731FD25A1FAD9DA1DD3E0020E7C8724A1BA2C90000000049454E44AE426082
			   ,@sysMenuQuanLyKhoID
			   ,@sysSiteIDSTD)						
 
	END
	--Update index 15                            
	UPDATE [dbo].[sysImageProcess]
	SET    [Image] = 0x89504E470D0A1A0A0000000D49484452000000100000003C08060000006F9D3A2C000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1300000B1301009A9C18000000D149444154584763FCFFFF3F03085C5A37E30F03C37F6630872060FCAB1F9CC902D60B2240F8E2DAE97F2EAE9DF69F187C7ECDB47F403BF60E3603D64DFF4B8CF3416A4E2E9B000C2F0C2F10E77F98254003B6A28501C906ECA7B2012484C1F9D55340D188E602520C80A4833DA85E20DD00B48444820117D6522725EE1B6C497918E4C6512F0CB1421554AC51A358472FD2867EC5329A948758521EAC2D9421959046CB8369FF471312CE3020BEA98B23108937007B338FF476227A338F781740F302C5060C64731FD25A1FAD9DA1DD3E0020E7C8724A1BA2C90000000049454E44AE426082
	WHERE  sysMenuParent = @sysMenuQuanLyKhoID
		   AND ImageIndex = 15 
	-- Them menu Phieu lap rap, thao do
IF NOT EXISTS (SELECT TOP 1 1
						 FROM   [sysMenu]
						 WHERE  sysMenuParent = @sysMenuChungTuID
								AND MenuName = N'Phiếu lắp ráp, tháo dở') 
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
	VALUES (N'Phiếu lắp ráp, tháo dở',
			N'Form assembly, dismantled',
			@sysSiteIDSTD,
			NULL,
			@DT46TableID,
			NULL,
			10,
			NULL,
			@sysMenuChungTuID,
			NULL,
			NULL,
			3,
	0x89504E470D0A1A0A0000000D49484452000000300000004608060000008A79175B000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000206348524D00007A26000080840000FA00000080E8000075300000EA6000003A98000017709CBA513C000000097048597300000B1000000B1001AD23BD7500001777494441546843D55B0954966516FED1D46ACACC99AC6CB2265B4CD32C47AD29B7CC2CD3DC73C92545C5054505945504D97163DF575964116407D90404041144045414514011C10D841FFEE5997BBFFC3CBF84608D73CE0CE7DCF3FDDFF2BEEF7DEE7DEEF2BE961A00C9FFF51F03F87F9667A67C7C7C7CEF73E7CEBD73E1C28569555555DBABABABFD4932490E9398D1B3659595955F969797BF75E2C489E79E95D1FE1480A3478FBE7CECD8B1515959598BF2F3F32D8A8B8B63CBCACA2E92826DA42C6A6A6A70FDFA75DCB8714390BABA3AE1D9952B5770E9D2A5968A8A8A4B67CF9E4D3F7DFAB4C7C99327758F1F3F3E27212161545858D8C03F0AAC4700B6B6B6831D1D1D277979796D0A0A0A723F72E4483659FB7A5A5A9A3227270785858520CB8394C7B56BD7505F5FAF686C6C94DFB9734771F7EE5D416EDFBEADB875EB969C4029AE5EBDCA204020505252828282029021909494049ABBC9DFDFFF9CB3B373AC8D8D8D8EB1B1F10B3D017A22004343C3B97BF6EC29DBBB776F334D081F1F1F84848480AC8FE4E4645E54468B7790121D172F5EEC20E565376FDE1414BF7FFFBEA2B9B959D9D2D2A22051F2EF7BF7EE313005819013083901EE20AFC9C80B1D44A90EF2A83C2A2A0A010101E0F5080076EFDE9D6F6060D0AF3B105D0258B66C592F2323A36A0B0B0B1C387040E9E6E6D6419691928BA5B1B1B1D2D4D4D476B27E3B2F4E4A741035644415D943E505C55B5B5B59940FAF02908720E4442939C584ECFCF9F31D44BF8EDCDCDC769E333A3ABA23303050E6E2E2A2780800A487CD1F06B073E7CE89E43E585959C9ECEDEDDB3D3D3DA534B1342222424AF491A6A7A7B7E7E5E5B59F3973A69D8256C6D6678AB082AC7C5B5B9BA2A3A3432997CBC157A9542A00624F3048A2998CBD409E939107DB290EDA694E694C4C4C3BD1B4C3D5D555460014A6A6A60C40AEAFAFFFE9934074E9013D3D3D2F1313137663BB83838394F8DF46134B232323A58989896D99999952A28F9402B19DA940B49011D7E50F1E3C50B2F27CA57B10281028B027DADBDB150C8400CAE9B98C825AC663790E4A046C9436F66E7070703B01E8A0D8939B999929D99004E0E45303D8B66DDBCB04A091F8A7A449A414C06D04A095266E238EB611807602D04EC1DB41C1DB41012958B3B6B656419E509052727A2E236A484F9D3AD54A34939295992E0AA21AC78082E8262700721E5B5A5ADAC11EA0A4D04E1E90529CB51165A5147B1D14838A8700B063C70ECDAE40FCCE033A3A3ACB0800087DBB9D9D5DBB9393533B05B0F4F0E1C30247E3E2E214442325015152302B391B112025F158498A28F2F272E539B945B2ACBC0AD9F1DC73B28CACD28EB4F402594646BA9CBE5590A585EF2986944443E1CAF714C44A4A10F2871E68DFB76F9FCCDCDC5C4E0094E401E8EAEA366FDFBE7D706710BF03A0ADAD9DCE03088082AC00F200C8A5A0C002C503C82BD8BF7F3F3C3C3C84AC448040795C4887C5C545283C7319651571A82F5883C68C59A82FFD0567CB7C9153508EDCDC3C90B22010208541B91F647570F6090F0F071909942C84F5780D4B4B4B30008A499061410022BB05A0A9A9398C902A76EDDAA524F4C2049C89C895E08062216020EBC0DBDB1B9495409E109422BAE0744935AE14ED078AD4F0206E149A6266E35EF2BFA038D3173529EB919D5B014A990260CA3A42EE27DE83620B146382F23C2F03108DC5EB514A670A81E88D4D9B36CD5405F1980788F7FE6C7D8A7C250F521506C17C64B1B6B606F1545894AD48F4415E4109CA0BE2A12CEC8D4B85AEB854E683DBA93FE056D45C54269A4096DE1F1549FB90915324782023234300C0D66743B0F2146B420D60006C243622195310D2898399E532E9D05704F11800E2FC422E543C310B5B9785B8CF2915943685CACB57AEBE972F5F16ACCF0B5F6F684573F14A3C68D885ABB5D7003B352080A6AF90A025E1733454BBA1F5C204545CB88EDADA3AC1C2949641A914948984AA4CD948987BF3E6CDF0F3F313EEB3B3B3854A2D0A196D1F01EB1A0055BD21CC6BB608BB95F9CD2EA6128F356BD60855981765ABF133BEE738993B772EDC3C027136F40B7879EF43F81E2DDCD3EE835BD12FA1B989401449E06E6D80D2A8D1B03F6005671757CC9A350B5A5A5A0278B6B8BBBBBB703D74E810BEF9E61B0E5AA1FA73ACF195A9C5429E59F9440A9152A3290B08CA71D0B03B057AE4E5099CA5EC23B89F2AB540213100196C6844022EA74CC0C259E31077C4012D875FC0FD40355C0F1B0D69D448440478A22A610C9293A2119F9024508FE7E3B684D759B06081402B7EC65EE72B0BD3E7975F7E11F46056D0FAA64F0440938DA4410F3843500B2158985DCB5E610094DB4195F7D1BB6C722D5388DD9B9A5E88FA8BBA08F4598D63B6DBF0C0A20FD03000CDF99FC3C5D607B9478C50973F06AE1E41A4B08B604DB62C5385B9CE00A8DA0B16676FF07B3696AFAFAF40298E11FAFE1C1978D51301F0CE8C68B497B304B7C032994CE039D502C13A454594264F9F16F8CFC098AFCC5F2A462465384357B4F921C17732B66A6E405262202EE5DA23F1980B70613E5C5D34B062E5068C1F3F1ECB962FC7AA55AB046FB28559E6CF9F8F79F3E661CA94290285B815E776842B3AC72181FCA9C73A40A9D29015E21680BA47507112D21E5FB97D16856995CBF29062393927909C9E8BD0837AA87390A0216318EA4B1C70BF7227A5D1653864BE025F4F9E81A953BFC19831633079F26481EB7C157F4F9A340913264CC0D8B16385D44D8D22A87F02B725BCEEFAF5EB67770B60CA4F1209A5289DAC93113859B507F1C54BE19730039EA1EA48CB8C14628185C1703ECFA549F3A98071B648498D475CB21FF4CC35B064F64464866E40DD0557941CB78483A531D66BEAE0C71F6762F6ECD942D0CFFAE927CC9C39133366CCC0F4E9D305A5A74E9D2A0883E09AC38664006C48A6D3EAD5ABA7770B60DA7C894443774CF0FEA36F22A8F455B866F4816DA404263EBD61E8F83A22130E08F4A16DA150B89842BC9129292D86AEF917D8E9F60ABC4E0DC691D2198849C84446663EA2625361666E4D99C719070E1EC47E8AADBD94E36DEDEC6045F5842DCDADCBF7DF7F0F4DE2FA16CA4CEAEAEA42C1647A3200A6504A4A0A962F5F3EA95B008B36F69AF8CB5635D90E37096C42DF80B5FF7098BA7D006DBB97B1DE5C024DB381C82F4C11B6876C1DCEE1D41A23E4A839E6AFEF858D567D6071E4650497BD85C20B87403DBFF01D2704CE2042054E4B13DA08CE34B194A68F12B7032875723C706D70A28C64411D007B80E38CBA5734343408E37FFEF9E7F1DD0258B04112BB54EB2584C418E25C450E2AAB8A50529E86E44C7758BBCEC4729DDEB0F75E05EAE905CB3390FA862B58B3F32DA8EB0C46589C09C2E3CC60EDFC13324E06F25E00B43B13005CA1BDF2FD8774A8BF7913B59424F8D9254A12D4B10A412BA455021748159EDB79F630B5E6A09D9EF08E6AC7E86E01CCD3E85D9B90E18496D63BA8AACDC38933CEC82E76C4C9920052C81DE68ED3A0A1FF3EAED55C15028C5A647886ACC39C7512041CD1C1B9F369C82D0CC21EFB4504F0E2A32ABB75EB56A1F87126632A6452DA3D46572E942C5C38A9C78187A7A7905A996ADCB28800D8CB5C50293E3EEE168081ED97F76FDDBE82A2F3A1708BFA0EA905F6F089D087FB91D988CD3446C0D18DD860F03E4E15E5089BF2F4EC70ACD4ED0B1D8B4F91571486ACFC00D8B9CFC5A1103741514E7DAC1C576BB628F55A822C59B2040C8AF33F739D859B46FE867B9ECD5BB60871C114620F3000AA498A71E3C60DED168047C8C63B576FE4C3356A02CA2E6609EE6745BC03F621F0D802F8C5AC848EE5485CBFF11B1D9C827FC432EDBE8888374356410051C8105A469C289EFCD7219343434383AA7102DAA4529AEB06AAE9A4E2229D549450BC7056A32DAC40292E9C0C80EB01EF06478C18F176B7008262B4EFE69639C3E3E80FC220AE051C70DC9FC4E56D8753C444685BBD4359E1064E971FC1DA5D6A303D380599F97E48CADE8F1D7BC6C1D3C506CA8E5628DA5BA094B792B441216B855CFA00B2967B686B9763ADC60681122DA41CEDE48460AF203A9650D63945CD2253893DC085530440FB85E6418306BDDE2D00FF987577D38B0DE192F821AED59D17829501F8511FE319FF05AC0F0F84FE81A1B8D17009070FFF131AC6FD11996889E385CE703EB4141E1B06A33ECE96BA523FB4567AA1BDD6136DD45E34E7A9A3317C216A6DC6E2BAB73AD6AC5E85B4F4E3829B843449799E83FA3201B940998D8F56A82310007016E243B2D0D0D03B7DFBF67DB55B007B03A654669799C22F670812CBE7A1FAFA6924A65250BA4C8681CB7BD8ED33080EC153119D6E024D6B09ECDCE6E1F829274467EA416FD72764E15A7434DF446B63159AEBCB71A73A0FB5F9C1B892EE8A2B0996A849D0C735C7EFB072DAA7D0D1DFF5A8FF77A6DD9E2775A58ED4B238D00E50EFB71DA110C44C6306403D5003753A7FE91680D6FE017B63F29723F5CAD7083D37183E397F8353F24BD861391FEB365841DF662EC25337C2EEF010E858FD03B1E916387ED602BB1DC722DA4D83FAA046D4D765E17CA50D0A2BB4919AB405978AB7E0F6F1AD38EDA0818B115B71DEF83DF858EBC2D2F6B70D0BEFFA5859AE037CCFFB0EA60F9F0B71D1E436820150A35743007E77C8F5D88646CB4132C839E9AFE7A2F27EC5BAED8B893243A06132109E7E4E14680D70F5DA8F3D4EDF62ADDE87D8B86D2392F24D10767C191C7C56A0B5201889595A3874EA6DF89F1A0087C47EB00CE98B3D5EAF2035623CCA9C7F4563E40AD499BD4BBCA97D2CCAB9501953DB5C4567A73514130954E478EFCD9D2F1D4B0A008856970940EF6E3D60EE3959B265D7D889FA66FA4ADD1DD6D4748DC5C7C34693FB2284053D3DFCF0FE3F86E3DBA93F42DFD80E7B3D7461E2F6216E35D520C0692EB4F6AAC12EBE37ACC25EC42EAF17A1EBD00B9B6D24D860D60BDE7A1FA3D17702EAAC864179A7E611002E76AC20A74F3A1D163252346DF485E24780B80FE284426D770577CBDD0238537259A2BE66D387FE41E1CA6B3575940DA88FCFC9A54AD820E4E2BAEB37A8222622F87004E293B26061BF05A171A6B8545582851B7B43D3F44D8427EC42EEA923740A118EB854EA7DBC1642DDE02F58BBE5395C741D876B96C371B7F6A29086991EAC205B9A37EDC5C4F932EAB342A976700BCF198AAB3003A0FD414967E5F9FE3144A6567692FEAFBC32C0748FB9F4F295AB34F96D9CA38A9B975788C27C6EE04A709E162B3F7F093EFEA1D8A83785361B9A98B7743CD61B0E4145E509DC6BBE852BB52771B6321A67CE1FC5C9E210AAD61BB0744B3F786F7C1927360CC0AAC573B078E96FFB01DEAAAE5BBB963B4DA11AF336732DDDF38686A9C5201800D586821E012C59B5EEEDC52BD48F2EFE65B92C2EE118355F593843D530AF3015B9E52EC8CC8B427E5E09F52BE9D86D618D759BD62330241A76CE9A884BB7C1ED7B35482BB0866FE477880C9F82A0C8C988CD364474DA6EE8597F0E374309EA5C3EC2CA453F4367879EA0202BC7FFA6C047EEA514B4DCFCF9D22E8D01B087F81D538CB6B0D93D0208083A3CCC3FE830F63BBA20F2682CF24F16E15A6D258253D661CFE15E30731E87FCF21064D0C6C5722FB5C50EAE888D4F4570A4354ACEC721BF8C36DEE1E3683363839BFE3350EDF236027D870A99CBDC7902BC8D5EC51D9FC9505FB11CBB76F3D6F6B73F3A37158A2637793788AAE17470C0C5936B001739DE1DD2C15A4A8F008CF7587DE4ECE1ADF03D1482A4E4144484C5A0E9763D824ADEA496FA4D44E6AD44D6DDA9883916027B476F68ED3080B1A92D82A3AC5076391AFEC766E06CBC0EEA4DA6A07A1159DB4082D3DBD4E01F378DF613EF23D0E4EFB8EB3313EABFAE8091B189A0BC52A9E4C35F5AE736C5181DB990B2BC07A7C2053A2816B6B44C238A89D81E016CD1D5FF609785F565EB7DF6F2D4F44CCACFB6F04D58807D312FC0396C3A4A311B0792DF868DDD411C74F2C0B2B564596B7B041D35A3BC4FD53A710C8A8FCD43ED921751AF2B41EB4902E0D11B0722DE85F681E71162FB16EEF8CD813A71DFD068D72300ACE86DAAFADC173188203A19E10305CE50A2070E1E3C18DE238085CB573F3767C98A211A9BB7DD8D8A8EA354E68CAFA6BC8FD55B3F8657FC6C98F97F82AF268E83B74F288C4CCDE1E91B44FD4C2B6252ED91516C86B0DC6F1071EA75546DEF8DBB4EB42F6E50C37E9F7EB08F7D0D7AAECF23C5F14D34FBCDC5AF2B34A1BF73CF230AC93B8096FB0A34D2E1D8AD9BAD080C08A7E39663827738061A1A6ED159E981433D02D0D2D5976CD7339AB4C3D814E63607E854EC04B66FDD81CF467F81919F8CC2E79F7E055B9BFD54688EE1578D4D7070A55EA7FD2E2ED6E4509CCC474AF91284950F86F7F181084C78079601CFC339F135F8640E8175E0409C0E5B8BBA4C676C335988DD76CB51DF721CB5F752517533116557236817E78B53E7BDE1E4A583E4C44C01E0D5EA1B3877F60234D66CF5E91140F5B51A494252D2386D0363681B98232E2199AA63156D3E52E9F43882CE7FB2699352096FFF102C58B61A16CE5B90DAF8250A649360756834522B67A1BC752DA22F7D00C7F4DE082CF8074A9BD51153FA35D61BFC00030B77189201E26E0E456AEBEB387AE3558457F747C8C5971050FA02BC0BFBC03D570D8EA9FDE09EF8194273A6C227F14BDADA0EC52ADD17F2A98EBDD76D21E3975A36BDB76F34FD003B8C2CF0C38C597CA44D2DEE690AAEEBC83E914B471B1BF0EDF41958BA7609A2AA46E114DE45F283B7317BE974ACD31B8E2BF76D70178750877DB8073F94361862C19A77B15DD7908087C2CB2706495717E334DE413E3EC2497C886CC550A4B5BC8BC4C6BF23BA868A61E56B3854F222DC4E301809EC1324D817D50BF335D40209C463FF14FBBBD2BC42572D4DDFA537BE9AFE0A9EEB23E1FF0E0136B676C4F536ECDCA92FDC3FFFA21A16690D8053C620B866FE15BB7D876185FA162C5CB61CB3164EC346A369D4764FC71AEDA9F861CE3758B2F2576CA6A34A964D5B8D60B06F3E5C32687CFA20610E87D4BFE140E240EC8B1D00DBA8FEB00C7B09E6C17F8169C00B30F6EE0743F73E30A264B074AB5A23ADFF9DAA177E0760D4976AE6E3A749AA3F9F2869FC6094E4DEE077240F867FFA46DBC4A99F483F1AF1D736BA6F193A427277F81849D3F0CF254DC33E93348DF867AFA6D15F0C681A39F695A64FFED9FF3719F372D38887C2BF451939B67FD3A75FF413C67D4CC273F05C23C64A9A468E23192F691AF5A5A469F4BF48BE96347D3641D244BA348D9B2A69FA70B4DA0902F0C31301686FDFC6FDD2AB247349B4BB128D756B6B589EF4FE593FD7DCB4B171F1E24579342F2BF73DEBC77A8A201EF300BF10857B6F92E75565FBB6AD695A5B361BD2B568B3E6A6A59DDF3FEBFB876BA5F1BCF3E6CE798374BB2DEAD723005530FF23BF17921E29DD0260546BD5D59F56ACE95BF73FF07D4FF3BE4A73DD2679AFA739BB0DE29E06ABBC67E579D19E147BDAF73B69AE854F33DFB300C0D60749E1D32CF8ACBFE90900BB909563B9FC84C5D95AFC7ECCC3F7AA63C4B1DFAA8C4D5199539C571C2B7A68DDD3CED913009E9017E7859EE47E5688ADCF40C46F780C3FE77B7ECE7C561DCFEF58497EC6BFC33ABDE77B36187BB7DB39FF53006C395E849554A5902A0056800DA01A9022008E1B1EA7AA287FC731F55473FEA700786106C1C24A8A81CC00C42CC296E6DFAA41AE4A2355E5458FF178918A22BDBA9CF33F05C08A893CE7AB48239176E23B912E221D440FB0F29D01B0479E7ACE3F03802DC38B729A53E53D3F1379DF99429DE347350698EB62CAE471AA73AAD2A8CB397B02D0554661EB1C796825D5CCA46A35F17757C54D953EAC94483FD5F122609EBFF3BC8FCDD9250095C87FDAC2D3F93BB6E87FAB2EB00144AF09D4FC5D2FF40C00B0957A6C03FEE43A4C2B06F1A8D5F86F00F8B39EFBA3E3D850EBBA02C014E88AD322F7C58C23564CBE57E526FFEE5CBC58392E50E2BC4C31552F75CE5C629556CD6062DBA2AADBB75D01E0416266108B10071BBB8F455559FE56F59EF3BD18A8AA0D192BCF4A8BF540E4B2AAD519846A6210E7110B26BF13418B54EA31063A57D19E003020165658CCF162A651ED791808CFAD0AB2330006C7A0D940FC6DE77A22B4303DC5405700BA4B6D626B2D5660D57EAA7360B3453BF7509D9B469E4FF4846A53F8A88FFA33009E4421D1AAAA00555B0D55059E9507AC9F2500B6A6AA92AA3412BBD63F1B036CB4CE3120B4F1DD0150B524BB5F35EBB0B29DB3107F2FB613AA559C9FA906377FF7345988BF513588180B628612DE75B9A9EFEAECF17FFD598FFF03C4FF3A807F033C27810617C563340000000049454E44AE426082
	) 
	END
END

----Ngôn ngữ----
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Lắp ráp' )
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Lắp ráp', N'Assembly')
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Tháo dỡ' )
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Tháo dỡ', N'Dismantling')
		
if not exists (select top 1 1 from [Dictionary] where [Content] = N'Cần có ngày chứng từ xuất để tra phiếu nhập' )
		INSERT INTO [dbo].[Dictionary] ([Content],[Content2]) 
		VALUES (N'Cần có ngày chứng từ xuất để tra phiếu nhập', N'Must have Export date to look up receipt of storing')
----------Cấu hình luồng dữ liệu------------------------
if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname='Soluong1') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuong','Soluong1')
 
if not exists (select top 1 1 from sysFormatString where _Key = 'SoLuong' and Fieldname='Soluong2') 
 insert into sysFormatString(_Key, Fieldname) Values ('SoLuong','Soluong2')
 
 if not exists (select top 1 1 from sysFormatString where _Key = 'DonGia' and Fieldname='Gia1') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGia','Gia1')
 
  if not exists (select top 1 1 from sysFormatString where _Key = 'DonGia' and Fieldname='Gia2') 
 insert into sysFormatString(_Key, Fieldname) Values ('DonGia','Gia2')