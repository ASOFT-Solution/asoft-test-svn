-- <Summary>
---- Insert dữ liệu ngầm vào bảng OT0099 - Note: Khi Update không được sửa @CodeMaster và @ID
-- <History>
---- Create on 16/02/2015 by Phan thanh hoàng Vũ
---- Modified on ... by ...
---- <Example>
DECLARE @CodeMaster VARCHAR(50), @OrderNo INT, @ID VARCHAR(50), @Description NVARCHAR(250), @DescriptionE NVARCHAR(250), @Disabled TINYINT

------Loại đơn hàng-------
SET @CodeMaster = 'OrderTypeID' 
SET @OrderNo = 1  
SET @ID = '0' 
SET @Description = N'0-Đơn hàng bán' 
SET @DescriptionE = N'0-Đơn hàng bán' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM OT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) 
	INSERT INTO OT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) 
	VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) 
ELSE 
	UPDATE OT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled 
	WHERE CodeMaster = @CodeMaster AND ID = @ID 
------Loại đơn hàng-------
SET @CodeMaster = 'OrderTypeID' 
SET @OrderNo = 2  
SET @ID = '1' 
SET @Description = N'1-Đơn hàng điều chỉnh' 
SET @DescriptionE = N'1-Đơn hàng điều chỉnh' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM OT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) 
	INSERT INTO OT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) 
	VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) 
ELSE 
	UPDATE OT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled 
	WHERE CodeMaster = @CodeMaster AND ID = @ID 