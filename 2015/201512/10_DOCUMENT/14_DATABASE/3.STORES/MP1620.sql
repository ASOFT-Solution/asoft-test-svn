
/****** Object:  StoredProcedure [dbo].[MP1620]    Script Date: 07/29/2010 15:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan
--Date 23/10/2003
--Purpose:XÐt tr­êng hîp cho phÐp söa (Truy vÊn CPNCTT_MF1619)
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[MP1620] 	@VoucherID as nvarchar(50), 
					@FromTable as nvarchar(50)
AS 

Declare @Status as tinyint, @IsDistribute as tinyint
Set @Status =0 
---1. Truong hop 1:  Kiem tra xem da phan bo hay chua
If @FromTable ='AT9000'
	If Exists (Select top 1 1 From AT9000 inner join MT1601 on MT1601.PeriodID = AT9000.PeriodID
			Where AT9000.VoucherID = @VoucherID and
				MT1601.IsDistribute <>0  )
		Set @Status = 2
	Else 	Set @Status = 0
Else
	If Exists (Select top 1 1 From MT9000 inner join MT1601 on MT1601.PeriodID = MT9000.PeriodID
			Where MT9000.VoucherID = @VoucherID and
				MT1601.IsDistribute <>0  )
		Set @Status = 2
	Else 	Set @Status = 0	

If @Status<>0 	GOTO RETURN_VALUES
-----2. Truong hop 2: Kiem tra but toan da duoc xu li so lieu o cho khac chua
If @FromTable ='AT9000'
	IF Exists (Select   top 1 1 From AT9000 Where AT9000.Status <>0 and VoucherID = @VoucherID)
		Set @Status = 1
	Else Set @Status = 0
Else
	IF Exists (Select   top 1 1 From MT9000 Where MT9000.Status <>0 and VoucherID = @VoucherID)
		Set @Status = 1
	Else Set @Status = 0

RETURN_VALUES:
	Select @Status as Status




