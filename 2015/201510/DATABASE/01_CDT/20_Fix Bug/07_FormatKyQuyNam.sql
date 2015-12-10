use [CDT]

declare @sysTableID int

-- MVATOut
select @sysTableID = sysTableID from sysTable where TableName = N'MVATOut'
update sysField set EditMask = '##' where sysTableID = @sysTableID and FieldName = N'KyBKBR' and isnull(EditMask,'') <> '##'
update sysField set EditMask = N'####' where sysTableID = @sysTableID and FieldName = N'NamBKBR' and isnull(EditMask,'') <> N'####'

-- MToKhai
select @sysTableID = sysTableID from sysTable where TableName = N'MToKhai'
update sysField set EditMask = N'##' where sysTableID = @sysTableID and FieldName = N'KyToKhai' and isnull(EditMask,'') <> N'##'
update sysField set EditMask = N'####' where sysTableID = @sysTableID and FieldName = N'NamToKhai' and isnull(EditMask,'') <> N'####'

-- MTTDBOut
select @sysTableID = sysTableID from sysTable where TableName = N'MTTDBOut'
update sysField set EditMask = N'##' where sysTableID = @sysTableID and FieldName = N'KyBKBRTTDB' and isnull(EditMask,'') <> N'##'
update sysField set EditMask = N'####' where sysTableID = @sysTableID and FieldName = N'NamBKBRTTDB' and isnull(EditMask,'') <> N'####'

-- MVATTNDN
select @sysTableID = sysTableID from sysTable where TableName = N'MVATTNDN'
update sysField set EditMask = N'#' where sysTableID = @sysTableID and FieldName = N'Quy' and isnull(EditMask,'') <> N'#'
update sysField set EditMask = N'##' where sysTableID = @sysTableID and FieldName = N'TuKy' and isnull(EditMask,'') <> N'##'
update sysField set EditMask = N'##' where sysTableID = @sysTableID and FieldName = N'DenKy' and isnull(EditMask,'') <> N'##'