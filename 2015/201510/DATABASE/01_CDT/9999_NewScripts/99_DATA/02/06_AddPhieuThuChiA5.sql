USE [CDT]

-- Add new report
Update sysTable 
set [Report] = N'INPCHI,INPCHIA5'
where TableName = N'DT12' 

Update sysTable 
set [Report] = N'INPTHU,INPTHUA5'
where TableName = N'DT11' 