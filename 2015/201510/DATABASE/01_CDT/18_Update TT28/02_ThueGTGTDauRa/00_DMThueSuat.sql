USE [CDT]

UPDATE [sysField] SET [sysField].[RefCriteria] = N'MaThue <> ''NHOM5''' 
FROM [sysField] 
INNER JOIN [sysTable] ON [sysTable].[sysTableID] = [sysField].[sysTableID]
WHERE [RefField] = 'MaThue' AND [RefTable] = 'DMThueSuat'
AND [sysTable].[TableName] IN ('VATIn', 'MT21', 'MT22', 'MT23', 'MT24', 'MT25')