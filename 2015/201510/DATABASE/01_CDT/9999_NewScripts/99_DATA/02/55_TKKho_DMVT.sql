-- [ACC_SALA] Thêm tài khoản kho 611 vào Danh mục VTHH
USE [CDT]
declare @sysTableID int

select @sysTableID = sysTableID from sysTable 
where TableName = 'DMVT'

Update sysField set RefCriteria = N'(TK like ''211%'' or TK like ''15%'' or TK like ''611%'') and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'
where sysTableID = @sysTableID
and RefCriteria = N'(TK like ''211%'' or TK like ''15%'') and TK not in (select  TK=case when TKMe is null then '''' else TKMe end from DMTK group by TKMe)'
and FieldName = 'TKkho' 