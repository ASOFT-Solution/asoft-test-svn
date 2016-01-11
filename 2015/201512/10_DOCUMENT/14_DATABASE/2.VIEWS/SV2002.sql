IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[SV2002]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[SV2002]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Loại nghiệp vụ trong đề xuất sửa xóa phiếu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 15/10/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 28/01/2013 by Lê Thị Thu Hiền
-- <Example>
---- 
CREATE VIEW SV2002

AS 

SELECT TransactionTypeID, [Description], DescriptionE FROM AT1008STD
UNION ALL
SELECT N'WF0011' AS TransactionTypeID, N'Phiếu nhập kho' AS Description, N'Receive Voucher' AS DescriptionE 
UNION ALL
SELECT N'WF0012' AS TransactionTypeID, N'Phiếu xuất kho' AS Description, N'Delivery Voucher' AS DescriptionE 
UNION ALL
SELECT N'WF0013' AS TransactionTypeID, N'Vận chuyển nội bộ' AS Description, N'Transport to other warehouse' AS DescriptionE 
UNION ALL
SELECT N'WF0015' AS TransactionTypeID, N'Xuất kho theo bộ' AS Description, N'Delivery Voucher according to item' AS DescriptionE 
UNION ALL
SELECT N'WF0018' AS TransactionTypeID, N'Phiếu kiểm kê kho' AS Description, N'Stock-taking' AS DescriptionE 
UNION ALL
SELECT N'OF0041' AS TransactionTypeID, N'Chào giá' AS Description, N'Quotation' AS DescriptionE 
UNION ALL
SELECT N'OF0027' AS TransactionTypeID, N'Đơn hàng bán' AS Description, N'Sale Orders' AS DescriptionE 
UNION ALL
SELECT N'OF0073' AS TransactionTypeID, N'Yêu cầu mua hàng' AS Description, N'Order request' AS DescriptionE 
UNION ALL
SELECT N'OF0051' AS TransactionTypeID, N'Đơn hàng mua' AS Description, N'Purchase Orders' AS DescriptionE 
UNION ALL
SELECT N'MF0018' AS TransactionTypeID, N'Kết quả sản xuất thành phẩm' AS Description, N'Manufacture result Finished product' AS DescriptionE 
UNION ALL
SELECT N'MF0019' AS TransactionTypeID, N'Kết quả sản xuất dở dang cuối kỳ' AS Description, N'Manufacture result Unfinished product' AS DescriptionE 



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

