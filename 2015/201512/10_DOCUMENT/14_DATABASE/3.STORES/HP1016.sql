IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1016]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1016]
GO
/****** Object:  StoredProcedure [dbo].[HP1016]    Script Date: 10/28/2011 10:04:05 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

--Create by: Dang Le Bao Quynh
--Create date: 17/07/2006
--Purpose: Get data from AT1302 (Danh muc san pham)
CREATE PROCEDURE [dbo].[HP1016] @DivisionID nvarchar(50)
AS
SET NOCOUNT ON
INSERT INTO HT1015(DivisionID, ProductID,ProductName,ProductTypeID,Disabled,MethodID,UnitPrice,Orders,CreateDate,CreateUserID,UnitID)
SELECT @DivisionID, InventoryID,InventoryName,InventoryTypeID,0,2,0,0,getDate(),'ASOFTADMIN',UnitID FROM AT1302 
WHERE Disabled=0 and DivisionID = @DivisionID
AND InventoryID NOT IN (SELECT ProductID FROM HT1015 WHERE DivisionID = @DivisionID)
AND InventoryTypeID IN (SELECT ProductTypeID FROM HT1018 WHERE Disabled=0 and DivisionID = @DivisionID)
GO




