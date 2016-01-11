IF EXISTS(SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HV0300]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[HV0300]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW HV0300 as

Select '0' as ConditionTypeID, N'Sẩy thai' as ConditionTypeName, 5 as HomeDays, 'H01' as TypeID, DivisionID
FROM AT1101
UNION
Select '1' as ConditionTypeID, N'Sinh thường' as ConditionTypeName, 5 as HomeDays, 'H01' as TypeID, DivisionID
FROM AT1101
UNION
Select '2' as ConditionTypeID, N'Sinh đôi' as ConditionTypeName, 10 as HomeDays, 'H01' as TypeID, DivisionID
FROM AT1101
UNION
Select '3' as ConditionTypeID, N'Sinh mổ' as ConditionTypeName, 7 as HomeDays, 'H01' as TypeID, DivisionID
FROM AT1101

UNION
Select '0' as ConditionTypeID, N'Khám thai' as ConditionTypeName, 1 as HomeDays, 'H02' as TypeID, DivisionID
FROM AT1101
UNION
Select '1' as ConditionTypeID, N'Sẩy thai, nạo hút thai, thai chết lưu' as ConditionTypeName, 20 as HomeDays, 'H02' as TypeID, DivisionID
FROM AT1101
UNION
Select '2' as ConditionTypeID, N'Sinh con, nuôi con nuôi' as ConditionTypeName, 180 as HomeDays, 'H02' as TypeID, DivisionID
FROM AT1101
UNION
Select '3' as ConditionTypeID, N'Thực hiện các biện pháp tránh thai' as ConditionTypeName, 7 as HomeDays, 'H02' as TypeID, DivisionID
FROM AT1101

UNION
Select '0' as ConditionTypeID, N'Ốm dài ngày' as ConditionTypeName, 10 as HomeDays, 'H03' as TypeID, DivisionID
FROM AT1101
UNION
Select '1' as ConditionTypeID, N'Ốm mà có phẫu thuật' as ConditionTypeName, 7 as HomeDays, 'H03' as TypeID, DivisionID
FROM AT1101
UNION
Select '2' as ConditionTypeID, N'Khác' as ConditionTypeName, 5 as HomeDays, 'H03' as TypeID, DivisionID
FROM AT1101

UNION
Select '0' as ConditionTypeID, N'Bản thân ốm ngắn ngày' as ConditionTypeName, NULL as HomeDays, 'H04' as TypeID, DivisionID
FROM AT1101
UNION
Select '1' as ConditionTypeID, N'Bản thân ốm dài ngày' as ConditionTypeName, NULL as HomeDays, 'H04' as TypeID, DivisionID
FROM AT1101
UNION
Select '2' as ConditionTypeID, N'Con ốm' as ConditionTypeName, NULL as HomeDays, 'H04' as TypeID, DivisionID
FROM AT1101