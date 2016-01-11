IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV2001]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV2001]
--Lấy tên loại đơn đơn hàng
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW AV2001
AS

Select 0 as ID, N'Đơn hàng bán' as Name
Union all
Select 1 as ID, N'Đơn hàng điều chỉnh' as Name
Union all
Select 3 as ID, N'Đủ' as Name
Union all
Select 4 as ID, N'Thiếu' as Name
Union all
Select 5 as ID, N'Thành phẩm' as Name
Union all
Select 6 as ID, N'Bán thành phẩm' as Name

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
