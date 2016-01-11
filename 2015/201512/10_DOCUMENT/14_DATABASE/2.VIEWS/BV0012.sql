IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[BV0012]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[BV0012]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Đổ nguồn các cột để thiết lập báo cáo quản trị
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 18/02/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 18/02/2013 by 
-- <Example>
---- SELECT Code, Description FROM BV0012 WHERE FormID = 'AF0141' AND ID = 'X'
----
CREATE VIEW BV0012

AS 
-------- AF0141 Báo cáo tài chính dạng 1-----------
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnA' AS Code, 'ColumnA' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnB' AS Code, 'ColumnB' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnC' AS Code, 'ColumnC' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnD' AS Code, 'ColumnD' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnE' AS Code, 'ColumnE' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnF' AS Code, 'ColumnF' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnG' AS Code, 'ColumnG' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnH' AS Code, 'ColumnH' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnI' AS Code, 'ColumnI' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnJ' AS Code, 'ColumnJ' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnK' AS Code, 'ColumnK' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnL' AS Code, 'ColumnL' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnM' AS Code, 'ColumnM' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnN' AS Code, 'ColumnN' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnO' AS Code, 'ColumnO' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnP' AS Code, 'ColumnP' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnQ' AS Code, 'ColumnQ' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnR' AS Code, 'ColumnR' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnS' AS Code, 'ColumnS' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'X' AS ID, 'ColumnT' AS Code, 'ColumnT' AS Description

----------

UNION ALL
SELECT 'AF0141' AS FormID, 'Y' AS ID, 'Level00' AS Code, N'Nhóm 1' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'Y' AS ID, 'Level01' AS Code, N'Nhóm 2' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'Y' AS ID, 'Level02' AS Code, N'Nhóm 3' AS Description
UNION ALL
SELECT 'AF0141' AS FormID, 'Y' AS ID, 'Level03' AS Code, N'Nhóm 4' AS Description

-------- AF0150 Báo cáo tài chính dạng 2 -----------
UNION ALL
SELECT 'AF0150' AS FormID, 'X' AS ID, 'ColumnA' AS Code, 'ColumnA' AS Description
UNION ALL
SELECT 'AF0150' AS FormID, 'X' AS ID, 'ColumnB' AS Code, 'ColumnB' AS Description
UNION ALL
SELECT 'AF0150' AS FormID, 'X' AS ID, 'ColumnC' AS Code, 'ColumnC' AS Description
UNION ALL
SELECT 'AF0150' AS FormID, 'X' AS ID, 'ColumnD' AS Code, 'ColumnD' AS Description
UNION ALL
SELECT 'AF0150' AS FormID, 'X' AS ID, 'ColumnE' AS Code, 'ColumnE' AS Description
-------------
UNION ALL
SELECT 'AF0150' AS FormID, 'Y' AS ID, 'Level00' AS Code, N'Nhóm 1' AS Description
UNION ALL
SELECT 'AF0150' AS FormID, 'Y' AS ID, 'Level01' AS Code, N'Nhóm 2' AS Description


-------- AF0156 Báo cáo tài chính dạng 3-----------
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnA' AS Code, 'ColumnA' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnB' AS Code, 'ColumnB' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnC' AS Code, 'ColumnC' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnD' AS Code, 'ColumnD' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnE' AS Code, 'ColumnE' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnF' AS Code, 'ColumnF' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnG' AS Code, 'ColumnG' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'X' AS ID, 'ColumnH' AS Code, 'ColumnH' AS Description

-------------
UNION ALL
SELECT 'AF0156' AS FormID, 'Y' AS ID, 'Level00' AS Code, N'Nhóm 1' AS Description
UNION ALL
SELECT 'AF0156' AS FormID, 'Y' AS ID, 'Level01' AS Code, N'Nhóm 2' AS Description

