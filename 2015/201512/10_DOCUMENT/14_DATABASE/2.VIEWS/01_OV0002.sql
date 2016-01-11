IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OV0002]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[OV0002]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Combo Trạng Thái
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 28/03/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 28/03/2012 by 
-- <Example>
---- 
CREATE VIEW OV0002
AS 
-----------Xử lý cho Trạng thái đơn hàng màn hình Chào bán
			SELECT 0 AS Status, N'0 : Chưa xử lý' AS Description, N'0 : Not Process' AS EDescription, 'QO' as TypeID, 1 AS Mode, DivisionID FROM AT1101 
 UNION ALL  SELECT 1 AS Status, N'1 : Đang xử lý' AS Description, N'1 : Process' AS EDescription, 'QO' as TypeID, 1 AS Mode, DivisionID FROM AT1101 
 UNION ALL  SELECT 2 AS Status, N'2 : Thành công' AS Description, N'2 : success' AS EDescription, 'QO' as TypeID, 1 AS Mode, DivisionID FROM AT1101 
 UNION ALL  SELECT 3 AS Status, N'3 : Thất bại'   AS Description, N'3 : Fail' AS EDescription, 'QO' as TypeID, 1 AS Mode, DivisionID FROM AT1101 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

