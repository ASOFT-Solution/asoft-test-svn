IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1018]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1018]
GO
/****** Object:  StoredProcedure [dbo].[HP1018]    Script Date: 11/11/2011 14:54:11 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


--Create by: Dang Le Bao Quynh
--Create date: 17/07/2006
--Purpose: Get data from AT1301 (Danh muc loai san pham)
CREATE PROCEDURE [dbo].[HP1018] @DivisionID nvarchar(50)
AS
SET NOCOUNT ON
INSERT INTO HT1018(DivisionID,ProductTypeID ,ProductType,Disabled,CreateUserID,CreateDate, LastModifyUserID ,LastModifyDate)  
SELECT @DivisionID, InventoryTypeID,InventoryTypeName,1,'ASOFTADMIN',getDate(),'ASOFTADMIN',getDate() FROM AT1301  
WHERE Disabled=0 and DivisionID = @DivisionID
AND InventoryTypeID NOT IN(SELECT ProductTypeID FROM HT1018 WHERE DivisionID = @DivisionID)
GO
