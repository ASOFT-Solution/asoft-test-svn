use [CDT]

declare @sysTableID int

-- DMTSCD
select @sysTableID = sysTableID from sysTable
where TableName = 'DMTSCD'
--Old: Số tháng khấu hao còn lại
Update sysField set LabelName = N'Thời gian khấu hao(tháng)'
where sysTableID = @sysTableID
and FieldName = 'SoThang'
--Old: Ngày ghi nhận giá trị còn lại
Update sysField set LabelName = N'Ngày ghi nhận nguyên giá'
where sysTableID = @sysTableID
and FieldName = 'NgayGTCL'

--Thêm cột DaKH
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysField]
               WHERE  [FieldName] = N'DaKH'
                      AND [sysTableID] = @sysTableID)
  BEGIN
      INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
      VALUES (@sysTableID, N'DaKH', 0, NULL, NULL, NULL, NULL, 5, N'Thời gian đã khấu hao (tháng)', N'Depreciation period (month)', 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DMTSCD_DaKH', NULL, 0, NULL)
  END
--Cập nhật lại thứ tự các cột

--NgayGTCL
Update sysField set TabIndex = 6
where sysTableID = @sysTableID
and FieldName = 'NgayGTCL'

Update sysField set TabIndex = 7
where sysTableID = @sysTableID
and FieldName = 'NgayKH'

Update sysField set TabIndex = 8, DefaultValue = N'2111'
where sysTableID = @sysTableID
and FieldName = 'TKTS'

Update sysField set TabIndex = 9, DefaultValue = N'2141'
where sysTableID = @sysTableID
and FieldName = 'TKKH'

Update sysField set TabIndex = 10
where sysTableID = @sysTableID
and FieldName = 'TKCP'

Update sysField set TabIndex = 11
where sysTableID = @sysTableID
and FieldName = 'MaPhi'

Update sysField set TabIndex = 12
where sysTableID = @sysTableID
and FieldName = 'MaBP'

Update sysField set TabIndex = 13
where sysTableID = @sysTableID
and FieldName = 'MaVV'

Update sysField set TabIndex = 14
where sysTableID = @sysTableID
and FieldName = 'NguyenGia1'

Update sysField set TabIndex = 15
where sysTableID = @sysTableID
and FieldName = 'DaKH1'

Update sysField set TabIndex = 16
where sysTableID = @sysTableID
and FieldName = 'GTCL1'

Update sysField set TabIndex = 17
where sysTableID = @sysTableID
and FieldName = 'KHThang1'

Update sysField set TabIndex = 18
where sysTableID = @sysTableID
and FieldName = 'NguyenGia2'

Update sysField set TabIndex = 19
where sysTableID = @sysTableID
and FieldName = 'DaKH2'

Update sysField set TabIndex = 20
where sysTableID = @sysTableID
and FieldName = 'GTCL2'

Update sysField set TabIndex = 21
where sysTableID = @sysTableID
and FieldName = 'KHThang2'

Update sysField set TabIndex = 22
where sysTableID = @sysTableID
and FieldName = 'NguyenGia3'

Update sysField set TabIndex = 23
where sysTableID = @sysTableID
and FieldName = 'DaKH3'

Update sysField set TabIndex = 24
where sysTableID = @sysTableID
and FieldName = 'GTCL3'

Update sysField set TabIndex = 25
where sysTableID = @sysTableID
and FieldName = 'KHThang3'

Update sysField set TabIndex = 26
where sysTableID = @sysTableID
and FieldName = 'NguyenGia4'

Update sysField set TabIndex = 27
where sysTableID = @sysTableID
and FieldName = 'DaKH4'

Update sysField set TabIndex = 28
where sysTableID = @sysTableID
and FieldName = 'GTCL4'

Update sysField set TabIndex = 29
where sysTableID = @sysTableID
and FieldName = 'KHThang4'

Update sysField set TabIndex = 30
where sysTableID = @sysTableID
and FieldName = 'DTID'


--Cập nhập công thức
Update sysField set [Formula] = '@DaKH * (@NguyenGia1/@SoThang)'
where sysTableID = @sysTableID
and FieldName = 'DaKH1'

Update sysField set [Formula] = '@DaKH * (@NguyenGia2/@SoThang)'
where sysTableID = @sysTableID
and FieldName = 'DaKH2'

Update sysField set [Formula] = '@DaKH * (@NguyenGia3/@SoThang)'
where sysTableID = @sysTableID
and FieldName = 'DaKH3'

Update sysField set [Formula] = '@DaKH * (@NguyenGia4/@SoThang)'
where sysTableID = @sysTableID
and FieldName = 'DaKH4'

Update sysField set [Formula] = '@GTCL1/(@SoThang-@DaKH)'
where sysTableID = @sysTableID
and FieldName = 'KHThang1'

Update sysField set [Formula] = '@GTCL2/(@SoThang-@DaKH)'
where sysTableID = @sysTableID
and FieldName = 'KHThang2'

Update sysField set [Formula] = '@GTCL3/(@SoThang-@DaKH)'
where sysTableID = @sysTableID
and FieldName = 'KHThang3'

Update sysField set [Formula] = '@GTCL4/(@SoThang-@DaKH)'
where sysTableID = @sysTableID
and FieldName = 'KHThang4'

