-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example> 
-- Thêm dữ liệu bảng OT1101STD
UPDATE OT1101STD SET LanguageID = 'OT1101.' + TypeID + '.' + RIGHT('00' + LTRIM(STR(OrderStatus)), 2)
-- Thêm dữ liệu bảng OT1101
UPDATE OT1101 SET OT1101.LanguageID = OT1101STD.LanguageID 
FROM OT1101 
LEFT JOIN OT1101STD ON OT1101.TypeID = OT1101STD.TypeID AND OT1101.OrderStatus = OT1101STD.OrderStatus 
