use [CDT]

Update sysField set EditMask='#', MinValue = 0
where sysTableID = (
select sysTableID from sysTable 
where TableName = 'DMVT')
and FieldName = 'LoaiVt'
and MinValue = 1

-- Dictionary
if not exists (select top 1 1 from Dictionary where Content = N'Loại vật tư phải từ 1 đến 8')
	insert into Dictionary(Content, Content2) Values (N'Loại vật tư phải từ 1 đến 8',N'Material type must be between 1 and 8')
