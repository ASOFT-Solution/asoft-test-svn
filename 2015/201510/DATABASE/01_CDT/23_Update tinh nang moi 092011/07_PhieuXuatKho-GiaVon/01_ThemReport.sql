USE [CDT]

DECLARE @sysTableID INT

select @sysTableID = sysTableID from sysTable
					where tableName = 'DT32'
					
Update sysTable set  Report = 'HDBHDATIN,HDBHTUIN,HDBLE,INPXK-GB,INPXK-GV'
where sysTableID = @sysTableID
and sysPackageID = 8
and Report = 'HDBHDATIN,HDBHTUIN,HDBLE,INPXK-GB'
