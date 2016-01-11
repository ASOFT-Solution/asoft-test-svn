-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
-- AnaTypeID S0
UPDATE OT1005STD SET SystemName = N'S01 - Mã phân tích 1', UserName = N'Nhân viên bán hàng', SystemNameE = N'S01 - Analysis code 1', UserNameE = N'Sale employee' WHERE AnaTypeID = 'S01'
UPDATE OT1005STD SET SystemName = N'S02 - Mã phân tích 2', UserName = N'Loại hàng', SystemNameE = N'S02 - Analysis code 2', UserNameE = N'Inventory type' WHERE AnaTypeID = 'S02'
UPDATE OT1005STD SET SystemName = N'S03 - Mã phân tích 3', UserName = N'S03 - Mã phân tích 3', SystemNameE = N'S03 - Analysis code 3', UserNameE = N'S03 - Analysis code 3' WHERE AnaTypeID = 'S03'
UPDATE OT1005STD SET SystemName = N'S04 - Mã phân tích 4', UserName = N'S04 - Mã phân tích 4', SystemNameE = N'S04 - Analysis code 4', UserNameE = N'S04 - Analysis code 4' WHERE AnaTypeID = 'S04' 
UPDATE OT1005STD SET SystemName = N'S05 - Mã phân tích 5', UserName = N'S05 - Mã phân tích 5', SystemNameE = N'S05 - Analysis code 5', UserNameE = N'S05 - Analysis code 5' WHERE AnaTypeID = 'S05' 
-- AnaTypeID P0
UPDATE OT1005STD SET SystemName = N'P01 - Mã phân tích 1', UserName = N'Nhân viên mua hàng', SystemNameE = N'P01 - Analysis code 1', UserNameE = N'Buy employee' WHERE AnaTypeID = 'P01' 
UPDATE OT1005STD SET SystemName = N'P02 - Mã phân tích 2', UserName = N'Loại hàng', SystemNameE = N'P02 - Analysis code 2', UserNameE = N'Inventory type' WHERE AnaTypeID = 'P02' 
UPDATE OT1005STD SET SystemName = N'P03 - Mã phân tích 3', UserName = N'Hải Quan', SystemNameE = N'P03 - Analysis code 3', UserNameE = N'Customs' WHERE AnaTypeID = 'P03'
UPDATE OT1005STD SET SystemName = N'P04 - Mã phân tích 4', UserName = N'P04 - Mã phân tích 4', SystemNameE = N'P04 - Analysis code 4', UserNameE = N'P04 - Analysis code 4' WHERE AnaTypeID = 'P04'
UPDATE OT1005STD SET SystemName = N'P05 - Mã phân tích 5', UserName = N'P05 - Mã phân tích 5', SystemNameE = N'P05 - Analysis code 5', UserNameE = N'P05 - Analysis code 5' WHERE AnaTypeID = 'P05'
-- Cập nhật OT1005
UPDATE OT1005 SET OT1005.SystemName = OT1005STD.SystemName, OT1005.SystemNameE = OT1005STD.SystemNameE FROM OT1005STD WHERE OT1005.AnaTypeID = OT1005STD.AnaTypeID
UPDATE OT1005 SET OT1005.UserName = OT1005STD.UserName FROM OT1005STD WHERE OT1005.AnaTypeID = OT1005STD.AnaTypeID AND ISNULL(OT1005.UserName, '') = ''
UPDATE OT1005 SET OT1005.UserNameE = OT1005STD.UserNameE FROM OT1005STD WHERE OT1005.AnaTypeID = OT1005STD.AnaTypeID AND ISNULL(OT1005.UserNameE, '') = ''