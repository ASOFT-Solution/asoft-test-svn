USE [CDT]
GO

update sysTable
Set Report = 'INHDDVU,INHDDVUTUIN'
Where TableName = 'DT31' and Report = 'INHDDVU'

update sysTable
Set Report = 'HDBHDATIN,HDBHTUIN'
Where TableName = 'DT32' and Report = 'HDBHDATIN'