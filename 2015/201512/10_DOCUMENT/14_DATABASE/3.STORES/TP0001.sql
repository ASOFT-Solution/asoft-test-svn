IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[TP0001]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[TP0001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
----- Create by Nguyen Van Nhan  
----- Date 09/12/2006  
---- Purpose: Cap nhat lai ma tang tu dong Doi tuong, Mat hang, TSCD  
----- Date 28/02/2008 Cap nhat lai ma tu dong cho nhan vien  
--- VD: OB-SI-S2-00001: 14: @Length
--- @Length: 14
-- @SLength: OB-SI-S2-: 9
CREATE PROCEDURE [dbo].[TP0001] 
	@DivisionID nvarchar(50),
	@TableName as nvarchar(20),  
    @Length as int,  
    @SLength as int  
AS  
  
Declare @Str as nvarchar(20),  
 @LastKey as int,  
 @Last as nvarchar(20),  
 @SEPARATOR as nvarchar(20),  
 @Cur as cursor,  
 @PhanNguyen as int,  
 @PhanTang as int,  
 @DodaiMa as int  
  
Set @PhanTang =@Length-@SLength  
---------===============================================================================================================  

-- TRONG TRUONG HOP MA SO TANG TU DONG CO SEPARATOR THI PHAI REPLACE TRUOC KHI UPDATE VAO TABLE AT4444
SELECT @SEPARATOR = SEPARATOR FROM AT0002 WHERE DivisionID = @DivisionID 
AND TABLEID = @TableName AND ISSEPARATOR = 1
 
If @TableName ='AT1202' --- Doi tuoong  
Begin  

SET @Cur = Cursor Static FOR   
SELECT Distinct left(ObjectID,@SLength), max(right(ObjectID,@PhanTang)) From AT1202   
Where Len(ObjectID)=@Length
And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
and S1 IS NOT NULL
Group by left(ObjectID,@SLength)  
Order by left(ObjectID,@SLength)  
  
--Select * from AT1202  
OPEN @Cur  
FETCH NEXT FROM @Cur INTO  @Str, @Last  
WHILE @@Fetch_Status = 0  
 Begin --- Cap nhat gia xuat kho thuong  
  Set @LastKey =0  
  set @LastKey = @last  
  DELETE FROM AT4444 WHERE TableName ='AT1202' and KeyString = @Str
  IF ISNULL(@SEPARATOR,'') <> ''
	SET @STR = REPLACE(@STR, @SEPARATOR,'')
	--PRINT @STR
	
  If not Exists (Select 1 From AT4444 Where TableName ='AT1202' and KeyString = @Str)  
   Insert AT4444 (DivisionID, TABLENAME, KEYSTRING, LASTKEY)  
   Values (@DivisionID, 'AT1202', @str, @LastKey)  
  else   
   Update AT4444 set LastKey =@LastKey  
   Where TableName ='AT1202' and KeyString = @Str  And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
   
  FETCH NEXT FROM @Cur INTO  @Str, @Last  
 End  
End  
  
---------===============================================================================================================  
If @TableName ='AT1302' --- Mat hang  
Begin  
SET @Cur = Cursor Static FOR   
SELECT Distinct left(InventoryID,@SLength), max(right(InventoryID,@PhanTang)) From AT1302   
Where Len(InventoryID)=@Length  
And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
Group by left(InventoryID,@SLength)  
Order by left(InventoryID,@SLength)  
  
OPEN @Cur  
FETCH NEXT FROM @Cur INTO  @Str, @Last  
WHILE @@Fetch_Status = 0  
 Begin   
  Set @LastKey =0    
  set @LastKey = @last 
  
  DELETE FROM AT4444 WHERE TableName ='AT1202' and KeyString = @Str
  IF ISNULL(@SEPARATOR,'') <> ''
	SET @STR = REPLACE(@STR, @SEPARATOR,'')
	--PRINT @STR
	   
  If not Exists (Select 1 From AT4444 Where TableName ='AT1302' and KeyString = @Str)  
   Insert AT4444 (DivisionID, TABLENAME, KEYSTRING, LASTKEY)  
   Values (@DivisionID, 'AT1302', @str, @LastKey)  
  else   
   Update AT4444 set LastKey =@LastKey  
   Where TableName ='AT1302' and KeyString = @Str And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)) 
  FETCH NEXT FROM @Cur INTO  @Str, @Last  
 End  
End  
  
---------===============================================================================================================  
If @TableName ='AT1503' --- Tai san co dinh  
Begin  
SET @Cur = Cursor Static FOR   
SELECT Distinct left(AssetID,@SLength), max(right(AssetID,@PhanTang)) From AT1503  
Where Len(AssetID)=@Length  
And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
Group by left(AssetID,@SLength)  
Order by left(AssetID,@SLength)  
  
OPEN @Cur  
FETCH NEXT FROM @Cur INTO  @Str, @Last  
WHILE @@Fetch_Status = 0  
 Begin   
  Set @LastKey =0    
  set @LastKey = @last    
  
  DELETE FROM AT4444 WHERE TableName ='AT1202' and KeyString = @Str
  IF ISNULL(@SEPARATOR,'') <> ''
	SET @STR = REPLACE(@STR, @SEPARATOR,'')
	--PRINT @STR
	
  If not Exists (Select 1 From AT4444 Where TableName ='AT1503' and KeyString = @Str)  
   Insert AT4444 (DivisionID, TABLENAME, KEYSTRING, LASTKEY)  
   Values (@DivisionID, 'AT1503', @str, @LastKey)  
  else   
   Update AT4444 set LastKey =@LastKey  
   Where TableName ='AT1503' and KeyString = @Str  And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
  FETCH NEXT FROM @Cur INTO  @Str, @Last  
 End  
End  
  
---------===============================================================================================================  
If @TableName ='HT1400' --- Nhan vien  
Begin  
SET @Cur = Cursor Static FOR   
SELECT Distinct left(EmployeeID,@SLength), max(right(EmployeeID,@PhanTang)) From HT1400   
Where Len(EmployeeID)=@Length  
And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
Group by left(EmployeeID,@SLength)  
Order by left(EmployeeID,@SLength)  
  
OPEN @Cur  
FETCH NEXT FROM @Cur INTO  @Str, @Last  
WHILE @@Fetch_Status = 0  
 Begin   
  Set @LastKey =0    
  Set @LastKey = @last    
  
  DELETE FROM AT4444 WHERE TableName ='AT1202' and KeyString = @Str
  IF ISNULL(@SEPARATOR,'') <> ''
	SET @STR = REPLACE(@STR, @SEPARATOR,'')
	--PRINT @STR
	
  If not Exists (Select 1 From AT4444 Where TableName ='HT1400' and KeyString = @Str)  
   Insert AT4444 (DivisionID, TABLENAME, KEYSTRING, LASTKEY)  
   Values (@DivisionID,'HT1400', @str, @LastKey)  
  else   
   Update AT4444 set LastKey =@LastKey  
   Where TableName ='HT1400' and KeyString = @Str  And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
  FETCH NEXT FROM @Cur INTO  @Str, @Last  
 End  
End