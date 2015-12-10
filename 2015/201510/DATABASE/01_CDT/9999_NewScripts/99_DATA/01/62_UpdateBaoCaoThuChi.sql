Use CDT

--01- Bảng kê phiếu thu
Update sysReport set Query = N'Select MaCT, NgayCT, SoCT, MaKH,
(select top 1 case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = b.MaKH) as TenKH, DienGiai, TK, TKDu, PsNo, MaNT, TyGia, 
  PsNoNT, MaBP, MaPhi, MaVV, MaSP, MaCongTrinh, OngBa
From BLTK b
where psno>0 and tk like ''11%'' and @@ps
order by ngayct, soct'
where ReportName = N'Bảng kê phiếu thu'

---Update filter
declare @sysReportID int,
		@sysFieldTKCo int,
		@sysFieldTKNo int,
		@sysFieldTKDu int,
		@sysFieldTK int

select @sysReportID = sysReportID from sysReport
where ReportName = N'Bảng kê phiếu thu'

select @sysFieldTKCo = sysFieldID from SysField
				where FieldName = 'TKCo'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DT11')

select @sysFieldTKNo = sysFieldID from SysField
				where FieldName = 'TKNo'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT11')

select @sysFieldTKDu = sysFieldID from SysField
				where FieldName = 'TKDu'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

select @sysFieldTK = sysFieldID from SysField
				where FieldName = 'TK'
				and sysTableID = (select sysTableID from sysTable where TableName = 'BLTK')

--Update report filter			
--TKNo --> TKDu
Update [sysReportFilter] set [sysFieldID] = @sysFieldTKDu
where [sysFieldID] = @sysFieldTKNo and sysReportID = @sysReportID

--TKCo --> TK
Update [sysReportFilter] set FilterCond = N'TK like ''11%''' , [sysFieldID] = @sysFieldTK
where [sysFieldID] = @sysFieldTKCo and sysReportID = @sysReportID


--Update cấu hình report
Update sysReport set dtTableID = null,mtAlias = null, mtTableID = (select top 1 sysTableID from sysTable where TableName = N'BLTK') 
where sysReportID = @sysReportID

--01- Bảng kê phiếu chi

Update sysReport set Query = N'Select MaCT, NgayCT, SoCT, MaKH,
(select top 1 case when @@lang = 1 then h.tenkh2 else h.tenkh end from dmkh h where h.makh = b.MaKH) as TenKH, DienGiai, TK, TKDu, PsCo, MaNT, TyGia, 
  PsCoNT, MaBP, MaPhi, MaVV, MaSP, MaCongTrinh, OngBa
From BLTK b
where psco>0 and tk like ''11%'' and @@ps
order by ngayct, soct'
where ReportName = N'Bảng kê phiếu chi'

select @sysFieldTKCo = sysFieldID from SysField
				where FieldName = 'TKCo'
				and sysTableID = (select sysTableID from sysTable where TableName = 'MT12')

select @sysFieldTKNo = sysFieldID from SysField
				where FieldName = 'TKNo'
				and sysTableID = (select sysTableID from sysTable where TableName = 'DT12')

---Update filter
select @sysReportID = sysReportID from sysReport
where ReportName = N'Bảng kê phiếu chi'

--TKco --> TKDu
Update [sysReportFilter] set [sysFieldID] = @sysFieldTKDu
where [sysFieldID] = @sysFieldTKCo and sysReportID = @sysReportID

--TKNo --> TK
Update [sysReportFilter] set FilterCond = N'TK like ''11%''' , [sysFieldID] = @sysFieldTK
where [sysFieldID] = @sysFieldTKNo and sysReportID = @sysReportID

--Update cấu hình report
Update sysReport set dtTableID = null,mtAlias = null, mtTableID = (select top 1 sysTableID from sysTable where TableName = N'BLTK') 
where sysReportID = @sysReportID
