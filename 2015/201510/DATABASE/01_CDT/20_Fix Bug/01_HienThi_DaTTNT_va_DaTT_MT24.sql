USE [CDT]

DECLARE
@sysTableID INT

SELECT @sysTableID = [sysTableID] FROM [sysTable] WHERE [TableName] = 'MT24'

UPDATE [sysField] SET [Visible] = 1 WHERE [sysTableID] = @sysTableID AND [FieldName] = 'DaTTNT'
UPDATE [sysField] SET [Visible] = 1 WHERE [sysTableID] = @sysTableID AND [FieldName] = 'DaTT'