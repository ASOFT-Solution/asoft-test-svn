use [CDT]

Update sysField set SmartView = 0
where sysTableID = (
select sysTableID from sysTable
where TableName = 'DT33')
and FieldName = 'TienCKNT' and SmartView = 1