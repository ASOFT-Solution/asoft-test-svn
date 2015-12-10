USE [CDT]

DECLARE @sysTableID INT

select @sysTableID = sysTableID from sysTable
					where tableName = 'DT32'
					
Update sysTable set  Report = Report + ',HDBH-PXH'
where sysTableID = @sysTableID
and sysPackageID = 8
and Report not like '%HDBH-PXH%'