IF EXISTS(SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV0321]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV0321]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW HV0321 as

Select 0 as TypeID, N'%' as TypeName, DivisionID
FROM AT1101
UNION
Select 1 as TypeID, N'Tăng lao động' as TypeName, DivisionID
FROM AT1101
UNION
Select 2 as TypeID, N'Tăng mức đóng' as TypeName, DivisionID
FROM AT1101
UNION
Select 3 as TypeID, N'Tăng bảo hiểm y tế' as TypeName, DivisionID
FROM AT1101
UNION
Select 4 as TypeID, N'Tăng bảo hiểm thất nghiệp' as TypeName, DivisionID
FROM AT1101
UNION
Select 5 as TypeID, N'Giảm lao động' as TypeName, DivisionID
FROM AT1101
UNION
Select 6 as TypeID, N'Giảm mức đóng' as TypeName, DivisionID
FROM AT1101
UNION
Select 7 as TypeID, N'Giảm bảo hiểm y tế' as TypeName, DivisionID
FROM AT1101
UNION
Select 8 as TypeID, N'Giảm bảo hiểm thất nghiệp' as TypeName, DivisionID
FROM AT1101