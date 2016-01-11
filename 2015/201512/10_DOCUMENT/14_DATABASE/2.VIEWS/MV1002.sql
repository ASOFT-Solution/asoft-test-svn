/****** Object:  View [dbo].[MV1002]    Script Date: 12/16/2010 15:24:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 25/11/2004
---purpose: Nguon du lieu ke thua cho du toan nguyen vat lieu (view chet)

ALTER VIEW [dbo].[MV1002]  as

Select 0 as Status, 'Chưa tính dự toán' as StatusName, DivisionID
From AT1101
Union
Select 1 as Status, 'Đã tính dự toán' as StatusName, DivisionID
From AT1101