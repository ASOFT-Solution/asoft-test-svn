USE [CDT]

Update sysFormatString set _Key = 'DonGia'
where FieldName = N'Gia_TTDB'
and _Key <> 'DonGia'

Update sysFormatString set _Key = 'ThueSuat'
where FieldName = N'ThueSuatTTDB'
and _Key <> 'ThueSuat'

Update sysFormatString set _Key = 'HeSo'
where FieldName = N'TyleCK'
and _Key <> 'HeSo'