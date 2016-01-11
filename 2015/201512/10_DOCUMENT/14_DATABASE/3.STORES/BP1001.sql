IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[BP1001]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[BP1001]
GO
/****** Object:  StoredProcedure [dbo].[BP1001]    Script Date: 07/30/2010 10:05:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/
CREATE PROCEDURE [dbo].[BP1001]
				@VoucherDate Datetime,
				@TableID nvarchar(50),
				@VoucherID nvarchar(50), 
				@TransactionID nvarchar(50), 
				@InventoryID nvarchar(50), 
				@Orders int, 
				@Quantity decimal

AS

DECLARE

	@StringKey1 nvarchar(50), 
	@StringKey2 nvarchar(50),
	@StringKey3 nvarchar(50), 
	@OutputLen int, 
	@OutputOrder int,
	@Separated int, 
	@Separator char(1),
	@Enabled1 tinyint, 
	@Enabled2 tinyint,
	@Enabled3 tinyint,
	@S1 nvarchar(50), 
	@S2 nvarchar(50),
	@S3 nvarchar(50),
	@SS1 nvarchar(50), 
	@SS2 nvarchar(50),
	@SS3 nvarchar(50),
	@S1Type tinyint, 
	@S2Type tinyint,
	@S3Type tinyint, 
	
	@Year nvarchar(4),
	@Month nvarchar(2),
	@Day nvarchar(2),
	@SeriID nvarchar(50),
	@SeriNo nvarchar(50),
	@Count as int,
	@i as int

SET @Day = Case When Day(@VoucherDate)<10 Then '0' + ltrim(Day(@VoucherDate)) Else ltrim(Day(@VoucherDate)) End
SET @Month = Case When Month(@VoucherDate)<10 Then '0' + ltrim(Month(@VoucherDate)) Else ltrim(Month(@VoucherDate)) End
SET @Year = ltrim(Year(@VoucherDate))


Select @Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,@S1=S1,@S2=S2,@S3=S3,@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
	@OutputLen = OutputLength, @OutputOrder=OutputOrder,@Separated=Separated,@Separator=Separator, @SS1=SS1,@SS2=SS2,@SS3=SS3
From AT1302 Where InventoryID = @InventoryID

---@S1Type: 0: H?ng s?, 1: dd-mm-yyyy, 2:ddmmyyyy, 3:PL1, 4:PL2, 5:PL3, 6:InventoryID

If @Enabled1 = 1
	Set @StringKey1 = 
	Case @S1Type 
	When 0 Then @SS1
	When 1 Then @Day + '-' + @Month + '-' + @Year
	When 2 Then @Day + @Month + @Year
	When 3 Then @S1
	When 4 Then @S2
	When 5 Then @S3
	When 6 Then @InventoryID
	Else '' End
Else
	Set @StringKey1 = ''

If @Enabled2 = 1
	Set @StringKey2 = 
	Case @S2Type 
	When 0 Then @SS2
	When 1 Then @Day + '-' + @Month + '-' + @Year
	When 2 Then @Day + @Month + @Year
	When 3 Then @S1
	When 4 Then @S2
	When 5 Then @S3
	When 6 Then @InventoryID
	Else '' End
Else
	Set @StringKey2 = ''

If @Enabled3 = 1
	Set @StringKey3 = 
	Case @S3Type 
	When 0 Then @SS3
	When 1 Then @Day + '-' + @Month + '-' + @Year
	When 2 Then @Day + @Month + @Year
	When 3 Then @S1
	When 4 Then @S2
	When 5 Then @S3
	When 6 Then @InventoryID
	Else '' End
Else
	Set @StringKey3 = ''

SET @Count = Round(@Quantity,0)
SET @i =1

While @i <= @Count
Begin
	EXEC AP0000 @SeriID OUTPUT, 'BT1001', 'BT', @Year, '', 16
	EXEC AP0000 @SeriNo OUTPUT, 'BT1001', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator

	If len(@SeriNo)>0
	Begin
		Insert Into BT1001 (SeriID,TableID, VoucherID, TransactionID, InventoryID, Orders, SeriNo)
		Values (@SeriID,@TableID, @VoucherID, @TransactionID, @InventoryID, @Orders, @SeriNo)
	End

	SET @i = @i + 1	
End