USE [CDT]

DECLARE @sysTableID INT

SELECT @sysTableID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT25'

UPDATE [sysField] SET [Formula] = N'@TtienHNT+@TthueNT' 
WHERE [sysTableID] = @sysTableID AND [FieldName] = 'TtienNT'
and [Formula] <> N'@TtienHNT+@TthueNT' 
