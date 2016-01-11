IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[PQ2222]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[PQ2222]
GO

/****** Object:  View [dbo].[PQ2222]    Script Date: 12/16/2010 15:40:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Create By: Dang Le Bao Quynh; Date: 06/05/2009
--Purpose: View chet luu tru danh muc tình tr?ng don hng.

CREATE VIEW [dbo].[PQ2222]
AS
SELECT     0 AS OrderStatus, 'Chưa chấp nhận' AS Description, 0 AS Orders, DivisionID from AT1101
UNION
SELECT     1 AS OrderStatus, 'Chấp nhận' AS Description, 1 AS Orders, DivisionID from AT1101
UNION
SELECT     2 AS OrderStatus, 'Chuẩn bị sản xuất' AS Description, 2 AS Orders, DivisionID from AT1101
UNION
SELECT     3 AS OrderStatus, 'Đang sản xuất' AS Description, 3 AS Orders, DivisionID from AT1101
UNION
SELECT     4 AS OrderStatus, 'Đã sản xuất' AS Description, 4 AS Orders, DivisionID from AT1101
UNION
SELECT     5 AS OrderStatus, 'Đang giao hàng' AS Description, 5 AS Orders, DivisionID from AT1101
UNION
SELECT     6 AS OrderStatus, 'Hoàn tất' AS Description, 6 AS Orders, DivisionID from AT1101
UNION
SELECT     8 AS OrderStatus, 'Tạm dừng sản xuất' AS Description, 7 AS Orders, DivisionID from AT1101
UNION
SELECT     9 AS OrderStatus, 'Hủy bỏ' AS Description, 8 AS Orders, DivisionID from AT1101

GO
