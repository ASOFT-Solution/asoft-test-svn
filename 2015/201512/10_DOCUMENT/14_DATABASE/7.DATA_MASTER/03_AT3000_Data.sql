-- <Summary>
---- 
-- <History>
---- Create on 21/12/2010 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
If not exists(Select top 1 1 From AT3000 Where DivisionID = (Select top 1 DefDivisionID from AT0000) and ReportID = 'AR3214')
Insert into AT3000 (DivisionID,ReportID,ReportName,Pages,Page1,Page2)
Select top 1 DefDivisionID,N'AR3214',N'Hóa đơn GTGT',2, N'Lưu', N'Giao cho khách hàng' from AT0000
If not exists(Select top 1 1 From AT3000 Where DivisionID = (Select top 1 DefDivisionID from AT0000) and ReportID = 'AR3314')
Insert into AT3000 (DivisionID,ReportID,ReportName,Pages,Page1,Page2)
Select top 1 DefDivisionID,N'AR3314',N'Hóa đơn bán hàng',2, N'Lưu', N'Giao cho khách hàng' from AT0000
If not exists(Select top 1 1 From AT3000 Where DivisionID = (Select top 1 DefDivisionID from AT0000) and ReportID = 'AR3414')
Insert into AT3000 (DivisionID,ReportID,ReportName,Pages,Page1,Page2)
Select top 1 DefDivisionID,N'AR3414',N'Hóa đơn xuất khẩu',2, N'Lưu', N'Giao cho khách hàng' from AT0000
