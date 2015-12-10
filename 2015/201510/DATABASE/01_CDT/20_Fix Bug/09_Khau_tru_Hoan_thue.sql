use [CDT]

declare @sysTableDTID int

SELECT @sysTableDTID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'DT36'

update sysField set [RefCriteria] = N'TK not in (select TK = case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)' 
WHERE sysTableID = @sysTableDTID AND FieldName = 'TK'

update sysField set [RefCriteria] = N'TK not in (select TK = case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)' 
WHERE sysTableID = @sysTableDTID AND FieldName = 'TKDU'