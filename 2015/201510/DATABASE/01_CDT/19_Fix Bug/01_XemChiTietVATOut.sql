use [CDT]

Update sysField set FormulaDetail = N'MaCT'
where sysTableID = (select sysTableID from sysTable where tableName = 'VATOut')
and FieldName = 'MaCT' and FormulaDetail is null 