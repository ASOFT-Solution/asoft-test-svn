
/****** Object:  View [dbo].[AV1310]    Script Date: 12/16/2010 14:58:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Van Nhan, Date 07/01/2005.
---- Purpose:  Xuly nhom theo mat hang
ALTER VIEW [dbo].[AV1310] as
Select 	DivisionID,
	S as ID, SName,
	'CI1' AS  TypeID,
	Disabled as Disabled
From AT1310 Where STypeID ='I01'
Union all
Select 	DivisionID,
	S as ID, SName,
	'CI2' AS  TypeID,
	Disabled as Disabled
From AT1310 Where STypeID ='I02'
Union all
Select 	DivisionID,
	S as ID, SName,
	'CI3' AS  TypeID,
	Disabled as Disabled
From AT1310 Where STypeID ='I03'
Union ALL
Select 	DivisionID,
	AnaID as ID,
	AnaName as SName,
	AnaTypeID as TypeID,
	Disabled
From AT1015

GO


