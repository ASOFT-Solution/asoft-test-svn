IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WV0001]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[WV0001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Đổ nguồn cho các Combo
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created on 09/06/2014 by Le Thi Thu Hien : Đổ nguồn Combo StatusID nghiệp vụ phiếu yêu cầu VCNB
---- Modified on 
-- <Example>
---- 

CREATE VIEW WV0001
AS 
---------------------------- StatusID của phiếu yêu cầu vận chuyển nội bộ ------------------------------
SELECT 'Status' AS TypeID, '0' AS Code, N'Chưa thực hiện' AS [Description], 'Non-Execute' AS DescriptionE, 0 AS [Disabled]
UNION ALL
SELECT 'Status' AS TypeID, '1' AS Code, N'Đang thực hiện' AS [Description], 'Execute' AS DescriptionE, 0 AS [Disabled]
UNION ALL
SELECT 'Status' AS TypeID, '8' AS Code, N'Hoàn tất' AS [Description], 'Complete' AS DescriptionE, 0 AS [Disabled]
UNION ALL
SELECT 'Status' AS TypeID, '9' AS Code, N'Hủy bỏ' AS [Description], 'Cancel' AS DescriptionE, 0 AS [Disabled]



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
