/****** Object:  StoredProcedure [dbo].[EP9001]    Script Date: 07/29/2010 16:20:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





-------- Created by Nguyen Quoc Huy.
--------  Created Date 03.08.2007
------- Purpose: Automatic create New ID keys
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[EP9001]  @NewKey nvarchar(50) OUTPUT, 
				 @TableName  as nvarchar(250), 
				 @StringKey1 as nvarchar(50), 
				 @StringKey2 as nvarchar(50),
				 @StringKey3 as nvarchar(50), 
				 @S1Type as int, 
				 @S2Type as int, 
				 @S3Type as int, 
				 @OutputLen as int, 
				 @OutputOrder as int , 	   	--- 0 NSSS; 1 SNSS, 2 SSNS, 3 SSSN
				 @Seperated as int, 
				 @Seperator as nvarchar(1),
				 @TranMonth as int, 
				 @TranYear as int,
				 @DivisionID as nvarchar(50) 
  
AS



Declare @KeyString nvarchar(50),
	@LastKey int,
	@LastKeyChar nvarchar(50),
	@LastKeyLen int,
	@SeperatorCount int,
	@KeyStringLen int,
	@StringNumber nvarchar(50),
	@Seperator1 nvarchar (1),
	@Seperator2 nvarchar (1),
	@Seperator3 nvarchar (1)


SET NOCOUNT ON

If @S1Type = 1 
	Set @StringKey1 = Replace(Right(str(@TranMonth), 2), ' ', '0')
Else If @S1Type = 2
	Set @StringKey1 = Ltrim(Rtrim(@TranYear))
Else If @S1Type = 3 --
	Set @StringKey1 = Ltrim(Rtrim(@StringKey1))
Else If @S1Type = 4
	Set @StringKey1 = Ltrim(Rtrim(@DivisionID))
Else If @S1Type = 5  --Hang so
	Set @StringKey1 = Ltrim(Rtrim(@StringKey1))
Else
	Set @StringKey1 = ''


If @S2Type = 1 
	Set @StringKey2 = Replace(Right(str(@TranMonth), 2), ' ', '0')
Else If @S2Type = 2
	Set @StringKey2 = LTrim(RTrim(@TranYear))
Else If @S2Type = 3 
	Set @StringKey2 = LTrim(Rtrim(@StringKey2))
Else If @S2Type = 4
	Set @StringKey2 = Ltrim(Rtrim(@DivisionID))
Else If @S2Type = 5  --Hang so
	Set @StringKey2 = Ltrim(Rtrim(@StringKey2))
Else
	Set @StringKey2 = ''


If @S3Type = 1 
	Set @StringKey3 = Replace(Right(str(@TranMonth), 2), ' ', '0')
Else If @S3Type = 2
	Set @StringKey3 = LTrim(RTrim(@TranYear))
Else If @S3Type = 3 
	Set @StringKey3 = LTrim(Rtrim(@StringKey3))
Else If @S3Type = 4
	Set @StringKey3 = Ltrim(Rtrim(@DivisionID))
Else If @S3Type = 5  --Hang so
	Set @StringKey3 = Ltrim(Rtrim(@StringKey3))
Else
	Set @StringKey3 = ''


select @KeyString = @StringKey1 + @StringKey2 + @StringKey3

if exists (select  LastKey  from AT4444 where TableName = @TableName and KeyString = @KeyString AND DivisionID = @DivisionID)

	begin
		select @LastKey  =LastKey + 1 
		from  AT4444 
		where TableName = @TableName and KeyString = @KeyString AND DivisionID = @DivisionID
		update  AT4444 set LastKey = @LastKey where TableName = @TableName and KeyString = @KeyString AND DivisionID = @DivisionID
		
	end

else

	begin
		insert into  AT4444 (TableName, KeyString, LastKey) VALUES (@TableName, @KeyString, 1)
		select @LastKey = 1	

	end
select @LastKeyChar = LTRIM(STR(@LastKey))
select @LastKeyLen  = LEN(@LastKeyChar)

if @Seperated = 0

begin
	select @SeperatorCount = 0
	select @Seperator =SPACE(0)
end

else

begin

	select @SeperatorCount = 0

	if LEN(@StringKey1) > 0 
		begin
			select @SeperatorCount = 1
			select @Seperator1 = @Seperator
		end
	else
		begin
			select @Seperator1 = SPACE(0)
		end

	if LEN(@StringKey2) > 0 
		begin
			select @SeperatorCount = @SeperatorCount + 1
			select @Seperator2 = @Seperator
	             end
	else
		begin
			select @Seperator2 = SPACE(0)
		end


	if LEN(@StringKey3) > 0 
		begin
			select @SeperatorCount = @SeperatorCount + 1
			select @Seperator3= @Seperator
		end

	else
		begin
			select @Seperator3 = SPACE(0)
		end
end

select @StringNumber =   REPLICATE('0', @OutputLen - @LastKeyLen - @SeperatorCount  - LEN(@KeyString))  + @LastKeyChar
select @StringKey1 = LTRIM(UPPER(@StringKey1))
select @StringKey2 = LTRIM(UPPER(@StringKey2))
select @StringKey3 = LTRIM(UPPER(@StringKey3))

	Set 	@NewKey  = 
		(CASE @OutputOrder
			WHEN 3 THEN isnull(@StringKey1,'') + isnull(@Seperator1,'') + isnull(@StringKey2,'') + isnull(@Seperator2,'') + isnull(@StringKey3,'') + isnull(@Seperator3,'') + @StringNumber
			WHEN 1 THEN @StringKey1 +  isnull(@Seperator1,'') + @StringNumber +  isnull(@Seperator2,'') + @StringKey2 +isnull(@Seperator3 ,'')+ @StringKey3 
			WHEN 2 THEN @StringKey1 + isnull(@Seperator1,'') +  @StringKey2 + isnull(@Seperator2,'') + @StringNumber  + isnull(@Seperator3,'') + @StringKey3 
			WHEN 0 THEN @StringNumber + isnull(@Seperator1,'') + @StringKey1 +  isnull(@Seperator2 ,'')+  @StringKey2 + isnull( @Seperator3,'') + @StringKey3 
		 END)
--Select @NewKey  as NewKey

SET NOCOUNT OFF