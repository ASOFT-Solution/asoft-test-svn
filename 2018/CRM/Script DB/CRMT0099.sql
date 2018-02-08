DECLARE @CodeMaster VARCHAR(50), @OrderNo INT, @ID VARCHAR(50), @Description NVARCHAR(250), @DescriptionE NVARCHAR(250), @Disabled TINYINT, @LanguageID VARCHAR(50) = NULL
----------Phân loại Yêu cầu
SET @CodeMaster = 'CRMT00000025' 
SET @OrderNo = 1  
SET @ID = '1' 
SET @Description = N'Hỗ trợ' 
SET @DescriptionE = N'Support' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------
SET @OrderNo = 2  
SET @ID = '2' 
SET @Description = N'Lỗi/Vấn đề' 
SET @DescriptionE = N'Bug/Issue' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
----------
SET @OrderNo = 3  
SET @ID = '3' 
SET @Description = N'Phàn nàn' 
SET @DescriptionE = N'Complain' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
----------
SET @OrderNo = 4  
SET @ID = '4' 
SET @Description = N'Chức năng mới' 
SET @DescriptionE = N'New function' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
----------
SET @OrderNo = 5  
SET @ID = '5' 
SET @Description = N'Báo giá' 
SET @DescriptionE = N'Quotation' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 

----------Phân loại Bug
SET @CodeMaster = 'CRMT00000026' 
SET @OrderNo = 1  
SET @ID = '1' 
SET @Description = N'Dùng chung' 
SET @DescriptionE = N'Is common' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
---------
SET @OrderNo = 2  
SET @ID = '2' 
SET @Description = N'Vấn đề lặp lại' 
SET @DescriptionE = N'Repeat Problem' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 
----------
SET @OrderNo = 3  
SET @ID = '3' 
SET @Description = N'Dừng chương trình' 
SET @DescriptionE = N'Stop program' 
SET @Disabled = 0 
IF NOT EXISTS (SELECT TOP 1 1 FROM CRMT0099 WHERE CodeMaster = @CodeMaster AND ID = @ID) INSERT INTO CRMT0099 (CodeMaster, OrderNo, ID, [Description],DescriptionE, [Disabled]) VALUES (@CodeMaster, @OrderNo, @ID, @Description, @DescriptionE, @Disabled) ELSE UPDATE CRMT0099 SET OrderNo = @OrderNo, [Description] = @Description,DescriptionE = @DescriptionE, [Disabled] =@Disabled WHERE CodeMaster = @CodeMaster AND ID = @ID 