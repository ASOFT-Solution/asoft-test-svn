-- <Summary>
---- Bổ sung nhóm Loại phiếu
-- <History>
---- Create on 11/10/2012 by Lê Thị Thu Hiền 
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017STD WHERE VoucherGroupID = '45')
INSERT INTO AT1017STD ( VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES ('45', N'Phiếu tiến độ giao hàng', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017STD WHERE VoucherGroupID = '46')
INSERT INTO AT1017STD ( VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES ('46', N'Lập phiếu yêu cầu mua hàng', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017STD WHERE VoucherGroupID = '47')
INSERT INTO AT1017STD ( VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES ('47', N'Lập phiếu tiến độ nhận hàng', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017STD WHERE VoucherGroupID = '48')
INSERT INTO AT1017STD ( VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES ('48', N'Dự trù kinh phí sản xuất', 0, 1)
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1017STD WHERE VoucherGroupID = '49')
INSERT INTO AT1017STD ( VoucherGroupID, [Description], [Disabled], IsUsed ) VALUES ('49', N'Phiếu điều chỉnh đơn hàng', 0, 1)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT1017STD WHERE VoucherGroupID ='25')
INSERT INTO AT1017STD
(
	VoucherGroupID,
	[Description],
	[Disabled],
	IsUsed
)
VALUES
(
	'25',
    N'Hàng mua trả lại',
	0,
	1
)