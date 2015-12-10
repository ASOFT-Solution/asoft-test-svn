USE [CDT]

DECLARE @sysTableID INT

select @sysTableID = sysTableID from sysTable
					where tableName = 'DT32'
					
Update sysTable set  Report = 'HDBHDATIN,HDBHTUIN,HDBLE'
where sysTableID = @sysTableID
and sysPackageID = 8
and Report = 'HDBHDATIN,HDBHTUIN'

Update sysField set Formula = N'@PSNT*@PCK/100'
where sysTableID = @sysTableID
and FieldName = 'CKNT'
and Formula = N'@TCKNT*@PS/@TTienHNT'