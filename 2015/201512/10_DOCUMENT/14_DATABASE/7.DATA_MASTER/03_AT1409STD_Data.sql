-- <Summary>
---- Them vao module commission management
-- <History>
---- Create on 17/12/2013 by Khanh Van
---- Modified on ... by ...
---- <Example> 

IF not exists (Select top 1 1 From AT1409STD Where ModuleID = 'ASOFTCM')
	INSERT into AT1409STD (ModuleID, Description, DescriptionE)
	VALUES (N'ASOFTCM', N'Quản lý hoa hồng',N'Commission Management')