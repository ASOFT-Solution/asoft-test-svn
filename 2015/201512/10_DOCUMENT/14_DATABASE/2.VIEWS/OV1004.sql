

/****** Object:  View [dbo].[OV1004]    Script Date: 12/16/2010 14:45:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---Created by: Vo Thanh Huong, date: 27/12/2004
---purpose: view chet, tao du lieu ngam cho trang thai cua du toan nguyen vat lieu

ALTER VIEW [dbo].[OV1004] as 
Select 0 as Status, 'Chưa tính dự toán' as StatusName,DivisionID from AT1101
Union
Select 1 as Status, 'Đã tính dự toán' as StatusName,DivisionID from AT1101

GO


