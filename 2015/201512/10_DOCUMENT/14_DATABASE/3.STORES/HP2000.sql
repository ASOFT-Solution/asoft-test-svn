
/****** Object:  StoredProcedure [dbo].[HP2000]    Script Date: 12/12/2011 10:38:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2000]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2000]
GO


/****** Object:  StoredProcedure [dbo].[HP2000]    Script Date: 12/12/2011 10:38:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



-----Created by Nguyen Van Nhan and Bich Phuong
---- Purpose: Kiem tra danh muc co duoc phep Xoa hay khong
---- Create 22/04/2004
-----Modify 18/5/2004 by Nguyen Lam Hoa
---- Created by: Hoàng Vũ on: 02/12/2015: Customize theo khách hàng SECOIN, check Xóa dữ liệu từ Loai sản phẩm bên HRM qua Loại mặt hàng bên CI. 
----add by: Vo Thanh Huong

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/


CREATE PROCEDURE [dbo].[HP2000] @DivisionID nvarchar(50),
				@TableName nvarchar(250), 
				@KeyValues as nvarchar(20)
 AS

Declare 	@Status as tinyint,
			@VMess as nvarchar(100),
			@EMess as nvarchar(100)

	Set @Status =0
	Set  @VMess=''
	Set @EMess =''

if @TableName='HT1001'  ----Daân toäc
    Begin 
	if Exists (Select top 1 1 From HV1400 Where EthnicID = @KeyValues and DivisionID = @DivisionID)
		Begin
			Set @Status=1 
			Set @VMess= N'HFML000034'--' D©n téc ' + @KeyValues + ' ®· ®­îc sö dông,b¹n kh«ng thÓ xãa!'
			Set @EMess=N'HFML000034'--'This ethnic ' + @KeyValues + 'has been used,you can not delete record!' 
			Goto MESS
		End 
    End	
If @TableName ='HT1101' --- to Nhom
     Begin
		If Exists (Select top 1 1 From HV1400 Where TeamID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess= N'HFML000035' --'Tæ nhãm '+ @KeyValues+' ®· ®­îc sö dông,b¹n kh«ng thÓ xãa! '
				Set @EMess = N'HFML000035' --'This team '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS
			End
     End

If @TableName ='HT1102' --- Chuc vu
     Begin
		If Exists (Select top 1 1 From HV1400 Where DutyID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000036' --'Chøc vô ' + @KeyValues+' ®· ®­îc sö dông,b¹n kh«ng thÓ xãa!'
				Set @EMess =N'HFML000036' --'This Duty '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS
			End
     End

If @TableName ='HT1103' --Doan the hiep hoi
     Begin
		If Exists (Select top 1 1 From HT1405 Where AssociationID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000037' --'§oµn thÓ '+ @KeyValues+' ®· ®­îc sö dông,b¹n kh«ng thÓ xãa!'
				Set @EMess =N'HFML000037' --'The '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End


If @TableName ='HT1002' -- T«n gi¸o
     Begin
		If Exists (Select top 1 1 From HV1400 Where ReligionID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000038' --'T«n gi¸o  '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000038' --'This Religion'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1003' -- Tr­êng häc
     Begin
		If Exists (Select top 1 1 From HT1301 Where SchoolID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000039' --'Tr­êng häc '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa!!  '
				Set @EMess =N'HFML000039' --'This school'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1004' -- Nganh hoc
  begin
		If Exists (Select top 1 1 From HT1301 Where MajorID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000040' --'Ngµnh häc '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000040' --'This Major'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1005' -- Trinh do hoc van
     Begin
		If Exists (Select top 1 1 From HV1400 Where EducationLevelID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000041' --'Tr×nh ®é '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000041' --'This EduacationLevel'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1006' -- trinh do ngoai ngu
     Begin
		If Exists (Select top 1 1 From HV1400  Where Language1ID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000042' --'Tr×nh ®é ngo¹i ng÷ '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000042' --'This Language'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
		If Exists (Select top 1 1 From HV1400  Where Language2ID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000042' --'Tr×nh ®é ngo¹i ng÷   '+ @KeyValues+' nµy ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000042' --'This Language'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End

		If Exists (Select top 1 1 From HV1400  Where Language3ID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000042' --'Tr×nh ®é ngo¹i ng÷   '+ @KeyValues+' nµy  ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000042' --'This Language'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1007' -- Cap do ngoai ngu
     Begin
		If Exists (Select top 1 1 From HV1400  Where LanguageLevel1ID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000043' --'CÊp ®é ngo¹i ng÷ '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000043' --'This LanguageLevel'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
		If Exists (Select top 1 1 From HV1400  Where LanguageLevel2ID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000043' --'CÊp ®é ngo¹i ng÷   '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000043' --'This LanguageLevel'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
		If Exists (Select top 1 1 From HV1400  Where LanguageLevel3ID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000043' --'CÊp ®é ngo¹i ng÷  '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000043' --'This LanguageLevel'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1008' -- Ngan hang
     Begin
		If Exists (Select top 1 1 From HV1400 Where BankID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000044' --'Ng©n hµng  '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000044' --'This Bank'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End

If @TableName ='HT1009' --Benh vien
     Begin
		If Exists (Select top 1 1 From HV1400 Where HospitalID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000045' --'BÖnh viÖn '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000045' --'This Hospital'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End

If @TableName ='HT1010' -- Trinh do chinh tri
     Begin
		If Exists (Select top 1 1 From HV1400 Where PoliticsID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000046' --'Tr×nh ®é chÝnh trÞ  '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000046' --'This Politics'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='AT1001' -- Quoc gia
     Begin
		If Exists (Select top 1 1 From HV1400 Where CountryID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000047' --'Quèc gia '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000047' --'This Country'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='AT1002' -- Tinh thµnh pho
     Begin
		If Exists (Select top 1 1 From HV1400 Where CityID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set @VMess=N'HFML000048' --'TØnh thµnh phè ' + @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000048' --'This City'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='AT1101' -- Don vi
     Begin
		If Exists (Select top 1 1 From HV1400 Where DivisionID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set @VMess=N'HFML000049' --'§¬n vÞ ' + @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000049' --'This Division'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End

		If Exists (Select top 1 1 From AT1102 Where DivisionID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set @VMess=N'HFML000049' --'§¬n vÞ ' + @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000049' --'This Division'+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End

If @TableName ='AT1102' -- Phong ban
     Begin
		If Exists (Select top 1 1 From HV1400 Where DepartmentID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set @VMess=N'HFML000050' --'Phßng ban ' + @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000050' --'This Department '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
		If Exists (Select top 1 1 From HT1101 Where DepartmentID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set @VMess=N'HFML000050' --'Phßng ban ' + @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000050' --'This Department '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End

If @TableName ='HT1011' -- Doi tuong thue
     Begin
		If Exists (Select top 1 1 From HV1400 Where TaxObjectID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set @VMess=N'HFML000051' --'Lo¹i thuÕ ' + @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa! '
				Set @EMess =N'HFML000051' --'This Tax '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1018' -- Loai san pham
     Begin
		If Exists (Select top 1 1 From HT1015 Where ProductTypeID = @KeyValues and DivisionID = @DivisionID
				   Union All
				   Select top 1 1 From AT1302 Where InventoryID = @KeyValues and DivisionID = @DivisionID
				
					)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000052' --' Lo¹i s¶n phÈm '+ @KeyValues+' ®· ®­îc sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000052' --'This ProductType '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End

If @TableName ='HT1015' -- San pham
     Begin
		If Exists (Select top 1 1 From HT1017 Where ProductID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000053' --' S¶n phÈm '+ @KeyValues+' ®· ®­îc chÊm c«ng b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000053' --'This Product '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End

If @TableName ='HT1019' -- San pham
     Begin
		If Exists (Select top 1 1 From HT1017 Where TimesID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000054' --' LÇn chÊm c«ng '+ @KeyValues+' ®· sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000054' --'This Time Absent '+ @KeyValues+' has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT2806' --Dieu kien phep
     Begin
		If Exists (Select top 1 1 From HT1403 Where LoaCondID = @KeyValues and DivisionID = @DivisionID)
			Begin	
				Set @Status = 1
				Set  @VMess=N'HFML000055' --' M· nµy ®· sö dông b¹n kh«ng thÓ xãa!  '
				Set @EMess =N'HFML000055' --'This value has been used, you can not delete record !'
				Goto  MESS

			End
     End
If @TableName ='HT1105' --Loại hợp đồng
 Begin
	If Exists (Select top 1 1 From HT1360 Where ContractTypeID = @KeyValues and DivisionID = @DivisionID)
		Begin	
			Set @Status = 1
			Set  @VMess=N'HFML000411' --' Loại hợp đồng đã được sử dụng, bạn không thể xóa!  '
			Set @EMess =N'HFML000411' --'This value has been used, you can not delete record !'
			Goto  MESS

		End
 End
MESS:
Select @Status as Status, @VMess as VieMessage, @EMess as EngMessage