USE [CDT]

-- Add new report
Update sysTable 
set [Report] = N'INPMHANG,HDMH1'
where TableName = N'DT22' 