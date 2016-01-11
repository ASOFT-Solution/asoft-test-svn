-- <Summary>
---- Insert dữ liệu ngầm vào bảng MT0099 - Note: Khi Update không được sửa @CodeMaster và @ID
-- <History>
---- Create on 16/02/2015 by Phan thanh hoàng Vũ
---- Modified on ... by ...
---- <Example>
DECLARE @CodeMaster VARCHAR(50), @OrderNo INT, @ID VARCHAR(50), @Description NVARCHAR(250), @DescriptionE NVARCHAR(250), @Disabled TINYINT

------Tình trạng/Trạng thái-------
SET @CodeMaster = 'OrderStatus' 
SET @OrderNo = 1  
SET @ID = '0' 
SET @Description = N'0-Chưa hoàn tất' 
SET @DescriptionE = N'0-Chưa hoàn tất' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM MT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) 
	INSERT INTO MT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) 
	VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) 
ELSE 
	UPDATE MT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled 
	WHERE CodeMaster = @CodeMaster AND ID = @ID 
------Tình trạng/Trạng thái-------
SET @CodeMaster = 'OrderStatus' 
SET @OrderNo = 2  
SET @ID = '1' 
SET @Description = N'1-Hoàn tất' 
SET @DescriptionE = N'1-Hoàn tất' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM MT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) 
	INSERT INTO MT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) 
	VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) 
ELSE 
	UPDATE MT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled 
	WHERE CodeMaster = @CodeMaster AND ID = @ID 