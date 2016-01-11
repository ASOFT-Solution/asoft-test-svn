
/****** Object:  View [dbo].[OV1002]    Script Date: 12/16/2010 14:43:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh huong
---Created date: 11/08/2004
---purpose: Tao du lieu ngam: Hình th?c giao hàng
 
ALTER VIEW [dbo].[OV1002] as

---Don hang mua
Select 0 as OrderType, 'Thương mại' as Description, 'SO' as TypeID,DivisionID from AT1101
Union
Select 1 as OrderType, 'Sản xuất' as Description, 'SO' as TypeID,DivisionID from AT1101
Union
Select 2 as OrderType, 'Dịch vụ' as Description, 'SO' as TypeID,DivisionID from AT1101
Union
Select 9 as OrderType, 'Khác' as Description, 'SO' as TypeID,DivisionID from AT1101
Union

---Don hang mua
Select 0 as OrderType, 'Chưa xác định' as Description, 'PO' as TypeID,DivisionID from AT1101

GO


