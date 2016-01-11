/****** Object: View [dbo].[MV0005] Script Date: 12/16/2010 09:33:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date : 15/11/2004
---purpose: Tao du lieu ngam cho tinh trang ke hoach san xuat

--Hoang Phuoc: 15/12/2010
-- Sửa font
ALTER VIEW [dbo].[MV0005] as ---view chet

SELECT '0' AS Status, N'MFML000218' AS Description, DivisionID from AT1101
UNION
SELECT '1' AS Status, N'MFML000219' AS Description, DivisionID from AT1101
UNION
SELECT '2' AS Status, N'MFML000220' AS Description, DivisionID from AT1101
UNION
SELECT '3' AS Status, N'MFML000221' AS Description, DivisionID from AT1101
UNION
SELECT '4' AS Status, N'MFML000222' AS Description, DivisionID from AT1101
UNION
SELECT '9' AS Status, N'MFML000223' AS Description, DivisionID from AT1101

GO


