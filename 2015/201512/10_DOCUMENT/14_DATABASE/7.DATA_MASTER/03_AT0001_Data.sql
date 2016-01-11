-- <Summary>
---- 
-- <History>
---- Create on 12/06/2015 by Huỳnh Tấn Phú
---- Modified on ... by ...: 
---- <Example>
---- Add Data
UPDATE AT0001 SET DBVersion ='8.0.R88.20150612'
UPDATE AT0001 SET PeriodNum = 12 WHERE PeriodNum IS NULL
If not exists (Select Top 1 1 From syscolumns Where id = Object_id('AT0001') And Name = 'Release') 
Begin
	Alter Table  AT0001 Add Release varchar(50) Null
end

If exists (Select Top 1 1 From syscolumns Where id = Object_id('AT0001') And Name = 'Release') 
Begin
	Alter Table  AT0001 Drop column Release
end
--UPDATE AT0001 SET Release ='8.0.R8.04072011'