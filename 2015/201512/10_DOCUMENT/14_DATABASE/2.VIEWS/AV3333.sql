
/****** Object:  View [dbo].[AV3333]    Script Date: 12/16/2010 15:47:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


---View chet

ALTER VIEW [dbo].[AV3333] as 

Select 'A01' as AnaTypeID,
	'Maõ phaân tích 1' as AnaTypeName, DivisionID
FROM AT1101	
Union
Select 'A02' as AnaTypeID,
	'Maõ phaân tích 2' as AnaTypeName, DivisionID
FROM AT1101
Union
Select 'A03' as AnaTypeID,
	'Maõ phaân tích 3' as AnaTypeName, DivisionID
FROM AT1101

GO


