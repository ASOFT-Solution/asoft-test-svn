-- <Summary>
---- 
-- <History>
---- Create on 05/01/2011 by Việt Khánh
---- Modified on ... by ...
---- <Example>
UPDATE AT1301STD SET InventoryTypeName = N'Hàng Hoá', InventoryTypeNameE = N'Commodity' WHERE InventoryTypeID = 'HH'
UPDATE AT1301STD SET InventoryTypeName = N'Công cụ, Phụ tùng', InventoryTypeNameE = N'Tools, parts' WHERE InventoryTypeID = 'CC'
UPDATE AT1301STD SET InventoryTypeName = N'Nguyên vật liệu', InventoryTypeNameE = N'Materials' WHERE InventoryTypeID = 'VL'
UPDATE AT1301STD SET InventoryTypeName = N'Thành phẩm, sản phẩm', InventoryTypeNameE = N'Finished products, products' WHERE InventoryTypeID = 'TP'
UPDATE AT1301STD SET InventoryTypeName = N'Khác', InventoryTypeNameE = N'Other' WHERE InventoryTypeID = 'KH'
UPDATE AT1301STD SET InventoryTypeName = N'Tài sản ', InventoryTypeNameE = N'Assets' WHERE InventoryTypeID = 'TS'
UPDATE AT1301STD SET InventoryTypeName = N'Nhiên liệu, phụ liệu', InventoryTypeNameE = N'Fuel, sub materials' WHERE InventoryTypeID = 'NL'
UPDATE AT1301STD SET InventoryTypeName = N'Dịch vụ', InventoryTypeNameE = N'Services' WHERE InventoryTypeID = 'DV'
-- Cập nhật AT1301
UPDATE AT1301 SET AT1301.InventoryTypeName = AT1301STD.InventoryTypeName FROM AT1301STD WHERE AT1301.InventoryTypeID = AT1301STD.InventoryTypeID AND ISNULL(AT1301.InventoryTypeName, '') = ''
UPDATE AT1301 SET AT1301.InventoryTypeNameE = AT1301STD.InventoryTypeNameE FROM AT1301STD WHERE AT1301.InventoryTypeID = AT1301STD.InventoryTypeID AND ISNULL(AT1301.InventoryTypeNameE, '') = ''